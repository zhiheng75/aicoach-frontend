import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart' hide ScreenUtil;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../entity/result_entity.dart';
import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../util/event_bus.dart';
import '../util/confirm_utils.dart';
import '../util/log_utils.dart';
import '../util/media_utils.dart';
import '../util/toast_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import '../widgets/load_image.dart';
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
  final String characterId;
  const ChatPage({Key? key, required this.characterId}) : super(key: key);

  // const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatState();
}

class _ChatState extends State<ChatPage>
    with
        BasePageMixin<ChatPage, ChatPagePresenter>,
        AutomaticKeepAliveClientMixin<ChatPage>
    implements ChatView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  final MediaUtils _mediaUtils = MediaUtils();
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
  final MessageListController _listScrollController = MessageListController();
  // 底部按钮控制器
  final BottomBarController _bottomBarControll = BottomBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();
  // 左右滑动提示
  bool _showSlideTip = false;

  late String isNew = "";
  late String cherid = "";

  List<Map<String, String>> characterData = [
    {
      "characterId": "dora",
      "stillImage": "dora_still_image",
      "motionImage": "dora_motion_image"
    },
    {
      "characterId": "peppa_pig",
      "stillImage": "peppa_pig",
      "motionImage": "peppa_pig"
    },
    {
      "characterId": "sophia",
      "stillImage": "sophia_still_image",
      "motionImage": "sophia_motion_image"
    },
    {
      "characterId": "gg_bond",
      "stillImage": "gg_bond",
      "motionImage": "gg_bond"
    },
    {"characterId": "mickey", "stillImage": "mickey", "motionImage": "mickey"},
    {"characterId": "eggy", "stillImage": "eggy", "motionImage": "eggy"},
    {
      "characterId": "ultraman",
      "stillImage": "ultraman",
      "motionImage": "ultraman"
    },
    {
      "characterId": "harry_potter",
      "stillImage": "harry_potter_still_image",
      "motionImage": "harry_potter_motion_image"
    },
  ];

  void init() {
    _pageState = 'loading';
    setState(() {});
    showSlideTip();
    getCharacterList();
  }

  void showSlideTip() {
    String? firstUsage = SpUtil.getString('firstUsage');
    _showSlideTip = firstUsage != 'N';
  }

  void hideSlideTip() {
    if (_showSlideTip) {
      SpUtil.putString('firstUsage', 'N');
      _showSlideTip = false;
      setState(() {});
    }
  }

  void getCharacterList() {
    _chatPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.characterList,
        isShow: false,
        isClose: false, onSuccess: (result) {
      if (result == null || result.data == null) {
        _pageState = 'fail';
        if (mounted) {
          setState(() {});
        }
        return;
      }
      List<dynamic> list = result.data! as List<dynamic>;
      if (list.isEmpty) {
        _pageState = 'fail';
        if (mounted) {
          setState(() {});
        }
        return;
      }
      _homeProvider = Provider.of<HomeProvider>(context, listen: false);
      _characterList =
          list.map((item) => CharacterEntity.fromJson(item)).toList();
      _pageState = 'success';
      if (mounted) {
        setState(() {});
      }
      for (int i = 0; i < _characterList.length; i++) {
        if (widget.characterId == _characterList[i].characterId) {
          confirmChangeCharacter(i);
        }
      }
    }, onError: (code, msg) {
      Log.d('获取角色列表失败:[error]$msg', tag: '[Function]getCharacterList');
      _pageState = 'fail';
      if (mounted) {
        setState(() {});
      }
    });
  }

  void changeCharacter(int characterIndex) {
    if (_isCharacterChanging) {
      return;
    }
    if (_characterIndex == characterIndex) {
      _isCharacterChanging = false;
      return;
    }
    if (_homeProvider.sessionId != '') {
      ConfirmUtils.show(
        context: context,
        title: '你要切换角色吗？',
        onConfirm: () {
          confirmChangeCharacter(characterIndex);
        },
        onCancel: () {},
        child: const Text(
          '切换角色会结束当前对话',
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
    confirmChangeCharacter(characterIndex);
  }

  void confirmChangeCharacter(int characterIndex) {
    _isCharacterChanging = true;
    _bottomBarControll.setDisabled(true);

    // 左右两侧图片
    int pre =
        characterIndex > 0 ? characterIndex - 1 : _characterList.length - 1;
    int next =
        characterIndex < _characterList.length - 1 ? characterIndex + 1 : 0;
    String leftImage = _characterList.elementAt(pre).imageUrl;
    String rightImage = _characterList.elementAt(next).imageUrl;
    _backgroundController.setSideImage(leftImage, rightImage);

    _characterIndex = characterIndex;
    CharacterEntity character = _characterList[characterIndex];
    _character = character;
    if (mounted) {
      setState(() {});
    }
    startNormalChat(character);
  }

  void openTopic() {
    if (checkTopicShouldOpen()) {
      getTopicList((topicList) {
        _homeProvider.addTopicMessage(topicList);
        _listScrollController.scrollToEnd();
      });
    }
  }

  bool checkTopicShouldOpen() {
    List<String> messageTypeList = _homeProvider.messageList
        .where((message) => message.type == 'normal' || message.type == 'topic')
        .map((message) => message.type)
        .toList();
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
        List<TopicEntity> list =
            data.map((item) => TopicEntity.fromJson(item)).toList();
        onSuccess(list);
      },
      onError: (code, msg) {
        // Toast.show(
        //   msg,
        //   duration: 1000,
        // );
      },
    );
  }

  void startNormalChat(CharacterEntity character) async {
    await _mediaUtils.stopPlay();
    await _chatWebsocket.endChat(true);
    _homeProvider.resetChatParams();
    _homeProvider.character = character;
    Future.delayed(Duration.zero, () {
      _isCharacterChanging = false;
      _bottomBarControll.setDisabled(true);
      _homeProvider.addIntroductionMessage();
      _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = _character!.text;
      normalMessage.audioUrl = _character!.audio;
      normalMessage.isTextEnd = true;
      _homeProvider.addNormalMessage(normalMessage);
      _mediaUtils.play(
        url: _character!.audio,
        useAvatar: true,
        whenFinished: () {
          _bottomBarControll.setDisabled(false);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // EventBus().on(NotificationUtils.resetChat, (idx) {
    //   if (idx != "2") {
    //     _chatWebsocket.endChat(true);
    //   }
    //   setState(() {
    //     isNew = idx;
    //   });
    //   if (idx == "2") {
    //     init();
    //   }
    // });
    // EventBus().on(NotificationUtils.loginIn, (_) {
    //   if (isNew == "2") {
    //     init();
    //   }
    // });
    EventBus().on(NotificationUtils.newResetChat, (_) {
      init();
    });

    // EventBus().on(NotificationUtils.taberThree, (idx) {
    //   setState(() {
    //     cherid = idx;
    //   });
    //   // init();
    // });

    // EventBus().on(NotificationUtils.resetChatTwo, (_) {
    //   init();
    // });

    // EventBus().on('LEAVECHATPAGE', (_) async {
    //   await _mediaUtils.stopPlay();
    //   _bottomBarControll.setDisabled(false);
    // });

    init();

    EventUMStatistics.umengCommonOnPageStart("chat_page");
    EventBus().on(NotificationUtils.messageEnd, (idx) {
      _listScrollController.scrollToEnd();
    });
  }

  endSocket() async {
    await _mediaUtils.stopPlay();
    await _chatWebsocket.endChat(true);
    _homeProvider.resetChatParams();
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

    double homeTabbarHeight = _screenUtil.screenHeight / 2 - 150;
    // double bottomBarHeight = _screenUtil.bottomBarHeight + 80.0;
    double bottomBarHeight = 80.0;

    void onConversationEnd() {
      // if (!_isConversationEnd) {
      ConfirmUtils.show(
        context: context,
        title: '结束对话',
        buttonDirection: 'vertical',
        confirmButtonText: '结束对话',
        cancelButtonText: '留在对话中',
        onConfirm: () async {
          NavigatorUtils.goBack(context);

          // widget.onEnd();
        },
        onCancel: () {},
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
      // Navigator.of(context).pop();
      // widget.onEnd();
    }

    Widget navbar = Container(
      width: _screenUtil.screenWidth - 32.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onConversationEnd,
        child: const LoadAssetImage(
          'guanbi_yuan_bai',
          width: 32.0,
          height: 32.0,
        ),
      ),
    );

    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (_isCharacterChanging) {
          return;
        }
        hideSlideTip();
        _backgroundController.slideStart(
          position: details.globalPosition,
        );
      },
      // onHorizontalDragUpdate: (details) {
      //   if (_isCharacterChanging) {
      //     return;
      //   }
      //   _backgroundController.slideMove(details.globalPosition);
      // },
      // onHorizontalDragEnd: (_) {
      //   if (_isCharacterChanging) {
      //     return;
      //   }
      //   _backgroundController.slideEnd((direction) {
      //     bool isSlideLeft = direction == 'left';
      //     int index = isSlideLeft ? _characterIndex + 1 : _characterIndex - 1;
      //     if (index < 0) {
      //       index = _characterList.length + index;
      //     }
      //     if (index == _characterList.length) {
      //       index = 0;
      //     }
      //     changeCharacter(index);
      //   });
      // },
      child: Stack(
        children: <Widget>[
          Background(controller: _backgroundController),
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
                child: MessageList(controller: _listScrollController),
              );
            },
          ),
          Positioned(
            top: 50,
            child: navbar,
          ),
          Positioned(
            top: 103.0,
            left: 16.0,
            child: Consumer<HomeProvider>(
              builder: (_, provider, __) {
                return LoadImage(
                  provider.character.stageImg,
                  width: 59.0,
                  height: 45.0,
                );
              },
            ),
          ),
          Positioned(
            top: 225.0,
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
            // bottom: _screenUtil.bottomBarHeight + 16.0,
            bottom: 16.0,
            child: BottomBar(
              chatWebsocket: _chatWebsocket,
              controller: _bottomBarControll,
              recordController: _recordController,
              language: 'cn',
              isNormalChat: true,
              onScrollEnd: () {
                _listScrollController.scrollToEnd();
              },
            ),
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
          // 左右滑动提示
          if (_showSlideTip)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: _screenUtil.screenWidth,
                height: _screenUtil.screenHeight,
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: _screenUtil.statusBarHeight + 113.0,
                    ),
                    const LoadAssetImage(
                      'slide_tip',
                      width: 229.0,
                      height: 406.0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // EventBus().off('LEAVECHATPAGE');
    endSocket();
    EventBus().off(NotificationUtils.resetChat);
    EventBus().off(NotificationUtils.resetChatTwo);
    EventBus().off(NotificationUtils.messageEnd);

    // EventBus().off(NotificationUtils.taberThree);

    EventBus().off(NotificationUtils.loginIn);
    EventBus().off(NotificationUtils.loginOut);
    EventUMStatistics.umengCommonOnPageEnd("chat_page");

    super.dispose();
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendCategoryEntitySuccess(List<CategoryEntity> list) {
    // TODO: implement sendCategoryEntitySuccess
  }

  @override
  void sendSuccess(CharacterListBean data) {
    // TODO: implement sendSuccess
  }

  @override
  void sendTopicEntitySuccess(List<TopicEntity> list) {
    // TODO: implement sendTopicEntitySuccess
  }
}
