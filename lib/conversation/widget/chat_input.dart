// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters, slash_for_doc_comments, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/setting/provider/device_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

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
  // 是否可对话
  bool canConversate = false;

  /** 输入相关参数 */
  // 输入方式：audio-语音 text-文字
  String inputType = 'audio';
  // 是否输入中
  bool isInputting = false;
  final TextEditingController textEditingController = TextEditingController();

  /** 录音相关参数 */
  FlutterSoundRecorder? recorder;
  // 录音状态 0-未录音 1-录音中
  int recordState = 0;
  StreamController<Food> streamController = StreamController<Food>();
  StreamSubscription? streamSubscription;

  /** 语音识别相关参数 */
  WebsocketManage? recognizer;
  // 语音识别状态 UNCONNECT-未连接状态 CONNECT-连接中状态 CONNECTED-已连接状态 FAIL-连接失败状态 DESTROYED-已销毁状态
  String recognizerState = 'UNCONNECT';
  // 计时器 -1-不发送数据
  int duration = -1;
  List<Uint8List> bufferList = [];
  List<Uint8List> bufferListNeedSend = [];
  bool isRunning = false;
  // 语音强制拆分多段，vad是否在下一段
  bool isVadInNext = false;

  //** AI语音相关参数 */
  FlutterSoundPlayer? player;
  // 播放状态 0-未播放 1-播放中
  int playerState = 0;
  // AI返回的语音列表
  List<Uint8List> aiSpeechList = [];

  // 是否文字返回完毕
  bool isTextReturnComplete = false;
  // 是否回答中
  bool isAnswering = false;

  // 对话
  ConversationProvider? provider;
  Message? message;


  void init() {
    provider = Provider.of<ConversationProvider>(context, listen: false);
    // 初始化录音
    initRecorder();
    // 初始化播放器
    initPlayer();
    // 初始化AI
    initAI();
    // 初始化倒计时
    intCutdown();
  }

  Future<void> intCutdown() async {
    // String deviceId = await Device.getDeviceId();
    String deviceId = Provider.of<DeviceProvider>(context, listen: false).deviceId;
    DioUtils.instance.requestNetwork(
      Method.get,
      HttpApi.permission,
      queryParameters: {
        'device_id': deviceId,
      },
      onSuccess: (result) {
        if (result == null) {
          return;
        }
        result = result as Map<String, dynamic>;
        if (result['data'] == null) {
          return;
        }
        int leftTime = result['data']['left_time'] ?? 0;
        if (leftTime > 0) {
          provider!.setAvailableTime(leftTime);
          provider!.setCutdownState(1);
          canConversate = true;
          // 避免刚好在接受欢迎语期间请求成功
          if (isTextReturnComplete && aiSpeechList.isEmpty && playerState == 0 && inputType == 'audio' && !isInputting) {
            startRecord();
          }
        }
      },
      onError: (code, msg) {
        if (kDebugMode) {
          print('获取倒计时：code=$code msg=$msg');
        }
      },
    );
  }

  void initRecorder() async {
    bool granted = await checkPermission();
    if (!granted) {
      return;
    }
    recorder = await FlutterSoundRecorder(
      logLevel: Level.nothing,
    ).openRecorder();
    if (recorder == null) {
      Toast.show("语音初始化错误", duration: 1000);
      return;
    }
    addRecordStream();
  }

  void initPlayer() async {
    player = await FlutterSoundPlayer(
      logLevel: Level.nothing,
    ).openPlayer();
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
    if (!canConversate) {
      return;
    }
    if (recorder == null) {
      return;
    }
    if (isInputting && recordState == 1) {
      return;
    }

    // 重置相关参数
    isInputting = true;
    isAnswering = false;
    recordState = 1;

    bufferList = [];
    bufferListNeedSend = [];

    message = null;

    await recorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: streamController.sink,
    );
    if (kDebugMode) {
      print('开始录音');
    }
    setState(() {});
  }

  Future<void> stopRecord() async {
    if (recordState == 0) {
      return;
    }

    await recorder!.stopRecorder();
    isInputting = false;
    recordState = 0;
    if (kDebugMode) {
      print('结束录音');
    }
    setState(() {});
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
    // 连接失败或者结束对话
    if (recognizerState == 'FAIL' || recognizerState == 'DESTROYED') {
      bufferListNeedSend = [];
      return;
    }
    // 未连接
    if (recognizerState == 'UNCONNECT') {
      if (kDebugMode) {
        print('websocket未连接');
      }
      connectRecognization();
    }
    bufferListNeedSend.add(buffer);
    if (!isRunning) {
      runRecognize();
    }
  }

  void runRecognize() async {
    // 无任务
    if (bufferListNeedSend.isEmpty) {
      return;
    }
    // 不发送数据
    if (duration == -1) {
      return;
    }

    isRunning = true;
    await Future.delayed(const Duration(milliseconds: 20));
    duration = duration + 20;
    if (kDebugMode) {
      print('duration:$duration');
    }
    // 默认为中间帧
    int frame = 1;
    if (duration >= 2000) {
      if (kDebugMode) {
        print('发送尾帧:${DateTime.now().millisecondsSinceEpoch}');
      }
      frame = 2;
      // 停止发送数据，等待识别结果
      duration = -1;
    }
    Uint8List buffer = bufferListNeedSend.removeAt(0);
    bufferList.add(buffer);
    Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(frame, audio: buffer);
    recognizer!.send(jsonEncode(data));
    isRunning = false;

    runRecognize();
  }

  void connectRecognization() {
    recognizerState = 'CONNECT';
    duration = -1;

    // 连接websocket
    String date = HttpDate.format(DateTime.now());
    String uri = 'wss://iat-api.xfyun.cn:443/v2/iat?host=iat-api.xfyun.cn&date=$date&authorization=${XunfeiUtil.getRecognizeAuthorization(date)}';
    WebsocketUtils.createWebsocket(
      "RECOGNIZE",
      Uri.parse(uri),
      onSuccess: () {
        recognizer = WebsocketUtils.getWebsocket("RECOGNIZE");
        addRecognizeListenner();

        // 发送首帧
        Uint8List buffer = Uint8List(0);
        bufferList.add(buffer);
        Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(0, audio: buffer);
        recognizer!.send(jsonEncode(data));

        recognizerState = 'CONNECTED';
        duration = 0;
      },
      onError: () {
        recognizerState = 'FAIL';
      },
    );
  }

  void addRecognizeListenner() {
    recognizer!.setOnMessage((event) async {
      if (kDebugMode) {
        print('识别结果:$event');
      }

      // 解析结果
      Map<String, dynamic> response = jsonDecode(event);
      Map<String, dynamic> result = XunfeiUtil.getRecognizeResult(response);
      if (result['code'] != 0) {
        return;
      }

      int status = result['status'];
      String text = result['text'];
      // 非识别结束
      if (status < 2) {
        if (kDebugMode) {
          print('vad 在下一段');
        }
        isVadInNext = true;
        if (message == null) {
          message = provider!.createMessage();
          message!.setSpeaker('user');
        }
        if (message!.text.isNotEmpty) {
          String firstChar = text.substring(0, 1).toLowerCase();
          text = firstChar + text.substring(1);
        }
        message!.appendText(text);
        provider!.updateMessageList();
        // 裁剪识别的文字对应的音频
        if (result['bg'] != null && result['ed'] != null) {
          List<int> offset = [result['bg'], result['ed']];
          message!.appendAudio(cropAudio(offset));
        }
      }

      if (status == 2) {
        bufferList = [];
        // 无语音
        if (!isVadInNext && text == '' && message == null) {
          closeRecognization();
          Toast.show('未检测到语音，请说话', duration: 1000);
          return;
        }
        // 识别部分语音
        if (isVadInNext) {
          closeRecognization();
          isVadInNext = false;
          return;
        }

        WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
        if (manage != null) {
          manage.send('[message_id=${message!.id}]${message!.text}');
        }
        await stopRecord();
        closeRecognization();
        provider!.runEvaluate();
        provider!.runTranslate();

        message = null;
      }

      // if (result['status'] != 2) {
      //   if (kDebugMode) {
      //     print('vad 在下一段');
      //   }
      //   isVadInNext = true;
      // }
      //
      // // 保存语音帧
      // if (result['bg'] != null && result['ed'] != null) {
      //   // offset.addAll([result['bg'], result['ed']]);
      //
      // }
      //
      // // 保存识别文本
      // if (result['text'] != '') {
      //   message ??= provider!.createMessage();
      //   message!.appendText(result['text']);
      //   provider!.updateMessageList();
      // }
      //
      // // 以静音检测作为结束的标志
      // if (result['status'] == 2) {
      //   if (!isVadInNext && result['text'] == '' && message == null) {
      //     // 停止讯飞语音识别
      //     closeRecognization();
      //     bufferList = [];
      //     Toast.show('未检测到语音，请说话', duration: 1000);
      //     return;
      //   }
      //
      //   if (isVadInNext) {
      //     // 停止讯飞语音识别
      //     closeRecognization();
      //     isVadInNext = false;
      //     return;
      //   }
      //
      //   // 发送文本给AI
      //   WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
      //   if (manage != null) {
      //     manage.send('[message_id=${message!.id}]${message!.text}');
      //   }
      //   // 停止录音
      //   await stopRecord();
      //   // 停止讯飞语音识别
      //   closeRecognization();
      //
      //   message!.setSpeaker('user');
      //   message!.appendAudio(bufferList);
      //   // 评测、翻译
      //   provider!.runEvaluate();
      //   provider!.runTranslate();
      //
      //   message = null;
      // }

      // // 触发静音检测
      // if (result['status'] == 2 && result['text'] == '') {
      //   // closeRecognization();
      //   // bufferList = [];
      //   // offset = [];
      //   // recognizerState = 'UNCONNECT';
      //   // 提示
      //   Toast.show('未检测到语音，请说话', duration: 1000);
      //   return;
      // }
      //
      // // 保存语音帧
      // if (result['bg'] != null && result['ed'] != null) {
      //   offset.addAll([result['bg'], result['ed']]);
      // }
      // if (result['status'] != 2) {
      //   if (text == null) {
      //     text = result['text'];
      //   } else {
      //     text = text! + result['text'];
      //   }
      //   return;
      // }
      //
      // closeRecognization();
      // await stopRecord();
      // bufferListNeedSend = [];
      // recognizerState = 'UNCONNECT';
      // // 发送消息给AI
      // WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
      // if (manage != null) {
      //   text = text! + result['text'];
      //   // 存消息
      //   Message userMessage = Message();
      //   userMessage.speaker = 'user';
      //   userMessage.appendText(text!);
      //   List<Uint8List> audio = [...bufferList];
      //   if (offset.length > 1) {
      //     // 原音频源为16bit，Uinit8List为8bit，故长度需减半
      //     int len = audio.length;
      //     int start = (offset[0] * 0.5).toInt();
      //     int end = (offset[offset.length - 1] * 0.5).ceil();
      //     // 长度校验
      //     if (start > len) {
      //       start = 0;
      //       end = len;
      //     } else if (end > len) {
      //       end = len;
      //     }
      //     audio = audio.sublist(start, end);
      //   }
      //   userMessage.appendAudio(audio);
      //   provider!.appendMessage(userMessage);
      //   userMessage.translate();
      //   if (kDebugMode) {
      //     print('发送文本：$text');
      //   }
      //   manage.send('[message_id=${userMessage.id}]$text');
      //   setState(() {
      //     isAnswering = true;
      //   });
      // }
    });
  }

  List<Uint8List> cropAudio(List<int> offset) {
    List<Uint8List> audio = [...bufferList];
    // 原音频源为16bit，Uinit8List为8bit，故长度需减半
    int len = audio.length;
    int start = (offset[0] * 0.5).floor();
    int end = (offset.last * 0.5).ceil();
    // 长度校验
    if (start > len) {
      start = 0;
      end = len;
    } else if (end > len) {
      end = len;
    }
    return audio.sublist(start, end);
  }

  void closeRecognization() {
    recognizerState = 'UNCONNECT';
    recognizer = null;
    WebsocketUtils.closeWebsocket('RECOGNIZE');
  }

  void playSpeech() {
    if (aiSpeechList.isEmpty) {
      if (playerState == 0 && isTextReturnComplete && inputType == 'audio' && !isInputting) {
        startRecord();
      }
      return;
    }

    if (player == null) {
      aiSpeechList.removeAt(0);
      playSpeech();
      return;
    }

    if (playerState == 1) {
      return;
    }

    playerState = 1;
    Uint8List speech = aiSpeechList.removeAt(0);
    player!.startPlayer(
      fromDataBuffer: speech,
      whenFinished: () {
        playerState = 0;
        playSpeech();
      }
    );
  }

  void initAI() {
    WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
    if (manage != null) {
      manage.setOnMessage((data) {
        if (message == null) {
          message = provider!.createMessage();
          isTextReturnComplete = false;
        }
        bool isString = data is String;
        if (isString) {
          bool isEnd = data.startsWith('[end');
          if (isEnd) {
            isTextReturnComplete = true;
            message!.translate();
            message = null;
            // 避免语音播放结束无法进行下一步
            if (aiSpeechList.isEmpty && playerState == 0 && inputType == 'audio' && !isInputting) {
              startRecord();
            }
            return;
          }
          message!.appendText(data);
          provider!.updateMessageList();
        } else {
          aiSpeechList.add(data as Uint8List);
          playSpeech();
        }
      });
      // manage.setOnMessage((data) {
      //   print('setOnMessage:data=$data');
      //   message ??= Message();
      //   bool isString = data is String;
      //   if (isString) {
      //     bool isEnd = data.startsWith('[end');
      //     if (!isEnd) {
      //       message!.appendText(data);
      //       return;
      //     }
      //     Message temp = message!;
      //     provider!.appendMessage(temp);
      //     return;
      //   }
      //   // 语音流
      //   if (playerState == 0 && player != null) {
      //     player!.startPlayer(
      //       fromDataBuffer: data as Uint8List,
      //       whenFinished: () {
      //         playerState = 0;
      //         if (inputType == 'audio' && !isInputting) {
      //           startRecord();
      //         }
      //       },
      //     );
      //     playerState = 1;
      //   }
      // });
    }
  }

  void endConversation() async {
    duration = -1;

    // 停止录音和播放
    if (recordState == 1) {
      await recorder!.stopRecorder();
    }
    if (playerState == 1) {
      await player!.stopPlayer();
    }

    // 销毁讯飞语音转文字
    if (recognizerState == 'CONNECTED') {
      recognizerState = 'DESTROYED';
      WebsocketUtils.closeWebsocket('RECOGNIZE');
    }

    WebsocketUtils.closeWebsocket('CONVERSATION');
    await addConversationRecord();
  }

  Future<void> addConversationRecord() async {
    String deviceId = Provider.of<DeviceProvider>(context, listen: false).deviceId;
    await DioUtils.instance.requestNetwork(
      Method.post,
      HttpApi.addConversationRecord,
      params: {
        'session_id': provider!.sessionId,
        // 'device_id': await Device.getDeviceId(),
        'device_id': deviceId,
        'duration': provider!.usageTime,
      },
      onSuccess: (_) {
        if (kDebugMode) {
          print('addConversationRecord: $_');
        }
      },
      onError: (code, msg) {
        if (kDebugMode) {
          print('addConversationRecord: code=$code msg=$msg');
        }
      }
    );
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
    if (recorder != null) {
      recorder!.closeRecorder();
    }
    if (player != null) {
      player!.closePlayer();
    }
    streamController.close();
    if (streamSubscription != null) {
      streamSubscription!.cancel();
    }
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