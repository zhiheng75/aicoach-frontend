import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/scene/collect_information.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:jverify/jverify.dart';
import 'package:provider/provider.dart';

import '../chat/chat.dart';
import '../constant/constant.dart';
import '../exam/exam.dart';
import '../mvp/base_page.dart';
import '../net/http_api.dart';
import '../widgets/double_tap_back_exit_app.dart';
import 'presenter/home_new_page_presenter.dart';
import 'view/home_new_view.dart';
import 'widget/home_tabbar.dart';

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({Key? key}) : super(key: key);

  @override
  State<HomeNewPage> createState() => _HomePageState();
}

class _HomePageState extends State<HomeNewPage>
    with
        BasePageMixin<HomeNewPage, HomeNewPagePresenter>,
        AutomaticKeepAliveClientMixin<HomeNewPage>
    implements HomeNewView {
  late HomeProvider _homeProvider;
  late HomeNewPagePresenter _homeNewPagePresenter;
  // chat-对话（默认） scene-场景 exam-模考
  String _currentTab = '';

  void init() {
    // 初始化手机号一键登录插件
    initPlatformState();
    initCollectInformation();
    // 获取体验时间
    _homeProvider.getUsageTime();
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

  void initCollectInformation() {
    EventBus().on('COLLECT_INFORMATION', (type) {
      _homeNewPagePresenter.requestNetwork<ResultData>(
        Method.get,
        url: HttpApi.collectInformation,
        isShow: type != 'login',
        isClose: type != 'login',
        onSuccess: (result) {
          if (result == null ||
              result.code != 200 ||
              result.data == null ||
              (result.data as Map<String, dynamic>)['is_evaluation'] == 1) {
            if (_currentTab == '') {
              _currentTab = 'chat';
              setState(() {});
            }
            return;
          }
          Map<String, dynamic> data = result.data as Map<String, dynamic>;
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            isScrollControlled: true,
            isDismissible: false,
            clipBehavior: Clip.none,
            enableDrag: false,
            builder: (_) => CollectInformationPage(
              characterId: data['character_id'],
              sceneId: data['scene_id'],
              sceneImage: data['scene_image'] ?? '',
              desc: data['desc'] ?? '',
              onEnd: () {
                if (_currentTab == '') {
                  _currentTab = 'chat';
                  setState(() {});
                  return;
                }
                if (_currentTab == 'chat') {
                  EventBus().emit('COLLECT_INFORMATION_END');
                }
              },
            ),
          );
        },
        onError: (code, msg) {
          if (_currentTab == '') {
            _currentTab = 'chat';
            setState(() {});
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      init();
      _currentTab = 'chat';
      setState(() {});
      // EventBus().emit('COLLECT_INFORMATION', 'init');
    });
  }

  @override
  void dispose() {
    EventBus().off('COLLECT_INFORMATION');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleTapBackExitApp(
      child: Material(
        child: Stack(
          children: <Widget>[
            if (_currentTab == 'chat') const ChatPage(),
            if (_currentTab == 'exam') const ExamPage(),
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
