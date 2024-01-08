// ignore_for_file: prefer_final_fields

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../../loginManager/login_manager.dart';
import '../../res/colors.dart';
import '../../util/media_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';
import '../utils/chat_websocket.dart';
import '../utils/recognize_util.dart';
import 'example.dart';
import 'record.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
    required this.chatWebsocket,
    required this.controller,
    required this.recordController,
  }) : super(key: key);

  final ChatWebsocket chatWebsocket;
  final BottomBarController controller;
  final RecordController recordController;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late ChatWebsocket _chatWebsocket;
  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  final MediaUtils _mediaUtils = MediaUtils();
  final RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];
  // ai回答消息
  NormalMessage? _answer;
  bool _isSend = false;

  void getExample() {
    String text = 'Hello, I would like to ask what preparations need to be made for traveling abroad.';
    String textZh = '你好，可以告诉我国外旅游需要做哪些准备吗？';
    String audio = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      clipBehavior: Clip.none,
      builder: (_) => Example(
        text: text,
        textZh: textZh,
        audio: audio,
      ),
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

    // int usageTime = _homeProvider.usageTime;
    // int vipState = _homeProvider.vipState;
    // int expDay = _homeProvider.expDay;
    // // 是否体验到期
    // if (vipState == 0 && (usageTime == 0 || expDay == 0)) {
    //   isAvailable = false;
    // }
    // // 是否会员到期
    // if (vipState == 2) {
    //   isAvailable = false;
    // }
    // if (!isAvailable) {
    //   showModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     barrierColor: Colors.transparent,
    //     isScrollControlled: true,
    //     isDismissible: false,
    //     builder: (_) => ExpirationReminder(),
    //   );
    // }
    return isAvailable;
  }

  void sendMessage(String text) async {
    try {
      if (_homeProvider.sessionId == '') {
        String characterId = _homeProvider.character.characterId;
        String? sceneId;
        String sessionType = _homeProvider.sessionType;
        if (sessionType == 'topic') {
          sceneId = _homeProvider.topic!.id.toString();
        }
        if (sessionType == 'scene') {
          sceneId = _homeProvider.scene!.id.toString();
        }
        _homeProvider.sessionId = await _chatWebsocket.startChat(
          characterId: characterId,
          sceneId: sceneId,
          onAnswer: (answer) {
            if (_answer == null) {
              _answer = NormalMessage();
              _homeProvider.addNormalMessage(_answer!);
            }
            if (answer is String) {
              if (answer.startsWith('[end=')) {
                _answer!.isTextEnd = true;
                _homeProvider.notify();
                _answer = null;
                return;
              };
              _answer!.text += answer;
              _homeProvider.notify();
              return;
            }

          },
        );
      }
      _chatWebsocket.sendMessage(text, () {
        NormalMessage message = _homeProvider.createNormalMessage(true);
        message.text = text;
        message.audio = [..._bufferList];
        message.speaker = 'user';
        _homeProvider.addNormalMessage(message);
        _isSend = false;
      });
    } catch(e) {
      _isSend = false;
      Toast.show(
        '发送失败，请稍后再试',
        duration: 1000,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _chatWebsocket = widget.chatWebsocket;
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  @override
  void dispose() {
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
                  showMessageList ? 'yanjing_kai' : 'yanjing_kai',
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
                  if (_isSend) {
                    return;
                  }
                  try {
                    // 检查权限
                    bool isRequest = await _mediaUtils.checkMicrophonePermission();
                    if (isRequest) {
                      return;
                    }
                    // 开始录音
                    _mediaUtils.startRecord(
                      onData: (buffer) {
                        _bufferList.add(buffer);
                        _recognizeUtil.pushAudioBuffer(1, buffer);
                      },
                      onComplete: (buffer) {
                        _recognizeUtil.pushAudioBuffer(2, buffer ?? Uint8List(0));
                      }
                    );
                    _bufferList = [];
                    // 设置识别
                    _recognizeUtil.recognize((result) async {
                      widget.controller.setShowRecord(false);
                      await _mediaUtils.stopRecord();
                      if (!_isSend) {
                        return;
                      }
                      if (result['success'] == false) {
                        Toast.show(
                          result['message'],
                          duration: 1000,
                        );
                        _isSend = false;
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
                  if (_isSend) {
                    return;
                  }
                  _isSend = widget.recordController.isInSendButton.value;
                  await _mediaUtils.stopRecord();
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