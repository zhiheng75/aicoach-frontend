import 'dart:io';

import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jverify/jverify.dart';

import '../../constant/constant.dart';
import '../../mvp/base_page.dart';
import '../../person/person_router.dart';
import '../../res/colors.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/image_utils.dart';
import '../../util/toast_utils.dart';
import '../login_router.dart';
import '../presenter/one_key_login_presenter.dart';
import '../view/one_key_login_view.dart';

class KeyLoginPage extends StatefulWidget {
  const KeyLoginPage({Key? key}) : super(key: key);

  @override
  State<KeyLoginPage> createState() => _KeyLoginPageState();
}

class _KeyLoginPageState extends State<KeyLoginPage>
    with
        BasePageMixin<KeyLoginPage, OneKeyLoginPresenter>,
        AutomaticKeepAliveClientMixin<KeyLoginPage>
    implements OneKeyLoginView{

  late OneKeyLoginPresenter _presenter;

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



  @override
  void initState() {
    super.initState();
    loginAuth();
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
          ),
        )
    );
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
          setState(() {
            showProgress();
            _result = "监听获取返回数据：[${event.code}] message = ${event.message}";
          });
          Log.d(
              "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          if (event.code == 6000) {
            _presenter.sendKeyLoginToken(event.message);
          } else {
            Toast.show(event.message);
          }
        });

        /// 再，执行同步的一键登录接口
        Constant.jverify.loginAuthSyncApi(autoDismiss: false);
      } else {
        setState(() {
          closeProgress();
          _result = "[2016],msg = 当前网络环境不支持认证";
          Toast.show(_result);
        });
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

  @override
  OneKeyLoginPresenter createPresenter() {
    _presenter = OneKeyLoginPresenter();
    return _presenter;
  }

  @override
  void loginSuccess() {
    Constant.jverify.dismissLoginAuthView();
    Toast.show("登录成功");
    NavigatorUtils.push(context, PersonalRouter.person,replace: true);
  }

  @override

  bool get wantKeepAlive => true;
}
