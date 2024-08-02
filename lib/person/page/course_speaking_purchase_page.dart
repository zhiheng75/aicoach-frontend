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
import 'package:Bubble/person/entity/goods_v_bean.dart';
import 'package:Bubble/person/entity/member_state_bean.dart';
import 'package:Bubble/person/presneter/course_speaking_purchase_presnter.dart';
import 'package:Bubble/person/presneter/user_membership_upgrade_page_presenter.dart';
import 'package:Bubble/person/view/course_speaking_purchase_view.dart';
import 'package:Bubble/person/view/user_membership_upgrade_page_view.dart';
import 'package:Bubble/person/widget/course_detail_Item.dart';
import 'package:Bubble/person/widget/new_course_speaking_item.dart';
import 'package:Bubble/person/widget/user_membership_upgrade_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/douyin_util.dart';
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

class CourseSpeakingPurchasePage extends StatefulWidget {
  const CourseSpeakingPurchasePage({super.key});

  @override
  State<CourseSpeakingPurchasePage> createState() =>
      _CourseSpeakingPurchasePageState();
}

class _CourseSpeakingPurchasePageState extends State<CourseSpeakingPurchasePage>
    with
        BasePageMixin<CourseSpeakingPurchasePage,
            CourseSpeakingPurchasePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CourseSpeakingPurchasePage>
    implements
        CourseSpeakingPurchaseView {
  RenderBox? boxTab;
  late Offset offsetTab;
  GlobalKey keyTab = GlobalKey(debugLabel: "university");
  bool isUpdateAppBar = false;
  late CourseSpeakingPurchasePresenter _courseSpeakingPurchasePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();

  // late LessonDetailBean dataBean;
  bool isLoding = true;
  late String headimgurl = "";
  late String userName = "";
  // late String userVIP = "";

  late GoodsVBean listData;
  late int typeIdx = 0;

  late int spokenIdx = 0;
  late int classIdx = 0;

  late int payIdx = 0;

  String _pay = 'wxpay';

  Fluwx fluwx = Fluwx();
  late String? accessToken;
  final ScrollController _scrollController = ScrollController();

  List<Color> colorBackData = [
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
  ];

  List<List<Color>> colorIconBackData = [
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
  ];

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

    EventUMStatistics.umengCommonOnPageStart("course_speaking_purchase_page");
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
    int _goodsId;
    String _goodPrice;

    if (typeIdx == 0) {
      _goodsId = listData.data.packageList.list[spokenIdx].id;
      _goodPrice = listData.data.packageList.list[spokenIdx].price;
    } else {
      _goodsId = listData.data.lessonList.list[classIdx].id;
      _goodPrice = listData.data.lessonList.list[classIdx].price;
    }

    if (_pay == 'wxpay') {
      _courseSpeakingPurchasePresenter.wxChatPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'alipay') {
      _courseSpeakingPurchasePresenter.aliPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'applepay') {
      _courseSpeakingPurchasePresenter.applePay(_goodsId);
    }
  }

  Widget userInfoWidget() {
    return Column(
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
                const Text(
                  "时间",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget classPayWidget() {
    return Container(
      key: keyTab,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ImageUtils.getAssetImage(
                  typeIdx == 0 ? "spoken_pay_bg" : "course_pay_bg"),
              fit: BoxFit.fitWidth)),
      height: 330.h,
      // height: 100,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15),
      //     gradient: const LinearGradient(
      //       colors: [
      //         Colours.color_FAF7FF,
      //         Colours.color_F3EEFE,
      //       ],
      //     )),
      margin: EdgeInsets.only(top: 8.w),
      // padding: const EdgeInsets.only(left: 4, right: 2, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      typeIdx = 0;
                    });
                    // EventUMStatistics.umengCommonMapEvent(
                    //     "click_index_go_to_personal_buy");
                  },
                  child: Container(
                    height: 40.h,
                    color: Colours.color_0000,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      typeIdx = 1;
                    });
                    // EventUMStatistics.umengCommonMapEvent(
                    //     "click_index_go_to_personal_buy");
                  },
                  child: Container(
                    height: 40.h,
                    color: Colours.color_0000,
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          SizedBox(
            // margin: const EdgeInsets.only(top: 10),
            height: 150.w,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: listData.data.packageList.list.length,
              itemBuilder: (context, index) {
                return typeIdx == 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            spokenIdx = index;
                          });
                          EventUMStatistics.umengCommonMapEvent(
                              "click_index_go_to_personal_buy");
                        },
                        child: NewCourseSpeakingItem(
                          isSele: spokenIdx == index ? true : false,
                          data: listData.data.packageList.list[index],
                        ),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            classIdx = index;
                          });
                          EventUMStatistics.umengCommonMapEvent(
                              "click_index_go_to_personal_buy");
                        },
                        child: NewCourseSpeakingTwoItem(
                          isSele: classIdx == index ? true : false,
                          data: listData.data.lessonList.list[index],
                        ),
                      );
              },
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

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget headWidget(String headStr) {
    return SliverToBoxAdapter(
      child: typeIdx == 0
          ? Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Text(
                headStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          : Container(),
    );
  }

  Widget detailWidget() {
    return SliverToBoxAdapter(
      child: Column(
        children:
            typeIdx == 0 ? _buildDetailItems() : _buildCourseDetailItems(),
      ),
    );
  }

  List<Widget> _buildDetailItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < listData.data.packageList.list[spokenIdx].detail.detailImg.length;
        i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 20, left: 9, right: 9),
        child: LoadImage(
          width: _screenUtil.screenWidth,
          listData.data.packageList.list[spokenIdx].detail.detailImg[i],
        ),
      ));
    }
    return list;
  }

  List<Widget> _buildCourseDetailItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < listData.data.lessonList.list[classIdx].detail.detailImg.length;
        i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 20, left: 9, right: 9),
        child: LoadImage(
          width: _screenUtil.screenWidth,
          listData.data.lessonList.list[classIdx].detail.detailImg[i],
        ),
      ));
    }
    return list;
  }

  // Widget _buildCourseWidget() {
  //   return Column(
  //       // children: _buildCourseWidgetItems(),
  //       );
  // }

  Widget _headTitle(String title) {
    return Container(
      height: 45,
      width: _screenUtil.screenWidth,
      color: const Color(0xFFFFFFFF),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 15,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(List<LessonListClass> list, String tit,
      Color backColor, List<Color> iconBackColor) {
    return Column(
      children: [
        _headTitle(tit),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildItems(list, backColor, iconBackColor),
        )
      ],
    );
  }

  List<Widget> _buildItems(List<LessonListClass> xxlist, Color backColor,
      List<Color> iconBackColor) {
    List<Widget> list = [];
    for (int i = 0; i < xxlist.length; i++) {
      list.add(CourseDetaiItem(
        unitData: xxlist[i],
        backColor: backColor,
        iconBackColor: iconBackColor,
      ));
    }
    return list;
  }

  // List<Widget> _buildCourseWidgetItems() {
  //   List<Widget> list = [];
  //   for (int i = 0;
  //       i < listData.data.lessonList.list[classIdx].lessons.length;
  //       i++) {
  //     list.add(Container(
  //       margin: const EdgeInsets.only(top: 20, left: 9, right: 9),
  //       child: LoadImage(
  //         width: _screenUtil.screenWidth,
  //         listData.data.lessonList.list[classIdx].detail.detailImg[i],
  //       ),
  //     ));
  //   }
  //   return list;
  // }

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
                          child: typeIdx == 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 10.h, left: 9.w, right: 9.w),
                                  child: LoadImage(
                                    listData.data.packageList.list[spokenIdx]
                                        .detail.teacherImg,
                                  ),
                                )
                              : Container(),
                        ),
                        headWidget("用户评价"),
                        SliverToBoxAdapter(
                          child: typeIdx == 0
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 9),
                                  height: 166.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listData
                                        .data
                                        .packageList
                                        .list[spokenIdx]
                                        .detail
                                        .userFeedbackImg
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10.w),
                                        child: SizedBox(
                                          width: 238.0,
                                          child: LoadImage(
                                            listData
                                                .data
                                                .packageList
                                                .list[spokenIdx]
                                                .detail
                                                .userFeedbackImg[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                        ),
                        detailWidget(),
                        typeIdx == 0
                            ? SliverToBoxAdapter(
                                child: Container(),
                              )
                            : SliverList.builder(
                                itemBuilder: (ctx, index) {
                                  LessonList lessonList =
                                      listData.data.lessonList;
                                  List<LessonListList> list = lessonList.list;
                                  List<Lesson> lessons = list[classIdx].lessons;
                                  return _buildStickyHeader(
                                      lessons[index].list,
                                      lessons[index].unitName,
                                      colorBackData[index],
                                      colorIconBackData[index]);
                                },
                                itemCount: listData.data.lessonList
                                    .list[classIdx].lessons.length,
                              ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 80,
                          ),
                        )
                      ]),
                    ),
                    // isUpdateAppBar
                    //     ? Positioned(
                    //         top: 0, left: 0, right: 0, child: Container())
                    //     : const Positioned(
                    //         top: 60,
                    //         left: 12,
                    //         right: 12,
                    //         // height: 80,
                    //         child: Center(
                    //           child: Text(
                    //             "升级会员",
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //       ),
                    // isUpdateAppBar
                    //     ? const Positioned(
                    //         top: 0,
                    //         left: 0,
                    //         right: 0,
                    //         child: XTCupertinoNavigationBar(
                    //           backgroundColor: Color(0xFFFFFFFF),
                    //           border: null,
                    //           padding: EdgeInsetsDirectional.zero,
                    //           leading: NavigationBackWidget(),
                    //           middle: Text(
                    //             "",
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           ),
                    //         ))
                    //     : Positioned(
                    //         top: 60,
                    //         left: 12,
                    //         child: GestureDetector(
                    //             onTap: () {
                    //               NavigatorUtils.goBack(context);
                    //             },
                    //             child: const LoadAssetImage(
                    //               "ic_back_icon",
                    //               width: 20.0,
                    //               height: 20.0,
                    //             )),
                    //       ),
                  ]),
                ),
        ),
      ),
    );
  }

  @override
  CourseSpeakingPurchasePresenter createPresenter() {
    // TODO: implement createPresenter
    _courseSpeakingPurchasePresenter = CourseSpeakingPurchasePresenter();
    return _courseSpeakingPurchasePresenter;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void paySuccess() {
    // TODO: implement paySuccess
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(GoodsVBean goodsBean) {
    // TODO: implement sendSuccess
    isLoding = false;
    listData = goodsBean;
    setState(() {});
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
