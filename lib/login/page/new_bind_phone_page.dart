import 'package:Bubble/login/entity/login_info_entity.dart';
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

class NewBindPhonePage extends StatefulWidget {
  final LoginInfoDataData wechatData;

  const NewBindPhonePage({Key? key, required this.wechatData})
      : super(key: key);

  @override
  State<NewBindPhonePage> createState() => _NewBindPhonePageState();
}

class _NewBindPhonePageState extends State<NewBindPhonePage>
    with
        ChangeNotifierMixin<NewBindPhonePage>,
        BasePageMixin<NewBindPhonePage, BindPhonePresenter>,
        AutomaticKeepAliveClientMixin<NewBindPhonePage>
    implements BindPhoneView {
  // final bool isKeyLogin = false;
  late BindPhonePresenter _bindPhonePresenter;

  bool _isSelect = false;

  //定义一个controller
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  // final FocusNode _nodeText2 = FocusNode();

  String typeLogin = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              typeLogin == "1"
                  ? Gaps.vGap12
                  : MyOnlyImgBar(
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
                padding: EdgeInsets.only(
                    left: 42,
                    right: 42,
                    top: typeLogin == "1" ? Dimens.h_dp168 : Dimens.h_dp60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "绑定手机号",
                      style: TextStyle(
                          fontSize: Dimens.font_sp17, color: Colours.black),
                    ),
                    Gaps.vGap12,
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "根据国家网络安全法要求，需完成手机号绑定才能使用本产品。",
                        style: TextStyle(
                            color: Colours.color_001652, fontSize: 13),
                      ),
                    ),
                    Gaps.vGap12,
                    Container(
                      height: Dimens.h_dp40,
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
                          typeLogin == "1" ? Gaps.hGap4 : Gaps.hGap16,
                          Expanded(
                            child: Center(
                              child: typeLogin == "1"
                                  ? Text(
                                      "186****1111",
                                      style: TextStyle(
                                          color: Colours.color_001652,
                                          fontSize: Dimens.font_sp18),
                                    )
                                  : MyTextField(
                                      key: const Key('phone'),
                                      txtStyle: const TextStyle(
                                        fontSize: 20,
                                        color: Colours.color_001652,
                                      ),
                                      hintStyle: const TextStyle(
                                          fontSize: 20,
                                          color: Colours.color_001652),
                                      focusNode: _nodeText1,
                                      controller: _phoneController,
                                      maxLength: 11,
                                      keyboardType: TextInputType.phone,
                                      hintText: "输入手机号",
                                      underLineColor: Colours.color_00,
                                      countDownColor: Colours.color_001652,
                                    ),
                            ),
                          ),
                          Gaps.hGap16,
                        ],
                      ),
                    ),
                    Gaps.vGap12,
                    typeLogin == "1"
                        ? Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "中国联通认证",
                              style: TextStyle(
                                  color: Colours.color_001652, fontSize: 13),
                            ),
                          )
                        : Gaps.vGap12,
                    const Expanded(child: Gaps.empty),
                    GestureDetector(
                        onTap: () {
                          // NavigatorUtils.push(
                          //   context,
                          //   LoginRouter.phoneLoginPage,
                          // );
                          judgementPhone();
                          NavigatorUtils.push(
                              context,
                              arguments: widget.wechatData,
                              "${LoginRouter.keyCheckCodePage}?PhoneNumber=${widget.wechatData.phone}&typeLogin=2");
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
                              typeLogin == "1" ? "绑定手机号" : "下一步",
                              style: TextStyle(
                                  color: Colours.color_001652,
                                  fontSize: Dimens.font_sp18),
                            ),
                          ),
                        )),
                    Gaps.vGap12,
                    typeLogin == "1"
                        ? GestureDetector(
                            onTap: () {
                              NavigatorUtils.push(
                                context,
                                "${LoginRouter.newBindPhonePage}?needKeyLogin=0",
                              );
                            },
                            child: SizedBox(
                              height: Dimens.h_dp20,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(Dimens.h_dp40),
                              //   color: Colors.white70,
                              //   border: Border.all(width: 1, color: Colors.black),
                              // ),
                              child: Center(
                                child: Text(
                                  "绑定其他手机号",
                                  style: TextStyle(
                                      color: Colours.color_001652,
                                      fontSize: Dimens.font_sp12),
                                ),
                              ),
                            ))
                        : Gaps.vGap20,
                    Gaps.vGap80,
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

  bool judgementPhone() {
    if (_phoneController.text.length == 11) {
      _bindPhonePresenter.sendSms(_phoneController.text.trim());
      return true;
    } else {
      Toast.show("手机号无效");
      return false;
    }
  }

  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    // TODO: implement changeNotifier
    throw UnimplementedError();
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
