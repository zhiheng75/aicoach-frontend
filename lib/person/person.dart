import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/net.dart';
import 'package:Bubble/person/entity/permission_bean.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void init() {
    getStudyInfo();
  }

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
      _study = StudyEntity.fromJson(result.data);
      setState(() {});
    }, onError: (code, msg) {});
  }

  // Future getAvailableTime() async {
  //   String deviceId = await Device.getDeviceId();
  //   _personPagePresenter.requestNetwork<ResultData>(Method.get,
  //       url: HttpApi.permission,
  //       queryParameters: {
  //         'device_id': deviceId,
  //       }, onSuccess: (result) {
  //     Log.e("这里==============");

  //     Log.e(result.toString());
  //     Log.e("==============");
  //     // Map<String, dynamic> data = {
  //     //   'left_time': 0,
  //     //   'is_member': 0,
  //     // };
  //     // if (result != null && result.code == 200 && result.data != null) {
  //     //   data = result.data as Map<String, dynamic>;
  //     // }
  //   });
  // }

  void tapMenu(String path) {
    NavigatorUtils.push(context, path);
  }

  void tapInvitationcCodeMenu(String path) {
    // NavigatorUtils.goWebViewPage(
    //     context, "注销账号", "http://www.shenmo-ai.com/account_cancellation/");
    NavigatorUtils.push(context, path);
  }

  void tapSignOUTMenu() {
    NavigatorUtils.goWebViewPage(
        context, "注销账号", "http://www.shenmo-ai.com/account_cancellation/");
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    init();
    // getAvailableTime();
    Map<String, dynamic> user = LoginManager.getUserInfo();
    Log.e(user.toString());

    // userName = validateInput(user['nickname'])
    //     ? user['nickname']
    //     : "用户${user['phone'].toString().substring(7, 11)}";
    // // userName = "用户${user['phone'].toString().substring(7, 11)}";
    //
    // Log.e("个人中心=============================");
    // headimgurl = validateInput(user['headimgurl']) ? user['headimgurl'] : "";
    // phone = user['phone'];

    // 用户名显示规则 name > nickname > phone
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }

    String name = '';
    if (validateInput(user['name']) && user['name'] != '微信用户') {
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
            child: headimgurl != ''
                ? LoadImage(
                    headimgurl,
                    width: 56.0,
                    height: 56.0,
                  )
                : const LoadAssetImage(
                    'default_head_img',
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
                  userName,
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

    Widget vipInfo() {
      return Container(
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
                LoadAssetImage(
                  phone == "17001234567" ? "jinpai" : 'zhuanshi',
                  width: 48.0,
                  height: 48.0,
                ),
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
                                  ? '会员权益至${permissionBeanData.data.membershipExpiryDate}'
                                  : '升级会员 为学习提速',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                        height: 23.0 / 16.0,
                      ),
                    ),
                    if (islog ? true : permissionBeanData.data.isMember == 1)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  phone == "17001234567" ? "完成学习:" : '剩余学习时间：',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                                height: 23.0 / 16.0,
                              ),
                            ),
                            TextSpan(
                              text: islog
                                  ? ""
                                  : '${permissionBeanData.data.allLeftTime > 60 ? permissionBeanData.data.allLeftTime ~/ 60 : 1}分钟',
                              // text: '${permissionBeanData.data.isMember} 分钟',
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
              onTap: () =>
                  NavigatorUtils.push(context, PersonalRouter.purchase),
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
                  islog
                      ? ""
                      : phone == "17001234567"
                          ? "领取"
                          : permissionBeanData.data.isMember == 1
                              ? '续费'
                              : '立即开通',
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
                          text: '免费体验',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 18.0 / 13.0,
                            letterSpacing: 0.05,
                          )),
                      TextSpan(
                          text: '45分钟',
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
            '学情报告',
            onPress: () => tapMenu(ReportRouter.reportPage),
          ),
          menuItem(
            'person_goumai',
            '购买记录',
            onPress: () => tapMenu(PersonalRouter.order),
          ),
          menuItem(
            'person_yaoqing',
            '邀请码',
            onPress: () =>
                tapInvitationcCodeMenu(PersonalRouter.personalInvitationcCode),
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
          menuItem(
            'vector_icon',
            '注销账号',
            onPress: () => tapSignOUTMenu(),
          ),
        ],
      ),
    );

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
                        vipInfo(),
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

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(PermissionBean permissionBean) {
    // TODO: implement sendSuccess
    setState(() {});
    islog = false;
    permissionBeanData = permissionBean;
  }
}
