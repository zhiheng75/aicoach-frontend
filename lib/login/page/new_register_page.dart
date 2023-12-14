import 'package:Bubble/login/entity/wx_info_entity.dart';
import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../home/home_router.dart';
import '../../method/fluter_native.dart';
import '../../mvp/base_page.dart';
import '../../util/image_utils.dart';
import '../../widgets/my_text_field.dart';
import '../../person/person_router.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/toast_utils.dart';
import '../../widgets/my_only_img_bar.dart';
import '../entity/login_info_entity.dart';
import '../entity/user_info_entity.dart';
import '../login_router.dart';

class NewRegisterPage extends StatefulWidget {
  const NewRegisterPage({Key? key}) : super(key: key);

  @override
  State<NewRegisterPage> createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage>
    with
        ChangeNotifierMixin<NewRegisterPage>,
        BasePageMixin<NewRegisterPage, RegisterPresenter>,

        AutomaticKeepAliveClientMixin<NewRegisterPage>
    implements
        RegisterView {


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
          value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset:false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage(
                      "login_bg_img"),
                  fit: BoxFit.fill)),
          child: Column(
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
                    child:
                    Column(
                      children:
                      _buildBody()
                      ,
                    ),
                  )


              //     MyScrollView(
              //   keyboardConfig: Utils.getKeyboardActionsConfig(
              //       context, <FocusNode>[_nodeText1]),
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   padding:
              //       const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              //   children: _buildBody(),
              // )
              )
            ],
          ),
        ),
      )

      ,);
  }

  List<Widget> _buildBody(){
    return <Widget>[
      Gaps.vGap80,
      Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            // NavigatorUtils.push(context, LoginRouter.onlySmsPage);
          },
          child:const LoadAssetImage("login_logo_img",width: 180,height: 67,),
          // const Text(
          //   "Bubble",
          //   style: TextStyles.textBold26,
          // ),
        ),
      ),
      Gaps.vGap85,
      Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          "手机号登录",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      Row(
        children: [
          const Text("+86 >",style: TextStyles.text20_white,),
          Gaps.hGap10,
          Expanded(child:MyTextField(
            key: const Key('phone'),
            txtStyle:const TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),
            hintStyle: const TextStyle(fontSize: 26,color: Colours.color_4ED7FF),
            focusNode: _nodeText1,
            controller: _phoneController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "输入手机号",
            underLineColor: Colors.transparent,
          ) ),
        ],
      ),
      const Divider(color: Colors.white,height: 0.4,),
      MyTextField(
        focusNode: _nodeText2,
        txtStyle:const TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 26,color: Colours.color_4ED7FF),
        underLineColor: Colors.transparent,
        controller: _vCodeController,
        maxLength: 4,
        keyboardType: TextInputType.number,
        hintText: "输入验证码",
        getVCode: () async {
          if (_phoneController.text.length == 11) {
            _registerPresenter.sendSms(_phoneController.text.trim(),true);
            return true;
          } else {
            Toast.show("手机号无效");
            return false;
          }
        },
      ),
      const Divider(color: Colors.white,height:0.4,),
      Gaps.vGap10,
      Container(
        alignment: Alignment.centerLeft,
        child: const Text("未注册手机号验证后生成新账号",style: TextStyle(color: Colors.white,fontSize: 13),),
      ),
      // Gaps.vGap50,
      const Expanded(child: Gaps.empty),

      GestureDetector(
        onTap: (){
          if(_isSelect&&_clickable){
            _registerPresenter.register(_phoneController.text, _vCodeController.text,true);

          }else if(!_clickable){
            if(_phoneController.text.isEmpty){
              Toast.show("手机号无效");
            }else if(_phoneController.text.isEmpty) {
              Toast.show("验证码无效");
            }else{
              Toast.show("输入有误");
            }

          }else if(!_isSelect){
            Toast.show("请同意服务协议");
          }

        },
        child: Container(
          alignment: Alignment.center,
          width: 300,
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
            "注册/登录",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Gaps.vGap15,
      GestureDetector(
        onTap: (){
          _isSelect = !_isSelect;
          setState(() {

          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: LoadAssetImage(
                _isSelect ? "select_img" : "unselect_img",
                width: 11,
                height: 11,
              ),
            ),
            Gaps.hGap10,
            const Text("我以阅读并同意 ", style: TextStyle(fontSize: 10,color: Colours.color_546092),),
            GestureDetector(
              onTap: () {
                NavigatorUtils.goWebViewPage(context, "隐私政策",
                    "http://www.shenmo-ai.com/privacy_policy/");
              },
              child: const Text("隐私政策", style: TextStyle(
                  fontSize: 10,color: Colours.color_546092, decoration: TextDecoration.underline)),
            ),
            const Text(" 和 ", style: TextStyle(fontSize: 10,color: Colours.color_546092),),
            GestureDetector(
              onTap: () {
                NavigatorUtils.goWebViewPage(
                    context, "服务协议", "http://www.shenmo-ai.com/tos/");
              },
              child: const Text("服务协议", style: TextStyle(color: Colours.color_546092,
                  fontSize: 10, decoration: TextDecoration.underline),),
            ),
          ],
        ) ,
      )
     ,
      Gaps.vGap26,
      const Text("其他登录方式",style: TextStyle(color: Colours.color_546092,fontSize: 13),),
      Gaps.vGap11,
      GestureDetector(
        onTap: () {

          if(_isSelect){
            FlutterToNative.jumpToWechatLogin().then((value) => {
              // _wechatCode = value,
              // Log.e("===========>$_wechatCode"),

              _registerPresenter.getWxInfo(value)
            });
          }else{
            Toast.show("请同意服务协议");
          }


              },
        child: const LoadAssetImage("wechat_login_img",width: 30,height: 30,),
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
    NavigatorUtils.push(context, HomeRouter.homePage,clearStack: true);
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
    NavigatorUtils.push(context, LoginRouter.bindPhonePage,arguments:data,replace: true);
  }

  @override
  void sendSmsSuccess() {
    NavigatorUtils.push(context, LoginRouter.onlySmsPage);
  }

  @override
  void loginSuccess() {


    // NavigatorUtils.push(context, HomeRouter.homePage,clearStack: true);
    NavigatorUtils.push(context, PersonalRouter.personalCenter,replace: true);
  }

}
