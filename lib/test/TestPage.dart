import 'dart:io';

import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:jverify/jverify.dart';

import '../widgets/load.dart';
import '../login/presenter/one_key_login_presenter.dart';
import '../login/view/one_key_login_view.dart';
import '../mvp/base_page.dart';

class Testpage extends StatefulWidget {
  const Testpage({Key? key}) : super(key: key);

  @override
  State<Testpage> createState() => _TestpageState();
}

class _TestpageState extends State<Testpage>  with
    BasePageMixin<Testpage, OneKeyLoginPresenter>,
    AutomaticKeepAliveClientMixin<Testpage>
    implements OneKeyLoginView {

  late OneKeyLoginPresenter _presenter;

  /// 统一 key
  final String f_result_key = "result";

  /// 错误码
  final String f_code_key = "code";

  /// 回调的提示信息，统一返回 flutter 为 message
  final String f_msg_key = "message";

  /// 运营商信息
  final String f_opr_key = "operator";

  String _result = "token=";
  var controllerPHone =  TextEditingController();
  final Jverify jverify =  Jverify();
  String? _token;


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('JVerify example'),
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      widthFactor: 2,
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            color: Colors.brown,
            child: Text(_result),
            width: 300,
            height: 100,
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CustomButton(
                    onPressed: () {
                      isInitSuccess();
                    },
                    title: "初始化状态"),
                new Text("   "),
                new CustomButton(
                  onPressed: () {
                    checkVerifyEnable();
                  },
                  title: "网络环境是否支持",
                ),
              ],
            ),
          ),
          new Container(
            child: SizedBox(
              child: new CustomButton(
                onPressed: () {
                  getToken();
                },
                title: "获取号码认证 Token",
              ),
              width: double.infinity,
            ),
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
          ),
          new Container(
            child: TextField(
              autofocus: false,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "手机号码", hintStyle: TextStyle(color: Colors.black)),
              controller: controllerPHone,
            ),
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
          ),
          new Container(
            child: SizedBox(
              child: new CustomButton(
                onPressed: () {
                  preLogin();
                },
                title: "预取号",
              ),
              width: double.infinity,
            ),
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
          ),
          new Container(
            child: SizedBox(
              child: new CustomButton(
                onPressed: () {
                  loginAuth();
                },
                title: "一键登录",
              ),
              width: double.infinity,
            ),
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
          ),
          new Container(
            child: SizedBox(
              child: new CustomButton(
                onPressed: () {
                  getSMSCode();
                },
                title: "获取验证码",
              ),
              width: double.infinity,
            ),
            margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }


  /// sdk 初始化是否完成
  void isInitSuccess() {
    jverify.isInitSuccess().then((map) {
      bool result = map[f_result_key];
      setState(() {
        if (result) {
          _result = "sdk 初始换成功";
        } else {
          _result = "sdk 初始换失败";
        }
      });
    });
  }

  /// 判断当前网络环境是否可以发起认证
  void checkVerifyEnable() {
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      setState(() {
        if (result) {
          _result = "当前网络环境【支持认证】！";
        } else {
          _result = "当前网络环境【不支持认证】！";
        }
      });
    });
  }

  /// 获取号码认证token
  void getToken() {
    setState(() {
      _showLoading(context);
    });
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.getToken().then((map) {
          int code = map[f_code_key];
          _token = map[f_msg_key];
          String operator = map[f_opr_key];
          setState(() {
            _hideLoading();
            _result = "[$code] message = $_token, operator = $operator";
          });
        });
      } else {
        setState(() {
          _hideLoading();
          _result = "[2016],msg = 当前网络环境不支持认证";
        });
      }
    });
  }

  /// 获取短信验证码
  void getSMSCode() {
    setState(() {
      _showLoading(context);
    });
    String phoneNum = controllerPHone.text;
    if (phoneNum == null || phoneNum.isEmpty) {
      setState(() {
        _hideLoading();
        _result = "[3002],msg = 没有输入手机号码";
      });
      return;
    }
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.getSMSCode(phoneNum: phoneNum).then((map) {
          print("获取短信验证码：${map.toString()}");
          int code = map[f_code_key];
          String message = map[f_msg_key];
          setState(() {
            _hideLoading();
            _result = "[$code] message = $message";
          });
        });
      } else {
        setState(() {
          _hideLoading();
          _result = "[3004],msg = 获取短信验证码异常";
        });
      }
    });
  }

  /// 登录预取号
  void preLogin() {
    setState(() {
      _showLoading(context);
    });
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.preLogin().then((map) {
          print("预取号接口回调：${map.toString()}");
          int code = map[f_code_key];
          String message = map[f_msg_key];
          setState(() {
            _hideLoading();
            _result = "[$code] message = $message";
          });
        });
      } else {
        setState(() {
          _hideLoading();
          _result = "[2016],msg = 当前网络环境不支持认证";
        });
      }
    });
  }

  void _showLoading(BuildContext context) {
    LoadingDialog.show(context);
  }

  void _hideLoading() {
    LoadingDialog.hidden();
  }

  /// SDK 请求授权一键登录
  void loginAuth() {
    setState(() {
      _showLoading(context);
    });
    jverify.checkVerifyEnable().then((map) {
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
        // uiConfig.authBGGifPath = "login_bg_img";

        //uiConfig.navHidden = true;
        uiConfig.navColor = Colors.transparent.value;
        // uiConfig.navColor = Colors.red.value;
        uiConfig.navText = "";
        uiConfig.navTextColor = Colors.blue.value;
        uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
        uiConfig.authBackgroundImage = "login_bg_img";
        uiConfig.logoWidth = 200;
        uiConfig.logoHeight = 80;
        uiConfig.statusBarDarkMode = false;
        //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
        uiConfig.logoOffsetY = 100;
        uiConfig.logoOffsetX = 35;
        uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.logoHidden = false;
        uiConfig.logoImgPath = "login_logo_img";

        uiConfig.numberFieldWidth = 200;
        uiConfig.numberFieldHeight = 40;
        //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
        // uiConfig.numFieldOffsetY = isiOS ? 20 : 120;
        uiConfig.numFieldOffsetY = 280;
        uiConfig.numFieldOffsetX = 25;
        uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
        uiConfig.numberColor = Colors.white.value;
        uiConfig.numberSize = 35;



        // uiConfig.sloganOffsetY = isiOS ? 20 : 160;
        uiConfig.sloganOffsetY = 480;
        uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
        uiConfig.sloganTextColor = Colours.color_546092.value;
        uiConfig.sloganTextSize = 15;
//        uiConfig.slogan
        //uiConfig.sloganHidden = 0;

        uiConfig.logBtnWidth = 320;
        uiConfig.logBtnHeight = 50;
        //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
        // uiConfig.logBtnOffsetY = isiOS ? 20 : 230;
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

        //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
        uiConfig.privacyOffsetX = 50;
        uiConfig.privacyOffsetY = 90; // 距离底部距离
        uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.clauseName = "《隐私政策》";
        uiConfig.clauseUrl = "http://www.shenmo-ai.com/privacy_policy/";
        uiConfig.clauseBaseColor = Colours.color_546092.value;
        uiConfig.clauseNameTwo = "《服务协议》";
        uiConfig.clauseUrlTwo = "http://www.shenmo-ai.com/tos/";
        uiConfig.clauseColor = Colours.color_546092.value;
        // uiConfig.privacyText = ["1极", "2光", "3认", "4证"];
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


        // uiConfig.privacyNavColor = Colors.red.value;
        // uiConfig.privacyNavTitleTextColor = Colors.blue.value;
        // uiConfig.privacyNavTitleTextSize = 16;

        // uiConfig.privacyNavTitleTitle = "ios lai le"; //only ios
        // uiConfig.privacyNavTitleTitle1 = "协议11 web页标题";
        // uiConfig.privacyNavTitleTitle2 = "协议22 web页标题";
        // uiConfig.privacyNavReturnBtnImage = "return_bg"; //图片必须存在;

        //弹框模式
        // JVPopViewConfig popViewConfig = JVPopViewConfig();
        // popViewConfig.width = (screenWidth - 100.0).toInt();
        // popViewConfig.height = (screenHeight - 150.0).toInt();
        //
        // uiConfig.popViewConfig = popViewConfig;

        /// 添加自定义的 控件 到授权界面
        List<JVCustomWidget> widgetList = [

          otherNumberLoginType(),
          tipsWidget(),
          // otherLoginTypeTxt(),
          // wechatLogin(),
        ];

        /// 步骤 1：调用接口设置 UI
        jverify.setCustomAuthorizationView(true, uiConfig,
            landscapeConfig: uiConfig, widgets: widgetList);

        /// 步骤 2：调用一键登录接口

        /// 方式一：使用同步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
        /// 先，添加 loginAuthSyncApi 接口回调的监听
        jverify.addLoginAuthCallBackListener((event) {
          setState(() {
            _hideLoading();
            _result = "监听获取返回数据：[${event.code}] message = ${event.message}";
          });
          print(
              "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          if (event.code == 6000) {
            // if(_isClickOther){
            //   jverify.dismissLoginAuthView();
            //   NavigatorUtils.push(context, LoginRouter.loginPage);
            // }else{
              _presenter.sendKeyLoginToken(event.message);
            // }

          } else {}
        });

        /// 再，执行同步的一键登录接口
        jverify.loginAuthSyncApi(autoDismiss: false);
      } else {
        setState(() {
          _hideLoading();
          _result = "[2016],msg = 当前网络环境不支持认证";
        });

        /*
        final String text_widgetId = "jv_add_custom_text";// 标识控件 id
        JVCustomWidget textWidget = JVCustomWidget(text_widgetId, JVCustomWidgetType.textView);
        textWidget.title = "新加 text view 控件";
        textWidget.left = 20;
        textWidget.top = 360 ;
        textWidget.width = 200;
        textWidget.height  = 40;
        textWidget.backgroundColor = Colors.yellow.value;
        textWidget.isShowUnderline = true;
        textWidget.textAlignment = JVTextAlignmentType.center;
        textWidget.isClickEnable = true;

        // 添加点击事件监听
        jverify.addClikWidgetEventListener(text_widgetId, (eventId) {
          print("receive listener - click widget event :$eventId");
          if (text_widgetId == eventId) {
            print("receive listener - 点击【新加 text】");
          }
        });
        widgetList.add(textWidget);

        final String btn_widgetId = "jv_add_custom_button";// 标识控件 id
        JVCustomWidget buttonWidget = JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
        buttonWidget.title = "新加 button 控件";
        buttonWidget.left = 100;
        buttonWidget.top = 400;
        buttonWidget.width = 150;
        buttonWidget.height  = 40;
        buttonWidget.isShowUnderline = true;
        buttonWidget.backgroundColor = Colors.brown.value;
        //buttonWidget.btnNormalImageName = "";
        //buttonWidget.btnPressedImageName = "";
        //buttonWidget.textAlignment = JVTextAlignmentType.left;

        // 添加点击事件监听
        jverify.addClikWidgetEventListener(btn_widgetId, (eventId) {
          print("receive listener - click widget event :$eventId");
          if (btn_widgetId == eventId) {
            print("receive listener - 点击【新加 button】");
          }
        });
        widgetList.add(buttonWidget);
        */

        /* 弹框模式
        JVPopViewConfig popViewConfig = JVPopViewConfig();
        popViewConfig.width = (screenWidth - 100.0).toInt();
        popViewConfig.height = (screenHeight - 150.0).toInt();

        uiConfig.popViewConfig = popViewConfig;
        */

        /*

        /// 方式二：使用异步接口 （如果想使用异步接口，则忽略此步骤，看方式二）

        /// 先，执行异步的一键登录接口
        jverify.loginAuth(true).then((map) {

          /// 再，在回调里获取 loginAuth 接口异步返回数据（如果是通过添加 JVLoginAuthCallBackListener 监听来获取返回数据，则忽略此步骤）
          int code = map[f_code_key];
          String content = map[f_msg_key];
          String operator = map[f_opr_key];
          setState(() {
           _hideLoading();
            _result = "接口异步返回数据：[$code] message = $content";
          });
          print("通过接口异步返回，获取到 loginAuth 接口返回数据，code=$code,message = $content,operator = $operator");
        });

        */

      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // 初始化 SDK 之前添加监听
    jverify.addSDKSetupCallBackListener((JVSDKSetupEvent event) {
      print("receive sdk setup call back event :${event.toMap()}");
    });

    jverify.setDebugMode(true); // 打开调试模式
    jverify.setup(
        appKey: "0846276bad587d5808701213", //"你自己应用的 AppKey",
        channel: "devloper-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// 授权页面点击时间监听
    jverify.addAuthPageEventListener((JVAuthPageEvent event) {
      print("receive auth page event :${event.toMap()}");
    });
  }

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

    jverify.addClikWidgetEventListener(btnWidgetId, (eventId) {
      if (btnWidgetId == eventId) {
        NavigatorUtils.push(context, LoginRouter.loginPage);
        jverify.dismissLoginAuthView();
      }
    });
    return textWidget;

  }


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

  JVCustomWidget otherLoginTypeTxt(){
    const String btnWidgetId = "jv_add_custom_txt2";// 标识控件 id
    JVCustomWidget textWidget = JVCustomWidget(btnWidgetId, JVCustomWidgetType.textView);
    textWidget.title = "其他方式登录";
    textWidget.left = 20;
    textWidget.top = 620 ;
    textWidget.width = 400;
    textWidget.height  = 60;
    textWidget.titleColor = Colours.color_3389FF.value;
    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.btnNormalImageName = "purchase_btn_img";
    textWidget.isClickEnable = true;
    return textWidget;
  }


  JVCustomWidget wechatLogin(){
    const String btnWidgetId = "jv_add_custom_button";// 标识控件 id
    JVCustomWidget textWidget = JVCustomWidget(btnWidgetId, JVCustomWidgetType.button);

    textWidget.left = 20;
    textWidget.top = 650 ;
    textWidget.width = 100;
    textWidget.height  = 60;

    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.btnNormalImageName = "wechat_login_img";
    textWidget.isClickEnable = true;

    jverify.addClikWidgetEventListener(btnWidgetId, (eventId) {
      print("receive listener - click widget event :$eventId");
      if (btnWidgetId == eventId) {
        Toast.show("去登录页面");
      }
    });
    return textWidget;
  }

  @override
  OneKeyLoginPresenter createPresenter() {
    _presenter = OneKeyLoginPresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void loginSuccess() {
    jverify.dismissLoginAuthView();
    Toast.show("登录成功");
    NavigatorUtils.push(context, PersonalRouter.person,replace: true);
  }
}

/// 封装 按钮
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;

  const CustomButton({super.key, @required this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(const Color(0xff888888)),
        backgroundColor: MaterialStateProperty.all(const Color(0xff585858)),
        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
      child:  Text("$title"),
    );
  }
}
