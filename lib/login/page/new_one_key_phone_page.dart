// ignore_for_file: avoid_print

import 'dart:async';

import 'package:Bubble/constant/constant.dart';
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
import 'package:flutter/gestures.dart';
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

class NewOneKeyPhonePage extends StatefulWidget {
  //1手机号登录
  final String typeLogin;

  const NewOneKeyPhonePage({Key? key, required this.typeLogin})
      : super(key: key);

  @override
  State<NewOneKeyPhonePage> createState() => _NewOneKeyPhonePageState();
}

class _NewOneKeyPhonePageState extends State<NewOneKeyPhonePage>
    with
        ChangeNotifierMixin<NewOneKeyPhonePage>,
        BasePageMixin<NewOneKeyPhonePage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<NewOneKeyPhonePage>
    implements RegisterView {
  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  late RegisterPresenter _registerPresenter;
  bool _isSelect = false;

  bool isWx = false;
  final ScreenUtil _screenUtil = ScreenUtil();

  void _verify() {
    final String name = _phoneController.text;
    final String vCode = _vCodeController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length != 4) {
      clickable = false;
    }

    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isWX();
  }

  Future<void> isWX() async {
    if (Device.isAndroid) {
      isWx = true;
    } else {
      Fluwx fluwx = Fluwx();
      if (await fluwx.isWeChatInstalled) {
        isWx = true;
      } else {
        isWx = false;
      }
    }

    setState(() {});
  }

  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _vCodeController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
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

              // MyOnlyImgBar(
              //     alignment: Alignment.centerLeft,
              //     backgroundColor: Colours.transflate,
              //     width: Dimens.w_dp32,
              //     height: Dimens.h_dp32,
              //     actionUrl: "round_close_img",
              //     onActionPress: () {
              //       NavigatorUtils.goBack(context);
              //     }),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 42, right: 42, top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // widget.typeLogin == "1"
                    //     ? Text(
                    //         "手机号码登录",
                    //         style: TextStyle(
                    //             fontSize: Dimens.font_sp17,
                    //             color: Colours.black),
                    //       )
                    //     : Gaps.vGap2,
                    // widget.typeLogin == "1"
                    //     ? Container(
                    //         margin: const EdgeInsets.only(top: 20),
                    //         // height: Dimens.h_dp40,
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.circular(Dimens.h_dp40),
                    //           color: Colors.white70,
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             Gaps.hGap16,
                    //             Text(
                    //               "+86",
                    //               style: TextStyle(
                    //                   color: Colours.color_9BA9BE,
                    //                   fontSize: Dimens.font_sp18),
                    //             ),
                    //             Gaps.hGap16,
                    //             Expanded(
                    //               child: MyTextField(
                    //                 key: const Key('phone'),
                    //                 txtStyle: const TextStyle(
                    //                   fontSize: 20,
                    //                   color: Colours.color_001652,
                    //                 ),
                    //                 hintStyle: const TextStyle(
                    //                     fontSize: 20,
                    //                     color: Colours.color_001652),
                    //                 focusNode: _nodeText1,
                    //                 controller: _phoneController,
                    //                 maxLength: 11,
                    //                 keyboardType: TextInputType.phone,
                    //                 hintText: "输入手机号",
                    //                 underLineColor: Colours.color_00,
                    //                 countDownColor: Colours.color_001652,
                    //               ),
                    //             ),
                    //             Gaps.hGap16,
                    //           ],
                    //         ),
                    //       )
                    //     : Container(
                    //         height: Dimens.h_dp40,
                    //         decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.circular(Dimens.h_dp40),
                    //           color: Colors.white70,
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             "186****1111",
                    //             style: TextStyle(
                    //                 color: Colours.color_001652,
                    //                 fontSize: Dimens.font_sp18),
                    //           ),
                    //         ),
                    //       ),
                    // Gaps.vGap24,
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: const Text(
                    //     "未注册手机号验证后生成新账号",
                    //     style: TextStyle(
                    //         color: Colours.color_001652, fontSize: 13),
                    //   ),
                    // ),
                    const Expanded(child: Gaps.empty),
                    GestureDetector(
                        onTap: () {
                          if (_isSelect) {
                            NavigatorUtils.push(
                              context,
                              replace: true,
                              LoginRouter.keyLoginPhonePage,
                            );
                            // _registerPresenter.sendSms(
                            //     _phoneController.text.trim(), false);
                          } else {
                            Toast.show("请同意服务协议");
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
                            color: Colors.black,
                            // border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LoadAssetImage(
                                "login_phone_icon",
                                width: 17.0,
                                height: 20.0,
                              ),
                              Gaps.hGap12,
                              Text(
                                "手机号登录",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.font_sp18),
                              ),
                            ],
                          ),
                        )),
                    isWx
                        ? GestureDetector(
                            onTap: () {
                              if (_isSelect) {
                                weChatLogin();
                              } else {
                                Toast.show("请同意服务协议");
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.h_dp40),
                                color: Colors.white,
                                // border: Border.all(width: 1, color: Colors.black),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const LoadAssetImage(
                                    "login_wx_icon",
                                    width: 24.0,
                                    height: 20.0,
                                  ),
                                  Gaps.hGap12,
                                  Text(
                                    "微信登录",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimens.font_sp18),
                                  ),
                                ],
                              ),
                            ))
                        : Container(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _isSelect = !_isSelect;
                            setState(() {});
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            child: LoadAssetImage(
                              _isSelect ? "select_img2" : "unselect_img2",
                              width: 15.0,
                              height: 15.0,
                            ),
                          ),
                        ),
                        // Gaps.hGap10,
                        Expanded(
                          child: RichText(
                              // RichText
                              text: TextSpan(
                                  text: '已阅读并同意',
                                  style: const TextStyle(
                                    color: Colours.color_333333,
                                    fontSize: 14.0,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: '《隐私协议》',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigatorUtils.goWebViewPage(
                                            context,
                                            "隐私协议",
                                            "http://www.shenmo-ai.com/privacy_policy/");
                                      },
                                    style: const TextStyle(
                                      color: Colours.color_333333,
                                      fontSize: 14.0,
                                    )),
                                const TextSpan(
                                    text: "、",
                                    style: TextStyle(
                                      color: Colours.color_333333,
                                      fontSize: 14.0,
                                    )),
                                TextSpan(
                                    text: '《服务协议》',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigatorUtils.goWebViewPage(
                                            context,
                                            "服务协议",
                                            "http://www.shenmo-ai.com/tos/");
                                      },
                                    style: const TextStyle(
                                      color: Colours.color_333333,
                                      fontSize: 14.0,
                                    )),
                                const TextSpan(
                                    text: '及',
                                    style: TextStyle(
                                      color: Colours.color_333333,
                                      fontSize: 14.0,
                                    )),
                                TextSpan(
                                    text: '《儿童个人信息保护声明》',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigatorUtils.goWebViewPage(
                                            context,
                                            "儿童个人信息保护声明",
                                            "http://www.shenmo-ai.com/bubble-ai_kids/");
                                      },
                                    style: const TextStyle(
                                      color: Colours.color_333333,
                                      fontSize: 14.0,
                                    )),
                              ])),
                        ),
                      ],
                    ),

                    Gaps.vGap50,
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  ///微信授权
  weChatLogin() async {
    if (_isSelect) {
      // if (Device.isAndroid) {
      //   FlutterToNative.jumpToWechatLogin().then((value) => {
      //         // _wechatCode = value,
      //         // Log.e("===========>$_wechatCode"),
      //         _registerPresenter.getWxInfo(value)
      //       });
      // } else {
      //   Log.e("===========>");
      Fluwx fluwx = Fluwx();

      fluwx.registerApi(
          appId: "wxfb033d09d2eecaf0",
          universalLink: "https://demo.shenmo-ai.net/ios/");
      if (await fluwx.isWeChatInstalled) {
        fluwx
            .authBy(
                which: NormalAuth(
                    scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'))
            .then((data) {});
        fluwx.addSubscriber((response) {
          if (response is WeChatAuthResponse) {
            // Log.e("===========>");
            // Log.e(response.code ?? "");
            // Log.e("===========>");

            String? result = response.code;
            _registerPresenter.getWxInfo(response.code ?? "");
            // setState(() {
            // String result =
            //     'state :${response.state} \n code:${response.code}';
            // print(result);
            // });
          }
        });
      } else {
        Toast.show("没有安装微信");
      }
      // }
    } else {
      Toast.show("请同意服务协议");
    }
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
    Log.e("======登录成功=======");
    Navigator.pop(context);

    // 刷新体验时间
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();
    // NavigatorUtils.push(context, HomeRouter.homePage, clearStack: true);
    EventBus().emit(NotificationUtils.loginIn);
    EventBus().emit(NotificationUtils.resetInFo);

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
    NavigatorUtils.push(context, LoginRouter.newBindPhonePage,
        arguments: data, replace: true);
  }
}
