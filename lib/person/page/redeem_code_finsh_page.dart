import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/net/proxy_config.dart';
import 'package:Bubble/person/entity/redeem_code_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sp_util/sp_util.dart';

class RedeemCodeFinshPage extends StatefulWidget {
  final DataCode data;
  // final String name;

  const RedeemCodeFinshPage({
    super.key,
    required this.data,
    // required this.name,
  });

  @override
  State<RedeemCodeFinshPage> createState() => _RedeemCodeFinshPageState();
}

class _RedeemCodeFinshPageState extends State<RedeemCodeFinshPage> {
  final ScreenUtil _screenUtil = ScreenUtil();
  Fluwx fluwx = Fluwx();
  late String? accessToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accessToken = SpUtil.getString(Constant.accessToken);

    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "兑换中心",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/purchase_one_bg_img.png',
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          children: [
            Gaps.vGap60,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadAssetImage(
                  'xueersi_success_icon',
                  width: 42.0.w,
                  height: 42.0.w,
                ),
                Gaps.hGap5,
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
            Gaps.vGap60,
            Container(
              margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 20.w),
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
              decoration: BoxDecoration(
                color: Colours.color_FFD67F,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: widget.data.goodsType == 1
                  ? Text(
                      "您已成功兑换口语畅聊卡《${widget.data.goodsName}》现在开始和虚拟伙伴一起联系吧",
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colours.color_A25C13,
                      ),
                    )
                  : RichText(
                      // RichText
                      text: TextSpan(
                          text: '您已成功兑换《${widget.data.goodsName}》课程',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colours.color_A25C13,
                          ),
                          children: <TextSpan>[
                          TextSpan(
                            text: '开课前务必添加老师微信,避免无法正常上课',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ])),
            ),
            Gaps.vGap40,
            GestureDetector(
              onTap: () {
                if (widget.data.goodsType == 1) {
                  NavigatorUtils.goBack(context);
                  NavigatorUtils.goBack(context);
                  EventBus().emit(NotificationUtils.taberTwo);
                } else {
                  String accessToken =
                      SpUtil.getString(Constant.accessToken) ?? "";
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
                }
              },
              child: Container(
                width: 240.w,
                height: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colours.color_8003FD,
                ),
                child: Center(
                  child: Text(
                    widget.data.goodsType == 1 ? "开始" : "立即添加老师微信",
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
      )),
    );
  }
}
