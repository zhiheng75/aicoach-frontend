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
  const XueersiPurchasePage({super.key});

  @override
  State<XueersiPurchasePage> createState() => _XueersiPurchasePageState();
}

class _XueersiPurchasePageState extends State<XueersiPurchasePage> {
  final ScreenUtil _screenUtil = ScreenUtil();

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
    return Material(
      child: Stack(
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
                      "98",
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
                        color: Colors.red,
                        width: 246,
                        height: 230,
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
}
