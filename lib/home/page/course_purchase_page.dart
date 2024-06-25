//课程购买

import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/home/entity/lesson_detail_bean.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/presenter/course_purchase_page_presenter.dart';
import 'package:Bubble/home/view/course_purchase_page_view.dart';
import 'package:Bubble/home/widget/course_equity_item.dart';
import 'package:Bubble/home/widget/people_item.dart';
import 'package:Bubble/home/widget/problem_item.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';

class CoursePurchasePage extends StatefulWidget {
  final String levelId;
  const CoursePurchasePage({super.key, required this.levelId});

  @override
  State<CoursePurchasePage> createState() => _CoursePurchasePageState();
}

class _CoursePurchasePageState extends State<CoursePurchasePage>
    with
        BasePageMixin<CoursePurchasePage, CoursePurchasePagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CoursePurchasePage>
    implements CoursePurchasePageView {
  RenderBox? boxTab;
  late Offset offsetTab;
  GlobalKey keyTab = GlobalKey(debugLabel: "university");
  bool isUpdateAppBar = false;
  bool _checked = false;
  final ScreenUtil _screenUtil = ScreenUtil();
  late CoursePurchasePagePresenter _coursePurchasePagePresenter;

  late LessonDetailBean dataBean;
  bool isLoding = true;
  late String phone = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _coursePurchasePagePresenter.getLessonDetail(widget.levelId);
    Map<String, dynamic> user = LoginManager.getUserInfo();

    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }
    EventUMStatistics.umengCommonOnPageStart("course_purchase_page");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventUMStatistics.umengCommonOnPageEnd("course_purchase_page");
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

  Widget classImgWidget(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: LoadImage(dataBean.data.banner, fit: BoxFit.fill
              // width: 56.0,
              // height: 56.0,
              ),
        ));
  }

  Widget aiTeacherWidget() {
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
                    Colours.color_E8CCFE,
                    Colours.color_ACCDFF,
                  ],
                )),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 100,
                      width: 150,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "嗨，我是Andy老师， 由我来陪伴你英语学习!",
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
                              "Andy老师",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )),
                  ],
                ),
              ],
            )),
        const Positioned(
            left: 5,
            bottom: 10,
            child: LoadAssetImage(
              "suofeiya_head",
              width: 170.0,
              height: 150.0,
            ))
      ],
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

  Widget classDetaileWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataBean.data.levelName,
                  key: keyTab,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Gaps.vGap4,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colours.color_FFD076,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      child: const Text(
                        "附赠",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Gaps.hGap6,
                    Text(
                      dataBean.data.tips,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Gaps.vGap4,
                Row(
                  children: [
                    const Text(
                      "￥",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_542DEC,
                      ),
                    ),
                    Text(
                      "${dataBean.data.price}",
                      style: const TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colours.color_542DEC,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          LoadImage(
            dataBean.data.teacherImg,
            width: _screenUtil.screenWidth,
          ),
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

  Widget otherHeadWidget(String headStr) {
    return SliverToBoxAdapter(
      child: LoadAssetImage(
        headStr,
        // width: 170.0,
        // height: 150.0,
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < dataBean.data.questions.length; i++) {
      list.add(ProblemItem(
        questions: dataBean.data.questions[i],
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
    for (int i = 0; i < dataBean.data.detailImg.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 20, left: 9, right: 9),
        child: LoadImage(
          dataBean.data.detailImg[i],
          width: _screenUtil.screenWidth,
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
                          image:
                              ImageUtils.getAssetImage("purchase_one_bg_img"),
                          fit: BoxFit.fill)),
                  child: Stack(children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        boxTab ??= keyTab.currentContext!.findRenderObject()
                            as RenderBox?;
                        offsetTab = boxTab!.localToGlobal(Offset.zero);

                        if (offsetTab.dy < 290.0) {
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
                            height: _screenUtil.statusBarHeight + 45,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: classImgWidget(context),
                        ),
                        SliverToBoxAdapter(
                          child: classDetaileWidget(context),
                        ),
                        headWidget("用户评价"),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 9),
                            height: 166.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: dataBean.data.userFeedbackImg.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width: 238.0,
                                    child: LoadImage(
                                      dataBean.data.userFeedbackImg[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // SliverToBoxAdapter(
                        //   child: Container(
                        //     margin: const EdgeInsets.only(top: 10),
                        //     height: 100.0,
                        //     child: ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: dataBean.data.userFeedbackImg.length,
                        //       itemBuilder: (context, index) {
                        //         return SizedBox(
                        //           width: 150.0,
                        //           child: Card(
                        //             // color: Colors.primaries[index],
                        //             child: LoadImage(
                        //               dataBean.data.userFeedbackImg[index],
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // otherHeadWidget("class_head"),
                        detailWidget(),
                        // otherHeadWidget("people_head"),
                        // otherHeadWidget("quanyi_hrad"),

                        // SliverGrid.builder(
                        //     itemCount: 6,
                        //     gridDelegate:
                        //         const SliverGridDelegateWithFixedCrossAxisCount(
                        //       //设置列数
                        //       crossAxisCount: 3,
                        //       //设置横向间距
                        //       crossAxisSpacing: 0,
                        //       //设置主轴间距
                        //       mainAxisSpacing: 0,
                        //       // mainAxisExtent: 173,
                        //     ),
                        //     itemBuilder: (BuildContext ctx, int index) {
                        //       return PeopleItem(
                        //         idx: index,
                        //       );
                        //     }),
                        // headWidget("权益"),
                        // SliverList.builder(
                        //   itemBuilder: (ctx, index) {
                        //     return GestureDetector(
                        //       onTap: () {},
                        //       child: CourseEquityItem(
                        //         idx: index,
                        //       ),
                        //     );
                        //   },
                        //   itemCount: 5,
                        // ),
                        SliverToBoxAdapter(
                          child: dataBean.data.questions.isEmpty
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      top: 40, bottom: 14),
                                  // height: 80,
                                  child: const LoadAssetImage(
                                    'wenti_bg',
                                  ),
                                ),
                        ),
                        problemWidget(),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Gaps.vGap80,
                              SizedBox(
                                height: _screenUtil.bottomBarHeight,
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    isUpdateAppBar
                        ? Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: XTCupertinoNavigationBar(
                              backgroundColor: const Color(0xFFFFFFFF),
                              border: null,
                              padding: EdgeInsetsDirectional.zero,
                              leading: const NavigationBackWidget(),
                              middle: Text(
                                dataBean.data.levelName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : Positioned(
                            top: 60,
                            left: 13,
                            child: GestureDetector(
                                onTap: () {
                                  NavigatorUtils.goBack(context);
                                },
                                child: const LoadAssetImage(
                                  "ic_back_icon",
                                  width: 20.0,
                                  height: 20.0,
                                ))),
                    Positioned(
                        bottom: 0,
                        // width: _screenUtil.screenWidth,
                        child: Container(
                          color: Colours.color_F9F8FF,
                          width: _screenUtil.screenWidth,
                          child: Column(
                            children: [
                              Gaps.vGap10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      EventUMStatistics.umengCommonMapEvent(
                                          "click_index_regular_price_class_consultation");
                                      if (phone == "17001234567") {
                                        NavigatorUtils.push(
                                            context, PersonalRouter.about);
                                      } else {
                                        Fluwx fluwx = Fluwx();
                                        fluwx.registerApi(
                                            appId: "wxfb033d09d2eecaf0",
                                            universalLink:
                                                "https://demo.shenmo-ai.net/ios/");
                                        // // MiniProgram
                                        fluwx.open(
                                            target: CustomerServiceChat(
                                                corpId: "wwd0c44d64eb7bcab7",
                                                url:
                                                    "https://work.weixin.qq.com/kfid/kfc17bc7445bac300b9"));
                                      }
                                    },
                                    child: Container(
                                      // color: Colors.amber,
                                      // width: 100,
                                      child: const LoadAssetImage(
                                        "zixun_icon",
                                        width: 25.0,
                                        height: 41.0,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        if (_checked) {
                                          if (phone == "17001234567") {
                                            NavigatorUtils.push(
                                                context,
                                                CourseRouter
                                                    .certifiedLearningPage,
                                                arguments: dataBean);
                                          } else {
                                            NavigatorUtils.push(context,
                                                HomeRouter.coursePaysPage,
                                                arguments: dataBean);
                                          }
                                        } else {
                                          Toast.show("请同意会员协议");
                                        }
                                      },
                                      child: Container(
                                        // color: Colors.black,
                                        child: LoadAssetImage(
                                          phone == "17001234567"
                                              ? "course_purchase_two"
                                              : "course_purchase_one",
                                          width: 290.0,
                                          // height: 52.0,
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _checked = !_checked;
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(10),
                                      child: LoadAssetImage(
                                        _checked ? 'yigouxuan' : 'weigouxuan',
                                        width: 15.0,
                                        height: 15.0,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 8.0,
                                  // ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '我已阅读并同意',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '会员协议',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF0047FF),
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              NavigatorUtils.goWebViewPage(
                                                  context,
                                                  "会员协议",
                                                  "http://www.shenmo-ai.com/tos/");
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _screenUtil.bottomBarHeight - 10,
                              ),
                            ],
                          ),
                        )),
                  ]),
                ),
        ),
      ),
    );
  }

  @override
  CoursePurchasePagePresenter createPresenter() {
    // TODO: implement createPresenter
    _coursePurchasePagePresenter = CoursePurchasePagePresenter();
    return _coursePurchasePagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(LessonDetailBean data) {
    // TODO: implement sendSuccess
    setState(() {
      isLoding = false;
      dataBean = data;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
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
