import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/login/presenter/bind_phone_presenter.dart';
import 'package:Bubble/login/view/bind_phone_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/change_notifier_manage.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:Bubble/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewBindPhonePage extends StatefulWidget {
  final NewWxInfoBeanData wechatData;
  final String typeLogin;

  const NewBindPhonePage(
      {Key? key, required this.wechatData, required this.typeLogin})
      : super(key: key);

  @override
  State<NewBindPhonePage> createState() => _NewBindPhonePageState();
}

class _NewBindPhonePageState extends State<NewBindPhonePage>
    with
        BasePageMixin<NewBindPhonePage, BindPhonePresenter>,
        AutomaticKeepAliveClientMixin<NewBindPhonePage>
    implements BindPhoneView {
  // final bool isKeyLogin = false;
  late BindPhonePresenter _bindPhonePresenter;

  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  bool _clickable = false;
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  Widget navbar() {
    return SizedBox(
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
                  if (widget.typeLogin == "2") {
                    NavigatorUtils.push(context, HomeRouter.tabberPage,
                        replace: true);
                  } else {
                    NavigatorUtils.goBack(context);
                  }
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
            if (widget.typeLogin == "2") {
              NavigatorUtils.push(context, HomeRouter.tabberPage,
                  replace: true);
            } else {
              NavigatorUtils.goBack(context);
            }
            return false;
          },
          child: Container(
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
                      LoadAssetImage(
                        "login_top_img",
                        width: 270.w,
                      ),
                      // const Text(
                      //   "Hi,欢迎来到口语嘟嘟",
                      //   style: TextStyle(
                      //       fontSize: 28,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colours.black),
                      // ),
                      // const Text(
                      //   "登录后更精彩，即将开始流利口语",
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colours.black),
                      // ),
                      Gaps.vGap33,
                      const Text(
                        "未注册手机验证后即完成注册",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_333333),
                      ),
                      Gaps.vGap16,

                      Container(
                        width: double.infinity,
                        height: Dimens.h_dp40,
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
                          txtStyle: TextStyle(
                            fontSize: Dimens.font_sp14,
                            color: Colours.color_001652,
                          ),
                          hintStyle: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: Colours.color_001652),
                          focusNode: _nodeText1,
                          controller: _phoneController,
                          maxLength: 11,
                          keyboardType: TextInputType.phone,
                          hintText: "请输入手机号",
                          underLineColor: Colours.color_00,
                          countDownColor: Colours.color_001652,
                        ),
                      ),
                      Gaps.vGap16,
                      GestureDetector(
                          onTap: () {
                            if (_clickable == false) return;

                            if (_phoneController.text.length == 11) {
                              _bindPhonePresenter
                                  .sendSms(_phoneController.text.trim());
                            } else {
                              Toast.show("手机号无效");
                            }
                          },
                          child: Container(
                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                            height: Dimens.h_dp40,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.h_dp40),
                              color: _clickable
                                  ? Colors.black
                                  : Colours.color_737373,
                              // border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Center(
                              child: Text(
                                "获取验证码",
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
      ),
    );
  }

  @override
  BindPhonePresenter createPresenter() {
    _bindPhonePresenter = BindPhonePresenter();
    return _bindPhonePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(String msg) {
    // TODO: implement sendSuccess
    NavigatorUtils.push(
        context,
        arguments: widget.wechatData,
        replace: true,
        "${LoginRouter.keyCheckTwoCodePage}?PhoneNumber=${_phoneController.text.trim()}&typeLogin=${widget.typeLogin}");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void wechatLoginFail(String msg) {
    // TODO: implement wechatLoginFail
  }

  @override
  void wechatLoginSuccess(String msg) {
    // TODO: implement wechatLoginSuccess
  }
}
