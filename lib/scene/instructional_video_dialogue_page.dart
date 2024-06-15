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
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

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

// final RouteObserver<Route<dynamic>> routeObserver = RouteObserver();

class VolumeUtil {
  static Future<double> getVolume() async {
    return VolumeController().getVolume();
  }
}

class InstructionalVideoDialoguePage extends StatefulWidget {
  // final List<CourseDatum> data;
  final StepDetailBean stepDetailData;
  final int idx;

  // final String characterHeadCover;

  const InstructionalVideoDialoguePage({
    super.key,
    required this.onEnd,
    required this.stepDetailData,
    required this.idx,

    // required this.characterHeadCover,
  });
  final Function() onEnd;

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

  // late VideoPlayerController _controller;
  late String introFileType;
  late int newDataIdx;

  late int resourceIdx = 0;
  late String introFileStr;
  late bool isFrist = true;
  late String resourceSceneId;

  late String stepId;

  late String titStr;
  late String isVideo = "0";
  late bool isplay = false;

  late List<CourseDatum> data;
  late int isUserBuy;
  late String levelId;
  late String lessonId;
  late double contentTop;
  late String isShowStr = "1";
  // late int chatNumberEnd = 0;
  late String ischatEndStr = "0";
  late String repeatWord = "";
  late String introVideoCoverStr = "";
  late String isPlayVideo = "0";

  late String mxtitStr;

  late bool isShowDialog = false;

  late Timer _timer;
  late int _secondsRemaining = 5; // 倒计时10秒

  late String isOnePlay = "1";
  // final BackgroundController _backgroundController = BackgroundController();

  late bool isShowbottom = false;

  void init() {
    _pageState = 'success';
    setState(() {});
    connectWebsocket();
    // String characterId = _homeProvider.character.characterId;
    // String sceneId = resourceSceneId; //_homeProvider.scene!.id.toString();
    // // String sceneId = _homeProvider.course!.id.toString();
    // _homeProvider.scene!.id = int.parse(resourceSceneId);
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
    if (one.contains("<image>") && one.contains("<word>")) {
      for (int i = 0; i < 2; i++) {
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
    } else if (one.contains("<word>")) {
      RegExpMatch? match = pattern.firstMatch(one);

      if (match != null) {
        String? tag = match.group(1); // 获取标签名
        String? content = match.group(2); // 获取内容
        Log.e('===============Tag: $tag, Content: $content');
        repeatWord = content!;
      }
    } else {
      repeatWord = "";
    }
  }

  void connectWebsocket() async {
    try {
      // _chatWebsocket.endChat(true);
      String characterId = _homeProvider.character.characterId;
      String sceneId = resourceSceneId; //_homeProvider.scene!.id.toString();
      // String sceneId = _homeProvider.course!.id.toString();
      _homeProvider.scene!.id = int.parse(resourceSceneId);
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        lessonId: lessonId,
        characterId: characterId,
        sceneId: sceneId,
        onConnected: () {
          // _pageState = 'success';
          // setState(() {});
          // _homeProvider.addIntroductionMessage();
          // // _homeProvider.addTipMessage('class started！');
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

          // // 倒计时
          // _homeProvider.startUsageTimeCutdown(() {
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
          Log.e("11111111111111111111111111111这里弹窗");
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

        // if (mxtitStr.contains('{[finish]}')) {
        //   ischatEndStr = "1";
        //   //弹窗点击确定后重新链接
        //   _instructionalVideoDialoguePresenter.postStepUpdate(lessonId, stepId);
        //   // onNextSocketEnd();
        // }

        return;
      }
      _answer!.text += answer;

      // mxtitStr = _answer!.text;
      _homeProvider.notify();
      _listScrollController.scrollToEnd();
      return;
    }
    // Log.e(answer);
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
    _homeProvider.endUsageTimeCutdown();

    // 异常结束
    if (reason == 'Error') {
      // insertTipMessage('Please switch to new class');
      init();
    }
    // 正常结束
    if (reason == 'Session End' && endType != 'force') {
      // insertTipMessage('Class finished！');
      _bottomBarControll.setDisabled(true);
      _isConversationEnd = true;
    }
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    _listScrollController.scrollToEnd();
  }

  void onConversationEnd() {
    if (!_isConversationEnd) {
      ConfirmUtils.show(
        context: context,
        title: '结束上课',
        buttonDirection: 'vertical',
        confirmButtonText: '结束对话',
        cancelButtonText: '留在对话中',
        onConfirm: () {
          endSocket();
          Navigator.of(context).pop();
          widget.onEnd();
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
      return;
    }
    Navigator.of(context).pop();
    widget.onEnd();
  }

  @override
  void initState() {
    super.initState();
    contentTop = _screenUtil.statusBarHeight + 300.0;
    newDataIdx = widget.idx;
    resourceIdx = 0;
    WidgetsBinding.instance.addObserver(this);

    EventBus().on(NotificationUtils.nextClass, (idx) {
      newDataIdx = newDataIdx + 1;
      resourceIdx = 0;
      forstartFlow(newDataIdx, resourceIdx);
      // forFlow();
    });

    // 全局监听App状态
    // SystemChannels.lifecycle.setMessageHandler((message) async {
    //   // 退到后台
    //   // if (_appLifecycleState == 'AppLifecycleState.inactive' ||
    //   //     message == 'AppLifecycleState.paused') {}
    //   if (message == 'AppLifecycleState.inactive') {
    //     if (isShowStr == "1") {
    //       // 应用程序已经进入后台 或锁屏
    //       ConfirmUtils.showSingle(
    //         context: context,
    //         title: "请重新开始对话",
    //         onCancel: () {
    //           endSocket();
    //           Navigator.of(context).pop();
    //           widget.onEnd();
    //         },
    //       );
    //       isShowStr = "2";
    //     }
    //     // ConfirmUtils.showSingle(
    //     //   context: context,
    //     //   title: "请重新开始对话",
    //     //   onCancel: () {
    //     //     endSocket();
    //     //     Navigator.of(context).pop();
    //     //     widget.onEnd();
    //     //   },
    //     // );
    //   }
    //   return message;
    // });
    // setState(() {
    data = widget.stepDetailData.data.data;
    isUserBuy = widget.stepDetailData.data.isUserBuy;
    levelId = widget.stepDetailData.data.levelId.toString();
    lessonId = widget.stepDetailData.data.lessonId.toString();
    // });

    _pageState = 'success';
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _homeProvider.ishread = "0";

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
    EventUMStatistics.umengCommonPageCollectionModeAuto();
    EventUMStatistics.umengCommonOnPageStart("【课程对话】页面停留时长");
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    //从其他页面过来
    isShowStr = "1";
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
    isShowStr = "2";
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    setState(() {
      isShowStr = "1";
    });
  }

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ClassShowView(() {
            //确定
            resourceIdx = 0;
            forstartFlow(newDataIdx, resourceIdx);
          }, () {
            //重新来
            resourceIdx = 0;

            newDataIdx = newDataIdx - 1;
            forstartFlow(newDataIdx, resourceIdx);
          });
        });
  }

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
                      setState(() {
                        isShowDialog = false;
                      });
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
                      setState(() {
                        isShowDialog = false;
                      });

                      forstartFlow(newDataIdx, resourceIdx);
                    },
                    child: Container(
                      width: 114,
                      height: 53,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ImageUtils.getAssetImage(
                              "queding_img",
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
      forstartFlow(newDataIdx, resourceIdx);
    } else {
      newDataIdx = newDataIdx + 1;
      if (newDataIdx < data.length) {
        resourceIdx = 0;

        isShowDialog = true;
        _startTimer();
        setState(() {});
        // showImageDialog();

        // ConfirmUtils.show(
        //   context: context,
        //   title: '是否进行下一段对话',
        //   buttonDirection: 'vertical',
        //   confirmButtonText: '结束',
        //   cancelButtonText: '下一段对话',
        //   onConfirm: () {
        //     endSocket();
        //     Navigator.of(context).pop();
        //     widget.onEnd();
        //   },
        //   onCancel: () {
        //     forstartFlow(dataIdx, resourceIdx);

        //     // endSocket();
        //   },
        //   child: const Text(
        //     '',
        //     style: TextStyle(
        //       fontSize: 15.0,
        //       fontWeight: FontWeight.w400,
        //       color: Color(0xFF333333),
        //       height: 18.0 / 15.0,
        //     ),
        //   ),
        // );
      } else {
        //退出界面
        Navigator.of(context).pop();
      }
    }
  }

  void forstartFlow(int dataIdx, int resourceIdx) {
    if (data[dataIdx].resource[resourceIdx].resourceType == 2) {
      //跳游戏
      Future.delayed(const Duration(seconds: 1), () {
        NavigatorUtils.push(context,
            "${HomeRouter.webviewNotNavPage}?url=${Uri.encodeComponent(data[dataIdx].resource[resourceIdx].gameUrl ?? "")}&index=$dataIdx&type=2",
            arguments: widget.stepDetailData);
      });
    } else {
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
          contentTop = _screenUtil.statusBarHeight + 300.0;

          videoFlow();
        } else if (introFileType == "image") {
          isVideo = "0";

          introFileStr = data[dataIdx].resource[resourceIdx].introFile!;
          contentTop = _screenUtil.statusBarHeight + 300.0;

          imgFlowRequestNetwork();
          init();
        } else {
          contentTop = _screenUtil.statusBarHeight + 240.0;

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
    // await _chatWebsocket.endChat(true);
    // _homeProvider.resetChatParams();
    // _homeProvider.character = character;
    Future.delayed(Duration.zero, () {
      // _isCharacterChanging = false;
      _bottomBarControll.setDisabled(true);
      // _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
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
    // setState(() {
    //   isPlayVideo = "0";
    // });
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
        startNormalChat(data[newDataIdx].resource[resourceIdx].greetingText!,
            data[newDataIdx].resource[resourceIdx].greetingAudio!);
      }
    }, onError: (code, msg) {
      startNormalChat(data[newDataIdx].resource[resourceIdx].greetingText!,
          data[newDataIdx].resource[resourceIdx].greetingAudio!);
    });
  }

  void startNormaltwoChat(String introText, String introAudio) async {
    await _mediaUtils.stopPlay();
    // await _chatWebsocket.endChat(true);
    // _homeProvider.resetChatParams();
    // _homeProvider.character = character;
    Future.delayed(Duration.zero, () {
      // _isCharacterChanging = false;
      _bottomBarControll.setDisabled(true);
      // _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
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
          _bottomBarControll.setDisabled(false);
          // });
        },
      );
    });
    init();
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
    // await _chatWebsocket.endChat(true);
    // _homeProvider.resetChatParams();
    // _homeProvider.character = character;
    Future.delayed(Duration.zero, () {
      // _isCharacterChanging = false;
      _bottomBarControll.setDisabled(true);
      // _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.inactive) {
    //   if (isShowStr == "1") {
    //     // 应用程序已经进入后台 或锁屏
    //     ConfirmUtils.showSingle(
    //       context: context,
    //       title: "请重新开始对话",
    //       onCancel: () {
    //         endSocket();
    //         Navigator.of(context).pop();
    //         widget.onEnd();
    //       },
    //     );
    //     isShowStr = "2";
    //   }
    // }
    // _appLifecycleState = state;
    // Future.delayed(Duration.zero, () async => await _mediaUtils.stopPlay());
  }

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;
  @override
  void dispose() {
    _mediaUtils.stopPlay();
    routeObserver.unsubscribe(this); //取消订阅

    EventBus().off(NotificationUtils.nextClass);
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
    EventUMStatistics.umengCommonOnPageEnd("【课程对话】页面停留时长");

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
      if (isOnePlay == "1") {
        isOnePlay = "2";
        startNormaltwoChatRequestNetwork();
      }
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

  Widget topMengWidget() {
    return Positioned(
        top: 0,
        width: _screenUtil.screenWidth,
        // height: _screenUtil.screenWidth / 16 * 9,
        child: Container(
          width: _screenUtil.screenWidth,
          height: 400,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(20.0),
            // border: Border.all(
            //   width: 1.0,
            //   style: BorderStyle.solid,
            //   color: Colours.color_001652,
            // ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0.95),
                Color.fromRGBO(255, 255, 255, 0.95),
                Color.fromRGBO(255, 255, 255, 0.95),

                Color.fromRGBO(255, 255, 255, 0.1),

                // Colors.white70,
                // Colors.white60,
                // Colors.white54,
                // Colors.white38,
                // Colors.white30,
                // Colors.white24,
                // Colors.white24,
                // Colors.white24,
                // Colors.white12,
                // Colors.white12,
                // Colors.white12,
                // Colors.white10,
              ],
            ),
          ),
        )
        //  LoadImage(
        //   "class_top_meng",
        //   width: _screenUtil.screenWidth,
        //   height: 63,
        // ),
        );
  }
//   Future<bool> videoIsPlaying()async{
//  _controller!.isPlaying();
//   }

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
                          // _isPlaying?
                          //      IconButton(
                          //         icon: const Icon(Icons.play_arrow),
                          //         onPressed: () => _controller?.play(),
                          //       )
                          //     : IconButton(
                          //         icon: const Icon(Icons.pause),
                          //         onPressed: () => _controller?.pause(),
                          //       ),
                          Expanded(
                            child: Slider(
                              // min: 0,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.white,
                              // secondaryActiveColor: Colors.red,
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
                          //                       Row(
                          //                         children: [
                          //                           Text('''
                          // Speed: ${_controller?.playbackInfo?.speed.toStringAsFixed(2)}'''),
                          //                           Expanded(
                          //                             child: Slider(
                          //                               value: _controller?.playbackInfo?.speed ?? 1,
                          //                               onChanged: (value) =>
                          //                                   _controller?.setPlaybackSpeed(value),
                          //                               min: 0.25,
                          //                               max: 2,
                          //                               divisions: (2 - 0.25) ~/ 0.25,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                        ],
                      ),
                    ))
                : Container(),
            // isPlayVideo == "0"
            //     ? introVideoCoverStr.isNotEmpty
            //         ? Positioned(
            //             top: 0,
            //             width: _screenUtil.screenWidth,
            //             height: _screenUtil.screenWidth / 16 * 9,
            //             child: Stack(
            //               children: [
            //                 LoadImage(
            //                   introVideoCoverStr,
            //                   width: _screenUtil.screenWidth,
            //                   height: _screenUtil.screenWidth / 16 * 9,
            //                 ),
            //                 Center(
            //                   child: InkWell(
            //                     onTap: _togglePlayback,
            //                     child: Center(
            //                       child: FutureBuilder(
            //                         future: _isPlaying,
            //                         initialData: false,
            //                         builder: (
            //                           BuildContext context,
            //                           AsyncSnapshot<bool> snapshot,
            //                         ) {
            //                           final isPlaying = snapshot.data ?? false;
            //                           return Icon(
            //                             isPlaying
            //                                 ? Icons.pause
            //                                 : Icons.play_arrow,
            //                             size: 50,
            //                             color: Colors.white,
            //                           );
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           )
            //         : Container()
            //     : Container(),
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
        left: (_screenUtil.screenWidth - 150) / 2,
        // width: 100,
        // height: 100,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(200.0),
            child: StreamBuilder(
              stream: AvatarController().getStream(),
              builder: (_, snapshot) {
                dynamic data = snapshot.data;
                // if (data == true) {
                //   if (widget.onFinshEnd != null) {
                //     widget.onFinshEnd!(data);
                //   }
                // }
                return data == true
                    ? LoadImage(
                        _homeProvider.character.motionImage,
                        format: ImageFormat.gif,
                        width: 150.0,
                        height: 150.0,
                      )
                    : LoadImage(
                        _homeProvider.character.stillImage,
                        format: ImageFormat.gif,
                        width: 150.0,
                        height: 150.0,
                      );
              },
            )
            //  Background(controller: _backgroundController),

            //  LoadImage(
            //   introFileStr,
            //   format: ImageFormat.gif,
            //   width: 150.0,
            //   height: 150.0,
            // ),
            ),
      );
      // introFileStr =
      //     widget.data[widget.idx].resource[resourceIdx].characterAvatar;
    }
  }

  ///返回事件
  void onBack() {
    onConversationEnd();
  }

  Widget navbar() {
    return Container(
      height: _screenUtil.statusBarHeight + 84,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              onBack();
            },
            child: SizedBox(
              width: 20,
              height: 20,
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
            titStr ?? "",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ))),
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
                      "${HomeRouter.coursePurchasePage}?levelId=$levelId",
                    );
                  },
                  child: const LoadAssetImage(
                    'class_vip_icon',
                    width: 32.0,
                    height: 32.0,
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
                    if (data == true) {}
                  },
                  onScrollEnd: () {
                    _listScrollController.scrollToEnd();
                  },
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
          body: Stack(
            children: [
              background,
              Positioned(
                top: contentTop,
                left: 0,
                child: content,
              ),
              // topMengWidget(),
              navbar(),
              topWidget(),
              topFlowWidget(),
              // isPlayVideo == "0" && isVideo == "1"
              //     ? Positioned(
              //         top: _screenUtil.statusBarHeight + 68,
              //         width: _screenUtil.screenWidth,
              //         height: _screenUtil.screenWidth / 16 * 9,
              //         child: LoadImage(
              //           introVideoCoverStr,
              //           width: _screenUtil.screenWidth,
              //           height: _screenUtil.screenWidth / 16 * 9,
              //         ),
              //       )
              //     : Container(),
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
                      top: 0, left: 0, right: 0, bottom: 0, child: showDia())
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
  bool get wantKeepAlive => false;

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
