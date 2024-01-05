import 'package:Bubble/dialog/agreement_dialog.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/method/fluter_native.dart';
import 'package:Bubble/person/person_router.dart';
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
import 'package:Bubble/login/presenter/register_presenter.dart';
import '../../home/home_router.dart';
import '../../mvp/base_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage>
    with
        ChangeNotifierMixin<PhoneLoginPage>,
        BasePageMixin<PhoneLoginPage, RegisterPresenter>,
        AutomaticKeepAliveClientMixin<PhoneLoginPage>
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
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                padding: const EdgeInsets.only(left: 42, right: 42, top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text("手机号登录"),
                    Text(
                      "手机号登录",
                      style: TextStyle(
                          fontSize: Dimens.font_sp17, color: Colours.black),
                    ),
                    Gaps.vGap12,
                    // TextField(
                    //   controller: _phoneController,
                    //   autofocus: true,
                    //   // focusNode: TextInputType.phone,
                    //   style:
                    //       TextStyle(color: Color(0xFF333333), fontSize: 16.0),
                    //   maxLines: 1,
                    //   decoration: const InputDecoration.collapsed(
                    //       hintStyle: TextStyle(
                    //         color: Color(0xFF999999),
                    //         fontSize: 16.0,
                    //       ),
                    //       hintText: "输入手机号"),
                    //   onChanged: _accountFieldChanged,
                    // ),
                    Container(
                      height: Dimens.h_dp40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.h_dp40),
                        color: Colors.white70,
                      ),
                      child: Row(
                        children: [
                          Gaps.hGap16,
                          Text(
                            "+86",
                            style: TextStyle(
                                color: Colours.color_9BA9BE,
                                fontSize: Dimens.font_sp18),
                          ),
                          Gaps.hGap16,
                          Expanded(
                            child: MyTextField(
                              key: const Key('phone'),
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
                              hintText: "输入手机号",
                              underLineColor: Colours.color_00,
                              countDownColor: Colours.color_001652,
                            ),
                          ),
                          Gaps.hGap16,
                        ],
                      ),
                    ),
                    Gaps.vGap24,
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "未注册手机号验证后生成新账号",
                        style: TextStyle(
                            color: Colours.color_001652, fontSize: 13),
                      ),
                    ),
                    // Gaps.vGap50,
                    const Expanded(child: Gaps.empty),
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
                            "我以阅读并同意",
                            style: TextStyle(
                                fontSize: Dimens.font_sp12,
                                color: Colours.black),
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
                            "和",
                            style: TextStyle(
                                fontSize: Dimens.font_sp12,
                                color: Colours.color_546092),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtils.goWebViewPage(context, "服务协议",
                                  "http://www.shenmo-ai.com/tos/");
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
                    Gaps.vGap24,
                    GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(context,
                              "${LoginRouter.keyCheckCodePage}?PhoneNumber=18611667447");
                        },
                        child: Container(
                          height: Dimens.h_dp40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.h_dp40),
                            color: Colors.white70,
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              "发送短信验证",
                              style: TextStyle(
                                  color: Colours.color_001652,
                                  fontSize: Dimens.font_sp18),
                            ),
                          ),
                        )),
                    Gaps.vGap80,
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "其他登录方式",
                        style: TextStyle(
                            color: Colours.color_001652, fontSize: 13),
                      ),
                    ),
                    Gaps.vGap20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const LoadAssetImage(
                            "wechat_login_img",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Gaps.hGap16,
                        GestureDetector(
                          onTap: () {},
                          child: const LoadAssetImage(
                            "qq_login_img",
                            width: 40,
                            height: 40,
                          ),
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
    // if (widget.isKeyLogin) {
    //   Constant.jverify.dismissLoginAuthView();
    //   hideLoading();
    // }

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

  void _accountFieldChanged(String str) {}
}
