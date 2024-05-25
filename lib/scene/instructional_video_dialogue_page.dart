import 'dart:typed_data';
import 'dart:ui';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/chat/widget/course_bottom_bar.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/page/class_video_page.dart';
import 'package:Bubble/scene/presenter/instructional_video_dialogue_presenter.dart';
import 'package:Bubble/scene/presenter/teaching_dialogue_presenter.dart';
import 'package:Bubble/scene/view/instructional_video_dialogue_view.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:provider/provider.dart';

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
  late int dataIdx;

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

  late String isShowStr = "1";
  // late int chatNumberEnd = 0;
  late String ischatEndStr = "0";
  late String repeatWord = "";

  void init() {
    _pageState = 'success';
    setState(() {});
    connectWebsocket();
    // String characterId = _homeProvider.character.characterId;
    // String sceneId = resourceSceneId; //_homeProvider.scene!.id.toString();
    // // String sceneId = _homeProvider.course!.id.toString();
    // _homeProvider.scene!.id = int.parse(resourceSceneId);
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
          // Log.e('===============Tag: $tag, Content: $content');
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
      // for (int i = 0; i < 2; i++) {
      //   RegExpMatch? match = pattern.firstMatch(one);

      //   if (match != null) {
      //     String? tag = match.group(1); // 获取标签名
      //     String? content = match.group(2); // 获取内容
      //     Log.e('===============Tag: $tag, Content: $content');
      //     if (tag == "word") {
      //       //取出来文字content
      //       repeatWord = content!;
      //     }
      //   }
      // }
    } else if (one.contains("<word>")) {
      RegExpMatch? match = pattern.firstMatch(one);

      if (match != null) {
        String? tag = match.group(1); // 获取标签名
        String? content = match.group(2); // 获取内容
        Log.e('===============Tag: $tag, Content: $content');
        repeatWord = content!;
      }
    }
  }

  void connectWebsocket() async {
    try {
      String characterId = _homeProvider.character.characterId;
      String sceneId = resourceSceneId; //_homeProvider.scene!.id.toString();
      // String sceneId = _homeProvider.course!.id.toString();
      _homeProvider.scene!.id = int.parse(resourceSceneId);
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        characterId: characterId,
        sceneId: sceneId,
        onConnected: () {
          _pageState = 'success';
          setState(() {});
          _homeProvider.addIntroductionMessage();
          // _homeProvider.addTipMessage('class started！');
          // 刷新使用时间
          _homeProvider.getUsageTime(() {
            // 倒计时
            _homeProvider.startUsageTimeCutdown(() {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                isDismissible: false,
                builder: (_) => ExpirationReminder(),
              );
            });
          });
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
    ConfirmUtils.show(
      context: context,
      title: '是否进行下一段对话',
      buttonDirection: 'vertical',
      confirmButtonText: '结束',
      cancelButtonText: '下一段对话',
      onConfirm: () {
        endSocket();
        Navigator.of(context).pop();
        widget.onEnd();
      },
      onCancel: () {
        // endSocket();
        forFlow();
      },
      child: const Text(
        '',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
          height: 18.0 / 15.0,
        ),
      ),
    );
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
        onNextSocketEnd();
        return;
      }
      // _answer = NormalMessage();
      _answer = _homeProvider.createNormalMessage();
      // 创建播放列表
      _listPlayer = _mediaUtils.createListPlay(() {
        _bottomBarControll.setDisabled(false);
      }, true);
      _homeProvider.addNormalMessage(_answer!);
    }
    if (answer is String) {
      if (answer.startsWith('[end')) {
        repeatTextStr(_answer!.text);
        Log.e("2222222222222222222222" + _answer!.text);
        _answer!.isTextEnd = true;
        // 音频已全部返回
        if (_listPlayer != null) {
          _listPlayer!.setReturnEnd();
          Log.e("ai播放完音频");
        }
        _homeProvider.notify();
        _answer = null;
        return;
      }
      _answer!.text += answer;
      // Log.e("11111111111111111111111" + _answer!.text);
      // _answer!.heardcover = _homeProvider.scene!.cover;
      _homeProvider.notify();
      _listScrollController.scrollToEnd();
      return;
    }
    if (answer is Uint8List) {
      _answer!.audio.add(answer);

      if (_appLifecycleState == AppLifecycleState.paused) {
        return;
      }
      if (_listPlayer != null) {
        _listPlayer!.play(answer);
        // chatNumberEnd = chatNumberEnd + 1;
        // Log.e("11111111111111111111111111chatNumberEnd+1" +
        //     chatNumberEnd.toString());
      }
    }
  }

  void onWebsocketEnd(String? reason, String endType) {
    _homeProvider.endUsageTimeCutdown();
    _bottomBarControll.setDisabled(true);
    _isConversationEnd = true;
    // 异常结束
    if (reason == 'Error') {
      insertTipMessage('Please switch to new class');
    }
    // 正常结束
    if (reason == 'Session End' && endType != 'force') {
      // insertTipMessage('Class finished！');
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
    WidgetsBinding.instance.addObserver(this);

    EventBus().on(NotificationUtils.nextClass, (_) {
      forFlow();
    });

    // 全局监听App状态
    SystemChannels.lifecycle.setMessageHandler((message) async {
      // 退到后台
      // if (_appLifecycleState == 'AppLifecycleState.inactive' ||
      //     message == 'AppLifecycleState.paused') {}
      if (message == 'AppLifecycleState.paused') {
        // ConfirmUtils.showSingle(
        //   context: context,
        //   title: "请重新开始对话",
        //   onCancel: () {
        //     endSocket();
        //     Navigator.of(context).pop();
        //     widget.onEnd();
        //   },
        // );
      }
      return message;
    });
    // setState(() {
    data = widget.stepDetailData.data.data;
    isUserBuy = widget.stepDetailData.data.isUserBuy;
    levelId = widget.stepDetailData.data.levelId.toString();
    lessonId = widget.stepDetailData.data.lessonId.toString();
    // });

    _pageState = 'success';
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _homeProvider.ishread = "0";
    Log.e(_homeProvider.character.motionImageD);
    dataIdx = widget.idx;
    resourceIdx = 0;
    forstartFlow(dataIdx, resourceIdx);
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
    Log.e("+++++++++++++++从其他页面过来");
    setState(() {
      isShowStr = "1";
    });
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
    Log.e("+++++++++++++++从当前页面跳转到下一页之后才会调用");
    setState(() {
      isShowStr = "2";
    });
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    Log.e("+++++++++++++++返回到了当前页面");
    setState(() {
      isShowStr = "1";
    });
  }

  void forFlow() {
    resourceIdx = resourceIdx + 1;
    // dataIdx = dataIdx + 1;
    if (resourceIdx < data[dataIdx].resource.length) {
      // resourceIdx = resourceIdx + 1;
    } else {
      dataIdx = dataIdx + 1;
      if (dataIdx < data.length) {
        resourceIdx = 0;
      } else {
        //退出界面
        Navigator.of(context).pop();
      }
    }

    forstartFlow(dataIdx, resourceIdx);
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
          introFileStr = data[dataIdx].resource[resourceIdx].introFile!;
          videoFlow();
        } else if (introFileType == "image") {
          introFileStr = data[dataIdx].resource[resourceIdx].introFile!;
          imgFlow();
          init();
        } else {
          introFileStr = _homeProvider.character.motionImageD;
          imgFlow();
          init();
        }
      });
    }
  }

  //视频顺序
  void videoFlow() {
    startNormalChat();
  }

  void startNormalChat() async {
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
      normalMessage.text = data[widget.idx].resource[resourceIdx].introText!;
      normalMessage.audioUrl =
          data[widget.idx].resource[resourceIdx].introAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: data[widget.idx].resource[resourceIdx].introAudio!,
        useAvatar: true,
        whenFinished: () {
          //通知播放视频

          // setState(() {
          //   isplay = true;
          // });
          _controller?.play();
          _controller?.setVolume(1);

          // showModalBottomSheet(
          //   context: context,
          //   backgroundColor: Colors.transparent,
          //   barrierColor: Colors.transparent,
          //   isScrollControlled: true,
          //   isDismissible: false,
          //   clipBehavior: Clip.none,
          //   enableDrag: false,
          //   builder: (_) => ClassVideoPage(
          //     introFileStr: introFileStr,
          //     onScrollEnd: () {
          //       // setState(() {
          //       //   isplay = false;
          //       // });
          //       startNormaltwoChat();
          //     },
          //   ),
          // );

          // _bottomBarControll.setDisabled(false);
          //   _controller.play();
          // checkVideoCompletion(_controller);
        },
      );
    });

    // await _mediaUtils.stopPlay();
    // // await _chatWebsocket.endChat(true);
    // _homeProvider.resetChatParams();
    // // _homeProvider.character = character;
    // Future.delayed(Duration.zero, () {
    //   // _isCharacterChanging = false;
    //   _bottomBarControll.setDisabled(true);
    //   _homeProvider.addIntroductionMessage();
    //   // _homeProvider.addTipMessage('Role-plays started！');
    //   NormalMessage normalMessage = _homeProvider.createNormalMessage();
    //   normalMessage.text =
    //       widget.data[widget.idx].resource[resourceIdx].greetingText!;
    //   normalMessage.audioUrl =
    //       widget.data[widget.idx].resource[resourceIdx].greetingAudio!;
    //   normalMessage.isTextEnd = true;
    //   _homeProvider.addNormalMessage(normalMessage);
    //   _mediaUtils.play(
    //     url: widget.data[widget.idx].resource[resourceIdx].greetingAudio!,
    //     useAvatar: true,
    //     whenFinished: () {
    //       // _bottomBarControll.setDisabled(false);
    //       _controller.play();
    //       checkVideoCompletion(_controller);
    //     },
    //   );
    // });
  }

  // void checkVideoCompletion(VideoPlayerController controller) {
  //   // if (controller.value.isInitialized) {
  //   // _controller.removeListener(_videoListener);
  //   // 当视频控制器初始化完成后，开始监听播放事件
  //   controller.addListener(() {
  //     isplay = false;
  //     final Duration position = controller.value.position;

  //     if (position >= controller.value.duration) {
  //       // 视频正在播放且播放到了末尾，视频播放完成
  //       Log.e("视频播放完成");
  //       isplay = true;
  //       if (isFrist) {
  //         startNormaltwoChat();
  //       }
  //     }
  //     setState(() {});
  //     // if (isPlaying && position >= controller.value.duration) {
  //     //   // 视频正在播放且播放到了末尾，视频播放完成
  //     //   Log.e("视频播放完成");
  //     // }
  //   });
  //   // }
  // }

  void startNormaltwoChat() async {
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
      normalMessage.text = data[widget.idx].resource[resourceIdx].greetingText!;
      normalMessage.audioUrl =
          data[widget.idx].resource[resourceIdx].greetingAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: data[widget.idx].resource[resourceIdx].greetingAudio!,
        useAvatar: true,
        whenFinished: () {
          setState(() {
            // isFrist = false;
            _bottomBarControll.setDisabled(false);
          });
        },
      );
    });
    init();
  }

  //图片及其他顺序
  void imgFlow() async {
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
      normalMessage.text = data[widget.idx].resource[resourceIdx].greetingText!;
      normalMessage.audioUrl =
          data[widget.idx].resource[resourceIdx].greetingAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: data[widget.idx].resource[resourceIdx].greetingAudio!,
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (isShowStr == "1") {
        setState(() {
          isShowStr = "2";
        });
        // 应用程序已经进入后台 或锁屏
        ConfirmUtils.showSingle(
          context: context,
          title: "请重新开始对话",
          onCancel: () {
            endSocket();
            Navigator.of(context).pop();
            widget.onEnd();
          },
        );
      }
    }
    _appLifecycleState = state;
    // Future.delayed(Duration.zero, () async => await _mediaUtils.stopPlay());
  }

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;
  @override
  void dispose() {
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
    Log.e(_controller?.playbackInfo?.position.toString() ?? "0");
    Log.e(_controller?.videoInfo?.duration.toString() ?? "0");

    if (_controller?.playbackInfo?.position ==
        _controller?.videoInfo?.duration) {
      startNormaltwoChat();
      //播放完成重置状态
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

  Widget topWidget() {
    if (introFileType == "video") {
      return Positioned(
        top: _screenUtil.statusBarHeight + 80,
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenWidth / 16 * 9,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: NativeVideoPlayerView(
            onViewReady: _initController,
          ),
        ),
      );
    } else if (introFileType == "image") {
      return Positioned(
        top: _screenUtil.statusBarHeight + 80,
        width: _screenUtil.screenWidth,
        height: 200,
        child: LoadImage(
          introFileStr,
          // width: 100.0,
          // height: 100.0,
        ),
      );
    } else {
      return Positioned(
        top: _screenUtil.statusBarHeight + 80,
        left: (_screenUtil.screenWidth - 150) / 2,
        // width: 100,
        // height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200.0),
          child: LoadImage(
            introFileStr,
            width: 150.0,
            height: 150.0,
          ),
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
      height: _screenUtil.statusBarHeight + 64,
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
                color: Colors.white, fontWeight: FontWeight.bold),
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
      top: _screenUtil.statusBarHeight + 50,
      left: (_screenUtil.screenWidth - 130) / 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: const Color.fromRGBO(1, 1, 1, 0.4),
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
      if (i == widget.idx) {
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
              color: Colours.color_FFFFFF,
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
          child: LoadImage(
            provider.scene?.cover ?? '',
          ),
        );
        double contentTop = _screenUtil.statusBarHeight + 300.0;
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
                      color: Colors.transparent,
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
                    if (data == true) {
                      //读完了
                      // chatNumberEnd = chatNumberEnd - 1;
                      // Log.e("11111111111111111111111111chatNumberEnd-1" +
                      //     chatNumberEnd.toString());

                      // if (chatNumberEnd == 0 && ischatEndStr == "1") {
                      //   //弹窗
                      //   onNextSocketEnd();
                      // }
                    }
                    // setState(() {
                    //   _controller.pause();
                    //   isplay = true;
                    // });
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
              navbar(),
              topWidget(),
              topFlowWidget(),
              Positioned(
                top: contentTop,
                left: 0,
                child: content,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: ValueListenableBuilder(
                  valueListenable: _bottomBarControll.showRecord,
                  builder: (_, show, __) =>
                      Record(show: show, controller: _recordController),
                ),
              ),
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
    // EventBus().emit(NotificationUtils.nextResetChat);
  }
}
