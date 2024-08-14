import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/get_pay_code_bean.dart';
import 'package:Bubble/person/entity/query_order_bean.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/person/presneter/xueersi_purchase_page_presenter.dart';
import 'package:Bubble/person/view/xueersi_purchase_page_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class XueersiPurchasePage extends StatefulWidget {
  final String goodPrice;
  final String goodsId;
  final String type;

  const XueersiPurchasePage({
    super.key,
    required this.goodPrice,
    required this.goodsId,
    required this.type,
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
  late String orderNo = "";
  late String payS = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xueersiPurchasePagePresenter.getPayCode(widget.goodsId);
    // 创建一个每隔三分钟（180000毫秒）触发一次的定时器
    Timer.periodic(const Duration(minutes: 3), (timer) {
      _xueersiPurchasePagePresenter.getPayCode(widget.goodsId);
    });
    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!isLoding) {
        _xueersiPurchasePagePresenter.getQueryOrder(orderNo);
      }
    });
  }

  void creatQueryOrder() {}

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
                              child: Stack(
                                children: [
                                  Base64Image(data.data.img),
                                  payS == "0"
                                      ? Container()
                                      : Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 0,
                                          bottom: 0,

                                          /// 必须clip，否则会对整个区域模糊。
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaY: 5, sigmaX: 5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                color:
                                                    Colors.black.withOpacity(0),
                                                child: Text('支付中'),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
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
    orderNo = getPayCodeBean.data.orderNo;
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

  @override
  void sendQueryOrderSuccess(String status) {
    // TODO: implement sendQueryOrderSuccess
    if (status == "SUCCESS") {
      if (widget.type == "1") {
        //支付成功
        NavigatorUtils.push(
            // ignore: use_build_context_synchronously
            context,
            replace: true,
            PersonalRouter.xueersiPurchaseSuccessPage);
      } else {
        NavigatorUtils.push(
            // ignore: use_build_context_synchronously
            context,
            replace: true,
            PersonalRouter.xueersiPurchaseSuccessTwoPage);

        // NavigatorUtils.goBack(context);
      }
      Provider.of<HomeProvider>(context, listen: false).getUsageTime();
      EventBus().emit(NotificationUtils.resetInFo);
    } else if (status == "Failed") {
      //支付中
      payS = "1";
      setState(() {});
    }
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
