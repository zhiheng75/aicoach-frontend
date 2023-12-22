import 'package:flutter/material.dart';

import '../chat/chat.dart';
import '../mvp/base_page.dart';
import '../widgets/double_tap_back_exit_app.dart';
import 'presenter/home_new_page_presenter.dart';
import 'view/home_new_view.dart';
import 'widget/home_tabbar.dart';

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({Key? key}) : super(key: key);

  @override
  State<HomeNewPage> createState() => _HomePageState();
}

class _HomePageState extends State<HomeNewPage> with BasePageMixin<HomeNewPage, HomeNewPagePresenter>, AutomaticKeepAliveClientMixin<HomeNewPage> implements HomeNewView {
  late HomeNewPagePresenter _homeNewPagePresenter;
  // chat-对话（默认） scene-场景 exam-模考
  String _currentTab = 'chat';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleTapBackExitApp(
      child: Stack(
        children: <Widget>[
          if (_currentTab == 'chat')
            const ChatPage(),
          Positioned(
            top: 60.0,
            child: HomeTabbar(
              currentTab: _currentTab,
              changeTab: (tab) {
                _currentTab = tab;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeNewPagePresenter createPresenter() {
    _homeNewPagePresenter = HomeNewPagePresenter();
    return _homeNewPagePresenter;
  }

  @override
  bool get wantKeepAlive => true;
}