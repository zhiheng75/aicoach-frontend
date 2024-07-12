import 'dart:async';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/dialog/agreement_dialog.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/method/fluter_native.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/change_notifier_manage.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:Bubble/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../home/home_router.dart';
import '../../mvp/base_page.dart';
import 'package:fluwx/fluwx.dart';

class LoginPhonePage extends StatefulWidget {
  final String typeLogin;
  const LoginPhonePage({Key? key, required this.typeLogin}) : super(key: key);

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage>
    with
        BasePageMixin<LoginPhonePage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<LoginPhonePage>
    implements RegisterView {
  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  bool _clickable = false;
  late RegisterPresenter _registerPresenter;
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  Widget navbar() {
    return SizedBox(
      // color: Colors.amber,
      height: _screenUtil.statusBarHeight + 40,
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
                  if (widget.typeLogin == "2") {
                    NavigatorUtils.push(context, HomeRouter.tabberPage,
                        replace: true);
                  } else {
                    NavigatorUtils.goBack(context);
                  }
                },
                child: SizedBox(
                  width: 20,
                  height: 20,
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
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              navbar(),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hi,欢迎来到口语嘟嘟",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colours.black),
                    ),
                    const Text(
                      "登录后更精彩，即将开始流利口语",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colours.black),
                    ),
                    Gaps.vGap33,
                    const Text(
                      "未注册手机验证后即完成注册",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colours.color_333333),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.h_dp40),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: MyTextField(
                        key: const Key('phone'),
                        textAlign: TextAlign.center,
                        isDelete: false,
                        textMessage: (message) {
                          if (message.length == 11) {
                            _clickable = true;
                          } else {
                            _clickable = false;
                          }
                          setState(() {});
                        },
                        txtStyle: const TextStyle(
                          fontSize: 20,
                          color: Colours.color_001652,
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 20, color: Colours.color_001652),
                        focusNode: _nodeText1,
                        controller: _phoneController,
                        maxLength: 11,
                        keyboardType: TextInputType.phone,
                        hintText: "请输入手机号",
                        underLineColor: Colours.color_00,
                        countDownColor: Colours.color_001652,
                      ),
                    ),
                    Gaps.vGap24,
                    GestureDetector(
                        onTap: () {
                          if (_clickable == false) return;

                          if (_phoneController.text.length == 11) {
                            _registerPresenter.sendSms(
                                _phoneController.text.trim(), false);
                          } else {
                            Toast.show("手机号无效");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          // height: Dimens.h_dp40,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.h_dp40),
                            color: _clickable
                                ? Colors.black
                                : Colours.color_737373,
                            // border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              "获取验证码录",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.font_sp18),
                            ),
                          ),
                        )),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  RegisterPresenter createPresenter() {
    _registerPresenter = RegisterPresenter();
    return _registerPresenter;
  }

  @override
  void hadBindWechat() {
    // Toast.show("登录成功");
    // SpUtil.putObject(Constant.userInfoKey, data);
    // SpUtil.getObj(Constant.userInfoKey, (v) => {
    //   print(v),
    // });

    // NavigatorUtils.goBack(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void wechatFail() {
    // Toast.show("登录失败");
  }

  @override
  void wechatSuccess(LoginInfoDataData data) {}

  @override
  void sendSmsSuccess() {
    NavigatorUtils.push(
      context,
      replace: true,
      "${LoginRouter.keyCheckCodePage}?PhoneNumber=${_phoneController.text.trim()}&typeLogin=${widget.typeLogin}",
    );
  }

  @override
  void loginSuccess() {}

  @override
  void newwechatSuccess(NewWxInfoBeanData data) {
    // TODO: implement newwechatSuccess
  }
}
