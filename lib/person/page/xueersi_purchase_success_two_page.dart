import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XueersiPurchaseSuccessTwoPage extends StatefulWidget {
  const XueersiPurchaseSuccessTwoPage({super.key});

  @override
  State<XueersiPurchaseSuccessTwoPage> createState() =>
      _XueersiPurchaseSuccessTwoPageState();
}

class _XueersiPurchaseSuccessTwoPageState
    extends State<XueersiPurchaseSuccessTwoPage> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EventUMStatistics.umengCommonOnPageStart(
        "xueersi_purchase_success_two_page");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventUMStatistics.umengCommonOnPageEnd("xueersi_purchase_success_two_page");
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
    return Material(
      child: Stack(
        children: <Widget>[
          bg(),
          Positioned(
            top: 200.h,
            left: 20,
            right: 20,
            child: Center(
              child: Column(
                children: [
                  LoadAssetImage(
                    'xueersi_success_icon',
                    width: 42.0.w,
                    height: 42.0.w,
                  ),
                  Gaps.vGap10,
                  Text(
                    "支付成功",
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Gaps.vGap70,
                  GestureDetector(
                    onTap: () {
                      NavigatorUtils.goBack(context);
                    },
                    child: Container(
                      width: 210,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colours.color_8003FD,
                      ),
                      child: Center(
                        child: Text(
                          "返回",
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
