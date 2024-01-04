import 'dart:io';

import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jverify/jverify.dart';

import '../../constant/constant.dart';
import '../../dialog/agreement_dialog.dart';
import '../../home/home_router.dart';
import '../../method/fluter_native.dart';
import '../../mvp/base_page.dart';
import '../../person/person_router.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/image_utils.dart';
import '../../util/log_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load.dart';
import '../../widgets/my_only_img_bar.dart';
import '../../widgets/my_text_field.dart';
import '../entity/login_info_entity.dart';
import '../login_router.dart';

class NewRegisterPage extends StatefulWidget {
  final bool isKeyLogin;
  const NewRegisterPage({Key? key, required this.isKeyLogin}) : super(key: key);

  @override
  State<NewRegisterPage> createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage>
    with
        ChangeNotifierMixin<NewRegisterPage>,
        BasePageMixin<NewRegisterPage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<NewRegisterPage>
    implements RegisterView {
  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  late RegisterPresenter _registerPresenter;
  bool _isSelect = false;

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
    // if(widget.isKeyLogin){
    // loginAuth();
    // }
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
                  image: ImageUtils.getAssetImage("splash_bg"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              MyOnlyImgBar(
                  alignment: Alignment.centerLeft,
                  backgroundColor: Colours.transflate,
                  width: Dimens.w_dp32,
                  height: Dimens.h_dp32,
                  actionUrl: "round_close_img",
                  onActionPress: () {
                    NavigatorUtils.goBack(context);
                  }),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 42, right: 42),
                child: Column(
                  children: _buildBody(),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildBody() {
  //   return <Widget>[
  //     Container(
  //       height: Dimens.h_dp40,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(Dimens.h_dp40),
  //         color: Colors.white70,
  //       ),
  //       child: Center(
  //         child: Text(
  //           "186****1111",
  //           style: TextStyle(
  //               color: Colours.color_001652, fontSize: Dimens.font_sp18),
  //         ),
  //       ),
  //     ),
  //     Gaps.vGap24,
  //     Container(
  //       alignment: Alignment.center,
  //       child: const Text(
  //         "未注册手机号验证后生成新账号",
  //         style: TextStyle(color: Colours.color_001652, fontSize: 13),
  //       ),
  //     ),
  //     const Expanded(child: Gaps.empty),
  //     GestureDetector(
  //       onTap: () {
  //         _isSelect = !_isSelect;
  //         setState(() {});
  //       },
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             alignment: Alignment.center,
  //             child: LoadAssetImage(
  //               _isSelect ? "select_img2" : "unselect_img2",
  //               width: 11,
  //               height: 11,
  //             ),
  //           ),
  //           Gaps.hGap10,
  //           Text(
  //             "我以阅读并同意",
  //             style:
  //                 TextStyle(fontSize: Dimens.font_sp12, color: Colours.black),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               NavigatorUtils.goWebViewPage(context, "隐私政策",
  //                   "http://www.shenmo-ai.com/privacy_policy/");
  //             },
  //             child: Text("隐私政策",
  //                 style: TextStyle(
  //                     fontSize: Dimens.font_sp12,
  //                     color: Colours.color_0047FF,
  //                     decoration: TextDecoration.underline)),
  //           ),
  //           Text(
  //             "和",
  //             style: TextStyle(
  //                 fontSize: Dimens.font_sp12, color: Colours.color_546092),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               NavigatorUtils.goWebViewPage(
  //                   context, "服务协议", "http://www.shenmo-ai.com/tos/");
  //             },
  //             child: Text(
  //               "服务协议",
  //               style: TextStyle(
  //                   color: Colours.color_0047FF,
  //                   fontSize: Dimens.font_sp12,
  //                   decoration: TextDecoration.underline),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     Gaps.vGap24,
  //     GestureDetector(
  //         onTap: () {},
  //         child: Container(
  //           height: Dimens.h_dp40,
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   image: ImageUtils.getAssetImage("btn_bg_img"),
  //                   fit: BoxFit.fill)),
  //           child: Center(
  //             child: Text(
  //               "本机号码一键登录",
  //               style: TextStyle(
  //                   color: Colours.color_001652, fontSize: Dimens.font_sp18),
  //             ),
  //           ),
  //         )),
  //     Gaps.vGap24,
  //     GestureDetector(
  //         onTap: () {

  //         },
  //         child: Container(
  //           height: Dimens.h_dp40,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(Dimens.h_dp40),
  //             color: Colors.white70,
  //             border: Border.all(width: 1, color: Colors.black),
  //           ),
  //           child: Center(
  //             child: Text(
  //               "其他手机号登录",
  //               style: TextStyle(
  //                   color: Colours.color_001652, fontSize: Dimens.font_sp18),
  //             ),
  //           ),
  //         )),
  //     Gaps.vGap20,
  //     Container(
  //       alignment: Alignment.center,
  //       child: const Text(
  //         "其他登录方式",
  //         style: TextStyle(color: Colours.color_001652, fontSize: 13),
  //       ),
  //     ),
  //     Gaps.vGap20,
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         GestureDetector(
  //           onTap: () {},
  //           child: const LoadAssetImage(
  //             "wechat_login_img",
  //             width: 40,
  //             height: 40,
  //           ),
  //         ),
  //         Gaps.hGap16,
  //         GestureDetector(
  //           onTap: () {},
  //           child: const LoadAssetImage(
  //             "qq_login_img",
  //             width: 40,
  //             height: 40,
  //           ),
  //         ),
  //       ],
  //     ),
  //     Gaps.vGap50,
  //   ];
  // }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap80,
      Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            // NavigatorUtils.push(context, LoginRouter.onlySmsPage);
          },
          child: const LoadAssetImage(
            "login_logo_img",
            width: 180,
            height: 67,
          ),
          // const Text(
          //   "Bubble",
          //   style: TextStyles.textBold26,
          // ),
        ),
      ),
      Gaps.vGap80,
      Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          "手机号登录",
          style: TextStyle(
              fontSize: 26,
              color: Colours.color_001652,
              fontWeight: FontWeight.bold),
        ),
      ),
      // Row(
      //   children: [
      //     Expanded(child:MyTextField(
      //       key: const Key('phone'),
      //       txtStyle:const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
      //       hintStyle: const TextStyle(fontSize: 20,color: Colours.color_4ED7FF),
      //       focusNode: _nodeText1,
      //       controller: _phoneController,
      //       maxLength: 11,
      //       keyboardType: TextInputType.phone,
      //       hintText: "输入手机号",
      //     ) ),
      //   ],
      // ),
      MyTextField(
        key: const Key('phone'),
        txtStyle: const TextStyle(
            fontSize: 20,
            color: Colours.color_001652,
            fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 20, color: Colours.color_001652),
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: "输入手机号",
        underLineColor: Colours.color_001652,
        countDownColor: Colours.color_001652,
      ),
      Gaps.vGap15,
      MyTextField(
        focusNode: _nodeText2,
        txtStyle: const TextStyle(
            fontSize: 20,
            color: Colours.color_001652,
            fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 20, color: Colours.color_001652),
        underLineColor: Colours.color_001652,
        controller: _vCodeController,
        maxLength: 4,
        keyboardType: TextInputType.number,
        hintText: "输入验证码",
        getVCode: () async {
          NavigatorUtils.push(
            context,
            LoginRouter.newOneKeyPhonePage,
          );
          return false;
          if (_phoneController.text.length == 11) {
            _registerPresenter.sendSms(_phoneController.text.trim(), true);
            return true;
          } else {
            Toast.show("手机号无效");
            return false;
          }
        },
      ),

      Gaps.vGap10,
      Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          "未注册手机号验证后生成新账号",
          style: TextStyle(color: Colours.color_001652, fontSize: 13),
        ),
      ),
      // Gaps.vGap50,
      const Expanded(child: Gaps.empty),

      GestureDetector(
          onTap: () {
            if (_isSelect && _clickable) {
              _registerPresenter.register(
                  _phoneController.text, _vCodeController.text, true);
            } else if (!_clickable) {
              if (_phoneController.text.isEmpty) {
                Toast.show("手机号无效");
              } else if (_phoneController.text.isEmpty) {
                Toast.show("验证码无效");
              } else {
                Toast.show("输入有误");
              }
            } else if (!_isSelect) {
              Toast.show("请同意服务协议");
            }

            // toNext(0);
          },
          child: Container(
            height: Dimens.h_dp48,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("btn_bg_img"),
                    fit: BoxFit.fill)),
            child: Center(
              child: Text(
                "注册/登录",
                style: TextStyle(
                    color: Colours.color_001652, fontSize: Dimens.font_sp18),
              ),
            ),
          )),
      Gaps.vGap15,
      GestureDetector(
        onTap: () {
          _isSelect = !_isSelect;
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: LoadAssetImage(
                _isSelect ? "select_img2" : "unselect_img2",
                width: 11,
                height: 11,
              ),
            ),
            Gaps.hGap10,
            Text(
              "我以阅读并同意 ",
              style:
                  TextStyle(fontSize: Dimens.font_sp12, color: Colours.black),
            ),
            GestureDetector(
              onTap: () {
                NavigatorUtils.goWebViewPage(context, "隐私政策",
                    "http://www.shenmo-ai.com/privacy_policy/");
              },
              child: Text("隐私政策",
                  style: TextStyle(
                      fontSize: Dimens.font_sp12,
                      color: Colours.color_0047FF,
                      decoration: TextDecoration.underline)),
            ),
            Text(
              " 和 ",
              style: TextStyle(
                  fontSize: Dimens.font_sp12, color: Colours.color_546092),
            ),
            GestureDetector(
              onTap: () {
                NavigatorUtils.goWebViewPage(
                    context, "服务协议", "http://www.shenmo-ai.com/tos/");
              },
              child: Text(
                "服务协议",
                style: TextStyle(
                    color: Colours.color_0047FF,
                    fontSize: Dimens.font_sp12,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
      Gaps.vGap26,
      Text(
        "其他登录方式",
        style: TextStyle(color: Colours.black, fontSize: Dimens.font_sp13),
      ),
      Gaps.vGap11,
      GestureDetector(
        onTap: () {
          // toNext(1);
          if (_isSelect) {
            if (Device.isAndroid) {
              FlutterToNative.jumpToWechatLogin().then((value) => {
                    // _wechatCode = value,
                    // Log.e("===========>$_wechatCode"),
                    _registerPresenter.getWxInfo(value)
                  });
            } else {}
          } else {
            Toast.show("请同意服务协议");
          }
        },
        child: const LoadAssetImage(
          "wechat_login_img",
          width: 30,
          height: 30,
        ),
      ),
      Gaps.vGap50,
    ];
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
    NavigatorUtils.push(context, HomeRouter.homePage, clearStack: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void wechatFail() {
    Toast.show("登录失败");
  }

  @override
  void wechatSuccess(LoginInfoDataData data) {
    // SpUtil.putObject(Constant.userInfoKey, data);
    // SpUtil.putString(Constant.accessToken, data.token);
    NavigatorUtils.push(context, LoginRouter.changeBindPhonePage,
        arguments: data, replace: true);
  }

  @override
  void sendSmsSuccess() {
    NavigatorUtils.push(context, LoginRouter.onlySmsPage);
  }

  @override
  void loginSuccess() {
    if (widget.isKeyLogin) {
      Constant.jverify.dismissLoginAuthView();
      hideLoading();
    }

    NavigatorUtils.push(context, PersonalRouter.person, replace: true);
  }

  void _showAgreement(int state) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AgreementDialog(() {
              _isSelect = true;
              toNext(state);
            }));
  }

  // 0 手机号登录 1微信登录
  void toNext(int state) {
    if (state == 0) {
      if (_isSelect && _clickable) {
        _registerPresenter.register(
            _phoneController.text, _vCodeController.text, true);
      } else if (!_clickable) {
        if (_phoneController.text.isEmpty) {
          Toast.show("手机号无效");
        } else if (_vCodeController.text.isEmpty) {
          Toast.show("验证码无效");
        } else {
          Toast.show("输入有误");
        }
      } else if (!_isSelect) {
        // _showAgreement(state);
        toNext(state);
      }
    } else if (state == 1) {
      if (_isSelect) {
        FlutterToNative.jumpToWechatLogin()
            .then((value) => {_registerPresenter.getWxInfo(value)});
      } else {
        // Toast.show("请同意服务协议");
        // _showAgreement(state);
      }
    }
  }
}
