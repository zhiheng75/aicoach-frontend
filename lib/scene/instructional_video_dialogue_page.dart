import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/chat/widget/background.dart';
import 'package:Bubble/chat/widget/course_bottom_bar.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/view/class_show_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/page/class_video_page.dart';
import 'package:Bubble/scene/presenter/instructional_video_dialogue_presenter.dart';
import 'package:Bubble/scene/presenter/teaching_dialogue_presenter.dart';
import 'package:Bubble/scene/view/instructional_video_dialogue_view.dart';
// import 'package:Bubble/scene/widget/top_head_background.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock/wakelock.dart';

import '../chat/entity/message_entity.dart';
import '../chat/utils/chat_websocket.dart';
// import '../chat/widget/bottom_bar.dart';
import '../chat/widget/message_list.dart';
import '../chat/widget/record.dart';
import '../home/provider/home_provider.dart';
import '../home/widget/expiration_reminder.dart';
import '../main.dart';
import '../mvp/base_page.dart';
import '../util/media_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VolumeUtil {
  static Future<double> getVolume() async {
    return VolumeController().getVolume();
  }
}

class InstructionalVideoDialoguePage extends StatefulWidget {
  final StepDetailBean stepDetailData;
  final int idx;

  const InstructionalVideoDialoguePage({
    super.key,
    // required this.onEnd,
    required this.stepDetailData,
    required this.idx,
  });
  // final Function() onEnd;

  @override
  State<InstructionalVideoDialoguePage> createState() =>
      _InstructionalVideoDialoguePageState();
}

class _InstructionalVideoDialoguePageState
    extends State<InstructionalVideoDialoguePage>
    with
        BasePageMixin<InstructionalVideoDialoguePage,
            InstructionalVideoDialoguePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<InstructionalVideoDialoguePage>,
        WidgetsBindingObserver
    implements
        InstructionalVideoDialogueView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  final MediaUtils _mediaUtils = MediaUtils();
  late HomeProvider _homeProvider;
  late InstructionalVideoDialoguePresenter _instructionalVideoDialoguePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  // 消息列表滚动控制器
  final MessageListController _listScrollController = MessageListController();
  // 底部按钮控制器
  final BottomBarController _bottomBarControll = BottomBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();
  // ai回答消息
  NormalMessage? _answer;
  // ai音频播放
  ListPlayer? _listPlayer;
  // app状态
  AppLifecycleState? _appLifecycleState;
  // 是否对话结束
  bool _isConversationEnd = false;

  late String introFileType;
  late int newDataIdx;

  late int resourceIdx = 0;
  late String introFileStr;
  late bool isFrist = true;
  late String resourceSceneId;

  late String stepId;

  late String titStr = "";
  late String isVideo = "0";
  late bool isplay = false;

  late List<CourseDatum> data;
  late int isUserBuy;
  late String levelId;
  late String goodsLabel;

  late String lessonId;
  late double contentTop;
  late String isShowStr = "1";
  late String ischatEndStr = "0";
  late String repeatWord = "";
  late String introVideoCoverStr = "";
  late String isPlayVideo = "0";

  late String mxtitStr;

  late bool isShowDialog = false;

  late Timer _timer;
  late int _secondsRemaining = 5; // 倒计时10秒

  late String isOnePlay = "1";

  late bool isShowbottom = false;
  bool isLoding = true;
  late String sessionId;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isUserOpen = false;

  late bool isback = false;
  late int _invokeInt = 0;

  late bool isNetWork = true;
  late bool isTimeBack = false;
  late int timerInt = 0;
  late DateTime timestamp;

  late Timer _backTimer;
  late int _backTimerInt = 120;

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void init() {
    _pageState = 'success';
    setState(() {});
    connectWebsocket();
  }

  void _startTimer() {
    _secondsRemaining = 5;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        isShowDialog = false;
        _secondsRemaining = 0;
        // newDataIdx = newDataIdx + 1;
        sessionId = const Uuid().v4().replaceAll('-', '');

        forstartFlow(newDataIdx, resourceIdx);
        setState(() {});
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void repeatTextStr(String str) {
    String one = str;
    RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
    for (int i = 0; i < 6; i++) {
      RegExpMatch? match = pattern.firstMatch(one);

      if (match != null) {
        String? tag = match.group(1); // 获取标签名
        String? content = match.group(2); // 获取内容
        if (tag == "image") {
          //去出来图片content
          // coverUrl = content!;
        }
        if (tag == "word") {
          //取出来文字content
          repeatWord = content!;
        }
        String reStr = "<$tag>$content</$tag>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
      }
    }
  }

  void connectWebsocket() async {
    try {
      _chatWebsocket.endChat(true);
      String characterId = _homeProvider.character.characterId;
      String sceneId = resourceSceneId; //_homeProvider.scene!.id.toString();
      // String sceneId = _homeProvider.course!.id.toString();
      _homeProvider.scene!.id = int.parse(resourceSceneId);
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        lessonId: lessonId,
        characterId: characterId,
        sceneId: sceneId,
        sessionIdStr: sessionId,
        onConnected: () {
          // // 刷新使用时间
          // _homeProvider.getUsageTime(() {
          //   // 倒计时
          //   _homeProvider.startUsageTimeCutdown(() {
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
        },
        onAnswer: onWebsocketAnswer,
        onEnd: onWebsocketEnd,
      );
    } catch (e) {
      _pageState = 'fail';
      setState(() {});
    }
  }

  void endSocket() async {
    await _chatWebsocket.endChat(true);
  }

  void onNextSocketEnd() {
    forFlow();
  }

  void onWebsocketAnswer(dynamic answer) {
    if (_answer == null) {
      // 结束标记
      if (answer is String &&
          (answer.contains('[end_session]') ||
              answer.contains('{[finish]}') ||
              RegExp(r'\[end=[0-9a-zA-Z]{16}\]').hasMatch(answer))) {
        ischatEndStr = "1";
        //弹窗点击确定后重新链接
        _instructionalVideoDialoguePresenter.postStepUpdate(lessonId, stepId);
        // onNextSocketEnd();
        _listScrollController.scrollToEnd();

        return;
      }
      // _answer = NormalMessage();
      _answer = _homeProvider.createNormalMessage();
      // 创建播放列表
      _listPlayer = _mediaUtils.createListPlay(() {
        _bottomBarControll.setDisabled(false);
        if (ischatEndStr == "1") {
          //在这里是播放完成
          endSocket();
          ischatEndStr = "0";
          onNextSocketEnd();
        }
      }, true);
      _homeProvider.addNormalMessage(_answer!);
    }
    if (answer is String) {
      if (answer.startsWith('[end')) {
        _answer!.isTextEnd = true;
        // 音频已全部返回
        if (_listPlayer != null) {
          _listPlayer!.setReturnEnd();
        }
        repeatTextStr(_answer!.text);
        _homeProvider.notify();
        _answer = null;
        _listScrollController.scrollToEnd();

        return;
      }
      _answer!.text += answer;
      Log.e("AI说的话" + _answer!.text);

      _homeProvider.notify();
      _listScrollController.scrollToEnd();
      return;
    }

    if (answer is Uint8List) {
      _answer!.audio.add(answer);
      _listScrollController.scrollToEnd();

      if (_appLifecycleState == AppLifecycleState.paused) {
        return;
      }
      if (_listPlayer != null) {
        _listPlayer!.play(answer);
      }
    }
  }

  void onWebsocketEnd(String? reason, String endType) {
    if (isback) {
      return;
    }
    setState(() {
      isback = true;
      _invokeInt = _invokeInt + 1;
    });
    _homeProvider.endUsageTimeCutdown();
    // 正常结束
    if (reason == 'Session End' && endType != 'force') {
      // insertTipMessage('Class finished！');
      _bottomBarControll.setDisabled(true);
      _isConversationEnd = true;
    } else if (reason == 'Error') {
      // 异常结束
      // insertTipMessage('Please switch to new class');
      // init();
      onReold("您的网络不太顺畅，请检查网络情况。");
    } else if (reason == 'keepalive ping timeout') {
      //超时断开走这里
      onReold("离开太久了!");
    } else {
      // DateTime now = DateTime.now();
      // Duration difference = now.difference(timestamp);
      // int seconds = difference.inSeconds;
      // if (seconds > 120) {
      //   isTimeBack = true;
      //   if (isNetWork) {
      //     onReold("离开太久了!");
      //   } else {
      //     onReold("您的网络不太顺畅，请检查网络情况。");
      //   }
      // } else {
      //   onReold("您的网络不太顺畅，请检查网络情况。");
      // }

      //如果切出时间太久了
      if (isTimeBack) {
        isTimeBack = false;
        setState(() {});
//去后台时间太长
        if (isNetWork) {
          onReold("离开太久了!");
        } else {
          onReold("您的网络不太顺畅，请检查网络情况。");
        }
      } else {
        onReold("您的网络不太顺畅，请检查网络情况。");
      }

//       //如果切出时间太久了
//       if (isTimeBack) {
// //去后台时间太长
//         if (isNetWork) {
//           onReold("离开太久了!");
//         } else {
//           onReold("您的网络不太顺畅，请检查网络情况。");
//         }
//       } else {
//         onReold("您的网络不太顺畅，请检查网络情况。");
//       }
    }
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    _listScrollController.scrollToEnd();
  }

  void onReold(String message) {
    ConfirmUtils.showNet(
      context: context,
      title: '提示',
      // buttonDirection: 'vertical',
      confirmButtonText: '重新加载',
      cancelButtonText: '取消',
      onConfirm: () {
        if (!isNetWork) {
          Toast.showBottom("请检查网络");
          return;
        }
        NavigatorUtils.goBack(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isback = false;
            _invokeInt = 0;
            isTimeBack = false;
          });
        });

        //刷新
        forstartFlow(newDataIdx, resourceIdx);
      },
      onCancel: () {
        setState(() {
          _invokeInt = 0;
        });
        // endSocket();
        NavigatorUtils.goBack(context);
        // widget.onEnd();
      },
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
          height: 18.0 / 15.0,
        ),
      ),
    );
  }

  void onConversationEnd() {
    // if (!_isConversationEnd) {
    ConfirmUtils.show(
      context: context,
      title: '结束上课',
      buttonDirection: 'vertical',
      confirmButtonText: '结束对话',
      cancelButtonText: '留在对话中',
      onConfirm: () {
        // endSocket();
        NavigatorUtils.goBack(context);

        // widget.onEnd();
      },
      onCancel: () {
        //留在对话还是退出
      },
      child: const Text(
        '对话进行中，确定要结束吗？',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
          height: 18.0 / 15.0,
        ),
      ),
    );
    //   return;
    // }
    // NavigatorUtils.goBack(context);
    // widget.onEnd();
  }

  void creatResetStatus() async {
    await _mediaUtils.stopTwoPlay();
    _bottomBarControll.setShowRecord(false);
    _bottomBarControll.setDisabled(false);
  }

  var lastPopTime = DateTime.now();

  void intervalClick(int needTime) {
    // 防重复提交
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      Toast.show("您的网络状况不稳定！");
      lastPopTime = DateTime.now();
      print("允许点击");
    } else {
      // lastPopTime = DateTime.now(); //如果不注释这行,则强制用户一定要间隔2s后才能成功点击. 而不是以上一次点击成功的时间开始计算.
      print("请勿重复点击！");
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    contentTop = _screenUtil.statusBarHeight + _screenUtil.screenWidth / 16 * 9;
    newDataIdx = widget.idx;
    resourceIdx = 0;
    WidgetsBinding.instance.addObserver(this);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _invokeInt = _invokeInt + 1;
      setState(() {});
      Log.e("===============" + result.toString() + "++++++++++++");
      if (result == ConnectivityResult.none) {
        isNetWork = false;

        isback = true;
        setState(() {});

        if (_invokeInt == 1) {
          endSocket();
          onReold("您的网络不太顺畅，请检查网络情况。");
        }
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        isNetWork = true;
        isback = true;
        setState(() {});
        if (_invokeInt == 1) {
          intervalClick(180);
          Future.delayed(const Duration(seconds: 3), () {
            connectWebsocket();
            setState(() {
              _invokeInt = 0;
            });
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              isback = false;
            });
          });
        }
      }
      setState(() {});
    });

    EventBus().on(NotificationUtils.courseType, (_) {
      if (ischatEndStr == "1") {
        //在这里是播放完成
        endSocket();
        ischatEndStr = "0";
        onNextSocketEnd();
      }
    });

    EventBus().on(NotificationUtils.nextClass, (idx) {
      newDataIdx = newDataIdx + 1;
      resourceIdx = 0;
      sessionId = const Uuid().v4().replaceAll('-', '');

      forstartFlow(newDataIdx, resourceIdx);
      // forFlow();
    });

    EventBus().on(NotificationUtils.messageEnd, (idx) {
      _listScrollController.scrollToEnd();
    });

    data = widget.stepDetailData.data.data;
    isUserBuy = widget.stepDetailData.data.isUserBuy;
    levelId = widget.stepDetailData.data.levelId.toString();
    lessonId = widget.stepDetailData.data.lessonId.toString();
    goodsLabel = widget.stepDetailData.data.goodsLabel.toString();
    // });

    _pageState = 'success';
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _homeProvider.ishread = "0";
    sessionId = const Uuid().v4().replaceAll('-', '');
    forstartFlow(newDataIdx, resourceIdx);
    // 监听App状态
    //   ScreenUtil.init(context);
// ScreenUtil.registerToBuild(context)
    //     // 监听锁屏状态变化
    // ScreenUtil.lockedStateStream.listen((locked) {
    //   if (locked) {
    //     // 手机锁屏了
    //     print('手机锁屏了');
    //   } else {
    //     // 手机解锁了
    //     print('手机解锁了');
    //   }
    // });
    EventUMStatistics.umengCommonOnPageStart(
        "instructional_video_dialogue_page");

    Future.delayed(const Duration(milliseconds: 200), () {
      isLoding = false;
      setState(() {});
    });

    // 全局监听App状态
    SystemChannels.lifecycle.setMessageHandler((message) async {
      Log.e("++++++++++++++++++++=================");

      // 退到后台
      if (introFileType == "video") {
        if (await _controller!.isPlaying()) {
          _controller!.pause();
        }
      }

      if (message == 'AppLifecycleState.paused') {
        //推到后台
        Log.e("AppLifecycleState.paused");
        timestamp = DateTime.now();
        isTimeBack = true;
        // isback = true;
        setState(() {});
        // isback = true;
        // _startBackTimer();
      }
      if (message == 'AppLifecycleState.resumed') {
        //回到前台
        // _cancelTimer();
        isTimeBack = false;
        // isback = false;
        setState(() {});
        Log.e("AppLifecycleState.resumed");
        // int resumedTime = getCurrentTime();
        // DateTime now = DateTime.now();
        // Duration difference = now.difference(timestamp);
        // int seconds = difference.inSeconds;
        // if (seconds > 120) {
        //   isTimeBack = true;
        //   if (isNetWork) {
        //     onReold("离开太久了!");
        //   } else {
        //     onReold("您的网络不太顺畅，请检查网络情况。");
        //   }
        // } else {
        //   isTimeBack = false;
        //   isback = false;
        // }
        // setState(() {});
      }

      return message;
    });
  }

  ///启动倒计时器
  void _startBackTimer() {
    _backTimerInt = 120;
    _backTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_backTimerInt == 0) {
        _cancelTimer();
        if (isNetWork) {
          onReold("离开太久了!");
        } else {
          onReold("您的网络不太顺畅，请检查网络情况。");
        }
        isback = true;
        setState(() {});
        return;
      }
      _backTimerInt = _backTimerInt - 1;
      Log.e("==========" + _backTimerInt.toString());
    });
  }

  void _cancelTimer() {
    _backTimer?.cancel();
  }

  // int getCurrentTime() {
  //   // 获取当前时间
  //   DateTime now = DateTime.now();
  //   return now.minute;
  // }

  // @override
  // void didChangeDependencies() {
  //   routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  //   super.didChangeDependencies();
  // }

  // @override
  // void didPush() {
  //   // TODO: implement didPush
  //   super.didPush();
  //   //从其他页面过来
  //   isShowStr = "1";
  // }

  // @override
  // void didPushNext() {
  //   // TODO: implement didPushNext
  //   super.didPushNext();
  //   isShowStr = "2";
  // }

  // @override
  // void didPopNext() {
  //   // TODO: implement didPopNext
  //   super.didPopNext();
  //   setState(() {
  //     isShowStr = "1";
  //   });
  // }

  // showImageDialog() {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return ClassShowView(() {
  //           //确定
  //           resourceIdx = 0;
  //           forstartFlow(newDataIdx, resourceIdx);
  //         }, () {
  //           //重新来
  //           resourceIdx = 0;

  //           newDataIdx = newDataIdx - 1;
  //           forstartFlow(newDataIdx, resourceIdx);
  //         });
  //       });
  // }

  Widget showDia() {
    return Container(
      color: const Color.fromRGBO(1, 1, 1, 0.5),
      child: Center(
        child: Container(
          height: 310,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageUtils.getAssetImage("tanchuang"),
                fit: BoxFit.fitHeight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gaps.vGap168,
              Container(
                height: 235,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _timer.cancel();
                      //重新开始
                      newDataIdx = newDataIdx - 1;

                      sessionId = const Uuid().v4().replaceAll('-', '');
                      isOnePlay = "1";
                      isShowDialog = false;
                      isTimeBack = false;
                      setState(() {});
                      forstartFlow(newDataIdx, resourceIdx);
                    },
                    child: Container(
                      width: 114,
                      height: 53,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ImageUtils.getAssetImage(
                              "quxiao_img",
                            ),
                            fit: BoxFit.fill),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Restart",
                            style: TextStyle(
                                fontSize: 17, color: Colours.color_875EFF),
                          ),
                          Text(
                            "重新开始",
                            style: TextStyle(
                                fontSize: 11, color: Colours.color_875EFF),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gaps.hGap15,
                  GestureDetector(
                    onTap: () async {
                      _timer.cancel();

                      //下一关
                      isShowDialog = false;
                      isTimeBack = false;
                      sessionId = const Uuid().v4().replaceAll('-', '');
                      setState(() {});
                      forstartFlow(newDataIdx, resourceIdx);
                    },
                    child: Container(
                      width: 114,
                      height: 53,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ImageUtils.getAssetImage(
                              "class_qurding_img",
                            ),
                            fit: BoxFit.fill),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_secondsRemaining.toString()}s Next",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                          ),
                          const Text(
                            "下一环节",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void forFlow() {
    resourceIdx = resourceIdx + 1;
    // dataIdx = dataIdx + 1;
    if (resourceIdx < data[newDataIdx].resource.length) {
      // resourceIdx = resourceIdx + 1;
      sessionId = const Uuid().v4().replaceAll('-', '');

      forstartFlow(newDataIdx, resourceIdx);
    } else {
      newDataIdx = newDataIdx + 1;
      if (newDataIdx < data.length) {
        resourceIdx = 0;

        isShowDialog = true;
        _startTimer();
        setState(() {});
        // showImageDialog();
      } else {
        //退出界面
        NavigatorUtils.goBack(context);
      }
    }
  }

  void forstartFlow(int dataIdx, int resourceIdx) {
    if (data[dataIdx].resource[resourceIdx].resourceType == 2) {
      endSocket();
      //跳游戏
      Future.delayed(const Duration(seconds: 1), () {
        NavigatorUtils.push(context,
            "${HomeRouter.webviewNotNavPage}?url=${Uri.encodeComponent(data[dataIdx].resource[resourceIdx].gameUrl ?? "")}&index=$dataIdx&type=2",
            arguments: widget.stepDetailData);
      });
    } else {
      // endSocket();
      setState(() {
        resourceSceneId =
            data[dataIdx].resource[resourceIdx].sceneId.toString();
        introFileType = data[dataIdx].resource[resourceIdx].introFileType!;
        titStr = data[dataIdx].resource[resourceIdx].title ?? "";
        stepId = data[dataIdx].stepId.toString();
        _homeProvider.scene!.id = int.parse(resourceSceneId);
        // connectWebsocket();
        if (introFileType == "video") {
          isVideo = "1";
          isPlayVideo = "0";
          introFileStr = data[dataIdx].resource[resourceIdx].introFile!;
          introVideoCoverStr =
              data[dataIdx].resource[resourceIdx].introVideoCover;
          contentTop = _screenUtil.statusBarHeight +
              _screenUtil.screenWidth / 16 * 9 +
              80;
          isback = true;
          setState(() {});
          videoFlow();
        } else if (introFileType == "image") {
          isVideo = "0";

          introFileStr = data[dataIdx].resource[resourceIdx].introFile!;
          contentTop = _screenUtil.statusBarHeight +
              _screenUtil.screenWidth / 16 * 9 +
              80;

          imgFlowRequestNetwork();
          init();
        } else {
          contentTop = _screenUtil.statusBarHeight + 240;
          isVideo = "0";
          introFileStr = _homeProvider.character.motionImageD;
          imgFlowRequestNetwork();
          init();
        }
      });
    }
  }

  //视频顺序
  void videoFlow() {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.post, HttpApi.generateAudio,
        params: {
          'text': data[newDataIdx].resource[resourceIdx].introText!,
          'character_id': _homeProvider.character.characterId,
        }, onSuccess: (result) {
      if (result?.code == 200) {
        Map<String, dynamic> data = result?.data as Map<String, dynamic>;
        startNormalChat(data['text'], data['speech_url']);
      } else {
        startNormalChat(data[newDataIdx].resource[resourceIdx].introText!,
            data[newDataIdx].resource[resourceIdx].introAudio!);
      }
    }, onError: (code, msg) {
      startNormalChat(data[newDataIdx].resource[resourceIdx].introText!,
          data[newDataIdx].resource[resourceIdx].introAudio!);
    });
  }

  void startNormalChat(String introText, String introAudio) async {
    await _mediaUtils.stopPlay();

    Future.delayed(Duration.zero, () {
      _bottomBarControll.setDisabled(true);

      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = introText;
      normalMessage.audioUrl = introAudio;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _listScrollController.scrollToEnd();

      _mediaUtils.play(
        url: introAudio,
        useAvatar: true,
        whenFinished: () async {
          setState(() {
            isPlayVideo = "1";
          });
          //通知播放视频
          _controller?.play();
          double volume = await VolumeUtil.getVolume();
          _controller?.setVolume(volume);
        },
      );
    });
  }

  void startNormaltwoChatRequestNetwork() {
    init();
    DioUtils.instance.requestNetwork<ResultData>(
        Method.post, HttpApi.generateAudio,
        params: {
          'text': data[newDataIdx].resource[resourceIdx].greetingText!,
          'character_id': _homeProvider.character.characterId,
        }, onSuccess: (result) {
      if (result?.code == 200) {
        Map<String, dynamic> data = result?.data as Map<String, dynamic>;
        startNormaltwoChat(data['text'], data['speech_url']);
      } else {
        startNormaltwoChat(data[newDataIdx].resource[resourceIdx].greetingText!,
            data[newDataIdx].resource[resourceIdx].greetingAudio!);
      }
    }, onError: (code, msg) {
      startNormaltwoChat(data[newDataIdx].resource[resourceIdx].greetingText!,
          data[newDataIdx].resource[resourceIdx].greetingAudio!);
    });
  }

  void startNormaltwoChat(String introText, String introAudio) async {
    await _mediaUtils.stopPlay();

    Future.delayed(Duration.zero, () {
      _bottomBarControll.setDisabled(true);

      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = introText;
      normalMessage.audioUrl = introAudio;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _listScrollController.scrollToEnd();

      _mediaUtils.play(
        url: introAudio,
        useAvatar: true,
        whenFinished: () {
          // setState(() {
          // isFrist = false;
          isback = false;
          setState(() {});
          _bottomBarControll.setDisabled(false);
          // });
        },
      );
    });
  }

  //图片及其他顺序
  void imgFlowRequestNetwork() async {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.post, HttpApi.generateAudio,
        params: {
          'text': data[newDataIdx].resource[resourceIdx].greetingText!,
          'character_id': _homeProvider.character.characterId,
        }, onSuccess: (result) {
      if (result?.code == 200) {
        Map<String, dynamic> data = result?.data as Map<String, dynamic>;
        imgFlow(data['text'], data['speech_url']);
      } else {
        imgFlow(data[newDataIdx].resource[resourceIdx].greetingText!,
            data[newDataIdx].resource[resourceIdx].greetingAudio!);
      }
    }, onError: (code, msg) {
      imgFlow(data[newDataIdx].resource[resourceIdx].greetingText!,
          data[newDataIdx].resource[resourceIdx].greetingAudio!);
    });
  }

  void imgFlow(String introText, String introAudio) async {
    await _mediaUtils.stopPlay();

    Future.delayed(Duration.zero, () {
      _bottomBarControll.setDisabled(true);

      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = introText;
      normalMessage.audioUrl = introAudio;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _listScrollController.scrollToEnd();

      _mediaUtils.play(
        url: introAudio,
        useAvatar: true,
        whenFinished: () {
          _bottomBarControll.setDisabled(false);
        },
      );
    });
  }

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    setState(() {
      isback = true;
    });

    endSocket();
  }

  void end() async {
    await _mediaUtils.stopPlay();
  }

  @override
  void dispose() {
    Wakelock.disable();
    subscription.cancel();
    endSocket();
    end();
    EventBus().off(NotificationUtils.nextClass);
    EventBus().off(NotificationUtils.messageEnd);

    _homeProvider.ishread = "";
    WidgetsBinding.instance.removeObserver(this);

    _controller?. //
        onPlaybackStatusChanged
        .removeListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .removeListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .removeListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .removeListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .removeListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .removeListener(_onPlaybackEnded);
    _controller = null;
    EventUMStatistics.umengCommonOnPageEnd("instructional_video_dialogue_page");
    routeObserver.unsubscribe(this); //取消订阅

    super.dispose();
  }

  void _onPlaybackReady() {
    setState(() {});
    if (isAutoplayEnabled) {
      _controller?.play();
    }
  }

  void _onPlaybackStatusChanged() {
    setState(() {});
  }

  void _onPlaybackPositionChanged() {
    isPlayVideo = "1";
    if (_controller?.playbackInfo?.position ==
        _controller?.videoInfo?.duration) {
      //播放完成重置状态
      setState(() {
        isPlayVideo = "0";
      });
    }
    setState(() {});
  }

  void _onPlaybackSpeedChanged() {
    setState(() {});
  }

  void _onPlaybackVolumeChanged() {
    setState(() {});
  }

  void _onPlaybackEnded() {
    isback = true;
    setState(() {});
    // if (isOnePlay == "1") {
    //   isOnePlay = "2";
    startNormaltwoChatRequestNetwork();
    // }
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }

  NativeVideoPlayerController? _controller;

  Future<void> _initController(controller) async {
    _controller = controller;

    _controller?. //
        onPlaybackStatusChanged
        .addListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .addListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .addListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .addListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .addListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .addListener(_onPlaybackEnded);

    await _loadVideoSource();
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await _createVideoSource();
    await _controller?.loadVideoSource(videoSource);
  }

  Future<VideoSource> _createVideoSource() async {
    return await VideoSource.init(
      path: introFileStr,
      type: VideoSourceType.network,
    );
  }

  Future<bool> get _isPlaying async => await _controller?.isPlaying() ?? false;

  Future<void> _togglePlayback() async {
    final isPlaying = await _isPlaying;
    if (isPlaying) {
      await _controller?.pause();
    } else {
      isPlayVideo = "1";
      await _controller?.play();
    }
    setState(() {});
  }

  Widget topWidget() {
    if (introFileType == "video") {
      return Positioned(
        top: _screenUtil.statusBarHeight + 68,
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenWidth / 16 * 9,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: NativeVideoPlayerView(
                onViewReady: _initController,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    isShowbottom = !isShowbottom;
                  });
                  Future.delayed(const Duration(seconds: 5), () {
                    setState(() {
                      isShowbottom = false;
                    });
                  });
                },
                child: Container(),
              ),
            ),
            isShowbottom
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: _screenUtil.screenWidth,
                      height: 40,
                      color: Colors.black87,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                          ),
                          InkWell(
                            onTap: _togglePlayback,
                            child: Center(
                              child: FutureBuilder(
                                future: _isPlaying,
                                initialData: false,
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<bool> snapshot,
                                ) {
                                  final isPlaying = snapshot.data ?? false;
                                  return Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 30,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              // min: 0,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white54,
                              thumbColor: Colors.white,
                              max: (_controller?.videoInfo?.duration ?? 0)
                                  .toDouble(),
                              value: (_controller?.playbackInfo?.position ?? 0)
                                  .toDouble(),
                              onChanged: (value) =>
                                  _controller?.seekTo(value.toInt()),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                formatDuration(
                                  Duration(
                                      seconds:
                                          _controller?.playbackInfo?.position ??
                                              0),
                                ),
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "/",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                formatDuration(
                                  Duration(
                                      seconds:
                                          _controller?.videoInfo?.duration ??
                                              0),
                                ),
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 10,
                          ),
                        ],
                      ),
                    ))
                : Container(),
          ],
        ),
      );
    } else if (introFileType == "image") {
      return Positioned(
        top: _screenUtil.statusBarHeight + 68,
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenWidth / 16 * 9,
        child: LoadImage(
          introFileStr,
          width: _screenUtil.screenWidth,
          height: _screenUtil.screenWidth / 16 * 9,
        ),
      );
    } else {
      return Positioned(
        top: _screenUtil.statusBarHeight + 68,
        left: (_screenUtil.screenWidth - 167) / 2,
        // width: 100,
        // height: 100,
        child: StreamBuilder(
          stream: AvatarController().getStream(),
          builder: (_, snapshot) {
            dynamic data = snapshot.data;

            return data == true
                ? LoadImage(
                    _homeProvider.character.motionImage,
                    format: ImageFormat.gif,
                    // width: 180.0,
                    height: 180.0,
                  )
                : LoadImage(
                    _homeProvider.character.stillImage,
                    format: ImageFormat.gif,
                    // width: 150.0,
                    height: 180.0,
                  );
          },
        ),
      );
    }
  }

  ///返回事件
  void onBack() {
    onConversationEnd();
  }

  Widget navbar() {
    return SizedBox(
      height: _screenUtil.statusBarHeight + 84,
      width: _screenUtil.screenWidth,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              onBack();
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 30,
              height: 30,
              child: Image.asset(
                width: 20,
                height: 26,
                'assets/images/ic_back_icon.png',
              ),
            ),
          ),
          Expanded(
            child: Center(
                child: Text(
              titStr,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )),
          ),
          isUserBuy == 1
              ? Container(
                  width: 35,
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
//到课程购买页
                    NavigatorUtils.push(
                      context,
                      "${PersonalRouter.courseSpeakingPurchasePage}?levelId=$levelId&goodsLabel=1",
                      // "${HomeRouter.coursePurchasePage}?levelId=$levelId",
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const LoadAssetImage(
                      'class_vip_icon',
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget topFlowWidget() {
    return Positioned(
      top: _screenUtil.statusBarHeight + 40,
      left: (_screenUtil.screenWidth - 130) / 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: const Color.fromRGBO(1, 1, 1, 0.1),
        ),
        width: 130,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildItems(),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < data.length; i++) {
      if (i == newDataIdx) {
        list.add(
          const SizedBox(
            width: 15,
            height: 15,
            child: Card(
              color: Colours.color_FF4343,
            ),
          ),
        );
      } else {
        list.add(
          const SizedBox(
            width: 15,
            height: 15,
            child: Card(
              color: Colours.color_FFFFFF9,
            ),
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        Widget background = SizedBox(
          height: _screenUtil.screenHeight,
          width: _screenUtil.screenWidth,
          child: LoadImage(provider.scene?.cover ?? '', fit: BoxFit.fill),
        );
        Widget inner;
        if (_pageState == 'success') {
          inner = Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _bottomBarControll.showMessageList,
                  builder: (_, showMessageList, __) {
                    if (!showMessageList) {
                      return const SizedBox();
                    }
                    return Container(
                      width: _screenUtil.screenWidth,
                      // color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: MessageList(controller: _listScrollController),
                    );
                  },
                ),
              ),
              Gaps.vGap10,
              Padding(
                padding: EdgeInsets.only(
                  bottom: _screenUtil.bottomBarHeight + 16.0,
                ),
                child: CourseBottomBar(
                  repeatWord: repeatWord,
                  stepId: stepId,
                  sceneId: resourceSceneId,
                  lessonId: lessonId,
                  chatWebsocket: _chatWebsocket,
                  controller: _bottomBarControll,
                  recordController: _recordController,
                  onFinshEnd: (data) {
                    // if (data == true) {}
                  },
                  onStartBool: (isfinsh) {
                    setState(() {
                      isUserOpen = isfinsh;
                    });
                  },
                  onScrollEnd: () {
                    _listScrollController.scrollToEnd();
                  },
                  onError: () {},
                ),
              ),
            ],
          );
        } else {
          inner = Column(
            children: <Widget>[
              if (_pageState == 'loading') const LoadData(),
              if (_pageState == 'fail')
                LoadFail(
                  reload: init,
                ),
            ],
          );
        }

        Widget content = SizedBox(
          width: _screenUtil.screenWidth,
          height: _screenUtil.screenHeight - contentTop,
          child: inner,
        );

        return Scaffold(
          body: isLoding == true
              ? lodingView()
              : Stack(
                  children: [
                    background,
                    Positioned(
                      top: contentTop,
                      left: 0,
                      child: content,
                    ),
                    Positioned(top: 0, left: 0, right: 0, child: navbar()),
                    topWidget(),
                    topFlowWidget(),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ValueListenableBuilder(
                        valueListenable: _bottomBarControll.showRecord,
                        builder: (_, show, __) =>
                            Record(show: show, controller: _recordController),
                      ),
                    ),
                    isShowDialog == true
                        ? Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: showDia())
                        : Positioned(top: 0, child: Container()),
                  ],
                ),
        );
      },
    );
  }

  @override
  InstructionalVideoDialoguePresenter createPresenter() {
    _instructionalVideoDialoguePresenter =
        InstructionalVideoDialoguePresenter();
    return _instructionalVideoDialoguePresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(String data) {
    // TODO: implement sendSuccess
    EventBus().emit(NotificationUtils.nextResetChat);
  }
}
