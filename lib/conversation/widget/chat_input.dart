// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../util/toast_utils.dart';
import '../../util/websocket_utils.dart';
import '../../widgets/load_image.dart';
import '../provider/conversation_provider.dart';
import '../utils/xunfei_util.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatInputController controller;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  // 输入方式：audio-语音 text-文字
  String inputType = 'audio';
  // 是否输入中
  bool isInputting = false;
  final TextEditingController textEditingController = TextEditingController();
  // 是否回答中
  bool isAnswering = false;
  // 录音
  FlutterSoundRecorder? recorder;
  // 录音状态 0-未录音 1-录音中
  int recordState = 0;
  StreamController<Food> streamController = StreamController<Food>();
  StreamSubscription? streamSubscription;
  // 语音识别
  WebsocketManage? recognizer;
  // 语音识别状态 UNCONNECT-未连接状态 CONNECT-连接中状态 CONNECTED-已连接状态 FAIL-连接失败状态 STOP-停止中状态 DESTROYED-已销毁状态
  String recognizerState = 'UNCONNECT';
  List<Uint8List> bufferList = [];
  List<Uint8List> bufferListNeedSend = [];
  bool isRunning = false;
  List<int> offset = [];
  // 对话
  ConversationProvider? provider;
  Message? message;
  String? text;
  // 播放器
  FlutterSoundPlayer? player;
  // 播放状态 0-未播放 1-播放中
  int playerState = 0;

  void init() async {
    provider = Provider.of<ConversationProvider>(context, listen: false);
    // 初始化录音
    initRecorder();
    // 初始化播放器
    initPlayer();
    // 初始化AI
    initAI();
  }

  void initRecorder() async {
    bool granted = await checkPermission();
    if (!granted) {
      return;
    }
    recorder = await FlutterSoundRecorder().openRecorder();
    if (recorder == null) {
      Toast.show("语音初始化错误", duration: 1000);
      return;
    }
    addRecordStream();
  }

  void initPlayer() async {
    player = await FlutterSoundPlayer().openPlayer();
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        Toast.show("麦克风权限未授权！", duration: 1000);
        return false;
      }
    }
    return true;
  }

  void addRecordStream() {
    streamSubscription = streamController.stream.listen(
      onData,
      onError: (_) async {
        await removeRecordStream();
      },
      onDone: () async {
        await removeRecordStream();
      },
      cancelOnError: true,
    );
  }

  Future<void> removeRecordStream() async {
    if (streamSubscription == null) {
      return;
    }
    await streamSubscription!.cancel();
    streamSubscription = null;
  }

  void startRecord() async {
    if (recorder == null) {
      return;
    }
    if (isInputting && recordState == 1) {
      return;
    }
    setState(() {
      isInputting = true;
      isAnswering = false;
    });
    recordState = 1;
    text = '';
    message = null;
    bufferList = [];
    bufferListNeedSend = [];
    offset = [];
    await recorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: streamController.sink,
    );
    if (kDebugMode) {
      print('开始录音');
    }
  }

  Future<void> stopRecord() async {
    setState(() {
      isInputting = false;
    });
    if (recordState != 1) {
      return;
    }
    if (recorder == null) {
      return;
    }
    await recorder!.stopRecorder();
    recordState = 0;
    if (kDebugMode) {
      print('结束录音');
    }
  }

  void onData(Food food) {
    Uint8List? buffer;
    if (food is FoodData) {
      buffer = food.data;
    }
    if (buffer != null) {
      speechRecognize(buffer);
    }
  }

  // 语音识别（讯飞版）
  void speechRecognize(Uint8List buffer) {
    if (recognizerState == 'FAIL' || recognizerState == 'DESTROYED') {
      if (kDebugMode) {
        print('语音识别状态：失败或销毁');
      }
      if (bufferListNeedSend.isNotEmpty) {
        bufferListNeedSend = [];
      }
      return;
    }
    bufferListNeedSend.add(buffer);
    if (recognizerState == 'UNCONNECT') {
      if (kDebugMode) {
        print('语音识别待连接');
      }
      connectRecognization();
      return;
    }
    if (recognizerState == 'CONNECT') {
      if (kDebugMode) {
        print('语音识别状态：连接中');
      }
      return;
    }
    if (recognizerState != 'STOP' && !isRunning) {
      isRunning = true;
      runRecognize();
    }
  }

  void connectRecognization() {
    recognizerState = 'CONNECT';
    String date = HttpDate.format(DateTime.now());
    String uri = 'wss://iat-api.xfyun.cn:443/v2/iat?host=iat-api.xfyun.cn&date=$date&authorization=${XunfeiUtil.getRecognizeAuthorization(date)}';
    WebsocketUtils.createWebsocket(
      "RECOGNIZE",
      Uri.parse(uri),
      onSuccess: () {
        if (kDebugMode) {
          print('连接讯飞语音识别成功');
        }
        WebsocketManage? manage = WebsocketUtils.getWebsocket("RECOGNIZE");
        if (manage != null) {
          recognizer = manage;
          addRecognizeListenner();
          //  发送首帧
          Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(0);
          recognizer!.send(jsonEncode(data));
          recognizerState = 'CONNECTED';
          return;
        }
        recognizerState = 'FAIL';
      },
      onError: () {
        if (kDebugMode) {
          print('连接讯飞语音识别失败');
        }
        recognizerState = 'FAIL';
      },
    );
  }

  void runRecognize() async {
    if (recognizerState == 'STOP' || recognizerState == 'DESTROYED') {
      isRunning = false;
      return;
    }
    if (bufferListNeedSend.isEmpty) {
      isRunning = false;
      return;
    }
    if (recognizer == null) {
      return;
    }
    Uint8List buffer = bufferListNeedSend.removeAt(0);
    Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(1, audio: buffer);
    recognizer!.send(jsonEncode(data));
    bufferList.add(buffer);
    await Future.delayed(const Duration(milliseconds: 40));
    runRecognize();
  }

  void addRecognizeListenner() {
    recognizer!.setOnMessage((event) async {
      if (kDebugMode) {
        print('识别结果:$event');
      }
      Map<String, dynamic> response = jsonDecode(event);
      Map<String, dynamic> result = XunfeiUtil.getRecognizeResult(response);
      if (result['code'] != 0) {
        return;
      }
      // 保存语音帧
      if (result['bg'] != null && result['ed'] != null) {
        offset.addAll([result['bg'], result['ed']]);
      }
      if (result['status'] != 2) {
        if (text == null) {
          text = result['text'];
        } else {
          text = text! + result['text'];
        }
        return;
      }
      // 触发静音检测
      if (result['status'] == 2 && result['text'] == '') {
        closeRecognization();
        bufferList = [];
        offset = [];
        recognizerState = 'UNCONNECT';
        // 提示
        Toast.show('未检测到语音，请说话', duration: 1000);
        return;
      }
      closeRecognization();
      await stopRecord();
      bufferListNeedSend = [];
      recognizerState = 'UNCONNECT';
      // 发送消息给AI
      WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
      if (manage != null) {
        text = text! + result['text'];
        // 存消息
        Message userMessage = Message();
        userMessage.speaker = 'user';
        userMessage.appendText(text!);
        List<Uint8List> audio = [...bufferList];
        if (offset.length > 1) {
          // 原音频源为16bit，Uinit8List为8bit，故长度需减半
          int len = audio.length;
          int start = (offset[0] * 0.5).toInt();
          int end = (offset[offset.length - 1] * 0.5).ceil();
          // 长度校验
          if (start > len) {
            start = 0;
            end = len;
          } else if (end > len) {
            end = len;
          }
          audio = audio.sublist(start, end);
        }
        userMessage.appendAudio(audio);
        provider!.appendMessage(userMessage);
        manage.send(text);
        setState(() {
          isAnswering = true;
        });
      }
    });
  }

  void closeRecognization() {
    recognizerState = 'STOP';
    recognizer = null;
    WebsocketUtils.closeWebsocket('RECOGNIZE');
  }

  void initAI() {
    WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
    if (manage != null) {
      manage.setOnMessage((data) {
        message ??= Message();
        bool isString = data is String;
        if (isString) {
          bool isEnd = data.startsWith('[end');
          if (!isEnd) {
            message!.appendText(data);
            return;
          }
          Message temp = message!;
          provider!.appendMessage(temp);
          return;
        }
        // 语音流
        if (playerState == 0 && player != null) {
          player!.startPlayer(
            fromDataBuffer: data as Uint8List,
            whenFinished: () {
              playerState = 0;
              if (inputType == 'audio' && !isInputting) {
                startRecord();
              }
            },
          );
          playerState = 1;
        }
      });
    }
  }

  void endConversation() async {
    if (playerState == 1) {
      await player!.stopPlayer();
      await player!.closePlayer();
    }
    recognizerState = 'DESTROYED';
    WebsocketUtils.closeWebsocket('RECOGNIZE');
    await stopRecord();
    await removeRecordStream();
    streamController.close();
    WebsocketUtils.closeWebsocket('CONVERSATION');
  }

  @override
  void initState() {
    super.initState();
    widget.controller.endConversation = endConversation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget micIcon = const LoadAssetImage(
      "maikefeng",
      width: 19.0,
      height: 23.0,
    );
    Widget input = const Text(
      '请开始讲话',
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.white,
      ),
    );
    if (isInputting) {
      if (inputType == 'audio') {
        micIcon = Image.asset(
          "assets/images/maikefeng_active.gif",
          width: 19.0,
          height: 23.0,
        );
        input = Image.asset(
          'assets/images/shengbo.gif',
          width: 121.0,
          height: 22.0,
          fit: BoxFit.fitWidth,
        );
      }
    } else {
      input = const Text(
        '老师正在回答中...',
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.white,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        children: <Widget>[
          micIcon,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: input,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const LoadAssetImage(
              'jianpan',
              width: 21.0,
              height: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputController {
  ChatInputController();

  late Function() _endConversation;

  Function() get endConversation => _endConversation;
  set endConversation(Function() endConversation) => _endConversation = endConversation;
}