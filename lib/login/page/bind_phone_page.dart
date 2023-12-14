import 'package:Bubble/login/view/bind_phone_view.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../mvp/base_page.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/image_utils.dart';
import '../../util/other_utils.dart';
import '../../util/toast_utils.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_only_img_bar.dart';
import '../../widgets/my_scroll_view.dart';
import '../../widgets/my_text_field.dart';
import '../entity/login_info_entity.dart';
import '../presenter/bind_phone_presenter.dart';

class BindPhonePage extends StatefulWidget {

  final LoginInfoDataData wechatData;

  const BindPhonePage(this.wechatData,{Key? key}) : super(key: key);

  @override
  State<BindPhonePage> createState() => _BindPhonePageState();
}

class _BindPhonePageState extends State<BindPhonePage>
    with
        ChangeNotifierMixin<BindPhonePage>,
        BasePageMixin<BindPhonePage, BindPhonePresenter>,
        AutomaticKeepAliveClientMixin<BindPhonePage>
    implements BindPhoneView {

  @override
  void initState() {
    super.initState();
    _bindPhonePresenter.data = widget.wechatData;
  }

  late BindPhonePresenter _bindPhonePresenter;

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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage(
                        "login_bg_img"),
                    fit: BoxFit.fill)),
            child:Column(

              children: [
                MyOnlyImgBar(
                    backgroundColor: Colours.transflate,
                    width: 17.0,
                    height: 17.0,
                    actionUrl: "white_close_img",
                    onActionPress: () {
                      NavigatorUtils.goBack(context);
                    }),
                  Expanded(
                      child: Container(
                        padding:const EdgeInsets.only(left: 42,right: 42),
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
            //   padding: const EdgeInsets.only(left: 16.0, right: 16.0,),
            //   children: _buildBody(),
            // ),
          ),
        )
    );
  }


  List<Widget> _buildBody() {
    return <Widget>[
      // const MyAppBar(
      //   backImgColor: Colors.white,
      //   backgroundColor: Colours.transflate,
      // ),
      Gaps.vGap80,
      const LoadAssetImage("login_logo_img",width: 180,height: 67,),
      Gaps.vGap85,
      const Text(
        "绑定手机号",
        style: TextStyles.text20_white,
      ),
      const Text("根据国家网络安全法要求，需完成手机号绑定才能使用本产品。",style: TextStyle(fontSize: 13,color: Colors.white),),
      Gaps.vGap26,
      Row(
        children: [
          const Text(
            "+86 >",
            style: TextStyles.text20_white,
          ),
          Gaps.hGap10,
          Expanded(
              child: MyTextField(
            focusNode: _nodeText1,
            txtStyle: const TextStyle(
                fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            hintStyle:
                const TextStyle(fontSize: 26, color: Colours.color_4ED7FF),
            controller: _phoneController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "输入手机号",
          )),
        ],
      ),
      const Divider(color: Colors.white,height: 0.4,),
      Gaps.vGap10,
      MyTextField(
        focusNode: _nodeText2,
        txtStyle:const TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 26,color: Colours.color_4ED7FF),
        controller: _vCodeController,
        maxLength: 4,
        keyboardType: TextInputType.number,
        hintText: "输入验证码",
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
  BindPhonePresenter createPresenter() {
    _bindPhonePresenter = BindPhonePresenter();
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
  void wechatLoginFail(String msg) {
    Toast.show(msg);
  }

  @override
  void wechatLoginSuccess(String msg) {
    Toast.show(msg);
    NavigatorUtils.push(context, PersonalRouter.personalCenter,replace: true);
  }


}
