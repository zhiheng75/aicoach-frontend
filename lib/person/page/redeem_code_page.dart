import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/redeem_code_bean.dart';
import 'package:Bubble/person/entity/redeem_list_bean.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/person/presneter/redeem_code_page_presnter.dart';
import 'package:Bubble/person/view/redeem_code_view.dart';
import 'package:Bubble/person/widget/success_show_view.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_fail.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedeemCodePage extends StatefulWidget {
  const RedeemCodePage({super.key});

  @override
  State<RedeemCodePage> createState() => _RedeemCodePageState();
}

class _RedeemCodePageState extends State<RedeemCodePage>
    with
        BasePageMixin<RedeemCodePage, RedeemCodePagePresenter>,
        WidgetsBindingObserver,
        RouteAware,
        AutomaticKeepAliveClientMixin<RedeemCodePage>
    implements RedeemCodeView {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  late RedeemListBean redeemListBean;
  // bool isLoding = true;
  late RedeemCodePagePresenter _redeemCodePagePresenter;
  late String pageState = 'loading';

  get goodPrice => null;

  List<Widget> _buildTSItems() {
    List<Widget> list = [];
    for (int i = 0; i < redeemListBean.data.desc.length; i++) {
      list.add(
        Text(redeemListBean.data.desc[i],
            style: TextStyle(
              fontSize: 13.0.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            )),
      );
    }
    return list;
  }

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < redeemListBean.data.list.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
          color: Colours.color_F9F8FF,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 7.w),
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("兑换内容:${redeemListBean.data.list[i].goodsName}",
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    )),
              ],
            ),
            Text("兑换日期:${redeemListBean.data.list[i].redeemedAt}",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                )),
          ],
        ),
      ));
    }
    return list;
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  var lastPopTime = DateTime.now();

  void intervalClick(int needTime) {
    // 防重复提交
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      _redeemCodePagePresenter.postRedeemCode(_phoneController.text);
      lastPopTime = DateTime.now();
      print("允许点击");
    } else {
      // lastPopTime = DateTime.now(); //如果不注释这行,则强制用户一定要间隔2s后才能成功点击. 而不是以上一次点击成功的时间开始计算.
      print("请勿重复点击！");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageState == 'loading') {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: Container(
          color: const Color(0xFFEBEDF0),
          alignment: Alignment.center,
          child: lodingView(),
        ),
      );
    }

    if (pageState == 'fail') {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: Container(
          color: const Color(0xFFEBEDF0),
          alignment: Alignment.center,
          child: LoadFail(
            reload: init,
          ),
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: const NavigationBackWidget(),
        middle: Text(
          "兑换中心",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
      child: Scaffold(
        body: CustomPaint(
          painter: TopOriginPainter(),
          size: Size.infinite,
          child: Container(
            width: double.infinity,
            color: Colours.color_E8E4FF,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const LoadAssetImage(
                          'redeem_code_bg',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                        Gaps.vGap20
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 00,
                      child: Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        width: double.infinity,
                        height: Dimens.h_dp45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimens.h_dp40),
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: MyTextField(
                          key: const Key('phone'),
                          textAlign: TextAlign.center,
                          isDelete: false,
                          autoFocus: true,
                          textMessage: (message) {},
                          txtStyle: TextStyle(
                            fontSize: Dimens.font_sp14,
                            color: Colours.color_001652,
                          ),
                          hintStyle: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: Colours.color_001652),
                          focusNode: _nodeText1,
                          controller: _phoneController,
                          // maxLength: 11,
                          // keyboardType: TextInputType.phone,
                          hintText: "请输入兑换码",
                          underLineColor: Colours.color_00,
                          countDownColor: Colours.color_001652,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Gaps.vGap16,
                    GestureDetector(
                      onTap: () {
                        if (_phoneController.text.isNotEmpty) {
                          intervalClick(1);
                        } else {
                          Toast.show("未输入兑换码，请填写后重试");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: Dimens.h_dp45,
                        decoration: BoxDecoration(
                            // color: Colors.amber,
                            image: DecorationImage(
                                image:
                                    ImageUtils.getAssetImage("redeem_code_btn"),
                                fit: BoxFit.fitHeight)),
                        child: Center(
                          child: Text(
                            '立即兑换',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              // height: 3.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    redeemListBean.data.desc.isEmpty
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(
                                left: 16.w, right: 16.w, top: 20.w),
                            padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: 5.h,
                                bottom: 10.h),
                            decoration: BoxDecoration(
                              color: Colours.color_FFD67F,
                              borderRadius: BorderRadius.circular(10.0),
                              // border: Border.all(
                              //   width: 1.0,
                              //   style: BorderStyle.solid,
                              //   color: Colours.color_001652,
                              // ),
                              // gradient: const LinearGradient(
                              //   begin: Alignment.topRight,
                              //   end: Alignment.bottomLeft,
                              //   colors: [
                              //     Colours.color_F8F3F5,
                              //     Colours.color_8256FF,
                              //     Colours.color_FF5CDB
                              //   ],
                              // ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LoadAssetImage(
                                  "tishi_icon",
                                  width: 24.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("温情提示:",
                                        style: TextStyle(
                                          fontSize: 17.0.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          // height: 3.5,
                                        )),
                                    Column(
                                      children: _buildTSItems(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: redeemListBean.data.list.isEmpty
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin:
                            EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                        padding:
                            EdgeInsets.only(top: 10.h, left: 5.w, right: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Gaps.hGap16,
                                LoadAssetImage(
                                  "ticket_icon",
                                  width: 24.w,
                                ),
                                Text("兑换记录",
                                    style: TextStyle(
                                      fontSize: 17.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      // height: 3.5,
                                    )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              children: _buildItems(),
                            ),
                            Gaps.vGap10
                          ],
                        ),
                      ),
              ),
              SliverToBoxAdapter(
                child: Gaps.vGap35,
              )
            ]),
          ),
        ),
      ),
    );
  }

  showPushDialog(String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SuccessShowView(
            titStr: '兑换失败',
            btnStr: '知道了',
            msgStr: message,
          );
        });
  }

  @override
  RedeemCodePagePresenter createPresenter() {
    // TODO: implement createPresenter
    _redeemCodePagePresenter = RedeemCodePagePresenter();
    return _redeemCodePagePresenter;
  }

  @override
  void sendCodeSuccess(DataCode data) {
    // final xx = goodstype;
    // final xxx = goodsname;
//  NavigatorUtils.push(
//       context,
//       PersonalRouter.redeemCodeFinshPage,
//       arguments:
//     );
    NavigatorUtils.push(context, PersonalRouter.redeemCodeFinshPage,
        arguments: data);

    _redeemCodePagePresenter.getRedeemList();
  }

  void init() {
    pageState = 'loading';
    _redeemCodePagePresenter.getRedeemList();
    setState(() {});
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(RedeemListBean data) {
    // TODO: implement sendSuccess
    redeemListBean = data;
    // isLoding = false;
    pageState = 'success';
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void sendCodeFail(String msg) {
    // TODO: implement sendCodeFail
    showPushDialog(msg);
  }

  @override
  void sendTwoFail(String msg) {
    // TODO: implement sendTwoFail
    pageState = 'fail';
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
