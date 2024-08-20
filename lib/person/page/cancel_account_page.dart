import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/btn_bg_widget.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class CancelAccountPage extends StatefulWidget {
  const CancelAccountPage({super.key});

  @override
  State<CancelAccountPage> createState() => _CancelAccountPageState();
}

class _CancelAccountPageState extends State<CancelAccountPage> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    Widget customerService = Container(
      width: _screenUtil.screenWidth - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '重要提示',
            style: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '*  账号一旦注销，您将无法登录，同时与账号相关的任何产品与服务都将无法使用。',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
              Text(
                '*  注销后，无法恢复，即使您在注销后以同一手机号账号再次向我们申请注册平台账户，会生成一个全新用户账号。',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
              Text(
                '*  注销后，无法恢复，即使您在注销后以同一手机号注销后，您与我们曾经签订的关于此账号的相关用户协议，杈益义务性文件等相应终止。',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
              Text(
                '*  我们善意并郑重的提示您：账号谨慎注销，注销前请慎重查看账号下所有的内容是否都视为放弃。',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
              Text(
                '*  若您执意需要注销账号，请点击“申请注销”，为了您的账号安全，账号注销处理',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
              Text(
                '* 期限为15天。15天内我们将完成账号注销。',
                style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 24.0 / 15.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          GestureDetector(
            onTap: () {
              ConfirmUtils.show(
                context: context,
                title: '提示',
                onConfirm: () {
                  LoginManager.toLoginOut();
                  NavigatorUtils.goBack(context);
                  //
                  EventBus().emit(NotificationUtils.loginOut);
                  JPush().setup(
                    appKey: "0ce313d976a06a8f651f2252", //你自己应用的 AppKey
                    channel: "kouyududu",
                    production: false,
                    debug: true,
                  );
                  JPush().deleteAlias();
                },
                onCancel: () {},
                child: const Text(
                  '确定注销吗?',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    height: 18.0 / 15.0,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              child: Text(
                "申请注销",
                style:
                    TextStyle(color: Colors.white, fontSize: Dimens.font_sp18),
              ),
            ),
          )
        ],
      ),
    );

    Widget footer = const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '客服邮箱：help@shenmo-ai.com',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          'ICP备案号：京ICP备2023024660号-1',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          '深模科技 版权所有',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/person_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            const XTCupertinoNavigationBar(
              backgroundColor: Color(0xFFFFFFFF),
              border: null,
              padding: EdgeInsetsDirectional.zero,
              leading: NavigationBackWidget(),
              middle: Text(
                "注销账号",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            customerService,
            footer,
            const Expanded(child: Gaps.empty),
          ],
        ),
      ),
    );
  }
}
