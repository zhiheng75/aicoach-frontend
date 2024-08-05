//课程订单
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/order_list_bean.dart';
import 'package:Bubble/person/item/course_order_item.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/person/presneter/course_order_presenter.dart';
import 'package:Bubble/person/view/course_order_view.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseOrderPage extends StatefulWidget {
  const CourseOrderPage({super.key});

  @override
  State<CourseOrderPage> createState() => _CourseOrderPageState();
}

class _CourseOrderPageState extends State<CourseOrderPage>
    with
        BasePageMixin<CourseOrderPage, CourseOrderPresenter>,
        AutomaticKeepAliveClientMixin<CourseOrderPage>
    implements CourseOrderView {
  late CourseOrderPresenter _courseOrderPresenter;

  late List<Datum> dataList = [];

  late String phone = "";
  bool isLoding = true;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> user = LoginManager.getUserInfo();
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }
    EventUMStatistics.umengCommonOnPageStart("course_order_page");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventUMStatistics.umengCommonOnPageEnd("course_order_page");
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

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 250.0,
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadAssetImage(
                'no_data',
                width: 63.0,
                height: 63.0,
              ),
              Text(
                '您还没有购买记录',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_999999,
                  height: 20.0 / 15.0,
                  letterSpacing: 0.05,
                ),
              ),
              Text(
                '现在开始升级体验吧！',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_999999,
                  height: 20.0 / 15.0,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
          phone == "17001234567"
              ? Container()
              : const Expanded(child: Gaps.empty),
          phone == "17001234567"
              ? Container()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (phone == "17001234567") {
                      NavigatorUtils.push(context, PersonalRouter.purchase);
                    } else {
                      NavigatorUtils.push(context,
                          "${PersonalRouter.courseSpeakingPurchasePage}?levelId=0&goodsLabel=0");
                    }
                  },
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    // height: ,
                    // height: Dimens.h_dp40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ImageUtils.getAssetImage("btn_bg_img"),
                            fit: BoxFit.fill)),
                    child: Center(
                      child: Text(
                        "升级会员",
                        style: TextStyle(
                            color: Colours.color_001652,
                            fontSize: Dimens.font_sp18),
                      ),
                    ),
                  )),
          const SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程订单",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: isLoding
                  ? lodingView()
                  : dataList.isEmpty
                      ? emptyWidget()
                      : CustomScrollView(
                          slivers: [
                            SliverList.builder(
                              itemBuilder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: CourseOrderItem(
                                    datum: dataList[index],
                                  ),
                                );
                              },
                              itemCount: dataList.length,
                            )
                          ],
                        ))),
    );
  }

  @override
  CourseOrderPresenter createPresenter() {
    _courseOrderPresenter = CourseOrderPresenter();
    return _courseOrderPresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void sendSuccess(OrderListBean msg) {
    // TODO: implement sendSuccess
    setState(() {
      dataList.addAll(msg.data);
      isLoding = false;
    });
  }
}
