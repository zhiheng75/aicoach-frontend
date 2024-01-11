import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/net.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../mvp/base_page.dart';
import '../report/report_router.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/load_image.dart';
import '../widgets/navbar.dart';
import 'entity/study_entity.dart';
import 'person_router.dart';
import 'presneter/person_page_presenter.dart';
import 'view/person_view.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage>
    with
        BasePageMixin<PersonPage, PersonPagePresenter>,
        AutomaticKeepAliveClientMixin<PersonPage>
    implements PersonView {
  late PersonPagePresenter _personPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  StudyEntity _study = StudyEntity();

  void init() {
    getStudyInfo();
  }

  void getStudyInfo() {
    _personPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.studyInfo,
        isShow: false,
        isClose: false, onSuccess: (result) {
      if (result == null || result.data == null) {
        return;
      }
      _study = StudyEntity.fromJson(result.data);
      setState(() {});
    }, onError: (code, msg) {});
  }

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

    double width = _screenUtil.screenWidth - 32.0;
    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
    );
    HomeProvider provider = Provider.of<HomeProvider>(context);

    Map<String, dynamic> user = LoginManager.getUserInfo();

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
        onTap: () => NavigatorUtils.push(context, PersonalRouter.setting), //
        child: const LoadAssetImage(
          'shezhi',
          width: 22.0,
          height: 22.0,
        ),
      ),
    );

    Widget userInfo = SizedBox(
      width: width,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(28.0),
            child: LoadImage(
              user['headimgurl'] ?? '',
              width: 56.0,
              height: 56.0,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user['name'] ??
                      user['nickname'] ??
                      '用户${user['phone'].toString().substring(7, 11)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 0.05,
                  ),
                ),
                Text(
                  '你的周学习活跃指数为${_study.activeRank}，\n保持每天学习 ，加油赶超！',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget studyInfoItem(dynamic value, String unit, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 18.0 / 20.0,
                  letterSpacing: 0.05,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 18.0 / 13.0,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 14.0,
              letterSpacing: 0.05,
            ),
          ),
        ],
      );
    }

    Widget studyInfo = Container(
      width: width,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 24.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          studyInfoItem(_study.duration, 'min', '学习时长'),
          studyInfoItem(_study.count, '个', '完成对话'),
          studyInfoItem(_study.rank, '优胜', '学习排行'),
        ],
      ),
    );

    Widget vipInfo = Container(
      width: width,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const LoadAssetImage(
                'zhuanshi',
                width: 48.0,
                height: 48.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    provider.vipState == 1
                        ? '会员权益至${provider.expireDate}'
                        : '升级会员 为学习提速',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                      height: 23.0 / 16.0,
                    ),
                  ),
                  if (provider.vipState == 1)
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '剩余学习时间：',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                              height: 23.0 / 16.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${provider.usageTime > 60 ? provider.usageTime ~/ 60 : 1}分钟',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA739EA),
                              height: 23.0 / 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Text(
                    '专属口语教练，科学测评\n个性化定制，24小时 不限场景',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.0 / 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => NavigatorUtils.push(context, PersonalRouter.purchase),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: const Color(0xFFE49600),
                ),
                color: const Color(0xFFFFCF71),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 7.0,
              ),
              child: Text(
                provider.vipState == 1 ? '续费' : '立即开通',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 20.0 / 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget experience = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (provider.vipState == 0 && provider.expDay > 0)
          Container(
            width: width,
            decoration: decoration,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: '免费体验3天，每天',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                      TextSpan(
                          text: '15分钟',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0047FF),
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: '剩余体验时间:',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                      TextSpan(
                          text:
                              '${provider.usageTime > 60 ? provider.usageTime ~/ 60 : 1}分钟',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0047FF),
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );

    Widget menuItem(
      String icon,
      String label, {
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
      decoration: decoration,
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
