import 'package:Bubble/login/view/bind_phone_view.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../mvp/base_page.dart';
import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/image_utils.dart';
import '../../util/other_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load_image.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_only_img_bar.dart';
import '../../widgets/my_scroll_view.dart';
import '../../widgets/my_text_field.dart';
import '../entity/login_info_entity.dart';
import '../presenter/bind_phone_presenter.dart';
import '../presenter/change_bind_phone_presenter.dart';
import '../view/change_bind_phone_view.dart';

class ChangeBindPhonePage extends StatefulWidget {
  final LoginInfoDataData wechatData;

  const ChangeBindPhonePage(this.wechatData, {Key? key}) : super(key: key);

  @override
  State<ChangeBindPhonePage> createState() => _ChangeBindPhonePageState();
}

class _ChangeBindPhonePageState extends State<ChangeBindPhonePage>
    with
        ChangeNotifierMixin<ChangeBindPhonePage>,
        BasePageMixin<ChangeBindPhonePage, ChangeBindPhonePresenter>,
        AutomaticKeepAliveClientMixin<ChangeBindPhonePage>
    implements ChangeBindPhoneView {
  @override
  void initState() {
    super.initState();
    _bindPhonePresenter.data = widget.wechatData;
    if (_bindPhonePresenter.data.phone != null &&
        _bindPhonePresenter.data.phone.isNotEmpty) {
      _phoneController.text = _bindPhonePresenter.data.phone;
    }
  }

  late ChangeBindPhonePresenter _bindPhonePresenter;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _vCodeController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

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

  void _bind() {
    _bindPhonePresenter.toBind(_phoneController.text, _vCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colours.color_00E6D0,
                    Colours.color_006CFF,
                    Colours.color_D74DFF,
                  ],
                      stops: [
                    0.0,
                    0.2,
                    1
                  ])),
              child: Column(
                children: [
                  const MyAppBar(
                    centerTitle: "绑定手机号224933",
                    backImgColor: Colors.white,
                    backgroundColor: Colours.transflate,
                  ),
                  Expanded(
                      child: Container(
                    width: ScreenUtil.getScreenW(context),
                    height: 500,
                    padding: const EdgeInsets.only(
                        top: Dimens.gap_dp23,
                        left: Dimens.gap_dp28,
                        right: Dimens.gap_dp28,
                        bottom: Dimens.gap_dp40),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildBody(),
                    ),
                  ))
                ],
              )

              // MyScrollView(
              //   keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
              //   children: _buildBody(),
              // ),
              ),
        ));
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap30,
      MyTextField(
        focusNode: _nodeText1,
        txtStyle: const TextStyle(
            fontSize: 17,
            color: Colours.color_111B44,
            fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 17, color: Colours.color_B7BFD9),
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        underLineColor: Colours.color_5B8BD2,
        hintText: "输入手机号",
        countDownColor: Colours.color_546092,
        closeColor: Colours.color_546092,
      ),
      // const Divider(color: Colours.color_5B8BD2,height: 0.4,),
      Gaps.vGap20,
      MyTextField(
        focusNode: _nodeText2,
        txtStyle: const TextStyle(
            fontSize: 17,
            color: Colours.color_111B44,
            fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 17, color: Colours.color_B7BFD9),
        controller: _vCodeController,
        maxLength: 6,
        underLineColor: Colours.color_5B8BD2,
        keyboardType: TextInputType.number,
        countDownColor: Colours.color_546092,
        closeColor: Colours.color_546092,
        hintText: "输入验证码",
        getVCode: () async {
          if (_phoneController.text.isNotEmpty) {
            if (_bindPhonePresenter.data.phone != _phoneController.text) {
              return judgementPhone();
            } else {
              Toast.show("请输入新手机号");
              return false;
            }
          } else {
            Toast.show("请输入手机号");
            return false;
          }
        },
      ),
      Gaps.vGap24,
      const Expanded(child: Gaps.empty),
      GestureDetector(
        onTap: () {
          if (_clickable) {
            _bind();
          } else {
            Toast.show("输入内容有误");
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: 400,
          height: 46,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageUtils.getAssetImage(
                  "login_out_bg_img",
                ),
                fit: BoxFit.fill),
          ),
          // child: Center(
          child: const Text(
            "绑定",
            style: TextStyle(color: Colours.color_3389FF, fontSize: 16),
          ),
        ),
      ),

      // MyButton(
      //   onPressed: _clickable ? _bind : null,
      //   text: "绑定",
      // ),
    ];
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
  ChangeBindPhonePresenter createPresenter() {
    _bindPhonePresenter = ChangeBindPhonePresenter();
    return _bindPhonePresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    Toast.show(msg);
  }

  @override
  void sendSuccess(String msg) {
    Toast.show(msg);
  }

  @override
  void bindFail(String msg) {
    Toast.show(msg);
  }

  @override
  void bindSuccess(String msg) {
    Toast.show(msg);
    NavigatorUtils.goBackWithParams(context, msg);
  }
}
