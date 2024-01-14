import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../entity/result_entity.dart';
import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../scene/entity/scene_entity.dart';
import '../util/EventBus.dart';
import '../util/confirm_utils.dart';
import '../util/log_utils.dart';
import '../util/media_utils.dart';
import '../util/toast_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'entity/character_entity.dart';
import 'entity/message_entity.dart';
import 'entity/topic_entity.dart';
import 'presenter/chat_page_presenter.dart';
import 'utils/chat_websocket.dart';
import 'view/chat_view.dart';
import 'widget/background.dart';
import 'widget/bottom_bar.dart';
import 'widget/message_list.dart';
import 'widget/record.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatState();
}

class _ChatState extends State<ChatPage> with BasePageMixin<ChatPage, ChatPagePresenter>, AutomaticKeepAliveClientMixin<ChatPage> implements ChatView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  late HomeProvider _homeProvider;
  late ChatPagePresenter _chatPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<CharacterEntity> _characterList = [];
  // 当前角色
  CharacterEntity? _character;
  int _characterIndex = -1;
  bool _isCharacterChanging = false;
  // 背景控制器
  final BackgroundController _backgroundController = BackgroundController();
  // 消息列表滚动控制器
  final ScrollController _listScrollController = ScrollController();
  // 底部按钮控制器
  final BottomBarController _bottomBarControll = BottomBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();

  void init() {
    _pageState = 'loading';
    setState(() {});
    getCharacterList();
  }
  
  void getCharacterList() {
    _chatPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.teacherList,
      isShow: false,
      isClose: false,
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _pageState = 'fail';
          setState(() {});
          return;
        }
        List<dynamic> list = result.data! as List<dynamic>;
        if (list.isEmpty) {
          _pageState = 'fail';
          setState(() {});
          return;
        }
        _homeProvider = Provider.of<HomeProvider>(context, listen: false);
        _characterList = list.map((item) => CharacterEntity.fromJson(item)).toList();
        _pageState = 'success';
        setState(() {});
        Future.delayed(const Duration(milliseconds: 300), () {
          changeCharacter(0);
        });
      },
      onError: (code, msg) {
        Log.d('获取角色列表失败:[error]$msg', tag: '[Function]getCharacterList');
        _pageState = 'fail';
        setState(() {});
      }
    );
  }

  void changeCharacter(int characterIndex) {
    if (_isCharacterChanging) {
      return;
    }
    if (_characterIndex == characterIndex) {
      _isCharacterChanging = false;
      return;
    }
    // 话题或者场景
    String sessionType = _homeProvider.sessionType;
    if (sessionType == 'topic' || sessionType == 'scene') {
      ConfirmUtils.show(
        context: context,
        title: '你要切换角色吗？',
        onConfirm: () {
          _isCharacterChanging = true;
          confirmChangeCharacter(characterIndex);
        },
        child: const Text(
          '场景角色会结束当前对话',
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
    _isCharacterChanging = true;
    confirmChangeCharacter(characterIndex);
  }

  void confirmChangeCharacter(int characterIndex) {
    _characterIndex = characterIndex;
    CharacterEntity character = _characterList[characterIndex];
    _character = character;
    setState(() {});
    startNormalChat(character);
  }

  void startNormalChat(CharacterEntity character) async {
    await _chatWebsocket.stopChat();
    _homeProvider.sessionId = '';
    _homeProvider.character = character;
    _homeProvider.clearMessageList();
    Future.delayed(Duration.zero, () {
      _homeProvider.addIntroductionMessage();
      _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = _character!.text;
      _homeProvider.addNormalMessage(normalMessage);
      MediaUtils().play(
        _character!.audio,
        whenFinished: () {
          _bottomBarControll.setDisabled(false);
          _isCharacterChanging = false;
        },
      );
    });
  }

  void openTopic() {
    String sessionType = _homeProvider.sessionType;
    // 自由对话
    if (sessionType == 'normal' && checkTopicShouldOpen()) {
      getTopicList((topicList) {
        _homeProvider.addTopicMessage(topicList);
      });
    }
    // 话题对话或者场景对话
    if (sessionType != 'normal') {
      ConfirmUtils.show(
        context: context,
        title: '切换话题',
        buttonDirection: 'vertical',
        confirmButtonText: '切换主题',
        cancelButtonText: '留在对话中',
        onConfirm: () {
          getTopicList((topicList) {
            _homeProvider.addTopicMessage(topicList);
          });
        },
        child: const Text(
          '主题对话进行中，确定要切换新主题吗？',
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
  }

  bool checkTopicShouldOpen() {
    List<String> messageTypeList = _homeProvider.messageList.where((message) => message.type == 'normal' || message.type == 'topic').map((message) => message.type).toList();
    int index = messageTypeList.indexOf('topic');
    // 已推出话题
    if (index > -1) {
      Toast.show(
        '已推出该角色话题，请选择话题',
        duration: 1000,
      );
      return false;
    }
    return true;
  }

  void getTopicList(Function(List<TopicEntity>) onSuccess) {
    _chatPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.topicOrScene,
      isShow: true,
      isClose: true,
      queryParameters: {
        'character_id': _homeProvider.character.characterId,
        'type': 1,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          Toast.show(
            '获取话题失败，请重试',
            duration: 1000,
          );
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<TopicEntity> list = data.map((item) => TopicEntity.fromJson(item)).toList();
        onSuccess(list);
      },
      onError: (code, msg) {
        Toast.show(
          msg,
          duration: 1000,
        );
      },
    );
  }

  void selectTopic(TopicEntity topic) {
    startTopicChat(topic);
  }

  void startTopicChat(TopicEntity topic) async {
    await _chatWebsocket.stopChat();
    _homeProvider.sessionId = '';
    _homeProvider.topic = topic;
    _homeProvider.clearMessageList();
    Future.delayed(Duration.zero, () {
      _homeProvider.addIntroductionMessage();
      _homeProvider.addTipMessage('Topic started！');
      _bottomBarControll.setDisabled(false);
    });
  }

  void startSceneChat(SceneEntity scene) async {
    await _chatWebsocket.stopChat();
    _homeProvider.sessionId = '';
    _homeProvider.scene = scene;
    _homeProvider.clearMessageList();
    Future.delayed(Duration.zero, () {
      _homeProvider.addTipMessage('Scene started！');
      _bottomBarControll.setDisabled(false);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    EventBus().on('SELECT_SCENE', (scene) => startSceneChat(scene));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_pageState == 'loading') {
      return Container(
        color: const Color(0xFFEBEDF0),
        alignment: Alignment.center,
        child: const LoadData(),
      );
    }

    if (_pageState == 'fail') {
      return Container(
        color: const Color(0xFFEBEDF0),
        alignment: Alignment.center,
        child: LoadFail(
          reload: init,
        ),
      );
    }

    if (_character == null) {
      return Container(
        color: const Color(0xFFEBEDF0),
      );
    }

    double homeTabbarHeight = 112.0;
    double bottomBarHeight = _screenUtil.bottomBarHeight + 80.0;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (_isCharacterChanging) {
          return;
        }
        int pre = _characterIndex > 0 ? _characterIndex - 1 : _characterList.length - 1;
        int next = _characterIndex < _characterList.length - 1 ? _characterIndex + 1 : 0;
        _backgroundController.slideStart(
          position: details.globalPosition,
          leftImage: _characterList.elementAt(pre).imageUrl,
          rightImage: _characterList.elementAt(next).imageUrl,
        );
      },
      onHorizontalDragUpdate: (details) {
        if (_isCharacterChanging) {
          return;
        }
        _backgroundController.slideMove(details.globalPosition);
      },
      onHorizontalDragEnd: (_) {
        if (_isCharacterChanging) {
          return;
        }
        _backgroundController.slideEnd((direction) {
          bool isSlideLeft = direction == 'left';
          int index = isSlideLeft ? _characterIndex + 1 : _characterIndex - 1;
          if (index < 0) {
            index = _characterList.length + index;
          }
          if (index == _characterList.length) {
            index = 0;
          }
          changeCharacter(index);
        });
      },
      child: Stack(
        children: <Widget>[
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 1.0,
              sigmaY: 1.0,
            ),
            child: Background(controller: _backgroundController),
          ),
          ValueListenableBuilder(
            valueListenable: _bottomBarControll.showMessageList,
            builder: (_, showMessageList, __) {
              if (!showMessageList) {
                return const SizedBox();
              }
              return Container(
                width: _screenUtil.screenWidth,
                height: _screenUtil.screenHeight,
                padding: EdgeInsets.only(
                  top: homeTabbarHeight,
                  bottom: bottomBarHeight,
                  left: 16.0,
                  right: 16.0,
                ),
                child: MessageList(
                  controller: _listScrollController        ,
                  onSelectTopic: selectTopic,
                ),
              );
            },
          ),
          Positioned(
            bottom: _screenUtil.bottomBarHeight + 16.0,
            child: BottomBar(
              chatWebsocket: _chatWebsocket,
              controller: _bottomBarControll,
              recordController: _recordController,
            ),
          ),
          Positioned(
            top: 216.0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: openTopic,
              child: Container(
                width: 52.0,
                height: 34.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    bottomLeft: Radius.circular(100.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFCCFEF2),
                      Color(0xFFDEFFF3),
                    ],
                    stops: [0.28, 0.9],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '话题',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
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
      ),
    );
  }

  @override
  void dispose() {
    EventBus().off('SELECT_SCENE');
    super.dispose();
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}