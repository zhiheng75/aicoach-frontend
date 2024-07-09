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
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage>
    with
        // ChangeNotifierMixin<LoginPhonePage>,
        BasePageMixin<LoginPhonePage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<LoginPhonePage>
    implements
        RegisterView {
  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  // final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  late RegisterPresenter _registerPresenter;
  // bool _isSelect = true;
  final ScreenUtil _screenUtil = ScreenUtil();

  // bool isWx = false;
  // void _verify() {
  //   final String name = _phoneController.text;
  //   final String vCode = _vCodeController.text;
  //   bool clickable = true;
  //   if (name.isEmpty || name.length < 11) {
  //     clickable = false;
  //   }
  //   if (vCode.isEmpty || vCode.length != 4) {
  //     clickable = false;
  //   }

  //   if (clickable != _clickable) {
  //     setState(() {
  //       _clickable = clickable;
  //     });
  //   }
  // }

  // @override
  // Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
  //   final List<VoidCallback> callbacks = <VoidCallback>[_verify];
  //   return <ChangeNotifier, List<VoidCallback>?>{
  //     _phoneController: callbacks,
  //     _vCodeController: callbacks,
  //     _nodeText1: null,
  //     _nodeText2: null,
  //   };
  // }

  @override
  void initState() {
    super.initState();
  }

  Widget navbar() {
    return Container(
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
                  NavigatorUtils.goBack(context);
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
                    // Center(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       TextField(
                    //         decoration: InputDecoration(hintText: 'Enter text'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      // height: Dimens.h_dp40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.h_dp40),
                        // color: _clickable
                        //     ? Colors.black
                        //     : Colours.color_737373,
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(Dimens.h_dp40),
                      //   color: Colors.white70,
                      // ),
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
                            NavigatorUtils.push(
                              context,
                              replace: true,
                              "${LoginRouter.keyCheckCodePage}?PhoneNumber=${_phoneController.text.trim()}&typeLogin=1",
                            );
                            _registerPresenter.sendSms(
                                _phoneController.text.trim(), false);
                          } else {
                            Toast.show("手机号无效");
                          }

                          // NavigatorUtils.push(context,
                          //     "${LoginRouter.keyCheckCodePage}?PhoneNumber=18611667447");
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
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: const Text(
                    //     "未注册手机号验证后生成新账号",
                    //     style: TextStyle(
                    //         color: Colours.color_001652, fontSize: 13),
                    //   ),
                    // ),
                    // const Expanded(child: Gaps.empty),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   // crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         _isSelect = !_isSelect;
                    //         setState(() {});
                    //       },
                    //       child: Container(
                    //         width: 30,
                    //         height: 30,
                    //         alignment: Alignment.center,
                    //         child: LoadAssetImage(
                    //           _isSelect ? "select_img2" : "unselect_img2",
                    //           width: 15.0,
                    //           height: 15.0,
                    //         ),
                    //       ),
                    //     ),
                    //     // Gaps.hGap10,
                    //     const Text(
                    //       "我已阅读并同意",
                    //       style: TextStyle(fontSize: 14, color: Colours.black),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         NavigatorUtils.goWebViewPage(context, "隐私政策",
                    //             "http://www.shenmo-ai.com/privacy_policy/");
                    //         // NavigatorUtils.goWebViewPage(context, "隐私政策",
                    //         //     "https://mini-game-dev.shenmo-ai.com/web/index.html ");
                    //       },
                    //       child: const Text("隐私政策",
                    //           style: TextStyle(
                    //               fontSize: 14,
                    //               color: Colours.color_0047FF,
                    //               decoration: TextDecoration.underline)),
                    //     ),
                    //     const Text(
                    //       "和",
                    //       style: TextStyle(
                    //           fontSize: 14, color: Colours.color_546092),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         NavigatorUtils.goWebViewPage(context, "服务协议",
                    //             "http://www.shenmo-ai.com/tos/");
                    //         // NavigatorUtils.goWebViewPage(context, "服务协议",
                    //         //     "https://books.shenmo-ai.com/mobile?character_id=li_bai&v=1&tag=prod&cat=1");
                    //       },
                    //       child: const Text(
                    //         "服务协议",
                    //         style: TextStyle(
                    //             color: Colours.color_0047FF,
                    //             fontSize: 14,
                    //             decoration: TextDecoration.underline),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Gaps.vGap24,
                    // Gaps.vGap50,
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  // ///微信授权
  // weChatLogin() async {
  //   if (_isSelect) {
  //     // if (Device.isAndroid) {
  //     //   FlutterToNative.jumpToWechatLogin().then((value) => {
  //     //         // _wechatCode = value,
  //     //         // Log.e("===========>$_wechatCode"),
  //     //         _registerPresenter.getWxInfo(value)
  //     //       });
  //     // } else {
  //     //   Log.e("===========>");
  //     Fluwx fluwx = Fluwx();

  //     fluwx.registerApi(
  //         appId: "wxfb033d09d2eecaf0",
  //         universalLink: "https://demo.shenmo-ai.net/ios/");
  //     if (await fluwx.isWeChatInstalled) {
  //       fluwx
  //           .authBy(
  //               which: NormalAuth(
  //                   scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'))
  //           .then((data) {});
  //       fluwx.addSubscriber((response) {
  //         if (response is WeChatAuthResponse) {
  //           // Log.e("===========>");
  //           // Log.e(response.code ?? "");
  //           // Log.e("===========>");

  //           String? result = response.code;
  //           _registerPresenter.getWxInfo(response.code ?? "");
  //           // setState(() {
  //           // String result =
  //           //     'state :${response.state} \n code:${response.code}';
  //           // print(result);
  //           // });
  //         }
  //       });
  //     } else {
  //       Toast.show("没有安装微信");
  //     }
  //     // }
  //   } else {
  //     Toast.show("请同意服务协议");
  //   }
  // }

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
    NavigatorUtils.push(context, LoginRouter.onlySmsPage);
  }

  @override
  void loginSuccess() {}

  @override
  void newwechatSuccess(NewWxInfoBeanData data) {
    // TODO: implement newwechatSuccess
  }
}
