import 'dart:async';
import 'dart:math';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/core/app_constants.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/login/view/verification_box.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../home/provider/home_provider.dart';
import '../../mvp/base_page.dart';
import '../../util/event_bus.dart';
import '../../util/change_notifier_manage.dart';

class CheckCodePage extends StatefulWidget {
  final String phoneNumber;
  //1手机号登录
  final String typeLogin;

  const CheckCodePage({
    super.key,
    required this.phoneNumber,
    required this.typeLogin,
  });

  @override
  State<CheckCodePage> createState() => _CheckCodePageState();
}

class _CheckCodePageState extends State<CheckCodePage>
    with
        BasePageMixin<CheckCodePage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<CheckCodePage>
    implements RegisterView {
  late RegisterPresenter _registerPresenter;

  ///计时器
  Timer? _timer;

  ///当前倒计时秒数
  int? _seconds;

  ///能否重新发送
  bool canResend = false;

  final String _verfiCode = "";
  final ScreenUtil _screenUtil = ScreenUtil();

  ///启动倒计时器
  void _startTimer() {
    _seconds = 60;
    canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        if (mounted) {
          setState(() {
            canResend = true;
          });
        }
        return;
      }
      _seconds = _seconds! - 1;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    Log.e(widget.phoneNumber);
    // Log.e(widget.isKeyLogin as String);

    print(widget.typeLogin);
    _startTimer();
    super.initState();
    EventUMStatistics.umengCommonOnPageStart("check_code_page");

    // _registerPresenter.sendSms(widget.phoneNumber, true);
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();

    // RegisterPresenter.disHttpKeySendSms();
    EventUMStatistics.umengCommonOnPageEnd("check_code_page");

    _cancelTimer();
  }

  Widget navbar() {
    return Container(
      // color: Colors.amber,
      height: _screenUtil.statusBarHeight + 60,
      width: _screenUtil.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
          ),
          Row(
            children: [
              Container(
                width: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // if (widget.typeLogin == "2") {
                  //   NavigatorUtils.push(context, HomeRouter.tabberPage,
                  //       replace: true);
                  // } else {
                  NavigatorUtils.goBack(context);
                  // }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    width: 20,
                    height: 26,
                    'assets/images/ic_back_icon.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String creatPhoneStr(String phonrStr) {
    phonrStr =
        "${phonrStr.substring(0, 3)} ${phonrStr.substring(3, 7)} ${phonrStr.substring(7, 11)}";
    return phonrStr;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () async {
            //这里可以响应物理返回键
            // if (widget.typeLogin == "2") {
            //   NavigatorUtils.push(context, HomeRouter.tabberPage,
            //       replace: true);
            // } else {
            NavigatorUtils.goBack(context);
            // }
            return false;
          },
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageUtils.getAssetImage("login_two_bg_img"),
                      fit: BoxFit.fill)),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  navbar(),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 108, left: 30, right: 16),
                  //   child: Text(
                  //     "请输入验证码:",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       color: Colours.color_001652,
                  //       // fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoadAssetImage(
                          "login_top_img",
                          width: 270.w,
                        ),
                        // Text(
                        //   "Hi,欢迎来到口语嘟嘟",
                        //   style: TextStyle(
                        //       fontSize: Dimens.font_sp28,
                        //       fontWeight: FontWeight.w400,
                        //       color: Colours.black),
                        // ),
                        // Text(
                        //   "登录后更精彩，即将开始流利口语",
                        //   style: TextStyle(
                        //       fontSize: Dimens.font_sp16,
                        //       fontWeight: FontWeight.w400,
                        //       color: Colours.black),
                        // ),
                        Gaps.vGap33,
                        Row(
                          children: [
                            Text(
                              "已发送验证码至",
                              style: TextStyle(
                                fontSize: Dimens.font_sp13,
                                color: Colours.color_001652,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gaps.hGap10,
                            Text(
                              creatPhoneStr(widget.phoneNumber),
                              style: TextStyle(
                                fontSize: Dimens.font_sp13,
                                color: Colours.color_001652,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _verificationBox(),
                  // Gaps.vGap10,
                  canResend
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (canResend) {
                                resendCode();
                                // RegisterPresenter.disHttpKeySendSms();
                                _registerPresenter.sendSms(
                                    widget.phoneNumber, true);
                              }
                            },
                            child: Text(
                              "重新发送",
                              style: TextStyle(
                                fontSize: Dimens.font_sp12,
                                color: Colours.color_333333,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                          ),
                          child: Text(
                            "$_seconds秒后重新发送",
                            style: TextStyle(
                              fontSize: Dimens.font_sp12,
                              color: Colours.color_333333,
                            ),
                          ),
                        ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _verificationBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: Container(
        height: 45.w,
        child: VerificationBox(
          count: 6,
          onSubmitted: (code) {
            verifyCode(code);
          },
          itemWidget: 45.w,
          borderWidth: 1,
          borderColor: Colours.color_001652,
          borderRadius: 16,
          textStyle: TextStyle(color: Colors.black, fontSize: Dimens.font_sp20),
          showCursor: true,
          unfocus: false,
        ),
      ),
    );
  }

  void verifyCode(String code) {
    print(code);

    _registerPresenter.register(widget.phoneNumber, code, false);
  }

  ///重新发送验证码
  void resendCode() {
    _startTimer();
  }

  @override
  RegisterPresenter createPresenter() {
    _registerPresenter = RegisterPresenter();
    return _registerPresenter;
  }

  @override
  void hadBindWechat() {
    // TODO: implement hadBindWechat
  }

  @override
  void loginSuccess() {
    // TODO: implement loginSuccess
    // if (widget.typeLogin == "0") {
    //   // Constant.jverify.dismissLoginAuthView();
    //   hideLoading();
    // }

    // 刷新体验时间
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();

    if (widget.typeLogin == "2") {
      NavigatorUtils.push(context, HomeRouter.tabberPage, replace: true);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      EventBus().emit(NotificationUtils.loginIn);
      EventBus().emit(NotificationUtils.resetInFo);
    }

    // NavigatorUtils.push(
    //   context,
    //   replace: true,
    //   PersonalRouter.person,
    // );
  }

  @override
  void sendSmsSuccess() {
    // TODO: implement sendSmsSuccess
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void wechatFail() {
    // TODO: implement wechatFail
  }

  @override
  void wechatSuccess(LoginInfoDataData data) {
    // TODO: implement wechatSuccess
  }

  @override
  void newwechatSuccess(NewWxInfoBeanData data) {
    // TODO: implement newwechatSuccess
  }

  @override
  void codeError() {
    // TODO: implement codeError
  }
}

class CheckTwoCodePage extends StatefulWidget {
  final String phoneNumber;
  //微信登录绑定
  final NewWxInfoBeanData wechatData;
  final String typeLogin;

  const CheckTwoCodePage(
      {super.key,
      required this.phoneNumber,
      required this.wechatData,
      required this.typeLogin});

  @override
  State<CheckTwoCodePage> createState() => _CheckTwoCodePageState();
}

class _CheckTwoCodePageState extends State<CheckTwoCodePage>
    with
        BasePageMixin<CheckTwoCodePage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<CheckTwoCodePage>
    implements RegisterView {
  late RegisterPresenter _registerPresenter;

  ///计时器
  Timer? _timer;

  ///当前倒计时秒数
  int? _seconds = 60;

  ///能否重新发送
  bool canResend = false;

  final String _verfiCode = "";
  final ScreenUtil _screenUtil = ScreenUtil();

  ///启动倒计时器
  void _startTimer() {
    _seconds = 60;
    canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        if (mounted) {
          setState(() {
            canResend = true;
          });
        }
        return;
      }
      _seconds = _seconds! - 1;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    Log.e(widget.phoneNumber);
    // Log.e(widget.isKeyLogin as String);
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      // _registerPresenter.sendSms(widget.phoneNumber, false);
      _startTimer();
    });
    EventUMStatistics.umengCommonOnPageStart("check_two_code_page");
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();

    _cancelTimer();
    // RegisterPresenter.disHttpKeySendSms();
    EventUMStatistics.umengCommonOnPageEnd("check_two_code_page");
  }

  Widget navbar() {
    return Container(
      // color: Colors.amber,
      height: _screenUtil.statusBarHeight + 60,
      width: _screenUtil.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
          ),
          Row(
            children: [
              Container(
                width: 15,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // if (widget.typeLogin == "2") {
                  //   NavigatorUtils.push(context, HomeRouter.tabberPage,
                  //       replace: true);
                  // } else {
                  NavigatorUtils.goBack(context);
                  // }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    width: 20,
                    height: 26,
                    'assets/images/ic_back_icon.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String creatPhoneStr(String phonrStr) {
    phonrStr =
        "${phonrStr.substring(0, 3)} ${phonrStr.substring(3, 7)} ${phonrStr.substring(7, 11)}";
    return phonrStr;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("login_two_bg_img"),
                    fit: BoxFit.fill)),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                navbar(),
                // const Padding(
                //   padding: EdgeInsets.only(top: 108, left: 30, right: 16),
                //   child: Text(
                //     "请输入验证码:",
                //     style: TextStyle(
                //       fontSize: 17,
                //       color: Colours.color_001652,
                //       // fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadAssetImage(
                        "login_top_img",
                        width: 270.w,
                      ),
                      // Text(
                      //   "Hi,欢迎来到口语嘟嘟",
                      //   style: TextStyle(
                      //       fontSize: Dimens.font_sp28,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colours.black),
                      // ),
                      // Text(
                      //   "登录后更精彩，即将开始流利口语",
                      //   style: TextStyle(
                      //       fontSize: Dimens.font_sp16,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colours.black),
                      // ),
                      Gaps.vGap33,
                      Row(
                        children: [
                          Text(
                            "已发送验证码至",
                            style: TextStyle(
                              fontSize: Dimens.font_sp13,
                              color: Colours.color_001652,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gaps.hGap10,
                          Text(
                            creatPhoneStr(widget.phoneNumber),
                            style: TextStyle(
                              fontSize: Dimens.font_sp13,
                              color: Colours.color_001652,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _verificationBox(),
                // Gaps.vGap10,
                canResend
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (canResend) {
                              resendCode();
                              // RegisterPresenter.disHttpKeySendSms();
                              _registerPresenter.sendSms(
                                  widget.phoneNumber, true);
                            }
                          },
                          child: Text(
                            "重新发送",
                            style: TextStyle(
                              fontSize: Dimens.font_sp12,
                              color: Colours.color_333333,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                        ),
                        child: Text(
                          "$_seconds秒后重新发送",
                          style: TextStyle(
                            fontSize: Dimens.font_sp12,
                            color: Colours.color_333333,
                          ),
                        ),
                      ),
              ],
            )),
      ),
    );
  }

  Widget _verificationBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: Container(
        height: 45.h,
        child: VerificationBox(
          count: 6,
          onSubmitted: (code) {
            verifyCode(code);
          },
          itemWidget: 45.w,
          borderWidth: 1,
          borderColor: Colours.color_001652,
          borderRadius: 16,
          textStyle: TextStyle(color: Colors.black, fontSize: Dimens.font_sp20),
          showCursor: true,
          unfocus: false,
        ),
      ),
    );
  }

  void verifyCode(String code) {
    print(code);
    // RegisterPresenter.disHttpKeySendSms();

    _registerPresenter.toBind(widget.phoneNumber, code, widget.wechatData);
  }

  void _bind(String code) {
    _registerPresenter.toBind(widget.phoneNumber, code, widget.wechatData);
  }

  ///重新发送验证码
  void resendCode() {
    _startTimer();
  }

  @override
  RegisterPresenter createPresenter() {
    _registerPresenter = RegisterPresenter();
    return _registerPresenter;
  }

  @override
  void hadBindWechat() {
    // TODO: implement hadBindWechat
  }

  @override
  void loginSuccess() {
    // TODO: implement loginSuccess
    // 刷新体验时间
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();

    if (widget.typeLogin == "2") {
      NavigatorUtils.push(context, HomeRouter.tabberPage, replace: true);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      EventBus().emit(NotificationUtils.loginIn);
      EventBus().emit(NotificationUtils.resetInFo);
    }
  }

  @override
  void sendSmsSuccess() {
    // TODO: implement sendSmsSuccess
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void wechatFail() {
    // TODO: implement wechatFail
  }

  @override
  void wechatSuccess(LoginInfoDataData data) {
    // TODO: implement wechatSuccess
  }

  @override
  void newwechatSuccess(NewWxInfoBeanData data) {
    // TODO: implement newwechatSuccess
  }

  @override
  void loginError(String msg) {
    // TODO: implement loginError
  }

  @override
  void codeError() {
    // TODO: implement codeError
  }
}
