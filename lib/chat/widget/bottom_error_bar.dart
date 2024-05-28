// ignore_for_file: prefer_final_fields, must_be_immutable

import 'dart:typed_data';

import 'package:Bubble/chat/entity/class_message_entity.dart';
import 'package:Bubble/chat/utils/error_class_evaluate_util.dart';
import 'package:Bubble/chat/widget/background.dart';
import 'package:Bubble/chat/widget/record_error.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/utils/class_evaluate_util.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/websocket_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../home/provider/home_provider.dart';
import '../../home/widget/expiration_reminder.dart';
import '../../loginManager/login_manager.dart';
import '../../res/colors.dart';
import '../../util/media_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';
import '../utils/chat_websocket.dart';
import '../utils/evaluate_util.dart';
import '../utils/recognize_util.dart';
import 'example.dart';
import 'record.dart';

class BottomErrorBar extends StatefulWidget {
  BottomErrorBar({
    Key? key,
    // required this.chatWebsocket,
    required this.controller,
    required this.recordController,
    this.isCollectInformation,
    this.language,
    this.isNormalChat = false,
    this.onScrollEnd,
    this.onMapEnd,
    required this.idStr,
    required this.suggestionSentenceStr,
    required this.suggestionAudioStr,
    required this.repeatWord,
  }) : super(key: key);
  final String repeatWord;

  // final ChatWebsocket chatWebsocket;
  final BottomErrorBarController controller;
  final RecordController recordController;
  bool? isCollectInformation;
  String? language;
  final String idStr;
  final String suggestionSentenceStr;
  final String suggestionAudioStr;

  final Function()? onScrollEnd;
  final Function(Map<String, dynamic> map)? onMapEnd;

  final bool isNormalChat;

  @override
  State<BottomErrorBar> createState() => _BottomErrorBarState();
}

class _BottomErrorBarState extends State<BottomErrorBar>
    with WidgetsBindingObserver {
  // late ChatWebsocket _chatWebsocket;
  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  final MediaUtils _mediaUtils = MediaUtils();
  final RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];

  bool isAvailable() {
    if (!LoginManager.isLogin()) {
      LoginManager.checkLogin(context, () {
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
      });

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

  void sendMessage(String text) async {
    insertUserMessage(text, (message) {
      ErrorClassEvaluateUtil().evaluate(message, (Map<String, dynamic> map) {
        Log.e(map.toString());
        widget.onMapEnd!(map);
      });
    });
  }

  void insertUserMessage(
      String text, Function(ErrorClassMessageEntity) onSuccess) {
    ErrorClassMessageEntity message = ErrorClassMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    message.sessionId = widget.idStr;
    message.speechfile = "";
    message.suggestionAudio = widget.suggestionAudioStr;
    message.tesuggestionSentencext = widget.suggestionSentenceStr;
    onSuccess(message);
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    if (widget.onScrollEnd != null) {
      widget.onScrollEnd!();
    }
  }

  void insertTwoUserMessage(
      String text, Function(ClassMessageEntity) onSuccess) {
    ClassMessageEntity message = ClassMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    onSuccess(message);
  }

  void sendTwoMessage(String msg, String word) {
    insertTwoUserMessage(word, (message) {
      ClassEvaluateUtil().evaluate(message, (Map<String, dynamic> map) {
        Log.e("============");

        Log.e(map.toString());
        Log.e("============");

        Log.e(map["total_score"]);
        // Log.e(map["total_score"]);
        try {
          double value = double.parse(map["total_score"]);
          if (value > 60) {
            sendMessage(word);
          } else {
            sendMessage(msg);
          }
        } catch (e) {
          sendMessage(msg);
        }
        // evaluation['total_score']
        Log.e("============");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _chatWebsocket = widget.chatWebsocket;
    _recognizeUtil.setLanguage(widget.language ?? 'en');
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    // 监听App状态
    // WidgetsBinding.instance.addObserver(this);

    EventBus().on('LOGINOUT', (_) {
      setState(() {
        LoginManager.toLoginOut();
        NavigatorUtils.push(
          context,
          "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
        );
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // _appLifecycleState = state;
    Future.delayed(Duration.zero, () async {
      await _mediaUtils.stopPlay();
    });
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
              color: const Color(0xFF001652).withOpacity(0.23)),
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
        child: StreamBuilder(
          stream: AvatarController().getStream(),
          builder: (_, snapshot) {
            return Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                // border: Border.all(
                //   width: 1.0,
                //   style: BorderStyle.solid,
                //   color: Colours.color_001652,
                // ),
                color: const Color(0xFFF8F8F8),
                gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colours.color_8256FF,
                    Colours.color_FF5CDB,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // LoadAssetImage(
                  //   'maikefeng_icon',
                  //   width: 24.0,
                  //   height: 24.0,
                  // ),
                  // SizedBox(
                  //   width: 5.0,
                  // ),
                  Text(
                    '按住更正读音',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Container(
      width: _screenUtil.screenWidth,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.controller.disabled,
        builder: (_, disabled, __) => button(
          disabled: disabled,
          onStart: (detail) async {
            if (!isAvailable()) {
              return;
            }
            try {
              bool hasAgree =
                  SpUtil.getBool(Constant.mediaUtils, defValue: false) ?? false;
              if (!hasAgree) {
                Toast.show("录音音频使用说明:用于对话场景", duration: 6000);
                SpUtil.putBool(Constant.mediaUtils, true);
              }

              // 检查权限
              bool isRequest = await _mediaUtils.checkMicrophonePermission();
              if (isRequest) {
                Toast.show("录音音频使用说明:用于对话场景", duration: 5000);
                return;
              }
              // 开始录音
              _bufferList = [];
              _mediaUtils.startRecord(onData: (buffer) {
                _bufferList.add(buffer);
                _recognizeUtil.pushAudioBuffer(1, buffer);
              }, onComplete: (buffer) {
                _recognizeUtil.pushAudioBuffer(2, buffer ?? Uint8List(0));
              });
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
                bool isInSendButton =
                    widget.recordController.isInSendButton.value;
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
                if (result['text'] == "") {
                  Toast.show(
                    '请说话',
                  );
                }
                if (widget.repeatWord != "") {
                  //这里先调评测,分高传tag分低穿别的
                  sendTwoMessage(result['text'], widget.repeatWord);
                } else {
                  sendMessage(result['text']);
                }
                // sendMessage(result['text']);
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
    );
  }
}

// 控制器
class BottomErrorBarController {
  BottomErrorBarController();

  ValueNotifier<bool> _disabled = ValueNotifier(false);
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
