import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import '../report/report_router.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/load_image.dart';
import '../widgets/navbar.dart';
import 'person_router.dart';
import 'presneter/person_page_presenter.dart';
import 'view/person_view.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> with BasePageMixin<PersonPage, PersonPagePresenter>, AutomaticKeepAliveClientMixin<PersonPage> implements PersonView {

  late PersonPagePresenter _personPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();

  void init() {}

  void tapMenu(String path) {
    NavigatorUtils.push(context, path);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget bg = Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/person_bg.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );

    Widget navbar = Navbar(
      title: '个人中心',
      action: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
        },
        child: const LoadAssetImage(
          'shezhi',
          width: 22.0,
          height: 22.0,
        ),
      ),
    );

    Widget userInfo = const Row();

    Widget studyInfo = Container();

    Widget vipInfo = Container();

    Widget experience = Container();

    Widget menuItem(String icon, String label, {
      Function()? onPress,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onPress != null) {
            onPress();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  LoadAssetImage(
                    icon,
                    width: 24.0,
                    height: 24.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 16.0 / 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget menu = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          menuItem(
            'person_baogao',
            '学习报告',
            onPress: () => tapMenu(ReportRouter.reportPage),
          ),
          menuItem(
            'person_goumai',
            '购买记录',
            onPress: () => tapMenu(PersonalRouter.order),
          ),
          menuItem(
            'person_fankui',
            '意见反馈',
            onPress: () => tapMenu(PersonalRouter.personalSuggestion),
          ),
          menuItem(
            'person_guanyu',
            '关于我们',
            onPress: () => tapMenu(PersonalRouter.about),
          ),
        ],
      ),
    );

    return Material(
      child: Stack(
        children: <Widget>[
          bg,
          Container(
            width: _screenUtil.screenWidth,
            height: _screenUtil.screenHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 60.0,
                  ),
                  navbar,
                  const SizedBox(
                    height: 16.0,
                  ),
                  userInfo,
                  const SizedBox(
                    height: 16.0,
                  ),
                  studyInfo,
                  const SizedBox(
                    height: 16.0,
                  ),
                  vipInfo,
                  const SizedBox(
                    height: 16.0,
                  ),
                  experience,
                  const SizedBox(
                    height: 16.0,
                  ),
                  menu,
                  SizedBox(
                    height: _screenUtil.bottomBarHeight + 16.0,
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
  PersonPagePresenter createPresenter() {
    _personPagePresenter = PersonPagePresenter();
    return _personPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}