// ignore_for_file: prefer_final_fields, must_be_immutable

import 'dart:typed_data';

import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../../home/widget/expiration_reminder.dart';
import '../../loginManager/login_manager.dart';
import '../../res/colors.dart';
import '../../util/EventBus.dart';
import '../../util/media_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';
import '../utils/chat_websocket.dart';
import '../utils/evaluate_util.dart';
import '../utils/recognize_util.dart';
import 'example.dart';
import 'record.dart';

class BottomBar extends StatefulWidget {
  BottomBar({
    Key? key,
    required this.chatWebsocket,
    required this.controller,
    required this.recordController,
    this.isCollectInformation,
  }) : super(key: key);

  final ChatWebsocket chatWebsocket;
  final BottomBarController controller;
  final RecordController recordController;
  bool? isCollectInformation;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with WidgetsBindingObserver {
  late ChatWebsocket _chatWebsocket;
  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  final MediaUtils _mediaUtils = MediaUtils();
  final RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];
  // ai回答消息
  NormalMessage? _answer;
  // app状态
  AppLifecycleState? _appLifecycleState;

  void getExample() {
    if (!LoginManager.isLogin()) {
      Toast.show(
        '请先登录',
        duration: 1000,
      );
      return;
    }
    if (widget.controller.disabled.value) {
      return;
    }
    // 判断是否需要地道表达
    MessageEntity message = _homeProvider.messageList.lastWhere((message) => message.type == 'normal' && (message as NormalMessage).speaker == 'ai', orElse: () => NormalMessage());
    if ((message as NormalMessage).text.isEmpty) {
      Toast.show(
        '暂无示例',
        duration: 1000,
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      clipBehavior: Clip.none,
      enableDrag: false,
      builder: (_) => Example(message: message),
    );
  }

  bool isAvailable() {
    if (!LoginManager.isLogin()) {
      Toast.show(
        '请先登录',
        duration: 1000,
      );
      return false;
    }

    bool isAvailable = true;

    // 新用户采集不花费使用时间
    if (widget.isCollectInformation != true) {
      int usageTime = _homeProvider.usageTime;
      int vipState = _homeProvider.vipState;
      int expDay = _homeProvider.expDay;
      // 是否体验到期
      if (vipState == 0 && (usageTime == 0 || expDay == 0)) {
        isAvailable = false;
      }
      // 是否会员到期
      if (vipState == 2) {
        isAvailable = false;
      }
      if (!isAvailable) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          isScrollControlled: true,
          isDismissible: false,
          builder: (_) => ExpirationReminder(),
        );
      }
    }
    return isAvailable;
  }

  Future<void> connectWebsocket() async {
    if (_homeProvider.sessionId != '') {
      return;
    }
    String characterId = _homeProvider.character.characterId;
    String? sceneId;
    String sessionType = _homeProvider.sessionType;
    if (sessionType == 'topic') {
      sceneId = _homeProvider.topic!.id.toString();
    }
    if (sessionType == 'scene') {
      sceneId = _homeProvider.scene!.id.toString();
    }
    try {
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        characterId: characterId,
        sceneId: sceneId,
        onConnected: () {
          _homeProvider.startUsageTimeCutdown(() async {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              isScrollControlled: true,
              isDismissible: false,
              builder: (_) => ExpirationReminder(),
            );
          });
        },
        onAnswer: onWebsocketAnswer,
        onEnd: onWebsocketEnd,
      );
    } catch (e) {
      rethrow;
    }
  }

  void onWebsocketAnswer(dynamic answer) {
    if (_answer == null) {
      _answer = NormalMessage();
      _homeProvider.addNormalMessage(_answer!);
    }
    if (answer is String) {
      if (answer.startsWith('[end')) {
        _answer!.isTextEnd = true;
        _homeProvider.notify();
        return;
      }
      _answer!.text += answer;
      _homeProvider.notify();
      EventBus().emit('SCROLL_MESSAGE_LIST');
      return;
    }
    if (answer is Uint8List) {
      if (_appLifecycleState == AppLifecycleState.paused) {
        return;
      }
      _mediaUtils.playLoop(
        buffer: answer,
        whenFinished: () {
          // 其他播放语音操作强制结束AI语音
          if (!_mediaUtils.banUsePlayer && !_answer!.isTextEnd) {
            return;
          }
          widget.controller.setDisabled(false);
        },
      );
    }
  }

  void onWebsocketEnd(String? reason, String endType) {
    _homeProvider.endUsageTimeCutdown();
    widget.controller.setDisabled(true);
    // 异常结束
    if (reason == 'Error') {
      insertTipMessage('Please switch to new roles, topics, or scene');
    }
    // 正常结束
    if (reason == 'Session End' && endType == 'normal') {
      insertTipMessage('Conversation finished！');
    }
  }

  void sendMessage(String text) async {
    // 连接
    try {
      await connectWebsocket();
    } catch(e) {
      Log.d('connect websocket fail:[error]${e.toString()}', tag: 'sendMessage');
    } finally {
      _chatWebsocket.sendMessage(
        text: text,
        onUninited: () {
          Toast.show(
            '发送失败，请稍后再试',
            duration: 1000,
          );
        },
        onSuccess: () {
          insertUserMessage(text, (message) {
            EvaluateUtil().evaluate(message, () {
              _homeProvider.updateNormalMessage(message);
            });
          });
        },
        onFail: () {
          insertTipMessage('Please switch to new roles, topics, or scene');
        },
      );
    }
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    EventBus().emit('SCROLL_MESSAGE_LIST');
  }

  void insertUserMessage(String text, Function(NormalMessage) onSuccess) {
    NormalMessage message = _homeProvider.createNormalMessage(true);
    message.text = text;
    message.audio = [..._bufferList];
    message.speaker = 'user';
    _homeProvider.addNormalMessage(message);
    EventBus().emit('SCROLL_MESSAGE_LIST');
    _answer = null;
    onSuccess(message);
  }

  @override
  void initState() {
    super.initState();
    _chatWebsocket = widget.chatWebsocket;
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    // 监听App状态
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _appLifecycleState = state;
    Future.delayed(Duration.zero, () async => await _mediaUtils.stopPlayLoop());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget iconButtom({
      required Widget child,
      required Function() onPress,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: const Color(0xFF001652).withOpacity(0.23)
          ),
          alignment: Alignment.center,
          child: child,
        ),
      );
    }

    Widget button({
      required bool disabled,
      required Function(LongPressStartDetails) onStart,
      required Function(LongPressEndDetails) onEnd,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (_) {
          if (disabled) {
            return;
          }
          onStart(_);
        },
        onLongPressMoveUpdate: (detail) {
          if (disabled) {
            return;
          }
          widget.recordController.fingerDetection(detail.globalPosition);
        },
        onLongPressEnd: (_) {
          if (disabled) {
            return;
          }
          onEnd(_);
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              width: 1.0,
              style: BorderStyle.solid,
              color: Colours.color_001652,
            ),
            color: disabled ? const Color(0xFFF8F8F8) : null,
            gradient: disabled ? null : const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colours.color_9AC3FF,
                Colours.color_FF71E0,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadAssetImage(
                'maikefeng',
                width: 24.0,
                height: 24.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '按住说话',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_001652,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: _screenUtil.screenWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.controller.showMessageList,
              builder: (_, showMessageList, __) => iconButtom(
                onPress: () => widget.controller.setShowMessageList(!showMessageList),
                child: LoadAssetImage(
                  showMessageList ? 'yanjing_bi' : 'yanjing_kai',
                  width: 24.0,
                  height: 17.9,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.disabled,
              builder: (_, disabled, __) => button(
                disabled: disabled,
                onStart: (detail) async {
                  if (!isAvailable()) {
                    return;
                  }
                  try {
                    // 检查权限
                    bool isRequest = await _mediaUtils.checkMicrophonePermission();
                    if (isRequest) {
                      return;
                    }
                    // 开始录音
                    _bufferList = [];
                    _mediaUtils.startRecord(
                      onData: (buffer) {
                        _bufferList.add(buffer);
                        _recognizeUtil.pushAudioBuffer(1, buffer);
                      },
                      onComplete: (buffer) {
                        _recognizeUtil.pushAudioBuffer(2, buffer ?? Uint8List(0));
                      }
                    );
                    // 设置识别
                    _recognizeUtil.recognize((result) async {
                      bool shoRecord = widget.controller.showRecord.value;
                      // 录音中
                      if (shoRecord) {
                        // 识别失败
                        if (result['success'] == false) {
                          widget.controller.setShowRecord(false);
                          await _mediaUtils.stopRecord();
                          Toast.show(
                            result['message'],
                            duration: 1000,
                          );
                        }
                       return;
                      }
                      bool isInSendButton = widget.recordController.isInSendButton.value;
                      // 取消发送
                      if (!isInSendButton) {
                        return;
                      }
                      if (result['success'] == false) {
                        Toast.show(
                          result['message'],
                          duration: 1000,
                        );
                        widget.controller.setDisabled(false);
                        return;
                      }
                      sendMessage(result['text']);
                    });
                    widget.controller.setShowRecord(true);
                  } catch (e) {
                    Toast.show(
                      e.toString().substring(11),
                      duration: 1000,
                    );
                  }
                },
                onEnd: (_) async {
                  // 录音中因识别失败关闭录音操作后手指还未抬起
                  if (!widget.controller.showRecord.value) {
                    return;
                  }
                  widget.controller.setShowRecord(false);
                  await _mediaUtils.stopRecord();
                  // 取消发送则关闭识别
                  if (!widget.recordController.isInSendButton.value) {
                    await _recognizeUtil.cancelRecognize();
                    return;
                  }
                  // 暂时禁用按钮
                  widget.controller.setDisabled(true);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: iconButtom(
              onPress: getExample,
              child: const LoadAssetImage(
                'tishi',
                width: 17.5,
                height: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 控制器
class BottomBarController {

  BottomBarController();

  ValueNotifier<bool> _disabled = ValueNotifier(true);
  ValueNotifier<bool> _showRecord = ValueNotifier(false);
  ValueNotifier<bool> _showMessageList = ValueNotifier(true);

  ValueNotifier<bool> get disabled => _disabled;
  ValueNotifier<bool> get showRecord => _showRecord;
  ValueNotifier<bool> get showMessageList => _showMessageList;

  void setDisabled(bool disabled) {
    _disabled.value = disabled;
  }

  void setShowRecord(bool showRecord) {
    _showRecord.value = showRecord;
  }

  void setShowMessageList(bool showMessageList) {
    _showMessageList.value = showMessageList;
  }

}