import 'package:Bubble/login/view/bind_phone_view.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../mvp/base_page.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/other_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_scroll_view.dart';
import '../../widgets/my_text_field.dart';
import '../entity/login_info_entity.dart';
import '../presenter/bind_phone_presenter.dart';
import '../presenter/change_bind_phone_presenter.dart';
import '../view/change_bind_phone_view.dart';

class ChangeBindPhonePage extends StatefulWidget {

  final LoginInfoDataData wechatData;

  const ChangeBindPhonePage(this.wechatData,{Key? key}) : super(key: key);

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

  void _bind(){
    _bindPhonePresenter.toBind(_phoneController.text, _vCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
        child:Scaffold(
          resizeToAvoidBottomInset:false,
          body: Container(
            height: ScreenUtil.getScreenH(context),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.color_00FFB4,
                    Colours.color_0E90FF,
                    Colours.color_DA2FFF,
                  ],
                )
            ),
            child: MyScrollView(
              keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
              children: _buildBody(),
            ),
          ),
        )
    );
  }


  List<Widget> _buildBody() {
    return <Widget>[
      const MyAppBar(
        centerTitle:  "换绑定手机号",
        backImgColor: Colors.white,
        backgroundColor: Colours.transflate,
      ),
      Container(
        padding: const EdgeInsets.only(left: 26.0, right: 26.0,),
        child: Column(
          children: [
            Gaps.vGap16,
            MyTextField(
              focusNode: _nodeText1,
              controller: _phoneController,
              maxLength: 11,
              keyboardType: TextInputType.phone,
              hintText: "请输入手机号",
            ),
            Gaps.vGap8,
            MyTextField(
              focusNode: _nodeText2,
              controller: _vCodeController,
              maxLength: 4,
              keyboardType: TextInputType.number,
              hintText: "请输入验证码",
              getVCode: () async {

                if(_bindPhonePresenter.data.phone.isEmpty){
                  return judgementPhone();
                }else{
                  if(_bindPhonePresenter.data.phone!=_phoneController.text){
                    Toast.show("请输入新手机号");
                    return false;
                  }else{
                    return judgementPhone();
                  }
                }


              },
            ),
            Gaps.vGap24,

            GestureDetector(
              onTap: (){
                if(_clickable){
                  _bind();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil.getScreenW(context),
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(100)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colours.color_DA2FFF,
                        Colours.color_0E90FF,
                        Colours.color_00FFB4,
                      ],
                    )),
                // child: Center(
                child: const Text(
                  "绑定",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),


      // MyButton(
      //   onPressed: _clickable ? _bind : null,
      //   text: "绑定",
      // ),
    ];
  }

  bool judgementPhone(){
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
