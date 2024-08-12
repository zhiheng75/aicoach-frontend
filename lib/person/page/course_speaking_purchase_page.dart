import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/widget/course_equity_item.dart';
import 'package:Bubble/home/widget/people_item.dart';
import 'package:Bubble/home/widget/problem_item.dart';
import 'package:Bubble/home/widget/problem_two_item.dart';
import 'package:Bubble/home/widget/teacher_show_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/net/proxy_config.dart';
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
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/douyin_util.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

class CourseSpeakingPurchasePage extends StatefulWidget {
  final String levelId;
  final String goodsLabel;
  const CourseSpeakingPurchasePage({
    super.key,
    required this.levelId,
    required this.goodsLabel,
  });

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

  RenderBox? boxTabTwo;
  late Offset offsetTabTwo;
  GlobalKey keyTabOne = GlobalKey(debugLabel: "keyTabOne");
  GlobalKey keyTabTwo = GlobalKey(debugLabel: "keyTabTwo");

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
  late int detailIdx = 0;
  bool _isVip = false;
  late String dataStr = "";

  // late int idx = 0;
  Fluwx fluwx = Fluwx();
  late String? accessToken;
  final ScrollController _scrollController = ScrollController();

  // final ScrollController _packageListScrollController = ScrollController();
  // final ScrollController _lessonListScrollController = ScrollController();

  final ScrollController _bgscrollController = ScrollController();

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
    if (widget.goodsLabel == "0") {
      typeIdx = 0;
    } else {
      typeIdx = 1;
    }
    getVipStatus();
    EventUMStatistics.umengCommonOnPageStart("course_speaking_purchase_page");
  }

  void getVipStatus() async {
    String deviceId = await Device.getDeviceId();
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.permission,
      queryParameters: {
        'device_id': deviceId,
      },
      onSuccess: (result) {
        if (result != null && result.data != null) {
          Map<String, dynamic> data = result.data! as Map<String, dynamic>;
          _isVip = data['is_member'] == 1;
          dataStr = "畅聊卡有效期至${data['membership_expiry_date']}";
          setState(() {});
        }
      },
    );
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

  bool get isIPad {
    return MediaQuery.of(context).size.width > 500;
  }

  Widget classPayWidget() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  ImageUtils.getAssetImage("course_speaking_purchase_top_bg"),
              fit: BoxFit.fill)),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 200.h,
              // color: typeIdx == 0 ? null : Colours.color_D0BBFF,
            ),
          ),
          Column(
            children: [
              Container(
                height: isIPad
                    ? _screenUtil.statusBarHeight + 50.h
                    : _screenUtil.statusBarHeight + 30.h,
              ),
              Row(
                children: [
                  Gaps.hGap16,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0.r),
                    child: LoadImage(
                      headimgurl,
                      width: 50.0.w,
                      height: 50.0.w,
                    ),
                  ),
                  Gaps.hGap6,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _isVip ? dataStr : "暂未开通畅聊卡",
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Gaps.vGap11,
              Container(
                // height: 390.h,
                // width: 390.h,
                decoration: BoxDecoration(
                    // color: Colors.amber,
                    image: DecorationImage(
                        image: ImageUtils.getAssetImage(
                            typeIdx == 0 ? "spoken_pay_bg" : "course_pay_bg"),
                        fit: BoxFit.fill)),

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
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                // 这里是你想要延迟执行的代码
                                if (spokenIdx ==
                                    listData.data.packageList.list.length - 1) {
                                  _scrollToIndex(spokenIdx - 1);
                                } else {
                                  _scrollToIndex(spokenIdx);
                                }
                              });

                              // EventUMStatistics.umengCommonMapEvent(
                              //     "click_index_go_to_personal_buy");
                            },
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              // color: Colours.color_0000,
                              child: LoadAssetImage(
                                typeIdx == 0 ? 'spoken_s_bg' : "spoken_n_bg",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                typeIdx = 1;
                              });
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                // 这里是你想要延迟执行的代码
                                if (classIdx ==
                                    listData.data.lessonList.list.length - 1) {
                                  _scrollToIndex(classIdx - 1);
                                } else {
                                  _scrollToIndex(classIdx);
                                }
                              });

                              // EventUMStatistics.umengCommonMapEvent(
                              //     "click_index_go_to_personal_buy");
                            },
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              child: Container(
                                // height: 40.h,
                                color: Colours.color_0000,
                                child: LoadAssetImage(
                                  typeIdx == 0 ? 'cours_n_bg' : "cours_s_bg",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap15,
                    SizedBox(
                        // margin: const EdgeInsets.only(top: 10),
                        height: 160.w,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: typeIdx == 0
                              ? listData.data.packageList.list.length
                              : listData.data.lessonList.list.length,
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
                                      data:
                                          listData.data.packageList.list[index],
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
                                      data:
                                          listData.data.lessonList.list[index],
                                    ),
                                  );
                          },
                        )),
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
                            width: 122.w,
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
                                LoadAssetImage(
                                  'wxpay_icon',
                                  width: 24.0.w,
                                  height: 24.0.w,
                                ),
                                Gaps.hGap4,
                                Text(
                                  "微信支付",
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
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
                            width: 122.w,
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
                                LoadAssetImage(
                                  'alipay_img',
                                  width: 24.0.w,
                                  height: 24.0.w,
                                ),
                                Gaps.hGap4,
                                Text(
                                  "支付宝",
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
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
                      child: Center(
                          key: keyTabOne,
                          child: LoadAssetImage(
                            'pay_btn_bg',
                            width: 331.0.w,
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
                          style: TextStyle(
                              fontSize: Dimens.font_sp12, color: Colours.black),
                        ),

                        GestureDetector(
                          onTap: () {
                            NavigatorUtils.goWebViewPage(context, "服务协议",
                                "http://www.shenmo-ai.com/tos/");
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
                              fontSize: Dimens.font_sp12,
                              color: Colours.color_546092),
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
                    Gaps.vGap15,
                  ],
                ),
              ),
            ],
          ),
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
              padding: EdgeInsets.only(left: 10.w, top: 20.h),
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
        margin: EdgeInsets.only(top: 20.h, left: 9.w, right: 9.w),
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
        // color: Colors.amber,
        margin: EdgeInsets.only(top: i == 0 ? 0 : 10.h, left: 9.w, right: 9.w),
        child: LoadImage(
          width: _screenUtil.screenWidth,
          listData.data.lessonList.list[classIdx].detail.detailImg[i],
        ),
      ));
    }
    return list;
  }

  Widget _headTitle(String title) {
    return SizedBox(
      height: 45.h,
      width: _screenUtil.screenWidth,
      child: Center(
        child: Column(
          children: [
            Container(
              height: 15.h,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(String typeStr, List<LessonListClass> list,
      String tit, Color backColor, List<Color> iconBackColor) {
    return Container(
      decoration: typeStr == "0"
          ? const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white,
            )
          : typeStr == "2"
              ? const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Colors.white,
                )
              : typeStr == "4"
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    )
                  : const BoxDecoration(
                      color: Colors.white,
                    ),
      margin: EdgeInsets.only(
          bottom: typeStr == "2"
              ? 10.h
              : typeStr == "4"
                  ? 10.h
                  : 0),
      padding: EdgeInsets.only(
          bottom: typeStr == "2"
              ? 10.h
              : typeStr == "4"
                  ? 10.h
                  : 0),
      child: Column(
        children: [
          _headTitle(tit),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildItems(list, backColor, iconBackColor),
          )
        ],
      ),
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

  ///跳转到课程大纲
  _toDaGangInfo() {
    RenderBox renderBox =
        keyTabTwo.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    /// 状态栏高度
    double _statusBarHeight = MediaQuery.of(context).padding.top;

    /// appbar 高度
    double _kLeadingWidth = 55;

    _bgscrollController.animateTo(
        offset.dy +
            _bgscrollController.offset -
            _kLeadingWidth -
            _statusBarHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  //到顶部
  _toTopInfo() {
    // RenderBox renderBox =
    //     keyTabTwo.currentContext!.findRenderObject() as RenderBox;
    // var offset = renderBox.localToGlobal(Offset.zero);

    // /// 状态栏高度
    // double _statusBarHeight = MediaQuery.of(context).padding.top;

    // /// appbar 高度
    // double _kLeadingWidth = 48;

    _bgscrollController!.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
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
                  color: typeIdx == 0
                      ? Colours.color_F6F2FF
                      : Colours.color_D0BBFF,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: ImageUtils.getAssetImage("pay_img_bg"),
                  //         fit: BoxFit.fill)),
                  child: Stack(children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        boxTab ??= keyTabOne.currentContext!.findRenderObject()
                            as RenderBox?;
                        offsetTab = boxTab!.localToGlobal(Offset.zero);
                        // Log.e("++++++++++" + offsetTab.dy.toString());

                        if (offsetTab.dy < 15.0) {
                          isUpdateAppBar = true;
                        } else {
                          isUpdateAppBar = false;
                        }

                        if (typeIdx == 1) {
                          final RenderBox renderBox = keyTabTwo.currentContext!
                              .findRenderObject()! as RenderBox;
                          final Offset offset =
                              renderBox.localToGlobal(Offset.zero);

                          if (offset.dy < 130) {
                            detailIdx = 1;
                          } else {
                            detailIdx = 0;
                          }
                        }

                        setState(() {});

                        return true;
                      },
                      child: CustomScrollView(
                          controller: _bgscrollController,
                          // physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            // SliverToBoxAdapter(
                            //   child: Container(
                            //     // color: Colors.amber,
                            //     height: _screenUtil.statusBarHeight + 50,
                            //   ),
                            // ),
                            // SliverToBoxAdapter(
                            //   child: userInfoWidget(),
                            // ),
                            SliverToBoxAdapter(
                              child: classPayWidget(),
                            ),
                            SliverToBoxAdapter(
                              child: typeIdx == 0
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 10.h, left: 9.w, right: 9.w),
                                      child: LoadImage(
                                        listData.data.packageList
                                            .list[spokenIdx].detail.teacherImg,
                                      ),
                                    )
                                  : Container(),
                            ),
                            headWidget("用户评价"),
                            SliverToBoxAdapter(
                              child: typeIdx == 0
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: 10.h, left: 9.w),
                                      height: 166.0.h,
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
                                            margin:
                                                EdgeInsets.only(right: 10.w),
                                            child: SizedBox(
                                              width: 238.0.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                child: LoadImage(
                                                  listData
                                                      .data
                                                      .packageList
                                                      .list[spokenIdx]
                                                      .detail
                                                      .userFeedbackImg[index],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(),
                            ),
                            detailWidget(),
                            SliverToBoxAdapter(
                              child: typeIdx == 0
                                  ? Container()
                                  : SizedBox(
                                      key: keyTabTwo,
                                      height: 60.h,
                                      child: const LoadAssetImage(
                                        'kechenggdagang_bg',
                                      )),
                            ),
                            typeIdx == 0
                                ? SliverToBoxAdapter(
                                    child: Container(),
                                  )
                                : SliverList.builder(
                                    itemBuilder: (ctx, index) {
                                      LessonList lessonList =
                                          listData.data.lessonList;
                                      List<LessonListList> list =
                                          lessonList.list;
                                      List<Lesson> lessons =
                                          list[classIdx].lessons;
                                      return Container(
                                        // color: Colors.amber,
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 10.w),
                                        child: _buildStickyHeader(
                                            listData
                                                        .data
                                                        .lessonList
                                                        .list[classIdx]
                                                        .lessons
                                                        .length ==
                                                    1
                                                ? "4"
                                                : index == 0
                                                    ? "0"
                                                    : index ==
                                                            listData
                                                                    .data
                                                                    .lessonList
                                                                    .list[
                                                                        classIdx]
                                                                    .lessons
                                                                    .length -
                                                                1
                                                        ? "2"
                                                        : "1",
                                            lessons[index].list,
                                            lessons[index].unitName,
                                            colorBackData[index],
                                            colorIconBackData[index]),
                                      );
                                    },
                                    itemCount: listData.data.lessonList
                                        .list[classIdx].lessons.length,
                                  ),
                            SliverToBoxAdapter(
                              child: Container(
                                height: isUpdateAppBar ? 120.h : 80.h,
                              ),
                            )
                          ]),
                    ),
                    isUpdateAppBar
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            // height: 80,
                            child: Container(
                              height: 80.h,
                              color: Colors.white,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  pay();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 20.h,
                                      bottom: 20.h,
                                      left: 20.w,
                                      right: 20.w),
                                  // width: 250.0,
                                  // height: 48.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    // border: Border.all(
                                    //   width: 1.0,
                                    //   style: BorderStyle.solid,
                                    //   color: Colours.color_001652,
                                    // ),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colours.color_581DFF,
                                        Colours.color_8256FF,
                                        Colours.color_FF5CDB
                                      ],
                                    ),
                                  ),
                                  // alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '¥',
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          // height: 3.5,
                                        ),
                                      ),
                                      Gaps.hGap2,
                                      Text(
                                        typeIdx == 0
                                            ? listData.data.packageList
                                                .list[spokenIdx].price
                                            : listData.data.lessonList
                                                .list[classIdx].price,
                                        style: TextStyle(
                                          fontSize: 18.0.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gaps.hGap26,
                                      Text(
                                        '开通支付',
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          // height: 3.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Positioned(
                            top: 0, left: 0, right: 0, child: Container()),
                    isUpdateAppBar
                        ? typeIdx == 1
                            ? Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: typeIdx == 1 ? 100.h : 80.h,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: ImageUtils.getAssetImage(
                                                "xiding_bg"),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                              .padding
                                              .top,
                                        ),
                                        // Gaps.vGap30,
                                        Row(
                                          children: [
                                            Gaps.hGap10,
                                            GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  NavigatorUtils.goBack(
                                                      context);
                                                },
                                                child: LoadAssetImage(
                                                  "ic_back_icon",
                                                  width: 20.0.w,
                                                  height: 20.0.w,
                                                )),
                                          ],
                                        ),
                                        typeIdx == 1
                                            ? Column(
                                                children: [
                                                  Gaps.vGap10,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          _toTopInfo();
                                                        },
                                                        child: Text(
                                                          "课程内容",
                                                          style: TextStyle(
                                                            fontSize: 15.0.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: detailIdx ==
                                                                    0
                                                                ? Colors.black
                                                                : Colours
                                                                    .color_757575,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          _toDaGangInfo();
                                                        },
                                                        child: Text(
                                                          "课程大纲",
                                                          style: TextStyle(
                                                            fontSize: 15.0.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: detailIdx ==
                                                                    1
                                                                ? Colors.black
                                                                : Colours
                                                                    .color_757575,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    )))
                            : Positioned(
                                top: 60,
                                left: 12,
                                child: GestureDetector(
                                    onTap: () {
                                      NavigatorUtils.goBack(context);
                                    },
                                    child: LoadAssetImage(
                                      "ic_back_icon",
                                      width: 20.0.w,
                                      height: 20.0.w,
                                    )),
                              )
                        : Positioned(
                            top: 60,
                            left: 12,
                            child: GestureDetector(
                                onTap: () {
                                  NavigatorUtils.goBack(context);
                                },
                                child: LoadAssetImage(
                                  "ic_back_icon",
                                  width: 20.0.w,
                                  height: 20.0.w,
                                )),
                          ),
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

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TeacherShowView(
            () {
              //确定
              // String accessToken = SpUtil.getString(Constant.accessToken) ?? "";
              // String url =
              //     "pages/mine/add-weChat/add-weChat?user_token=$accessToken";
              // var encoded = Uri.encodeComponent(url);
              String accessToken = SpUtil.getString(Constant.accessToken) ?? "";
              var encoded = Uri.encodeComponent(accessToken);
              String url =
                  "pages/mine/add-weChat/add-weChat?user_token=$encoded";
              fluwx.open(
                  target: MiniProgram(
                      username: "gh_dcd9c62ba779",
                      path: url,
                      miniProgramType: ProxyConfig.isOfficialAddress
                          ? WXMiniProgramType.release
                          : WXMiniProgramType.test));
              EventUMStatistics.umengCommonMapEvent(
                  "click_index_go_to_add_a_tutor");
            },
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void paySuccess() {
    // TODO: implement paySuccess

    getVipStatus();
    if (typeIdx == 1) {
      showImageDialog();
    }

    Provider.of<HomeProvider>(context, listen: false).getUsageTime();
    EventBus().emit(NotificationUtils.resetInFo);

    DYUtil().evaluate("2");
  }

  void _scrollToIndex(int index) {
    // 滚动到指定位置
    // _scrollController.
    _scrollController.animateTo(
      index * 160.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent *
    //       (index / listData.data.length),
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  // void _scrollToTwoIndex(int index) {
  //   // 滚动到指定位置
  //   // _scrollController.
  //   _lessonListScrollController.animateTo(
  //     index * 160.w,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  //   // _scrollController.animateTo(
  //   //   _scrollController.position.maxScrollExtent *
  //   //       (index / listData.data.length),
  //   //   duration: const Duration(milliseconds: 300),
  //   //   curve: Curves.easeOut,
  //   // );
  // }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(GoodsVBean goodsBean) {
    // TODO: implement sendSuccess
    isLoding = false;
    listData = goodsBean;

    if (widget.goodsLabel == "0") {
      for (int i = 0; i < listData.data.packageList.list.length; i++) {
        PackageListList data = listData.data.packageList.list[i];
        if (data.isSelected == 1) {
          spokenIdx = i;
        }
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        // 这里是你想要延迟执行的代码
        _scrollToIndex(spokenIdx);
      });
    } else {
      for (int i = 0; i < listData.data.lessonList.list.length; i++) {
        LessonListList data = listData.data.lessonList.list[i];
        if (data.levelId.toString() == widget.levelId) {
          classIdx = i;
        }
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        // 这里是你想要延迟执行的代码
        _scrollToIndex(classIdx);
      });
    }

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
