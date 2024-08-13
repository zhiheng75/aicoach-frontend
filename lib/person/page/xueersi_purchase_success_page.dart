import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/bind_teacher_bean.dart';
import 'package:Bubble/person/presneter/xueersi_purchase_success_page_presnter.dart';
import 'package:Bubble/person/view/xueersi_purchase_success_page_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XueersiPurchaseSuccessPage extends StatefulWidget {
  const XueersiPurchaseSuccessPage({super.key});

  @override
  State<XueersiPurchaseSuccessPage> createState() =>
      _XueersiPurchaseSuccessPageState();
}

class _XueersiPurchaseSuccessPageState extends State<XueersiPurchaseSuccessPage>
    with
        BasePageMixin<XueersiPurchaseSuccessPage,
            XueersiPurchaseSuccessPagePresenter>,
        WidgetsBindingObserver,
        RouteAware,
        AutomaticKeepAliveClientMixin<XueersiPurchaseSuccessPage>
    implements
        XueersiPurchaseSuccessPageView {
  final ScreenUtil _screenUtil = ScreenUtil();
  late XueersiPurchaseSuccessPagePresenter _xueersiPurchaseSuccessPagePresenter;
  late BindTeacherBean data;

  bool isLoding = true;

  Widget bg() {
    return Container(
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
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: isLoding
          ? lodingView()
          : Stack(
              children: <Widget>[
                bg(),
                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadAssetImage(
                            'xueersi_success_icon',
                            width: 42.0.w,
                            height: 42.0.w,
                          ),
                          Text(
                            "支付成功",
                            style: TextStyle(
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap30,
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 22.h,
                                bottom: 18.h,
                                right: 15.w,
                                left: 15.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0.r),
                              color: Colors.white,
                            ),
                            // width: 310.w,
                            // height: 370.h,
                            child: Column(
                              children: [
                                const LoadAssetImage(
                                  'tianjia_img',
                                ),
                                Gaps.vGap24,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: LoadImage(
                                        data.data.teacherAvatar,
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Gaps.hGap10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.data.teacherName,
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          data.data.teacherDesc,
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Gaps.vGap9,
                                LoadImage(
                                  data.data.teacherQrCode,
                                  width: 190.0.w,
                                  height: 190.0.w,
                                ),
                                Gaps.vGap18,
                                Text(
                                  "扫描二维码添加辅导老师微信",
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 25.h,
                            right: 20.w,
                            child: LoadAssetImage(
                              "jiantou_img",
                              width: 56.w,
                              height: 40.h,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 60.h,
                  left: 12.w,
                  child: GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                        NavigatorUtils.goBack(context);
                      },
                      child: LoadAssetImage(
                        "ic_back_icon",
                        width: 20.0.w,
                        height: 20.0.w,
                      )),
                ),
              ],
            ),
    );
  }

  @override
  XueersiPurchaseSuccessPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _xueersiPurchaseSuccessPagePresenter =
        XueersiPurchaseSuccessPagePresenter();
    return _xueersiPurchaseSuccessPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(BindTeacherBean bindTeacherBean) {
    // TODO: implement sendSuccess
    data = bindTeacherBean;
    isLoding = false;
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
