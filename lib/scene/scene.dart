import 'dart:typed_data';
import 'dart:ui';

import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
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
import '../util/EventBus.dart';
import '../util/media_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'presenter/scene_page_presenter.dart';
import 'view/scene_view.dart';

class ScenePage extends StatefulWidget {
  const ScenePage({
    Key? key,
    required this.onEnd,
  }) : super(key: key);

  final Function() onEnd;

  @override
  State<ScenePage> createState() => _SceneState();
}

class _SceneState extends State<ScenePage> with BasePageMixin<ScenePage, ScenePagePresenter>, AutomaticKeepAliveClientMixin<ScenePage>, WidgetsBindingObserver implements SceneView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  final MediaUtils _mediaUtils = MediaUtils();
  late HomeProvider _homeProvider;
  late ScenePagePresenter _scenePagePresenter;
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
      String characterId = _homeProvider.character.characterId;
      String sceneId = _homeProvider.scene!.id.toString();
      String sessionId = await _chatWebsocket.startChat(
        characterId: characterId,
        sceneId: sceneId,
        onConnected: () {
          _pageState = 'success';
          setState(() {});
          _homeProvider.addIntroductionMessage();
          _homeProvider.addTipMessage('Scene started！');
          _bottomBarControll.setDisabled(false);
          _mediaUtils.resumeUse();
        },
        onAnswer: onAnswer,
        onEnd: () {
          _isConversationEnd = true;
          String tip = 'Conversation finished！';
          _homeProvider.addTipMessage(tip);
          EventBus().emit('SCROLL_MESSAGE_LIST');
          // 断开则禁用按钮
          _bottomBarControll.setDisabled(true);
        },
      );
      _homeProvider.sessionId = sessionId;
    } catch (e) {
      _pageState = 'fail';
      setState(() {});
    }
  }

  void onAnswer(dynamic answer) {
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
          _chatWebsocket.addAwayTimer(() {
            String tip = '未发送语音已超过30秒，如若再无发送，将在30秒后自动结束对话！';
            _homeProvider.addTipMessage(tip);
            EventBus().emit('SCROLL_MESSAGE_LIST');
          });
        },
      );
    }
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
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        Widget background = SizedBox(
          height: _screenUtil.screenHeight,
          child: Column(
            children: <Widget>[
              LoadImage(
                provider.scene!.cover,
              ),
              Expanded(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 7.0,
                    sigmaY: 7.0,
                  ),
                  child: LoadImage(
                    provider.scene!.cover,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        );

        Widget navbar = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: _screenUtil.screenWidth,
              alignment: Alignment.center,
              child: const Text(
                '场景对话',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 20.0 / 17.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onConversationEnd,
                child: const LoadAssetImage(
                  'guanbi_yuan_bai',
                  width: 32.0,
                  height: 32.0,
                ),
              ),
            ),
          ],
        );

        double contentTop = _screenUtil.statusBarHeight + 260.0;
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
                child: BottomBar(
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
              top: _screenUtil.statusBarHeight + 9.0,
              child: navbar,
            ),
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
    );
  }

  @override
  ScenePagePresenter createPresenter() {
    _scenePagePresenter = ScenePagePresenter();
    return _scenePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}