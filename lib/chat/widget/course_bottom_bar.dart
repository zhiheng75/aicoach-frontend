// ignore_for_file: prefer_final_fields, must_be_immutable

import 'dart:typed_data';

import 'package:Bubble/chat/widget/background.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/utils/class_evaluate_util.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:phone_state/phone_state.dart';

class CourseBottomBar extends StatefulWidget {
  CourseBottomBar({
    Key? key,
    required this.chatWebsocket,
    required this.controller,
    required this.recordController,
    this.isCollectInformation,
    this.language,
    this.isNormalChat = false,
    this.onScrollEnd,
    this.onFinshEnd,
    this.onStartBool,
    this.onError,
    required this.lessonId,
    required this.stepId,
    required this.sceneId,
    required this.repeatWord,

    // this.onStarEnd,
  }) : super(key: key);

  final ChatWebsocket chatWebsocket;
  final BottomBarController controller;
  final RecordController recordController;
  bool? isCollectInformation;
  String? language;
  final Function()? onScrollEnd;
  final Function()? onError;

  final Function(bool isfinsh)? onFinshEnd;
  final Function(bool isfinsh)? onStartBool;

  final String lessonId;
  final String stepId;
  final String sceneId;

  final bool isNormalChat;
  final String repeatWord;

  @override
  State<CourseBottomBar> createState() => _CourseBottomBarState();
}

class _CourseBottomBarState extends State<CourseBottomBar>
    with WidgetsBindingObserver {
  late ChatWebsocket _chatWebsocket;
  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  final MediaUtils _mediaUtils = MediaUtils();
  RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];
  // ai回答消息
  NormalMessage? _answer;
  // ai音频播放
  ListPlayer? _listPlayer;
  // app状态
  AppLifecycleState? _appLifecycleState;

  PhoneState status = PhoneState.nothing();
  bool granted = false;

  bool isUserOpen = false;
  late bool _phoneSate = true;

  void getExample() {
    LoginManager.checkLogin(context, () {
      if (widget.controller.disabled.value) {
        return;
      }
      // 判断是否需要地道表达
      MessageEntity message = _homeProvider.messageList.lastWhere(
          (message) =>
              message.type == 'normal' &&
              (message as NormalMessage).speaker == 'ai',
          orElse: () => NormalMessage());
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
    });
  }

  bool isAvailable() {
    if (!LoginManager.isLogin()) {
      LoginManager.checkLogin(context, () {
        bool isAvailable = true;

        // // 新用户采集不花费使用时间
        // if (widget.isCollectInformation != true) {
        //   int usageTime = _homeProvider.usageTime;
        //   int vipState = _homeProvider.vipState;
        //   int expDay = _homeProvider.expDay;
        //   // 是否体验到期
        //   if (vipState == 0 && (usageTime == 0 || expDay == 0)) {
        //     isAvailable = false;
        //   }
        //   // 是否会员到期
        //   if (vipState == 2) {
        //     isAvailable = false;
        //   }
        //   if (!isAvailable) {
        //     showModalBottomSheet(
        //       context: context,
        //       backgroundColor: Colors.transparent,
        //       barrierColor: Colors.transparent,
        //       isScrollControlled: true,
        //       isDismissible: false,
        //       builder: (_) => ExpirationReminder(),
        //     );
        //   }
        // }
        return isAvailable;
      });

      return false;
    }

    bool isAvailable = true;

    // // 新用户采集不花费使用时间
    // if (widget.isCollectInformation != true) {
    //   int usageTime = _homeProvider.usageTime;
    //   int vipState = _homeProvider.vipState;
    //   int expDay = _homeProvider.expDay;
    //   // 是否体验到期
    //   if (vipState == 0 && (usageTime == 0 || expDay == 0)) {
    //     isAvailable = false;
    //   }
    //   // 是否会员到期
    //   if (vipState == 2) {
    //     isAvailable = false;
    //   }
    //   if (!isAvailable) {
    //     showModalBottomSheet(
    //       context: context,
    //       backgroundColor: Colors.transparent,
    //       barrierColor: Colors.transparent,
    //       isScrollControlled: true,
    //       isDismissible: false,
    //       builder: (_) => ExpirationReminder(),
    //     );
    //   }
    // }
    return isAvailable;
  }

  Future<void> connectWebsocket() async {
    if (_homeProvider.sessionId != '') {
      return;
    }
    String characterId = _homeProvider.character.characterId;
    String? sceneId;
    // String sessionType = _homeProvider.sessionType;
    // if (sessionType == 'topic') {
    //   sceneId = _homeProvider.topic!.id.toString();
    // }
    // if (sessionType == 'scene') {
    sceneId = widget.sceneId; //_homeProvider.scene!.id.toString();
    // }
    // if (sessionType == 'course') {
    //   sceneId = _homeProvider.course!.id.toString();
    // }
    try {
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        lessonId: widget.lessonId,
        characterId: characterId,
        sceneId: sceneId,
        onConnected: () {
          // // 刷新使用时间
          // _homeProvider.getUsageTime(() {
          //   // 倒计时
          //   _homeProvider.startUsageTimeCutdown(() async {
          //     showModalBottomSheet(
          //       context: context,
          //       backgroundColor: Colors.transparent,
          //       barrierColor: Colors.transparent,
          //       isScrollControlled: true,
          //       isDismissible: false,
          //       builder: (_) => ExpirationReminder(),
          //     );
          //   });
          // });

          // // 倒计时
          // _homeProvider.startUsageTimeCutdown(() async {
          //   showModalBottomSheet(
          //     context: context,
          //     backgroundColor: Colors.transparent,
          //     barrierColor: Colors.transparent,
          //     isScrollControlled: true,
          //     isDismissible: false,
          //     builder: (_) => ExpirationReminder(),
          //   );
          // });
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
      // _answer = NormalMessage();
      _answer = _homeProvider.createNormalMessage();
      // 创建列表播放
      _listPlayer = _mediaUtils.createListPlay(() {
        widget.controller.setDisabled(false);
      }, widget.isNormalChat);
      _homeProvider.addNormalMessage(_answer!);
    }
    if (answer is String) {
      if (answer.startsWith('[end')) {
        _answer!.isTextEnd = true;
        // 音频已全部返回
        if (_listPlayer != null) {
          _listPlayer!.setReturnEnd();
        }
        _homeProvider.notify();
        return;
      }
      _answer!.text += answer;
      _homeProvider.notify();
      if (widget.onScrollEnd != null) {
        widget.onScrollEnd!();
      }
      return;
    }
    if (answer is Uint8List) {
      _answer!.audio.add(answer);
      if (_appLifecycleState == AppLifecycleState.paused) {
        return;
      }
      if (_listPlayer != null) {
        _listPlayer!.play(answer);
      }
    }
  }

  void onWebsocketEnd(String? reason, String endType) {
    _homeProvider.endUsageTimeCutdown();
    // widget.controller.setDisabled(true);
    // 异常结束
    if (reason == 'Error') {
      if (widget.onError != null) {
        widget.onError!();
      }
      // insertTipMessage('Please switch to new roles, topics, or scene');
    }
    if (reason == 'keepalive ping timeout') {}
    // 正常结束
    if (reason == 'Session End' && endType == 'normal') {
      // insertTipMessage('Conversation finished！');
    }
  }

  void sendMessage(String text) async {
    // 连接
    try {
      // await connectWebsocket();
    } catch (e) {
      Log.d('connect websocket fail:[error]${e.toString()}',
          tag: 'sendMessage');
    } finally {
      NormalMessage message = createUserNormalMessage(text);
      _chatWebsocket.sendMessage(
        text: '[message_id=${message.id}]$text',
        onUninited: () {
          Toast.show(
            '发送失败，请稍后再试',
            duration: 1000,
          );
        },
        onSuccess: () {
          insertUserMessage(message, () {
            if (widget.onScrollEnd != null) {
              widget.onScrollEnd!();
            }
            EvaluateUtil().evaluate(message, () {
              _homeProvider.updateNormalMessage(message);
            });
          });
        },
        onFail: () {
          // insertTipMessage('Please switch to new roles, topics, or scene');
        },
      );
    }
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    if (widget.onScrollEnd != null) {
      widget.onScrollEnd!();
    }
  }

  NormalMessage createUserNormalMessage(String text) {
    NormalMessage message = _homeProvider.createNormalMessage(true);
    message.text = text;
    message.audio = [..._bufferList];
    message.speaker = 'user';
    message.lessonId = widget.lessonId;
    message.stepId = widget.stepId;
    message.typeId = "4";
    return message;
  }

  void insertUserMessage(NormalMessage message, Function() onSuccess) {
    _homeProvider.addNormalMessage(message);
    _answer = null;
    onSuccess();
  }

  void sendTwoMessage(String msg, String word) {
    insertTwoUserMessage(word, (message) {
      ClassEvaluateUtil().evaluate(message, (Map<String, dynamic> map) {
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

  void insertTwoUserMessage(
      String text, Function(ClassMessageEntity) onSuccess) {
    ClassMessageEntity message = ClassMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    onSuccess(message);
  }

  Future<bool> requestPermission() async {
    bool phoneSate = await Permission.phone.isDenied;
    if (phoneSate) {
      Toast.show("获取通话状态使用说明:用于对话过程中按住说话状态", duration: 5000);
    }
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    _chatWebsocket = widget.chatWebsocket;
    _recognizeUtil.setLanguage(widget.language ?? 'en');
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    // 监听App状态
    WidgetsBinding.instance.addObserver(this);

    EventBus().on(NotificationUtils.resetANChat, (_) {
      Future.delayed(const Duration(seconds: 1), () async {
        creatResetStatus();
      });
    });

    // 全局监听App状态
    SystemChannels.lifecycle.setMessageHandler((message) async {
      // 退到后台
      if (isUserOpen) {
        // ignore: unrelated_type_equality_checks
        if (message == 'AppLifecycleState.paused') {
          // await MediaUtils().stopPlayByAppPaused();
          creatResetStatus();
        }
        if (message == 'AppLifecycleState.resumed') {
          creatResetStatus();
        }
        if (message == 'AppLifecycleState.inactive') {
          creatResetStatus();
        }
      }
      // _appLifecycleState = message;

      return message;
    });

    // requestPermission();

    if (Device.isIOS) {
      setStream();
    } else {
      and();
    }
  }

  void and() async {
    bool temp = await requestPermission();
    setState(() {
      granted = temp;
      if (granted) {
        setStream();
      }
    });
  }

  void setStream() {
    PhoneState.stream.listen((event) {
      status = event;
      if (status.status.name == "CALL_INCOMING") {
        creatResetStatus();
        _phoneSate = false;
        setState(() {});
      }
      if (status.status.name == "CALL_STARTED") {
        creatResetStatus();
        _phoneSate = false;
        setState(() {});
      }
      if (status.status.name == "CALL_ENDED") {
        creatResetStatus();
        _phoneSate = true;
        setState(() {});
      }
    });
  }

  void creatResetStatus() async {
    await _mediaUtils.stopTwoPlay();
    widget.controller.setShowRecord(false);
    widget.controller.setDisabled(false);
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.inactive) {}
  //   _appLifecycleState = state;

  //   Future.delayed(Duration.zero, () async {
  //     await _mediaUtils.stopTwoPlay();
  //   });
  //   // Future.delayed(Duration.zero, () async {
  //   //   await _mediaUtils.stopPlay();
  //   // });
  // }

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
            dynamic data = snapshot.data;
            if (data == true) {
              if (widget.onFinshEnd != null) {
                widget.onFinshEnd!(data);
              }
            }
            return Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Colours.color_001652,
                ),
                color: data == true
                    ? null
                    : disabled
                        ? const Color(0xFFF8F8F8)
                        : null,
                gradient: data == true || !disabled
                    ? const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colours.color_9AC3FF,
                          Colours.color_FF71E0,
                        ],
                      )
                    : null,
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(100.0),
              //   // border: Border.all(
              //   //   width: 1.0,
              //   //   style: BorderStyle.solid,
              //   //   color: Colours.color_001652,
              //   // ),
              //   color: data == true
              //       ? null
              //       : disabled
              //           ? const Color(0xFFF8F8F8)
              //           : null,
              //   gradient: data == true || !disabled
              //       ? const LinearGradient(
              //           begin: Alignment.bottomLeft,
              //           end: Alignment.topRight,
              //           colors: [
              //             Colours.color_8256FF,
              //             Colours.color_FF5CDB,
              //           ],
              //         )
              //       : null,
              // ),
              alignment: Alignment.center,
              child: data == true
                  ? Image.asset(
                      'assets/images/shengwen.gif',
                      height: 50.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const LoadAssetImage(
                          'maikefeng',
                          width: 24.0,
                          height: 24.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          disabled ? "AI 识别中" : '按住说话',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
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
                onPress: () {
                  if (!showMessageList) {
                    if (widget.onScrollEnd != null) {
                      widget.onScrollEnd!();
                    }
                  }
                  widget.controller.setShowMessageList(!showMessageList);
                },
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
                  // widget.onStarEnd!();
                  EventUMStatistics.umengCommonMapEvent(
                      "click_index_class_dialog");

                  if (!_phoneSate) {
                    return;
                  }
                  if (!isAvailable()) {
                    return;
                  }
                  try {
                    bool hasAgree =
                        SpUtil.getBool(Constant.mediaUtils, defValue: false) ??
                            false;
                    if (!hasAgree) {
                      Toast.show("录音音频使用说明:用于对话场景", duration: 6000);
                      SpUtil.putBool(Constant.mediaUtils, true);
                      widget.controller.setShowRecord(false);
                    }

                    // 检查权限
                    bool isRequest =
                        await _mediaUtils.checkMicrophonePermission();
                    if (isRequest) {
                      Toast.show("录音音频使用说明:用于对话场景", duration: 5000);
                      widget.controller.setShowRecord(false);
                      return;
                    }
                    setState(() {
                      isUserOpen = true;
                    });
                    if (widget.onStartBool != null) {
                      widget.onStartBool!(true);
                    }
                    _recognizeUtil = RecognizeUtil();
                    _recognizeUtil.setLanguage(widget.language ?? 'en');
                    // 开始录音
                    _bufferList = [];
                    _mediaUtils.startRecord(onData: (buffer) {
                      _bufferList.add(buffer);
                      _recognizeUtil.pushAudioBuffer(1, buffer);
                    }, onComplete: (buffer) {
                      _recognizeUtil.pushAudioBuffer(2, buffer ?? Uint8List(0));
                      _bufferList.add(buffer ?? Uint8List(0));
                    });

                    // 设置识别
                    _recognizeUtil.recognize((result) async {
                      bool shoRecord = widget.controller.showRecord.value;
                      // 录音中
                      if (shoRecord) {
                        // 识别失败
                        if (result['success'] == false) {
                          await _mediaUtils.stopRecord();
                          Toast.show(
                            result['message'],
                            duration: 1000,
                          );
                          widget.controller.setShowRecord(false);
                          widget.controller.setDisabled(false);
                        }
                        return;
                      }
                      bool isInSendButton =
                          widget.recordController.isInSendButton.value;
                      // 取消发送
                      if (!isInSendButton) {
                        widget.controller.setDisabled(false);
                        return;
                      }
                      if (result['success'] == false) {
                        Toast.show(
                          result['message'],
                          duration: 1000,
                        );
                        widget.controller.setDisabled(false);
                        widget.controller.setShowRecord(false);
                        return;
                      }

                      String textStr = result['text'];
                      if (textStr.isEmpty) {
                        widget.controller.setDisabled(false);
                        return;
                      }
                      if (widget.repeatWord != "") {
                        //这里先调评测,分高传tag分低穿别的
                        sendTwoMessage(result['text'], widget.repeatWord);
                      } else {
                        sendMessage(result['text']);
                      }
                    });
                    widget.controller.setShowRecord(true);
                  } catch (e) {
                    widget.controller.setDisabled(false);
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
          const Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
            child: SizedBox(
              width: 17.5,
              height: 24.0,
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
