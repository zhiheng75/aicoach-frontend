import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';
import 'package:spokid/login/presenter/login_presenter.dart';
import 'package:spokid/login/view/login_view.dart';
import 'package:spokid/util/log_utils.dart';
import 'package:spokid/util/toast_utils.dart';
import '../../method/fluter_native.dart';
import '../../mvp/base_page.dart';
import '../../my_text_field.dart';
import '../../res/constant.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/change_notifier_manage.dart';
import '../../util/other_utils.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_scroll_view.dart';
import '../login_router.dart';



class LoginPage extends StatefulWidget {

  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with
        ChangeNotifierMixin<LoginPage>,
        BasePageMixin<LoginPage, LoginPresenter>,
        AutomaticKeepAliveClientMixin<LoginPage>
    implements LoginView {

  late LoginPresenter _loginPresenter;
  //定义一个controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  String _wechatCode = "";

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _nameController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    _nameController.text = SpUtil.getString(Constant.phone).nullSafe;
  }

  void _verify() {
    final String name = _nameController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }
  
  void _login() {
    // SpUtil.putString(Constant.phone, _nameController.text);
    _loginPresenter.login(_nameController.text, true);
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MyAppBar(
        isBack: true,
        actionName: "验证码登录",
        onPressed: () {
          NavigatorUtils.push(context, LoginRouter.smsLoginPage);
        },
      ),
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
   const Text(
      "密码登录",
      style: TextStyles.textBold26,
    ),
    Gaps.vGap16,
    MyTextField(
      key: const Key('phone'),
      focusNode: _nodeText1,
      controller: _nameController,
      maxLength: 11,
      keyboardType: TextInputType.phone,
      hintText: "输入手机号",
    ),
    Gaps.vGap8,
    MyTextField(
      key: const Key('password'),
      keyName: 'password',
      focusNode: _nodeText2,
      isInputPwd: true,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      hintText: "输入密码",
    ),
    Gaps.vGap24,
    MyButton(
      key: const Key('login'),
      onPressed: _clickable ? _login : null,
      text: "登录",
    ),
    Container(
      height: 40.0,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Text(
          "忘记密码",
          key: const Key('forgotPassword'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onTap: () =>{

  }
      ),
    ),
    Gaps.vGap16,
    Container(
      alignment: Alignment.center,
      child: GestureDetector(
        child: Text(
          "注册",
          key: const Key('noAccountRegister'),
          style: TextStyle(
            color: Theme.of(context).primaryColor
          ),
        ),
        onTap: () => {
        NavigatorUtils.push(context, LoginRouter.registerPage)
  }),
      ),
    Gaps.vGap24,
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            // Toast.show("微信登录");
            FlutterToNative.jumpToWechatLogin().then((value) => {
              _wechatCode = value,
              Log.e("===========>$_wechatCode"),
            NavigatorUtils.push(context, LoginRouter.bindPhonePage,arguments: {"wechatCode",_wechatCode}),
              // _loginPresenter.wechatLogin(value)
            });
          },
          child: const Text("微信登录"),
        ),
        Gaps.hGap32,
        GestureDetector(
          onTap: (){
            Toast.show("QQ登录");
          },
          child: const Text("QQ登录"),
        ),
        GestureDetector(
          onTap: (){
            FlutterToNative.jumpToKeyLogin().then((value)=>{

            });
          },
          child: const Text("一键登录"),
        )
      ],
    )
  ];

  @override
  LoginPresenter createPresenter() {
    _loginPresenter = LoginPresenter();
    return _loginPresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void wechatFail() {
    NavigatorUtils.push(context, LoginRouter.bindPhonePage,arguments: {"wechatCode",_wechatCode});
  }

  @override
  void wechatSuccess(String token) {

  }
}
