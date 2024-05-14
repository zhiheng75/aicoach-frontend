import 'dart:typed_data';
import 'dart:ui';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/chat/widget/course_bottom_bar.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../chat/entity/message_entity.dart';
import '../chat/utils/chat_websocket.dart';
// import '../chat/widget/bottom_bar.dart';
import '../chat/widget/message_list.dart';
import '../chat/widget/record.dart';
import '../home/provider/home_provider.dart';
import '../home/widget/expiration_reminder.dart';
import '../mvp/base_page.dart';
import '../util/media_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'package:video_player/video_player.dart';

class InstructionalVideoDialoguePage extends StatefulWidget {
  final List<CourseDatum> data;
  final int idx;
  final int isUserBuy;
  final String levelId;

  const InstructionalVideoDialoguePage({
    super.key,
    required this.onEnd,
    required this.data,
    required this.idx,
    required this.levelId,
    required this.isUserBuy,
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

  late VideoPlayerController _controller;

  late String introFileType;
  late int dataIdx;

  late int resourceIdx = 0;
  late String introFileStr;
  late bool isFrist = true;
  late String resourceSceneId;
  late String titStr;
  late String isVideo = "0";
  late bool isplay = true;

  void init() {
    _pageState = 'loading';
    setState(() {});
    connectWebsocket();
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
          _homeProvider.addTipMessage('class started！');
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
      title: '是否进行下一个场景',
      buttonDirection: 'vertical',
      confirmButtonText: '结束',
      cancelButtonText: '下一段对话',
      onConfirm: () {
        endSocket();
        Navigator.of(context).pop();
        widget.onEnd();
      },
      onCancel: () {
        endSocket();
        forFlow();
      },
      child: const Text(
        '下一个场景的名字',
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
      if (answer is String && (answer.contains('{[finish]}'))) {
        //弹窗点击确定后重新链接
        onNextSocketEnd();
        EventBus().emit(NotificationUtils.nextResetChat);

        return;
      }
      // 结束标记
      if (answer is String &&
          (answer.contains('[end_session]') ||
              answer.contains('{[finish]}') ||
              RegExp(r'\[end=[0-9a-zA-Z]{16}\]').hasMatch(answer))) {
        //弹窗点击确定后重新链接
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
        _answer!.isTextEnd = true;
        // 音频已全部返回
        if (_listPlayer != null) {
          _listPlayer!.setReturnEnd();
        }
        _homeProvider.notify();
        _answer = null;
        return;
      }
      _answer!.text += answer;
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
      }
    }
  }

  void onWebsocketEnd(String? reason, String endType) {
    _homeProvider.endUsageTimeCutdown();
    _bottomBarControll.setDisabled(true);
    _isConversationEnd = true;
    // 异常结束
    if (reason == 'Error') {
      insertTipMessage('Please switch to new roles, topics, or scene');
    }
    // 正常结束
    if (reason == 'Session End' && endType != 'force') {
      insertTipMessage('Conversation finished！');
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
        title: '结束场景对话',
        buttonDirection: 'vertical',
        confirmButtonText: '结束对话',
        cancelButtonText: '留在对话中',
        onConfirm: () {
          Navigator.of(context).pop();
          widget.onEnd();
        },
        onCancel: () {
          //留在对话还是退出
        },
        child: const Text(
          '场景对话进行中，确定要结束吗？',
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
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _homeProvider.ishread = "0";
    dataIdx = widget.idx;
    // dataIdx = 0;
    resourceIdx = 0;
    forstartFlow(dataIdx, resourceIdx);
    // 监听App状态
    WidgetsBinding.instance.addObserver(this);
  }

  void forFlow() {
    resourceIdx = resourceIdx + 1;
    // dataIdx = dataIdx + 1;
    if (resourceIdx < widget.data[dataIdx].resource.length) {
      // resourceIdx = resourceIdx + 1;
    } else {
      dataIdx = dataIdx + 1;
      if (dataIdx < widget.data.length) {
        resourceIdx = 0;
      } else {
        //退出界面
        Navigator.of(context).pop();
      }
    }

    forstartFlow(dataIdx, resourceIdx);
  }

  void forstartFlow(int dataIdx, int resourceIdx) {
    setState(() {
      resourceSceneId =
          widget.data[dataIdx].resource[resourceIdx].sceneId.toString();
      introFileType = widget.data[dataIdx].resource[resourceIdx].introFileType!;
      titStr = widget.data[dataIdx].resource[resourceIdx].title;
      _homeProvider.scene!.id = int.parse(resourceSceneId);
      connectWebsocket();
      if (introFileType == "video") {
        isVideo = "1";
        introFileStr = widget.data[dataIdx].resource[resourceIdx].introFile!;
        _controller = VideoPlayerController.networkUrl(Uri.parse(introFileStr))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        // _controller.play();
        // _controller.value.
        videoFlow();
      } else if (introFileType == "image") {
        introFileStr = widget.data[dataIdx].resource[resourceIdx].introFile!;
        imgFlow();
      } else {
        introFileStr =
            widget.data[dataIdx].resource[resourceIdx].characterAvatar;
        imgFlow();
      }
      init();
    });
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
      _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text =
          widget.data[widget.idx].resource[resourceIdx].greetingText!;
      normalMessage.audioUrl =
          widget.data[widget.idx].resource[resourceIdx].greetingAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: widget.data[widget.idx].resource[resourceIdx].greetingAudio!,
        useAvatar: true,
        whenFinished: () {
          // _bottomBarControll.setDisabled(false);
          _controller.setLooping(false);
          _controller.play();
          checkVideoCompletion(_controller);
        },
      );
    });
  }

  void checkVideoCompletion(VideoPlayerController controller) {
    // if (controller.value.isInitialized) {
    // _controller.removeListener(_videoListener);
    // 当视频控制器初始化完成后，开始监听播放事件
    controller.addListener(() {
      isplay = false;
      final Duration position = controller.value.position;

      if (position >= controller.value.duration) {
        // 视频正在播放且播放到了末尾，视频播放完成
        Log.e("视频播放完成");
        isplay = true;
        if (isFrist) {
          startNormaltwoChat();
        }
      }
      setState(() {});
      // if (isPlaying && position >= controller.value.duration) {
      //   // 视频正在播放且播放到了末尾，视频播放完成
      //   Log.e("视频播放完成");
      // }
    });
    // }
  }

  void startNormaltwoChat() async {
    await _mediaUtils.stopPlay();
    // await _chatWebsocket.endChat(true);
    // _homeProvider.resetChatParams();
    // _homeProvider.character = character;
    Future.delayed(Duration.zero, () {
      // _isCharacterChanging = false;
      _bottomBarControll.setDisabled(true);
      _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text =
          widget.data[widget.idx].resource[resourceIdx].introText!;
      normalMessage.audioUrl =
          widget.data[widget.idx].resource[resourceIdx].introAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: widget.data[widget.idx].resource[resourceIdx].greetingAudio!,
        useAvatar: true,
        whenFinished: () {
          setState(() {
            isFrist = false;
            _bottomBarControll.setDisabled(false);
          });
        },
      );
    });
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
      _homeProvider.addIntroductionMessage();
      // _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text =
          widget.data[widget.idx].resource[resourceIdx].greetingText!;
      normalMessage.audioUrl =
          widget.data[widget.idx].resource[resourceIdx].greetingAudio!;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: widget.data[widget.idx].resource[resourceIdx].greetingAudio!,
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
    _appLifecycleState = state;
    Future.delayed(Duration.zero, () async => await _mediaUtils.stopPlay());
  }

  @override
  void dispose() {
    super.dispose();
    _homeProvider.ishread = "";

    if (isVideo == "1") {
      _controller.dispose();
    }
  }

  Widget topWidget() {
    if (introFileType == "video") {
      return Positioned(
        top: _screenUtil.statusBarHeight + 80,
        width: _screenUtil.screenWidth,
        height: 200,
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        isFrist
                            ? Container()
                            : Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (isplay) {
                                      _controller.play();
                                    } else {
                                      _controller.pause();
                                    }
                                    isplay = !isplay;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.amber,
                                    child: Center(
                                        child: Text(isplay ? "播放" : "暂停")),
                                  ),
                                ),
                              )
                      ],
                    )),
              )
            : Container(
                color: Colors.black,
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
    return XTCupertinoNavigationBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(onBack: onBack),
        middle: Text(
          titStr,
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        trailing: widget.isUserBuy == 1
            ? Container()
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
//到课程购买页
                  NavigatorUtils.push(
                    context,
                    "${HomeRouter.coursePurchasePage}?levelId=${widget.levelId}",
                  );
                },
                child: const LoadAssetImage(
                  'class_vip_icon',
                  width: 32.0,
                  height: 32.0,
                ),
              ));

    return Container(
      width: _screenUtil.screenWidth,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 16.0,
      // ),
      // alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onConversationEnd,
            child: const LoadAssetImage(
              'guanbi_yuan_bai',
              width: 32.0,
              height: 32.0,
            ),
          ),
          const Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "这里是科恒名字",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_001652,
                ),
              ),
            ],
          )),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onConversationEnd,
            child: const LoadAssetImage(
              'guanbi_yuan_bai',
              width: 32.0,
              height: 32.0,
            ),
          ),
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
    for (int i = 0; i < widget.data.length; i++) {
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
          // Column(
          //   children: <Widget>[
          // LoadImage(
          //   provider.scene?.cover ?? '',
          // ),
          //     Expanded(
          //       child: ImageFiltered(
          //         imageFilter: ImageFilter.blur(
          //           sigmaX: 7.0,
          //           sigmaY: 7.0,
          //         ),
          //         child: LoadImage(
          //           provider.scene?.cover ?? '',
          //           fit: BoxFit.fitHeight,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        );

        // Widget navbar = Container(
        //   width: _screenUtil.screenWidth - 32.0,
        //   margin: const EdgeInsets.symmetric(
        //     horizontal: 16.0,
        //   ),
        //   alignment: Alignment.centerRight,
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.opaque,
        //     onTap: onConversationEnd,
        //     child: const LoadAssetImage(
        //       'guanbi_yuan_bai',
        //       width: 32.0,
        //       height: 32.0,
        //     ),
        //   ),
        // );

        double contentTop = _screenUtil.statusBarHeight + 280.0;
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
                  chatWebsocket: _chatWebsocket,
                  controller: _bottomBarControll,
                  recordController: _recordController,
                  // onStarEnd: () {
                  //   setState(() {
                  //     _controller.pause();
                  //     isplay = true;
                  //   });
                  // },
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
                // top: _screenUtil.statusBarHeight + 9.0,
                child: navbar(),
              ),
              topWidget(),
              topFlowWidget(),
              // Positioned(
              //   top: _screenUtil.statusBarHeight + 50,
              //   width: _screenUtil.screenWidth,
              //   height: 200,
              //   child: _controller.value.isInitialized
              //       ? AspectRatio(
              //           aspectRatio: _controller.value.aspectRatio,
              //           child: Container(
              //               color: Colors.blue,
              //               child: VideoPlayer(_controller)),
              //         )
              //       : Container(
              //           color: Colors.blue,
              //         ),
              // ),
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
}
