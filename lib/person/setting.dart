// ignore_for_file: prefer_final_fields

import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/switch_button.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart' hide ScreenUtil;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/constant.dart';
import '../entity/empty_response_entity.dart';
import '../entity/result_entity.dart';
import '../home/home_router.dart';
import '../login/entity/login_info_entity.dart';
import '../login/login_router.dart';
import '../loginManager/login_manager.dart';
import '../method/fluter_native.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../res/colors.dart';
import '../routers/fluro_navigator.dart';
import '../util/confirm_utils.dart';
import '../util/toast_utils.dart';
import '../widgets/load_image.dart';
import '../widgets/navbar.dart';
import 'presneter/setting_page_presenter.dart';
import 'view/setting_view.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with
        BasePageMixin<SettingPage, SettingPagePresenter>,
        AutomaticKeepAliveClientMixin<SettingPage>,
        WidgetsBindingObserver
    implements SettingView {
  late SettingPagePresenter _settingPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  Map<String, dynamic> _userInfo = {};
  bool _isBindedPhone = false;
  bool _isBindedWx = false;

  bool _isAccessNotice = false;

  void init() async {
    _userInfo = LoginManager.getUserInfo();
    _isBindedPhone = _userInfo['phone'] != null && _userInfo['phone'] != '';
    _isBindedWx = _userInfo['openid'] != null && _userInfo['openid'] != '';
    setState(() {});
  }

  ///获取通知权限状态
  void getPermissionNoticeStatus() async {
    try {
      PermissionStatus permission = await Permission.notification.status;
      _isAccessNotice = permission == PermissionStatus.granted;
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void bindWx() async {
    Fluwx fluwx = Fluwx();

    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");
    if (await fluwx.isWeChatInstalled) {
      fluwx
          .authBy(
              which: NormalAuth(
                  scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'))
          .then((data) {});
      fluwx.addSubscriber((response) {
        if (response is WeChatAuthResponse) {
          String? result = response.code;
          // _registerPresenter.getWxInfo(response.code ?? "");
          getWxInfo(result!);

          // setState(() {
          //   String result =
          //       'state :${response.state} \n code:${response.code}';
          //   print(result);
          // });
        }
      });
    } else {
      Toast.show("没有安装微信");
    }

    FlutterToNative.jumpToWechatLogin().then((value) {
      getWxInfo(value);
    });
  }

  void getWxInfo(String code) {
    _settingPagePresenter.requestNetwork<LoginInfoData>(
      Method.get,
      url: HttpApi.wechatInfo,
      queryParameters: {
        'code': code,
        'platform': 'app',
      },
      isShow: true,
      onSuccess: (data) {
        if (data != null) {
          confirmBind(data.data);
        } else {
          Toast.show(
            data?.msg,
            duration: 1000,
          );
        }
      },
      onError: (code, msg) {
        Toast.show(
          msg,
          duration: 1000,
        );
      },
    );
  }

  void confirmBind(LoginInfoDataData data) {
    Options op = Options();
    op.contentType = "application/json";
    Map<String, dynamic> params = {};
    params['id'] = _userInfo['id'];
    params['openid'] = data.openid;
    params['nickname'] = data.nickname;
    params['headimgurl'] = data.headimgurl;
    params['sex'] = data.sex;
    params['city'] = data.city;
    params['country'] = data.country;
    params['province'] = data.province;
    params['unionid'] = data.unionid;
    _settingPagePresenter.requestNetwork<EmptyResponseData>(
      Method.post,
      url: HttpApi.bindWX,
      isShow: true,
      params: params,
      onSuccess: (mData) {
        if (mData?.code == 200) {
          Toast.show(
            '绑定成功',
            duration: 1000,
          );
          _userInfo['openid'] = data.openid;
          _userInfo['nickname'] = data.nickname;
          _userInfo['headimgurl'] = data.headimgurl;
          _userInfo['sex'] = data.sex;
          _userInfo['city'] = data.city;
          _userInfo['country'] = data.country;
          _userInfo['province'] = data.province;
          _userInfo['unionid'] = data.unionid;
          SpUtil.putObject(Constant.userInfoKey, _userInfo);
          Future.delayed(const Duration(seconds: 1), init);
        } else {
          Toast.show(
            mData?.msg,
            duration: 1000,
          );
        }
      },
      onError: (code, msg) {
        Toast.show(
          msg,
          duration: 1000,
        );
      },
    );
  }

  ///隐私设置
  void _goAppSetting() {
    openAppSettings();
  }

  void unbindWx() {
    _settingPagePresenter.requestNetwork<ResultData>(Method.post,
        url: HttpApi.unbindWX,
        isShow: true,
        isClose: true, onSuccess: (result) {
      if (result?.code == 200) {
        Toast.show(
          '解绑成功',
          duration: 1000,
        );
        _userInfo['openid'] = '';
        SpUtil.putObject(Constant.userInfoKey, _userInfo);
        Future.delayed(const Duration(seconds: 1), init);
      } else {
        Toast.show(
          result?.msg,
          duration: 1000,
        );
      }
    }, onError: (code, msg) {
      Toast.show(
        msg,
        duration: 1000,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addObserver(this);
    getPermissionNoticeStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getPermissionNoticeStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget session(String icon, String label,
        {Function()? onPress, Widget? child}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onPress != null) {
            onPress();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xFFE8E8E8),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  LoadAssetImage(
                    icon,
                    width: 51.0,
                    height: 51.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (child != null) child,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            const XTCupertinoNavigationBar(
              backgroundColor: Color(0xFFFFFFFF),
              border: null,
              padding: EdgeInsetsDirectional.zero,
              leading: NavigationBackWidget(),
              middle: Text(
                "设置",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            // const SizedBox(
            //   height: 60.0,
            // ),
            // const Navbar(
            //   title: '设置',
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 32.0,
                      ),
                      const Text(
                        '账户绑定',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      session(
                        'setting_phone',
                        '手机号',
                        onPress: () {
                          NavigatorUtils.pushResult(
                            context,
                            LoginRouter.changeBindPhonePage,
                            (_) => init(),
                            arguments: LoginInfoDataData.fromJson(_userInfo),
                          );
                        },
                        child: Text(
                          _isBindedPhone ? '去换绑' : '去绑定',
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 15.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      session(
                        'setting_wx',
                        '微信',
                        onPress: () {
                          if (_isBindedWx) {
                            ConfirmUtils.show(
                              context: context,
                              title: '要解除与微信的绑定吗？',
                              buttonDirection: 'vertical',
                              cancelButtonText: '再想一想',
                              onConfirm: unbindWx,
                            );
                          } else {
                            bindWx();
                          }
                        },
                        child: Text(
                          _isBindedWx ? '已绑定' : '去绑定',
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 15.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SwitchButton(
                        key: ValueKey("_isAccessNotice: $_isAccessNotice"),
                        hint: "通知权限",
                        isChecked: _isAccessNotice,
                        isCloseChange: false,
                        onChange: (bool isChecked) {
                          _goAppSetting();
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '用户服务条款',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0047FF),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigatorUtils.goWebViewPage(
                                      context,
                                      "用户服务条款",
                                      "http://www.shenmo-ai.com/tos/");
                                },
                            ),
                            const TextSpan(
                              text: ' 和 ',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF333333),
                              ),
                            ),
                            TextSpan(
                              text: '隐私政策',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0047FF),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigatorUtils.goWebViewPage(context, "隐私政策",
                                      "http://www.shenmo-ai.com/privacy_policy/");
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          LoginManager.toLoginOut();
                          NavigatorUtils.push(context, HomeRouter.homePage);
                        },
                        child: Container(
                          width: 295.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colours.color_001652,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colours.color_9AC3FF,
                                Colours.color_FF71E0,
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '退出登录',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Colours.color_001652,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        '京ICP备2023024660号-1',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                          height: 18.0 / 12.0,
                          letterSpacing: 0.05,
                        ),
                      ),
                      SizedBox(
                        height: _screenUtil.bottomBarHeight + 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SettingPagePresenter createPresenter() {
    _settingPagePresenter = SettingPagePresenter();
    return _settingPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}
