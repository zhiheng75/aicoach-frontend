import 'dart:async';
import 'dart:math';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/login/view/verification_box.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../home/provider/home_provider.dart';
import '../../mvp/base_page.dart';
import '../../util/EventBus.dart';
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

  ///启动倒计时器
  void _startTimer() {
    _seconds = 30;
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

    // _registerPresenter.sendSms(widget.phoneNumber, true);
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    RegisterPresenter.disHttpKeySendSms();

    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("splash_bg"),
                    fit: BoxFit.fill)),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyOnlyImgBar(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colours.transflate,
                    width: 32.0,
                    height: 32.0,
                    actionUrl: "white_close_img",
                    onActionPress: () {
                      NavigatorUtils.goBack(context);
                    }),
                const Padding(
                  padding: EdgeInsets.only(top: 108, left: 30, right: 16),
                  child: Text(
                    "请输入验证码:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colours.color_001652,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "已发送验证码到 ${widget.phoneNumber} ",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colours.color_001652,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  canResend
                      ? GestureDetector(
                          onTap: () {
                            if (canResend) {
                              resendCode();
                              RegisterPresenter.disHttpKeySendSms();
                              _registerPresenter.sendSms(
                                  widget.phoneNumber, true);
                            }
                          },
                          child: const Text(
                            "重新发送",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4884F3),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              "$_seconds",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4884F3),
                              ),
                            ),
                            const Text("秒"),
                          ],
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                ]),
                _verificationBox()
              ],
            )),
      ),
    );
  }

  Widget _verificationBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 32),
      child: Container(
        height: 45,
        child: VerificationBox(
          count: 6,
          onSubmitted: (code) {
            verifyCode(code);
          },
          itemWidget: 45,
          borderWidth: 1,
          borderColor: Colours.color_001652,
          borderRadius: 4,
          textStyle: const TextStyle(color: Color(0xFF666666), fontSize: 27),
          showCursor: true,
          unfocus: false,
        ),
      ),
    );
  }

  void verifyCode(String code) {
    print(code);

    _registerPresenter.register(widget.phoneNumber, code, true);
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
    if (widget.typeLogin == "0") {
      Constant.jverify.dismissLoginAuthView();
      hideLoading();
    }

    // 刷新体验时间
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();
    NavigatorUtils.push(context, HomeRouter.homePage, clearStack: true);
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
}

class CheckTwoCodePage extends StatefulWidget {
  final String phoneNumber;
  //微信登录绑定
  final NewWxInfoBeanData wechatData;

  const CheckTwoCodePage(
      {super.key, required this.phoneNumber, required this.wechatData});

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
  int? _seconds = 30;

  ///能否重新发送
  bool canResend = false;

  final String _verfiCode = "";

  ///启动倒计时器
  void _startTimer() {
    _seconds = 30;
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
    Future.delayed(Duration(milliseconds: 200), () {
      _registerPresenter.sendSms(widget.phoneNumber, false);
      _startTimer();
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimer();
    RegisterPresenter.disHttpKeySendSms();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("splash_bg"),
                    fit: BoxFit.fill)),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyOnlyImgBar(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colours.transflate,
                    width: 32.0,
                    height: 32.0,
                    actionUrl: "white_close_img",
                    onActionPress: () {
                      NavigatorUtils.goBack(context);
                    }),
                const Padding(
                  padding: EdgeInsets.only(top: 108, left: 30, right: 16),
                  child: Text(
                    "请输入验证码:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colours.color_001652,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "已发送验证码到 ${widget.phoneNumber} ",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colours.color_001652,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  canResend
                      ? GestureDetector(
                          onTap: () {
                            if (canResend) {
                              resendCode();
                              _registerPresenter.sendSms(
                                  widget.phoneNumber, true);
                            }
                          },
                          child: const Text(
                            "重新发送",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4884F3),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              "$_seconds",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4884F3),
                              ),
                            ),
                            const Text("秒"),
                          ],
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                ]),
                _verificationBox()
              ],
            )),
      ),
    );
  }

  Widget _verificationBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 32),
      child: Container(
        height: 45,
        child: VerificationBox(
          count: 6,
          onSubmitted: (code) {
            _bind(code);
          },
          itemWidget: 45,
          borderWidth: 1,
          borderColor: Colours.color_001652,
          borderRadius: 4,
          textStyle: const TextStyle(color: Color(0xFF666666), fontSize: 27),
          showCursor: true,
          unfocus: false,
        ),
      ),
    );
  }

  void verifyCode(String code) {
    print(code);
    RegisterPresenter.disHttpKeySendSms();

    _registerPresenter.register(widget.phoneNumber, code, true);
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
    // NavigatorUtils.push(context, PersonalRouter.person, replace: true);
    NavigatorUtils.push(context, HomeRouter.homePage, clearStack: true);
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
}
