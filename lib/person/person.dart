import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/net.dart';
import 'package:Bubble/person/entity/permission_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';

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
  late PermissionBean permissionBeanData;

  late bool islog = true;
  late String userName = "";
  late String headimgurl = "";
  late String phone = "";
  late int totalTime = 0;
  void init() {}
  late HomeProvider _homeProvider;

  void getStudyInfo() {
    _personPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.studyInfo,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Log.e("来了==============");

      Log.e(result.toString());
      Log.e("==============");

      if (result == null || result.data == null) {
        return;
      }
      if (result.code == 200) {
        islog = false;
        _study = StudyEntity.fromJson(result.data);
      }

      setState(() {});
    }, onError: (code, msg) {});
  }

  void tapMenu(String path) {
    NavigatorUtils.push(context, path);
  }

  void tapInvitationcCodeMenu(String path) {
    NavigatorUtils.push(context, path);
  }

  void tapSignOUTMenu() {
    NavigatorUtils.goWebViewPage(
        context, "注销账号", "http://www.shenmo-ai.com/account_cancellation/");
  }

  void tapshezhiMenu() {
    NavigatorUtils.push(context, PersonalRouter.setting);
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off(NotificationUtils.resetChat);
    EventBus().off(NotificationUtils.resetInFo);
    EventBus().off("LOGINOUT");
  }

  @override
  void initState() {
    super.initState();
    // userInfo();
    // _personPagePresenter.getUsageTime();
    EventBus().on('LOGINOUT', (_) {
      setState(() {
        LoginManager.toLoginOut();
        NavigatorUtils.push(
          context,
          "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
        );
      });
    });

    EventBus().on(NotificationUtils.resetInFo, (_) {
      Log.e("进来了");
      Future.delayed(const Duration(seconds: 1), () {
        userInfo();
        _personPagePresenter.getUsageTime();

        // 这里是你想要延迟执行的代码
      });
    });

    EventBus().on(NotificationUtils.resetChat, (idx) {
      if (idx == "3") {
        // _homeProvider.getUsageTime();
        userInfo();
        _personPagePresenter.getUsageTime();
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    init();
    // getAvailableTime();
    userInfo();
  }

  void userInfo() {
    Map<String, dynamic> user = LoginManager.getUserInfo();
    Log.e("11111111111$user");
    String name = '';

    // 用户名显示规则 name > nickname > phone
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }

    if (validateInput(user['phone'])) {
      String namephone = '';
      namephone = user['phone'];
      String maskedPhoneNumber = namephone.replaceRange(3, 7, '****');
      name = maskedPhoneNumber;
    } else if (validateInput(user['name']) && user['name'] != '微信用户') {
      name = user['name'];
    } else if (validateInput(user['nickname'])) {
      name = user['nickname'];
    } else {
      String phone = '';
      if (validateInput(user['phone'])) {
        phone = user['phone'];
        name = "用户${phone.toString().substring(7, 11)}";
      }
    }
    userName = name;
    String headImg = '';
    if (validateInput(user['headimgurl'])) {
      headImg = user['headimgurl'];
    }
    headimgurl = headImg;

    setState(() {});
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

//  加载中
  Widget get _loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double width = _screenUtil.screenWidth - 32.0;
    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
    );
    // HomeProvider provider = Provider.of<HomeProvider>(context);
    // HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);

    Widget bg = Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/purchase_one_bg_img.png',
          ),
          fit: BoxFit.fill,
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
            borderRadius: BorderRadius.circular(36.0),
            child: LoadImage(
              headimgurl,
              width: 72.0,
              height: 72.0,
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
                  userName,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.05,
                  ),
                ),
                Gaps.vGap4,
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
            height: 8.0,
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

    Widget studyInfoTwoItem(dynamic value, String unit, String label) {
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
                  color: Colours.color_FF00A8,
                  height: 18.0 / 20.0,
                  letterSpacing: 0.05,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 18.0 / 13.0,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6.0,
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

    Widget studyInfo() {
      return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          // border: Border.all(
          //   width: 1.0,
          //   style: BorderStyle.solid,
          //   color: Colours.color_001652,
          // ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white70,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo,
            Gaps.vGap13,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                studyInfoItem(_study.duration, 'min', '学习时长'),
                studyInfoItem(_study.count, '个', '完成对话'),
                studyInfoTwoItem(_study.rank, '优胜', '学习排行'),
              ],
            ),
          ],
        ),
      );
    }

    // ///补零
    // String zeroFill(int i) {
    //   return i >= 10 ? "$i" : "0$i";
    // }

    // String second2DHMS(int sec) {
    //   String hms = "00天00时00分00秒";
    //   if (sec > 0) {
    //     int d = sec ~/ 86400;
    //     int h = (sec % 86400) ~/ 3600;
    //     int m = (sec % 3600) ~/ 60;
    //     int s = sec % 60;
    //     hms = "${zeroFill(d)}天${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
    //   }
    //   return hms;
    // }

    Widget isVip() {
      if (islog ? true : permissionBeanData.data.isMember == 1) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: islog
                    ? ""
                    : phone == "17001234567"
                        ? "奖牌领取"
                        : permissionBeanData.data.isMember == 1
                            ? '至${permissionBeanData.data.membershipExpiryDate}'
                            : '升级会员 为学习提速',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 23.0 / 16.0,
                ),
              ),
              // TextSpan(
              //   text: phone == "17001234567" ? "完成学习:" : '剩余学习时间：',
              //   style: const TextStyle(
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w500,
              //     color: Color(0xFF333333),
              //     height: 23.0 / 16.0,
              //   ),
              // ),
              // TextSpan(
              //   text: islog
              //       ? ""
              //       : '${permissionBeanData.data.allLeftTime > 60 ? permissionBeanData.data.allLeftTime ~/ 60 : 1}分钟',
              //   // text: '${permissionBeanData.data.isMember} 分钟',
              //   style: const TextStyle(
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w500,
              //     color: Color(0xFFA739EA),
              //     height: 23.0 / 16.0,
              //   ),
              // ),
            ],
          ),
        );
      } else {
        return const Text(
          '专属口语教练\n科学测评,个性化定制\n24小时 不限场景',
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
            height: 18.0 / 13.0,
          ),
        );
      }
    }

    Widget vipInfo() {
      return Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Colours.color_ECCCFF,
                Colours.color_F3E4FF,
              ],
            )),
        padding: const EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 16),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LoadAssetImage(
                      phone == "17001234567" ? "jinpai" : 'zhuanshi',
                      width: 64.0,
                      height: 51.0,
                    ),
                    Gaps.hGap4,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          islog
                              ? ""
                              : phone == "17001234567"
                                  ? "奖牌领取"
                                  : permissionBeanData.data.isMember == 1
                                      ? '会员权益'
                                      : '升级会员 为学习提速',
                          // islog
                          //     ? ""
                          //     : phone == "17001234567"
                          //         ? "奖牌领取"
                          //         : permissionBeanData.data.isMember == 1
                          //             ? '会员权益至${permissionBeanData.data.membershipExpiryDate}'
                          //             : '升级会员 为学习提速',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colours.color_8256FF,
                            // foreground: Paint()
                            //   ..shader = const LinearGradient(colors: [
                            //     Colours.color_8256FF,
                            //     Colours.color_FF5CDB,
                            //   ]).createShader(
                            //       const Rect.fromLTWH(0, 0, 150, 0))
                          ),
                        ),
                        isVip(),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (phone == "17001234567") {
                      NavigatorUtils.push(context, PersonalRouter.purchase);
                    } else {
                      NavigatorUtils.push(
                        context,
                        "${PersonalRouter.userMembershipUpgradePage}?levelId=0&goodsLabel=0",
                      );
                    }
                    EventUMStatistics.umengCommonMapEvent("个人中心-购买入口点击次数");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Colours.color_8256FF,
                            Colours.color_FF5CDB,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          // stops: [0.28, 0.9],
                        )),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 7.0,
                    ),
                    child: Text(
                      islog
                          ? ""
                          : phone == "17001234567"
                              ? "领取"
                              : permissionBeanData.data.isMember == 1
                                  ? '立即续费'
                                  : '立即开通',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 20.0 / 15.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Positioned(
            //   right: 5,
            //   top: 10,
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     onTap: () {
            //       if (phone == "17001234567") {
            //         NavigatorUtils.push(context, PersonalRouter.purchase);
            //       } else {
            //         NavigatorUtils.push(
            //           context,
            //           "${PersonalRouter.userMembershipUpgradePage}?levelId=9999999",
            //         );
            //       }
            //       EventUMStatistics.umengCommonMapEvent("个人中心-购买入口点击次数");
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(30),
            //           gradient: const LinearGradient(
            //             colors: [
            //               Colours.color_8256FF,
            //               Colours.color_FF5CDB,
            //             ],
            //             begin: Alignment.bottomLeft,
            //             end: Alignment.topRight,
            //             // stops: [0.28, 0.9],
            //           )),
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 14.0,
            //         vertical: 7.0,
            //       ),
            //       child: Text(
            //         islog
            //             ? ""
            //             : phone == "17001234567"
            //                 ? "领取"
            //                 : permissionBeanData.data.isMember == 1
            //                     ? '立即续费'
            //                     : '立即开通',
            //         style: const TextStyle(
            //           fontSize: 15.0,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           height: 20.0 / 15.0,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      );
    }

    Widget experience = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (islog
            ? true
            : permissionBeanData.data.isMember == 0 &&
                permissionBeanData.data.leftTime > 0)
          Container(
            width: width,
            // decoration: decoration,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: '免费体验',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                      TextSpan(
                          text: '${totalTime / 60}分钟',
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
                          text: islog
                              ? ""
                              : '${permissionBeanData.data.allLeftTime > 60 ? permissionBeanData.data.allLeftTime ~/ 60 : 1}分钟',
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
      ],
    );

    Widget vipTYInfo() {
      return Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Colours.color_ECCCFF5,
                Colours.color_F3E4FF5,
              ],
            )),
        child: Column(
          children: [
            experience,
            vipInfo(),
          ],
        ),
      );
    }

    Widget menuItem(
      String icon,
      String label,
      String edition, {
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
              LoadAssetImage(
                icon,
                width: 24.0,
                height: 24.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 16.0 / 14.0,
                  ),
                ),
              ),
              Text(
                edition,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_999999,
                  height: 16.0 / 14.0,
                ),
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
          menuItem('customer_service_icon', '联系客服', '', onPress: () {
            if (phone == "17001234567") {
              // NavigatorUtils.push(context, PersonalRouter.about);
              tapMenu(PersonalRouter.about);
            } else {
              Fluwx fluwx = Fluwx();
              fluwx.registerApi(
                  appId: "wxfb033d09d2eecaf0",
                  universalLink: "https://demo.shenmo-ai.net/ios/");
              // // MiniProgram
              fluwx.open(
                  target: CustomerServiceChat(
                      corpId: "wwd0c44d64eb7bcab7",
                      url:
                          "https://work.weixin.qq.com/kfid/kfc17bc7445bac300b9"));
            }
          } //=> tapMenu(PersonalRouter.about),
              ),
          menuItem(
            'community_icon',
            '加入社群',
            '',
            onPress: () => tapMenu(PersonalRouter.joinCommunityPage),
          ),
          menuItem(
            'person_fankui',
            '意见反馈',
            '',
            onPress: () => tapMenu(PersonalRouter.personalSuggestion),
          ),
          menuItem(
            'person_guanyu',
            '关于我们',
            'v2.0.5',
            onPress: () => tapMenu(PersonalRouter.about),
          ),

          menuItem(
            'vector_icon',
            '注销账号',
            '',
            onPress: () => tapSignOUTMenu(),
          ),
          // menuItem(
          //   'shezhi',
          //   '设置',
          //   onPress: () => tapshezhiMenu(),
          // ),
        ],
      ),
    );

    Widget courseInfo() {
      return Container(
        // height: 100,
        width: width,
        decoration: decoration,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapMenu(ReportRouter.courseOrderPage);
                EventUMStatistics.umengCommonMapEvent("个人中心-我的课程点击次数");
              },
              child: Column(
                children: [
                  const LoadAssetImage(
                    "course_icon",
                    width: 32.0,
                    height: 32.0,
                  ),
                  Gaps.vGap5,
                  const Text(
                    "我的课程",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapMenu(ReportRouter.reportPage);

                EventUMStatistics.umengCommonMapEvent("从个人中心进入系统课学情报告的曝光次数");
                EventUMStatistics.umengCommonMapEvent("个人中心-学情报告点击次数");
              },
              child: Column(
                children: [
                  const LoadAssetImage(
                    "study_report_icon",
                    width: 32.0,
                    height: 32.0,
                  ),
                  Gaps.vGap5,
                  const Text(
                    "学情报告",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapMenu(PersonalRouter.errorCorrectionPage);
                EventUMStatistics.umengCommonMapEvent("个人中心-纠错点击次数");
              },
              child: Column(
                children: [
                  const LoadAssetImage(
                    "error_correction_icon",
                    width: 32.0,
                    height: 32.0,
                  ),
                  Gaps.vGap5,
                  const Text(
                    "纠错",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapInvitationcCodeMenu(PersonalRouter.personalInvitationcCode);
              },
              child: Column(
                children: [
                  const LoadAssetImage(
                    "Invite_icon",
                    width: 32.0,
                    height: 32.0,
                  ),
                  Gaps.vGap5,
                  const Text(
                    "邀请码",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      child: islog
          ? _loadingView
          : Stack(
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
                        SizedBox(
                          height: _screenUtil.statusBarHeight + 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                tapshezhiMenu();
                              },
                              child: const LoadAssetImage(
                                "shezhi",
                                width: 24.0,
                                height: 24.0,
                              ),
                            ),
                            // Gaps.hGap4,
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        studyInfo(),
                        const SizedBox(
                          height: 16.0,
                        ),
                        vipTYInfo(),
                        const SizedBox(
                          height: 16.0,
                        ),
                        courseInfo(),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // experience,
                        menu,
                        SizedBox(
                          height: _screenUtil.bottomBarHeight + 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   right: 20,
                //   top: 50,
                //   child: GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () {
                //       tapshezhiMenu();
                //     },
                //     child: const LoadAssetImage(
                //       "shezhi",
                //       width: 24.0,
                //       height: 24.0,
                //     ),
                //   ),
                // ),
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

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(PermissionBean permissionBean) {
    // TODO: implement sendSuccess
    permissionBeanData = permissionBean;
    totalTime = permissionBean.data.totalTime;
    getStudyInfo();

    // setState(() {});
  }
}
