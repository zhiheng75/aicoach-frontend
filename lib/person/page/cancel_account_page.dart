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
          const Text(
            '使用前请您先阅读以下条款',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            '1）永久不可登录和使用该账户\n2）身份、账户等数据将被清空\n3）之前的所有对话及设置数据都将被清空\n4）已签约的服务将失效\n5） 与其他账户的绑定关系将解除\n6） 处理时效最长不超过15个工作日',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            width: 200,
            child: BtnWidget("btn_bg_img", "申请注销",
                txtStyle: TextStyle(
                    color: Colours.color_001652,
                    fontSize: Dimens.font_sp18), () {
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
            }),
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
