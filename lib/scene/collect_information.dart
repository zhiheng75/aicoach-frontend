import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../chat/entity/message_entity.dart';
import '../chat/utils/chat_websocket.dart';
import '../chat/widget/bottom_bar.dart';
import '../chat/widget/message_list.dart';
import '../chat/widget/record.dart';
import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../util/EventBus.dart';
import '../util/media_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import '../widgets/load_image.dart';
import 'presenter/collect_information_page_presenter.dart';
import 'view/collect_information_view.dart';

class CollectInformationPage extends StatefulWidget {
  const CollectInformationPage({
    Key? key,
    required this.characterId,
    required this.sceneId,
    required this.sceneImage,
    required this.desc,
    required this.onEnd,
  }) : super(key: key);

  final String characterId;
  final int sceneId;
  final String sceneImage;
  final String desc;
  final Function() onEnd;

  @override
  State<CollectInformationPage> createState() => _SceneState();
}

class _SceneState extends State<CollectInformationPage> with BasePageMixin<CollectInformationPage, CollectInformationPagePresenter>, AutomaticKeepAliveClientMixin<CollectInformationPage>, WidgetsBindingObserver implements CollectInformationView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  final MediaUtils _mediaUtils = MediaUtils();
  late HomeProvider _homeProvider;
  late CollectInformationPagePresenter _collectInformationPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  // 消息列表滚动控制器
  final ScrollController _listScrollController = ScrollController();
  // 底部按钮控制器
  final BottomBarController _bottomBarControll = BottomBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();
  // ai回答消息
  NormalMessage? _answer;
  // app状态
  AppLifecycleState? _appLifecycleState;
  // 是否对话结束
  bool _isConversationEnd = false;

  void init() {
    _pageState = 'loading';
    setState(() {});
    connectWebsocket();
  }

  void connectWebsocket() async {
    try {
      _homeProvider.sessionId = await _chatWebsocket.startChat(
        characterId: widget.characterId,
        sceneId: widget.sceneId.toString(),
        onConnected: () {
          _pageState = 'success';
          setState(() {});
          IntroductionMessage introductionMessage = IntroductionMessage();
          introductionMessage.desc = widget.desc;
          _homeProvider.addMessage(introductionMessage);
          _bottomBarControll.setDisabled(false);
          _mediaUtils.resumeUse();
        },
        onAnswer: onWebsocketAnswer,
        onEnd: onWebsocketEnd,
      );
    } catch (e) {
      _pageState = 'fail';
      setState(() {});
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
        _answer = null;
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
          _bottomBarControll.setDisabled(false);
        },
      );
    }
  }


  void onWebsocketEnd(String? reason, String endType) {
    _bottomBarControll.setDisabled(true);
    _isConversationEnd = true;
    if (mounted) {
      setState(() {});
    }
    // 异常结束
    if (reason == 'Error') {
      insertTipMessage('Please switch to new roles, topics, or scene');
    }
    // 正常结束
    if (reason == 'Session End' && endType == 'normal') {
      insertTipMessage('Conversation finished！');
    }
  }

  void insertTipMessage(String tip) {
    _homeProvider.addTipMessage(tip);
    EventBus().emit('SCROLL_MESSAGE_LIST');
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
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
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<HomeProvider>(
        builder: (_, provider, __) {
          Widget background = SizedBox(
            height: _screenUtil.screenHeight,
            child: Column(
              children: <Widget>[
                LoadImage(
                  widget.sceneImage,
                ),
                Expanded(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 7.0,
                      sigmaY: 7.0,
                    ),
                    child: LoadImage(
                      widget.sceneImage,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          );

          Widget endButton = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
              widget.onEnd();
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
                gradient: const LinearGradient(
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
                  Text(
                    '开启学习',
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

          double contentTop = _screenUtil.statusBarHeight + 114.0;
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: MessageList(
                          controller: _listScrollController        ,
                          onSelectTopic: (_) => null,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: _screenUtil.bottomBarHeight + 16.0,
                  ),
                  child: _isConversationEnd ? endButton : BottomBar(
                    chatWebsocket: _chatWebsocket,
                    controller: _bottomBarControll,
                    recordController: _recordController,
                  ),
                ),
              ],
            );
          } else {
            inner = Column(
              children: <Widget>[
                if (_pageState == 'loading')
                  const LoadData(),
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

          return Stack(
            children: [
              background,
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
                  builder: (_, show, __) => Record(show: show, controller: _recordController),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  CollectInformationPagePresenter createPresenter() {
    _collectInformationPagePresenter = CollectInformationPagePresenter();
    return _collectInformationPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}