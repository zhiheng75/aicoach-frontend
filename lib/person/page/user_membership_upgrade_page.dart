import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/widget/course_equity_item.dart';
import 'package:Bubble/home/widget/people_item.dart';
import 'package:Bubble/home/widget/problem_item.dart';
import 'package:Bubble/home/widget/problem_two_item.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/goods_bean.dart';
import 'package:Bubble/person/presneter/user_membership_upgrade_page_presenter.dart';
import 'package:Bubble/person/view/user_membership_upgrade_page_view.dart';
import 'package:Bubble/person/widget/user_membership_upgrade_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  late GoodsBean listData;
  late int idx = 0;
  late int payIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  Widget userInfoWidget() {
    return Container(
      height: 90,
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
                    "是会员吗",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.vGap4,
          Marquee(
            speed: 8,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colours.color_F8F8F8,
                ),
                padding: const EdgeInsets.all(4),
                child: const Text(
                  '用户 ******天，56秒前开通了包月会员',
                  style: TextStyle(
                    fontSize: 11.0,
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
            // height: 80,
            // width: 280,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_E8CCFE,
                    Colours.color_ACCDFF,
                  ],
                )),
            // height: 200,
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
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LoadAssetImage(
                'zhuanshi',
                width: 48.0,
                height: 48.0,
              ),
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
          Gaps.vGap4,
          SizedBox(
            // margin: const EdgeInsets.only(top: 10),
            height: 200.0,
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
                  },
                  child: UserMembershipUpgradeItem(
                    isSele: idx == index ? true : false,
                    data: listData.data[index],
                  ),
                );
              },
            ),
          ),
          Gaps.vGap4,
          Text(
            listData.data[idx].desc,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_191919,
            ),
          ),
          Gaps.vGap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    payIdx = 0;
                  });
                  // NavigatorUtils.push(context, CourseRouter.certifiedLearningPage);
                },
                child: Container(
                  width: 120,
                  decoration: payIdx == 0
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colours.color_8256FF,
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                  margin: const EdgeInsets.all(10),
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    payIdx = 1;
                  });
                  // NavigatorUtils.push(context, CourseRouter.certifiedLearningPage);
                },
                child: Container(
                  width: 120,
                  decoration: payIdx == 1
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colours.color_8256FF,
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                  margin: const EdgeInsets.all(10),
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
            onTap: () {},
            child: Center(
              child: Container(
                width: 250.0,
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  // border: Border.all(
                  //   width: 1.0,
                  //   style: BorderStyle.solid,
                  //   color: Colours.color_001652,
                  // ),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colours.color_9AC3FF,
                      Colours.color_FF71E0,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '立即购买',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Gaps.vGap10,
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
        ],
      ),
    );
  }

  Widget headWidget(String headStr) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            Positioned(
              bottom: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colours.color_8256FF,
                      Colours.color_FF5CDB,
                    ],
                  ),
                ),
                width: 80,
                height: 5,
              ),
            ),
            Text(
              headStr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
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
          color: Colours.color_F8F8F8,
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
      list.add(LoadImage(
        listData.data[idx].detail.detailImg[i],
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
              : Stack(children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      boxTab ??= keyTab.currentContext!.findRenderObject()
                          as RenderBox?;
                      offsetTab = boxTab!.localToGlobal(Offset.zero);

                      if (offsetTab.dy < 110.0) {
                        isUpdateAppBar = true;
                        // isUpdatePage = false;
                        // isUpdateTheme = true;
                      } else {
                        isUpdateAppBar = false;
                        // isUpdatePage = true;
                        // isUpdateTheme = false;
                      }
                      setState(() {});

                      return true;
                    },
                    child: CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          // color: Colors.amber,
                          height: _screenUtil.statusBarHeight + 40,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: userInfoWidget(),
                      ),
                      SliverToBoxAdapter(
                        child: classPayWidget(),
                      ),
                      SliverToBoxAdapter(
                        child: LoadImage(
                          listData.data[idx].detail.teacherImg,
                        ),
                      ),
                      headWidget("用户评价"),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 100.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listData
                                .data[idx].detail.userFeedbackImg.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 150.0,
                                child: Card(
                                  // color: Colors.primaries[index],
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
                      listData.data[idx].type == 1
                          ? otherHeadWidget("people_head")
                          : SliverToBoxAdapter(child: Container()),
                      listData.data[idx].type == 1
                          ? otherHeadWidget("quanyi_hrad")
                          : SliverToBoxAdapter(child: Container()),
                      listData.data[idx].type == 1
                          ? headWidget("常见问题")
                          : SliverToBoxAdapter(child: Container()),
                      listData.data[idx].type == 1
                          ? problemWidget()
                          : SliverToBoxAdapter(
                              child: Container(),
                            )
                    ]),
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
                              "L1英语口语系统课",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ))
                      : Positioned(
                          top: 50,
                          left: 20,
                          child: GestureDetector(
                              onTap: () {
                                NavigatorUtils.goBack(context);
                              },
                              child: const LoadAssetImage(
                                "ic_back_icon",
                                width: 20.0,
                                height: 20.0,
                              ))),
                ]),
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

  @override
  void paySuccess() {
    // TODO: implement paySuccess
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();
    EventBus().emit(NotificationUtils.loginIn);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off(NotificationUtils.loginIn);
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

// class MarqueeText extends StatefulWidget {
//   final String text;
//   final TextStyle style;
//   final Duration duration;

//   const MarqueeText(
//       {super.key,
//       required this.text,
//       required this.style,
//       required this.duration});

//   @override
//   _MarqueeTextState createState() => _MarqueeTextState();
// }

// class _MarqueeTextState extends State<MarqueeText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(duration: widget.duration, vsync: this);
//     animation = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
//       parent: controller,
//       curve: Curves.linear,
//     ))
//       ..addListener(() => setState(() {}));
//     controller.forward();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final textPainter = TextPainter(
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.text = TextSpan(text: widget.text, style: widget.style);
//         textPainter.layout(maxWidth: constraints.biggest.width);

//         return AnimatedBuilder(
//           animation: animation,
//           builder: (context, child) {
//             double dx = -textPainter.width * animation.value;
//             return Transform.translate(
//               offset: Offset(dx, 0.0),
//               child: child,
//             );
//           },
//           child: Text(widget.text, style: widget.style),
//         );
//       },
//     );
//   }
// }

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
    return _scrollView ?? Column();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
