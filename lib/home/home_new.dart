import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:jverify/jverify.dart';

import '../chat/chat.dart';
import '../constant/constant.dart';
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

  void init() {
    // 初始化手机号一键登录插件
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // 初始化 SDK 之前添加监听
    Constant.jverify.addSDKSetupCallBackListener((JVSDKSetupEvent event) {
      LogUtil.d("receive sdk setup call back event :${event.toMap()}");
    });

    Constant.jverify.setDebugMode(true); // 打开调试模式
    Constant.jverify.setup(
        appKey: "d213d60b209d0807dc4146f4", //"你自己应用的 AppKey",
        channel: "devloper-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效
    if (!mounted) return;

    /// 授权页面点击时间监听
    Constant.jverify.addAuthPageEventListener((JVAuthPageEvent event) {
      LogUtil.d("receive auth page event :${event.toMap()}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleTapBackExitApp(
      child: Material(
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