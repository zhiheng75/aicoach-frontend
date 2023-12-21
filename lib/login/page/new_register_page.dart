import 'dart:io';

import 'package:Bubble/login/presenter/register_presenter.dart';
import 'package:Bubble/login/view/register_view.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
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

  List<JVCustomWidget> jgListWidget = [];

  /// 统一 key
  final String f_result_key = "result";

  /// 错误码
  final String f_code_key = "code";

  /// 回调的提示信息，统一返回 flutter 为 message
  final String f_msg_key = "message";

  /// 运营商信息
  final String f_opr_key = "operator";

  String _result = "token=";

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
    if(widget.isKeyLogin){
      loginAuth();
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
      Gaps.vGap80,
      Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          "手机号登录",
          style: TextStyle(fontSize: 26, color: Colors.white,fontWeight: FontWeight.bold),
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
        txtStyle:const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 20,color: Colours.color_4ED7FF),
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: "输入手机号",
        underLineColor: Colors.transparent,
      ),
      Gaps.vGap15,
      MyTextField(
        focusNode: _nodeText2,
        txtStyle:const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 20,color: Colours.color_4ED7FF),
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

          // toNext(0);
        },
        child: Container(

          height: 46,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage(
                      "purchase_btn_img"),
                  fit: BoxFit.fill)),
          child: const Center(
            child: Text(
              "注册/登录",
              style: TextStyle(
                  color: Colors.white, fontSize: 16),
            ),
          ),
        )
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
          // toNext(1);
          if(_isSelect){

            if(Device.isAndroid){
              FlutterToNative.jumpToWechatLogin().then((value) => {
                // _wechatCode = value,
                // Log.e("===========>$_wechatCode"),
                _registerPresenter.getWxInfo(value)
              });
            }else{

            }


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
    NavigatorUtils.push(context, LoginRouter.changeBindPhonePage,arguments:data,replace: true);
  }

  @override
  void sendSmsSuccess() {
    NavigatorUtils.push(context, LoginRouter.onlySmsPage);
  }

  @override
  void loginSuccess() {

    if(widget.isKeyLogin){
      Constant.jverify.dismissLoginAuthView();
      hideLoading();
    }

    NavigatorUtils.push(context, PersonalRouter.personalCenter,replace: true);
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
  void toNext(int state){
    if(state==0){
      if(_isSelect&&_clickable){
        _registerPresenter.register(_phoneController.text, _vCodeController.text,true);

      }else if(!_clickable){
        if(_phoneController.text.isEmpty){
          Toast.show("手机号无效");
        }else if(_vCodeController.text.isEmpty) {
          Toast.show("验证码无效");
        }else{
          Toast.show("输入有误");
        }

      }else if(!_isSelect){

        // _showAgreement(state);
        toNext(state);
      }
    }else if(state==1){
      if(_isSelect){
        FlutterToNative.jumpToWechatLogin().then((value) => {

          _registerPresenter.getWxInfo(value)
        });
      }else{
        // Toast.show("请同意服务协议");
        // _showAgreement(state);
      }
    }

  }



  /// SDK 请求授权一键登录
  void loginAuth() {
    showProgress();
    Constant.jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        final screenSize = MediaQuery.of(context).size;
        final screenWidth = screenSize.width;
        final screenHeight = screenSize.height;
        bool isiOS = Platform.isIOS;

        /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
        /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
        /// ios项目存放在 Assets.xcassets。
        ///
        JVUIConfig uiConfig = JVUIConfig();
        uiConfig.navColor = Colors.transparent.value;
        uiConfig.navText = "";
        uiConfig.navTextColor = Colors.blue.value;
        uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
        uiConfig.authBackgroundImage = "login_bg_img";
        uiConfig.logoWidth = 200;
        uiConfig.logoHeight = 80;
        uiConfig.statusBarDarkMode = false;
        uiConfig.logoOffsetY = 100;
        uiConfig.logoOffsetX = 35;
        uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.logoHidden = false;
        uiConfig.logoImgPath = "login_logo_img";

        uiConfig.numberFieldWidth = 200;
        uiConfig.numberFieldHeight = 40;
        uiConfig.numFieldOffsetY = 280;
        uiConfig.numFieldOffsetX = 25;
        uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
        uiConfig.numberColor = Colors.white.value;
        uiConfig.numberSize = 35;


        uiConfig.sloganOffsetY = 480;
        uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
        uiConfig.sloganTextColor = Colours.color_546092.value;
        uiConfig.sloganTextSize = 15;

        uiConfig.logBtnWidth = 320;
        uiConfig.logBtnHeight = 50;
        uiConfig.logBtnOffsetY = 520;
        uiConfig.logBtnBackgroundPath = "purchase_btn_img";
        uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
        uiConfig.logBtnText = "本机号码一键登录";
        uiConfig.logBtnTextColor = Colors.white.value;
        uiConfig.logBtnTextSize = 16;
        uiConfig.loginBtnNormalImage = "purchase_btn_img"; //图片必须存在
        uiConfig.loginBtnPressedImage = "purchase_btn_img"; //图片必须存在
        uiConfig.loginBtnUnableImage = "purchase_btn_img"; //图片必须存在

        uiConfig.privacyHintToast = true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。

        uiConfig.privacyState = true; //设置默认勾选
        uiConfig.privacyCheckboxSize = 14;
        uiConfig.checkedImgPath = "select_img"; //图片必须存在
        uiConfig.uncheckedImgPath = "unselect_img"; //图片必须存在
        uiConfig.privacyCheckboxInCenter = false;
        uiConfig.privacyCheckboxHidden = false;

        uiConfig.privacyOffsetX = 50;
        uiConfig.privacyOffsetY = 90; // 距离底部距离
        uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.clauseName = "《隐私政策》";
        uiConfig.clauseUrl = "http://www.shenmo-ai.com/privacy_policy/";
        uiConfig.clauseBaseColor = Colours.color_546092.value;
        uiConfig.clauseNameTwo = "《服务协议》";
        uiConfig.clauseUrlTwo = "http://www.shenmo-ai.com/tos/";
        uiConfig.clauseColor = Colours.color_546092.value;
        uiConfig.privacyTextSize = 12;
        uiConfig.privacyWithBookTitleMark = true;
        uiConfig.privacyTextCenterGravity = true;
        uiConfig.authStatusBarStyle = JVIOSBarStyle.StatusBarStyleDarkContent;
        uiConfig.privacyStatusBarStyle = JVIOSBarStyle.StatusBarStyleDefault;
        uiConfig.modelTransitionStyle =
            JVIOSUIModalTransitionStyle.CrossDissolve;

        uiConfig.statusBarColorWithNav = true;
        uiConfig.virtualButtonTransparent = true;

        uiConfig.privacyStatusBarColorWithNav = true;
        uiConfig.privacyVirtualButtonTransparent = true;

        uiConfig.needStartAnim = true;
        uiConfig.needCloseAnim = true;
        uiConfig.enterAnim = "activity_slide_enter_bottom";
        uiConfig.exitAnim = "activity_slide_exit_bottom";

        /// 添加自定义的 控件 到授权界面
        jgListWidget.add(otherNumberLoginType());
        jgListWidget.add(tipsWidget());


        /// 步骤 1：调用接口设置 UI
        Constant.jverify.setCustomAuthorizationView(true, uiConfig,
            landscapeConfig: uiConfig, widgets: jgListWidget);

        /// 步骤 2：调用一键登录接口

        /// 先，添加 loginAuthSyncApi 接口回调的监听
        Constant.jverify.addLoginAuthCallBackListener((event) {
          // setState(() {

            _result = "监听获取返回数据：[${event.code}] message = ${event.message}";
          // });
          Log.d(
              "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          if (event.code == 6000) {
            showLoading(context);
            _registerPresenter.sendKeyLoginToken(event.message);
          } else {
            Toast.show(event.message);
          }
        });

        /// 再，执行同步的一键登录接口
        Constant.jverify.loginAuthSyncApi(autoDismiss: false);
      } else {
        // setState(() {
        //   _result = "[2016],msg = 当前网络环境不支持认证";
          Toast.show(_result);
        // });
      }
    });
  }

  //其他号码登录
  JVCustomWidget otherNumberLoginType(){
    const String btnWidgetId = "jv_add_custom_button";// 标识控件 id
    JVCustomWidget textWidget = JVCustomWidget(btnWidgetId, JVCustomWidgetType.button);
    textWidget.title = "其他登录方式";
    textWidget.left = 30;
    textWidget.top = 580 ;
    textWidget.width = 320;
    textWidget.height  = 45;
    textWidget.titleColor = Colours.color_3389FF.value;
    textWidget.titleFont = 16;
    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.btnNormalImageName = "login_out_bg_img";
    textWidget.btnPressedImageName = "login_out_bg_img";
    textWidget.isClickEnable = true;

    Constant.jverify.addClikWidgetEventListener(btnWidgetId, (eventId) {
      if (btnWidgetId == eventId) {
        NavigatorUtils.push(context, LoginRouter.loginPage);
        Constant.jverify.dismissLoginAuthView();
      }
    });
    return textWidget;

  }

  //登录及注册文案
  JVCustomWidget tipsWidget(){
    const String txtWidget = "jv_add_custom_txt1";// 标识控件 id
    JVCustomWidget textWidget = JVCustomWidget(txtWidget, JVCustomWidgetType.textView);
    textWidget.title = "未注册手机号验证后生成新账户";
    textWidget.left = 25;
    textWidget.top = 315 ;
    textWidget.width = 200;
    textWidget.height  = 40;
    textWidget.titleFont = 13;
    textWidget.backgroundColor = Colors.transparent.value;
    textWidget.titleColor = Colors.white.value;
    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.isClickEnable = false;
    return textWidget;
  }

}
