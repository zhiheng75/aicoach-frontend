import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/widget/course_equity_item.dart';
import 'package:Bubble/home/widget/people_item.dart';
import 'package:Bubble/home/widget/problem_item.dart';
import 'package:Bubble/home/widget/problem_two_item.dart';
import 'package:Bubble/home/widget/teacher_show_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/goods_bean.dart';
import 'package:Bubble/person/entity/member_state_bean.dart';
import 'package:Bubble/person/presneter/user_membership_upgrade_page_presenter.dart';
import 'package:Bubble/person/view/user_membership_upgrade_page_view.dart';
import 'package:Bubble/person/widget/user_membership_upgrade_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

class UserMembershipUpgradePage extends StatefulWidget {
  const UserMembershipUpgradePage({super.key});

  @override
  State<UserMembershipUpgradePage> createState() =>
      _UserMembershipUpgradePageState();
}

class _UserMembershipUpgradePageState extends State<UserMembershipUpgradePage>
    with
        BasePageMixin<UserMembershipUpgradePage,
            UserMembershipUpgradepagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<UserMembershipUpgradePage>
    implements
        UserMembershipUpgradePageView {
  RenderBox? boxTab;
  late Offset offsetTab;
  GlobalKey keyTab = GlobalKey(debugLabel: "university");
  bool isUpdateAppBar = false;
  bool _checked = false;
  final ScreenUtil _screenUtil = ScreenUtil();
  late UserMembershipUpgradepagePresenter _userMembershipUpgradepagePresenter;

  // late LessonDetailBean dataBean;
  bool isLoding = true;
  late String headimgurl = "";
  late String userName = "";
  late String userVIP = "";

  late GoodsBean listData;
  late int idx = 0;
  late int payIdx = 0;

  String _pay = 'wxpay';

  late String rechargeSloganStr = "";
  late String rechargeLessonSloganStr = "";

  Fluwx fluwx = Fluwx();
  late String? accessToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accessToken = SpUtil.getString(Constant.accessToken);

    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");
    Map<String, dynamic> user = LoginManager.getUserInfo();

    headimgurl = user['headimgurl'];

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

    EventUMStatistics.umengCommonPageCollectionModeAuto();
    EventUMStatistics.umengCommonOnPageStart("个人中心-售卖页停留时长");
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

  void pay() {
    int _goodsId = listData.data[idx].id;
    double _goodPrice = listData.data[idx].price;

    if (_pay == 'wxpay') {
      _userMembershipUpgradepagePresenter.wxChatPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'alipay') {
      _userMembershipUpgradepagePresenter.aliPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'applepay') {
      _userMembershipUpgradepagePresenter.applePay(_goodsId);
    }
  }

  Widget userInfoWidget() {
    return Container(
      // height: 100,
      // color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Gaps.hGap16,
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: LoadImage(
                  headimgurl,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Gaps.hGap6,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    userVIP,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.vGap6,
          Marquee(
            speed: 8,
            child: Container(
                margin: const EdgeInsets.only(
                    right: 10, left: 10, top: 3, bottom: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colours.color_FFFFFF5,
                ),
                padding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 14, right: 14),
                child: const Text(
                  '用户 ******天，56秒前开通了包月会员',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )),
          )

          // Container(height: 20, width: 100, child: RepeatedListView()),
        ],
      ),
    );
  }

  Widget teacherWidget() {
    return Stack(
      children: [
        Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_FAF7FF,
                    Colours.color_F3EEFE,
                  ],
                )),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "每周六 晚19:00-21:00 报名后分配",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_2C0047,
                          ),
                        ),
                        Gaps.vGap5,
                        Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colours.color_6D388F,
                            ),
                            child: const Text(
                              "辅导老师",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )),
                    const SizedBox(
                      height: 100,
                      width: 150,
                    ),
                  ],
                ),
              ],
            )),
        const Positioned(
            right: 5,
            bottom: 10,
            child: LoadAssetImage(
              "suofeiya_head",
              width: 170.0,
              height: 150.0,
            ))
      ],
    );
  }

  Widget classPayWidget() {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Colours.color_FAF7FF,
              Colours.color_F3EEFE,
            ],
          )),
      margin: const EdgeInsets.all(9),
      padding: const EdgeInsets.only(left: 4, right: 2, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Gaps.hGap8,
              const LoadAssetImage(
                'zhuanshi',
                width: 48.0,
                height: 48.0,
              ),
              Gaps.hGap4,
              Text(
                "升级会员",
                key: keyTab,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Gaps.vGap4,
          SizedBox(
            // margin: const EdgeInsets.only(top: 10),
            height: 160.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listData.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      idx = index;
                    });
                    if (index == 0) {
                      EventUMStatistics.umengCommonMapEvent(
                          "个人中心-售卖页引流包支付点击次数");
                    } else {
                      EventUMStatistics.umengCommonMapEvent(
                          "个人中心-售卖页正价课支付点击次数");
                    }
                  },
                  child: UserMembershipUpgradeItem(
                    isSele: idx == index ? true : false,
                    data: listData.data[index],
                  ),
                );
              },
            ),
          ),
          // Gaps.vGap9,
          Container(
            margin: const EdgeInsets.only(left: 18, right: 18, top: 9),
            child: Text(
              listData.data[idx].type != 1
                  ? rechargeSloganStr
                  : rechargeLessonSloganStr,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_191919,
              ),
            ),
          ),
          Gaps.vGap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    payIdx = 0;
                    _pay = 'wxpay';
                  });
                  // NavigatorUtils.push(context, CourseRouter.certifiedLearningPage);
                },
                child: Container(
                  width: 122,
                  decoration: payIdx == 0
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2.0,
                            style: BorderStyle.solid,
                            color: Colours.color_8256FF,
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                  // margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadAssetImage(
                        'wxpay_icon',
                        width: 24.0,
                        height: 24.0,
                      ),
                      Gaps.hGap4,
                      const Text(
                        "微信支付",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.hGap16,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    payIdx = 1;
                    _pay = 'alipay';
                  });
                  // NavigatorUtils.push(context, CourseRouter.certifiedLearningPage);
                },
                child: Container(
                  width: 122,
                  decoration: payIdx == 1
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2.0,
                            style: BorderStyle.solid,
                            color: Colours.color_8256FF,
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                  // margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadAssetImage(
                        'alipay_img',
                        width: 24.0,
                        height: 24.0,
                      ),
                      Gaps.hGap4,
                      const Text(
                        "支付宝",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              pay();
            },
            child: const Center(
                child: LoadAssetImage(
              'pay_btn_bg',
              width: 331.0,
              // height: 24.0,
            )),
          ),
          Gaps.vGap4,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gaps.hGap10,
              Text(
                "购买后即为同意",
                style:
                    TextStyle(fontSize: Dimens.font_sp12, color: Colours.black),
              ),

              GestureDetector(
                onTap: () {
                  NavigatorUtils.goWebViewPage(
                      context, "服务协议", "http://www.shenmo-ai.com/tos/");
                },
                child: Text(
                  "《用户协议》",
                  style: TextStyle(
                    color: Colours.color_0047FF,
                    fontSize: Dimens.font_sp12,
                    // decoration: TextDecoration.underline
                  ),
                ),
              ),
              Text(
                "和",
                style: TextStyle(
                    fontSize: Dimens.font_sp12, color: Colours.color_546092),
              ),
              GestureDetector(
                onTap: () {
                  NavigatorUtils.goWebViewPage(context, "隐私政策",
                      "http://www.shenmo-ai.com/privacy_policy/");
                },
                child: Text("《隐私协议》",
                    style: TextStyle(
                      fontSize: Dimens.font_sp12,
                      color: Colours.color_0047FF,
                      // decoration: TextDecoration.underline
                    )),
              ),
            ],
          ),
          Gaps.vGap10,
        ],
      ),
    );
  }

  Widget headWidget(String headStr) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: Text(
          headStr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < listData.data[idx].detail.questions.length; i++) {
      list.add(ProblemTwoItem(
        questions: listData.data[idx].detail.questions[i],
      ));
    }
    return list;
  }

  Widget problemWidget() {
    //  dataBean.data.questions

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colours.color_FAF8FF,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 5,
        ),
        child: Column(
          children: _buildItems(),
        ),
      ),
    );
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> _buildDetailItems() {
    List<Widget> list = [];
    for (int i = 0; i < listData.data[idx].detail.detailImg.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 20, left: 9, right: 9),
        child: LoadImage(
          width: _screenUtil.screenWidth,
          listData.data[idx].detail.detailImg[i],
        ),
      ));
    }
    return list;
  }

  Widget detailWidget() {
    return SliverToBoxAdapter(
      child: Column(
        children: _buildDetailItems(),
      ),
    );
  }

  Widget otherHeadWidget(String headStr) {
    return SliverToBoxAdapter(
      child: LoadAssetImage(
        width: _screenUtil.screenWidth,
        headStr,
        // width: 170.0,
        // height: 150.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      child: Scaffold(
        body: CustomPaint(
          painter: TopOriginPainter(),
          size: Size.infinite,
          child: isLoding
              ? lodingView()
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ImageUtils.getAssetImage("pay_img_bg"),
                          fit: BoxFit.fill)),
                  child: Stack(children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        boxTab ??= keyTab.currentContext!.findRenderObject()
                            as RenderBox?;
                        offsetTab = boxTab!.localToGlobal(Offset.zero);

                        if (offsetTab.dy < 110.0) {
                          isUpdateAppBar = true;
                        } else {
                          isUpdateAppBar = false;
                        }
                        setState(() {});

                        return true;
                      },
                      child: CustomScrollView(slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            // color: Colors.amber,
                            height: _screenUtil.statusBarHeight + 50,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: userInfoWidget(),
                        ),
                        SliverToBoxAdapter(
                          child: classPayWidget(),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 9, right: 9),
                            child: LoadImage(
                              listData.data[idx].detail.teacherImg,
                            ),
                          ),
                        ),
                        headWidget("用户评价"),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 9),
                            height: 166.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData
                                  .data[idx].detail.userFeedbackImg.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width: 238.0,
                                    child: LoadImage(
                                      listData.data[idx].detail
                                          .userFeedbackImg[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // headWidget("课程详情"),
                        detailWidget(),
                        // listData.data[idx].type != 1
                        //     ? otherHeadWidget("people_head")
                        //     : SliverToBoxAdapter(child: Container()),
                        // listData.data[idx].type != 1
                        //     ? otherHeadWidget("quanyi_hrad")
                        //     : SliverToBoxAdapter(child: Container()),
                        listData.data[idx].type != 1
                            ? SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(top: 40, bottom: 14),
                                  // height: 80,
                                  child: const LoadAssetImage(
                                    'wenti_bg',
                                  ),
                                ),
                              )
                            : SliverToBoxAdapter(child: Container()),
                        listData.data[idx].type != 1
                            ? problemWidget()
                            : SliverToBoxAdapter(
                                child: Container(),
                              ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 80,
                          ),
                        )
                      ]),
                    ),
                    isUpdateAppBar
                        ? Positioned(
                            top: 0, left: 0, right: 0, child: Container())
                        : const Positioned(
                            top: 60,
                            left: 12,
                            right: 12,
                            // height: 80,
                            child: Center(
                              child: Text(
                                "升级会员",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                    isUpdateAppBar
                        ? const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: XTCupertinoNavigationBar(
                              backgroundColor: Color(0xFFFFFFFF),
                              border: null,
                              padding: EdgeInsetsDirectional.zero,
                              leading: NavigationBackWidget(),
                              middle: Text(
                                "升级会员",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))
                        : Positioned(
                            top: 60,
                            left: 12,
                            child: GestureDetector(
                                onTap: () {
                                  NavigatorUtils.goBack(context);
                                },
                                child: const LoadAssetImage(
                                  "ic_back_icon",
                                  width: 20.0,
                                  height: 20.0,
                                )),
                          ),
                  ]),
                ),
        ),
      ),
    );
  }

  @override
  UserMembershipUpgradepagePresenter createPresenter() {
    // TODO: implement createPresenter
    _userMembershipUpgradepagePresenter = UserMembershipUpgradepagePresenter();
    return _userMembershipUpgradepagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(GoodsBean data) {
    // TODO: implement sendSuccess
    setState(() {
      isLoding = false;
      listData = data;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TeacherShowView(
            () {
              //确定
              String accessToken = SpUtil.getString(Constant.accessToken) ?? "";
              String url =
                  "pages/mine/add-weChat/add-weChat?user_token=$accessToken";
              var encoded = Uri.encodeComponent(url);
              fluwx.open(
                  target: MiniProgram(
                      username: "gh_dcd9c62ba779",
                      path: encoded,
                      miniProgramType: WXMiniProgramType.preview));
              EventUMStatistics.umengCommonMapEvent("添加辅导老师页面曝光次数");
            },
          );
        });
  }

  @override
  void paySuccess() {
    // TODO: implement paySuccess
    if (listData.data[idx].type == 4) {
      showImageDialog();
//       ConfirmUtils.showSingle(
//         context: context,
//         title: "支付成功\n前往微信添加\n本课程辅导老师",
//         onCancel: () {
// //         移动应用appid:wxfb033d09d2eecaf0
// // 小程序appid:wx2140a8026b8cdf74
// // 跳转路径：pages/mine/add-weChat/add-weChat?user_token=token
//           // alertDialoFg();
//           //跳转小程序

//           fluwx.open(
//               target: MiniProgram(
//                   username: "gh_dcd9c62ba779",
//                   path:
//                       "pages/mine/add-weChat/add-weChat?user_token=$accessToken",
//                   miniProgramType: WXMiniProgramType.test));
//           Navigator.of(context).pop();
//         },
//       );
      Provider.of<HomeProvider>(context, listen: false).getUsageTime();
      EventBus().emit(NotificationUtils.resetInFo);
    } else {
      Provider.of<HomeProvider>(context, listen: false).getUsageTime();
      EventBus().emit(NotificationUtils.resetInFo);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off(NotificationUtils.resetInFo);
    EventUMStatistics.umengCommonOnPageEnd("个人中心-售卖页停留时长");
  }

  @override
  void sendMemberStateSuccess(MemberStateBean data) {
    // TODO: implement sendMemberStateSuccess
    if (data.code == 200) {
      if (data.data.isMember == 1) {
        userVIP = "会员";
      } else if (data.data.isMember == 2) {
        userVIP = "会员已到期 ";
      } else {
        userVIP = "暂未开通会员";
      }
    }
    setState(() {});

// userVIP
  }

  @override
  void sendSuccessMsg(String title, String msg) {
    // TODO: implement sendSuccessMsg
    setState(() {
      rechargeSloganStr = title;
      rechargeLessonSloganStr = msg;
    });
  }
}

class TopOriginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义新的坐标系原点
    canvas.translate(0.0, size.height);
    // 绘制操作从这里开始
    // ...
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Marquee extends StatefulWidget {
  const Marquee({required this.child, this.speed = 10, Key? key})
      : super(key: key);
  final Widget child;
  final int speed;

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrctrl;
  SingleChildScrollView? _scrollView;

  double _space = 0;

  @override
  void initState() {
    super.initState();

    _scrctrl = ScrollController();

    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.speed));
    _animation = Tween(
      begin: 0.1,
      end: 100.0,
    ).animate(_controller);
    _animation.addListener(() {
      if (_scrctrl.hasClients) {
        if (_scrollView != null && _scrctrl.position.hasContentDimensions) {
          var index = _animation.value / 100;
          _scrctrl.jumpTo(index * _scrctrl.position.maxScrollExtent);
        }
        if (_scrctrl.position.hasViewportDimension && _space == 0) {
          setState(() {
            _space = _scrctrl.position.viewportDimension;
          });
        }
      }
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    _scrollView = SingleChildScrollView(
      controller: _scrctrl,
      scrollDirection: Axis.horizontal,
      child: _scrctrl.hasClients
          ? Row(
              children: [
                SizedBox(
                  width: _space,
                ),
                widget.child,
                SizedBox(
                  width: _space,
                ),
              ],
            )
          : const SizedBox(),
    );
    return _scrollView ?? const Column();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
