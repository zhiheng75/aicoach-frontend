import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../entity/result_entity.dart';
import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../util/log_utils.dart';
import '../util/toast_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'entity/character_entity.dart';
import 'entity/message_entity.dart';
import 'presenter/chat_page_presenter.dart';
import 'view/chat_view.dart';
import 'widget/background.dart';
import 'widget/bottom_bar.dart';
import 'widget/message_list.dart';
import 'widget/topic.dart';
import 'widget/record.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatState();
}

class _ChatState extends State<ChatPage> with BasePageMixin<ChatPage, ChatPagePresenter>, AutomaticKeepAliveClientMixin<ChatPage> implements ChatView {
  late ChatPagePresenter _chatPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<CharacterEntity> _characterList = [];
  late HomeProvider _homeProvider;
  // 当前角色
  CharacterEntity? _character;
  // 背景组件控制器
  final BackgroundController _backgroundController = BackgroundController();
  // 底部按钮控制器
  final BottomBarController _bottomBarControll = BottomBarController();
  // 底部按钮控制器
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
          changeCharacter(_characterList.first);
        });
      },
      onError: (code, msg) {
        Log.d('获取角色列表失败:[error]$msg', tag: '[Function]getCharacterList');
        _pageState = 'fail';
        setState(() {});
      }
    );
  }

  void changeCharacter(CharacterEntity character) {
    _character = character;
    setState(() {});
    Future.delayed(Duration.zero, () {
      _homeProvider.character = character;
      _homeProvider.clearMessageList();
      _homeProvider.addIntroductionMessage();
      _homeProvider.addTipMessage('Role-plays started！');
      NormalMessage normalMessage = _homeProvider.createNormalMessage();
      normalMessage.text = _character!.text;
      _homeProvider.addNormalMessage(normalMessage);
      // MediaUtils().play(
      //   _character!.audio,
      //   whenFinished: () {
      //     _bottomBarControll.setDisabled(false);
      //   },
      // );
      _bottomBarControll.setDisabled(false);
    });
  }

  void openTopic() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (_) => Topic(
        onSelect: (topic) {
          if (_homeProvider.topic?.id == topic.id) {
            Toast.show(
              '该话题正在使用中',
              duration: 1000,
            );
            return;
          }
          Navigator.of(context).pop();
          _homeProvider.topic = topic;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
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

    List<String> characterAvatarList = _characterList.map((item) => item.imageUrl).toList();

    double homeTabbarHeight = 112.0;
    double bottomBarHeight = _screenUtil.bottomBarHeight + 80.0;

    return Stack(
      children: <Widget>[
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 1.0,
            sigmaY: 1.0,
          ),
          child: Background(
            controller: _backgroundController,
            characterAvatarList: characterAvatarList,
          ),
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
              child: const MessageList(),
            );
          },
        ),
        Positioned(
          bottom: _screenUtil.bottomBarHeight + 16.0,
          child: BottomBar(
            controller: _bottomBarControll,
            recordController: _recordController,
          ),
        ),
        Positioned(
          top: 216.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: openTopic,
            child: Container(
              width: 52.0,
              height: 34.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),
                ),
                border: Border.all(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Colors.white.withOpacity(0.2),
                ),
                color: const Color(0xFFB9B9B9).withOpacity(0.36),
              ),
              alignment: Alignment.center,
              child: const Text(
                '话题',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 16.9 / 14.0,
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
    );
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}