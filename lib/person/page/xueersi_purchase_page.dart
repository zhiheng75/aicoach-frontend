import 'dart:convert';

import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/get_pay_code_bean.dart';
import 'package:Bubble/person/presneter/xueersi_purchase_page_presenter.dart';
import 'package:Bubble/person/view/xueersi_purchase_page_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XueersiPurchasePage extends StatefulWidget {
  final String goodPrice;
  final String goodsId;

  const XueersiPurchasePage({
    super.key,
    required this.goodPrice,
    required this.goodsId,
  });

  @override
  State<XueersiPurchasePage> createState() => _XueersiPurchasePageState();
}

class _XueersiPurchasePageState extends State<XueersiPurchasePage>
    with
        BasePageMixin<XueersiPurchasePage, XueersiPurchasePagePresenter>,
        WidgetsBindingObserver,
        RouteAware,
        AutomaticKeepAliveClientMixin<XueersiPurchasePage>
    implements XueersiPurchasePageView {
  final ScreenUtil _screenUtil = ScreenUtil();
  late XueersiPurchasePagePresenter _xueersiPurchasePagePresenter;
  late GetPayCodeBean data;
  bool isLoding = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xueersiPurchasePagePresenter.getPayCode(widget.goodsId);
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

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
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Text(
                        "应付金额",
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "￥",
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.goodPrice,
                            style: TextStyle(
                              fontSize: 40.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 22.h, bottom: 18.h, right: 30.w, left: 30.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0.r),
                          color: Colors.white,
                        ),
                        // width: 310.w,
                        // height: 370.h,
                        child: Column(
                          children: [
                            Text(
                              "请使用微信扫码支付",
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Gaps.vGap18,
                            Container(
                              // color: Colors.red,
                              width: 246,
                              height: 230,
                              child: Base64Image(data.data.img),
                            ),
                            Gaps.vGap30,
                            Row(
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
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
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
              ],
            ),
    );
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(GetPayCodeBean getPayCodeBean) {
    // TODO: implement sendSuccess
    data = getPayCodeBean;
    isLoding = false;

    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  XueersiPurchasePagePresenter createPresenter() {
    // TODO: implement createPresenter
    _xueersiPurchasePagePresenter = XueersiPurchasePagePresenter();
    return _xueersiPurchasePagePresenter;
  }
}

class Base64Image extends StatelessWidget {
  final String base64String;

  Base64Image(this.base64String);

  @override
  Widget build(BuildContext context) {
    // 将Base64字符串解码成Uint8List
    final decodedBytes = base64Decode(base64String);
    return Image.memory(decodedBytes);
  }
}
