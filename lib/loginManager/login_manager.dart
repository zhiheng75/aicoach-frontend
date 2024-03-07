import 'dart:io';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:jverify/jverify.dart';

import '../login/entity/login_info_entity.dart';
import '../net/http_api.dart';
import '../person/person_router.dart';
import '../res/colors.dart';
import '../util/log_utils.dart';
import '../util/other_utils.dart';
import '../widgets/load.dart';

class LoginManager {
  static bool isLogin() {
    final String token = SpUtil.getString(Constant.accessToken).nullSafe;
    return token.isNotEmpty;
  }

  static void checkLogin(BuildContext context, Function toNext) {
    final String accessToken = SpUtil.getString(Constant.accessToken).nullSafe;

    // NavigatorUtils.push(context, LoginRouter.myApp);
    // return;

    if (accessToken.isNotEmpty) {
      toNext();
    } else {
      //跳转登录()
      LoadingDialog.show(context);
      int type = 1; //0 一键登录  1 其他登录
      final Jverify jverify = Jverify();
      jverify.setup(
          appKey: "d213d60b209d0807dc4146f4", //"你自己应用的 AppKey",
          channel: "devloper-default");
      jverify.isInitSuccess().then((map) {
        Log.e("==================");
        Log.e(map.toString());
        Log.e("==================");
        bool result = map[Constant.jgResultKey];
        if (result) {
          // _result = "sdk 初始换成功";
          jverify.checkVerifyEnable().then((map) {
            bool result = map[Constant.jgResultKey];
            if (result) {
              jverify.getToken().then((map) {
                int code = map[Constant.jgCodeKey];

                ///6000
                String token = map[Constant.jgMsgKey];
                if (code == 2000 && token != null && token.isNotEmpty) {
                  LoadingDialog.hidden();
                  loginAuth(context);
                } else {
                  LoadingDialog.hidden();
                  NavigatorUtils.push(
                    context,
                    "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
                  );
                }
              });
            } else {
              LoadingDialog.hidden();
              NavigatorUtils.push(
                context,
                "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
              );
            }
          });
        } else {
          LoadingDialog.hidden();
          NavigatorUtils.push(
            context,
            "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
          );
        }
      });

      // isInitSuccess().then((value) => {
      //       if (value)
      //         {
      //           checkVerifyEnable().then((value) => {
      //                 if (value)
      //                   {
      //                     getToken().then((value) => {
      //                           LoadingDialog.hidden(),
      //                           if (value)
      //                             {
      //                               type = 0,
      //                               loginAuth(context),
      //                             }
      //                           else
      //                             {
      //                               type = 1,
      //                               NavigatorUtils.push(
      //                                 context,
      //                                 "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
      //                               ),
      //                             },
      //                         })
      //                   }
      //                 else
      //                   {
      //                     LoadingDialog.hidden(),
      //                     NavigatorUtils.push(
      //                       context,
      //                       "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
      //                     ),
      //                   }
      //               })
      //         }
      //       else
      //         {
      //           LoadingDialog.hidden(),
      //           NavigatorUtils.push(
      //             context,
      //             "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
      //           ),
      //         }
      //     });
    }
  }

  //  sdk 初始化是否完成
  static Future<bool> isInitSuccess() async {
    Constant.jverify.setDebugMode(true); // 打开调试模式
    Constant.jverify.setup(
        appKey: "d213d60b209d0807dc4146f4", //"你自己应用的 AppKey",
        channel: "devloper-default");
    return Constant.jverify.isInitSuccess().then((map) {
      Log.e(map.toString());
      bool result = map[Constant.jgResultKey];
      Log.e(result.toString());

      if (result) {
        // "sdk 初始换成功";
        return true;
      } else {
        // "sdk 初始换失败";
        return false;
      }
    });
  }

  /// 判断当前网络环境是否可以发起认证
  static Future<bool> checkVerifyEnable() async {
    Constant.jverify.setDebugMode(true); // 打开调试模式
    Constant.jverify.setup(
        appKey: "d213d60b209d0807dc4146f4", //"你自己应用的 AppKey",
        channel: "devloper-default");
    return Constant.jverify.checkVerifyEnable().then((map) {
      bool result = map[Constant.jgResultKey];

      if (result) {
        //"当前网络环境【支持认证】！";
        return true;
      } else {
        //"当前网络环境【不支持认证】！";
        return false;
      }
    });
  }

  /// 获取号码认证token
  static Future<bool> getToken() async {
    return Constant.jverify.getToken().then((map) {
      int code = map[Constant.jgCodeKey];

      ///6000
      String token = map[Constant.jgMsgKey];

      ///

      if (code == 2000 && token != null && token.isNotEmpty) {
        return true;
      } else {
        // Toast.show(token);
        return false;
      }
    });
  }

  /// SDK 请求授权一键登录
  static void loginAuth(BuildContext context) {
    // showProgress();
    String _result = "token=";
    Constant.jverify.checkVerifyEnable().then((map) {
      bool result = map[Constant.jgResultKey];
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
        uiConfig.navHidden = true;
        uiConfig.navColor = Colors.white.value;
        uiConfig.navText = "";
        uiConfig.navTextColor = Colors.blue.value;
        uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
        uiConfig.authBackgroundImage = "login_bg_img";
        uiConfig.logoWidth = 80;
        uiConfig.logoHeight = 80;
        uiConfig.statusBarDarkMode = false;
        uiConfig.logoOffsetY = 100;
        // uiConfig.logoOffsetX = 35;
        uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.logoHidden = false;
        uiConfig.logoImgPath = "icon";

        uiConfig.numberFieldWidth = 200;
        uiConfig.numberFieldHeight = 40;
        uiConfig.numFieldOffsetY = 180;
        // uiConfig.numFieldOffsetX = 25;
        uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
        uiConfig.numberColor = Colors.black.value;
        uiConfig.numberSize = 35;

        uiConfig.sloganOffsetY = 10;
        uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
        uiConfig.sloganTextColor = Colours.black.value;
        uiConfig.sloganTextSize = 15;

        uiConfig.logBtnWidth = 320;
        uiConfig.logBtnHeight = 50;
        uiConfig.logBtnOffsetY = 30;
        uiConfig.logBtnBackgroundPath = "purchase_btn_img";
        uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
        uiConfig.logBtnText = "本机号码一键登录";
        uiConfig.logBtnTextColor = Colors.black.value;
        uiConfig.logBtnTextSize = 16;
        uiConfig.loginBtnNormalImage = "purchase_btn_img"; //图片必须存在
        uiConfig.loginBtnPressedImage = "purchase_btn_img"; //图片必须存在
        uiConfig.loginBtnUnableImage = "purchase_btn_img"; //图片必须存在

        uiConfig.privacyHintToast =
            true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。

        uiConfig.privacyState = true; //设置默认勾选
        uiConfig.privacyCheckboxSize = 14;
        uiConfig.checkedImgPath = "select_img"; //图片必须存在
        uiConfig.uncheckedImgPath = "unselect_img"; //图片必须存在
        uiConfig.privacyCheckboxInCenter = false;
        uiConfig.privacyCheckboxHidden = false;

        uiConfig.privacyOffsetX = 50;
        uiConfig.privacyOffsetY = 190; // 距离底部距离
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
        List<JVCustomWidget> jgListWidget = [];
        jgListWidget.add(otherNumberLoginType(context));
        jgListWidget.add(tipsWidget());

        Constant.jverify.addAuthPageEventListener((JVAuthPageEvent event) {
          Log.d("======");
        });

        /// 步骤 1：调用接口设置 UI
        Constant.jverify.setCustomAuthorizationView(true, uiConfig,
            landscapeConfig: uiConfig, widgets: jgListWidget);

        /// 步骤 2：调用一键登录接口

        /// 先，添加 loginAuthSyncApi 接口回调的监听
        Constant.jverify.addLoginAuthCallBackListener((event) {
          // setState(() {
          //
          // _result = "监听获取返回数据：[${event.code}] message = ${event.message}";
          // // });
          // Log.d(
          //     "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          // if (event.code == 6000) {
          //   showLoading(context);
          //   _registerPresenter.sendKeyLoginToken(event.message);
          // } else {
          //   Toast.show(event.message);
          // }
          if (event.code == 6000) {
            sendHttpKeyLogin(context, event.message);
          } else if (event.code == 6002) {
            disHttpKeyLogin();
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

  static late CancelToken cancelToken;
  static void sendHttpKeyLogin(context, token) {
    Map<String, String> map = {};
    map["loginToken"] = token;
    cancelToken = CancelToken();
    DioUtils.instance.requestNetwork<LoginInfoData>(
        Method.post, HttpApi.keyLogin, params: map, cancelToken: cancelToken,
        onSuccess: (data) {
      if (data != null) {
        if (data.code == 200) {
          SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
          SpUtil.putString(Constant.accessToken, data.data.token);

          Constant.jverify.dismissLoginAuthView();
          NavigatorUtils.push(context, PersonalRouter.person);
        }
      }
    }, onError: (code, msg) {
      Toast.show(msg);
    });
  }

  static void disHttpKeyLogin() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  //其他号码登录
  static JVCustomWidget otherNumberLoginType(BuildContext context) {
    const String btnWidgetId = "jv_add_custom_button"; // 标识控件 id
    JVCustomWidget textWidget =
        JVCustomWidget(btnWidgetId, JVCustomWidgetType.button);
    textWidget.title = "其他登录方式";
    textWidget.left = 30;
    textWidget.top = 580;
    textWidget.width = 320;
    textWidget.height = 45;
    textWidget.titleColor = Colours.color_3389FF.value;
    textWidget.titleFont = 16;
    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.btnNormalImageName = "login_out_bg_img";
    textWidget.btnPressedImageName = "login_out_bg_img";
    textWidget.isClickEnable = true;

    Constant.jverify.addClikWidgetEventListener(btnWidgetId, (eventId) {
      if (btnWidgetId == eventId) {
        NavigatorUtils.push(
          context,
          "${LoginRouter.newOneKeyPhonePage}?typeLogin=1",
        );
        // NavigatorUtils.push(context, LoginRouter.loginPage);
        Constant.jverify.dismissLoginAuthView();
      }
    });
    return textWidget;
  }

  //登录及注册文案
  static JVCustomWidget tipsWidget() {
    const String txtWidget = "jv_add_custom_txt1"; // 标识控件 id
    JVCustomWidget textWidget =
        JVCustomWidget(txtWidget, JVCustomWidgetType.textView);
    textWidget.title = "未注册手机号验证后生成新账户";
    textWidget.left = 30;
    textWidget.top = 300;
    textWidget.width = 320;
    textWidget.height = 40;
    textWidget.titleFont = 13;
    // textWidget.backgroundColor = Colors.transparent.value;
    textWidget.titleColor = Colors.black.value;
    textWidget.isShowUnderline = false;
    textWidget.textAlignment = JVTextAlignmentType.center;
    textWidget.isClickEnable = false;
    return textWidget;
  }

  static clearToken() {
    SpUtil.remove(Constant.accessToken);
  }

  static toLoginOut() {
    SpUtil.remove(Constant.accessToken);
    SpUtil.remove(Constant.userInfoKey);
  }

  static int getUserId() {
    if (!isLogin()) {
      return 0;
    }
    Map<dynamic, dynamic>? userInfo = SpUtil.getObject(Constant.userInfoKey);
    if (userInfo == null) {
      return 0;
    }
    return userInfo['id'] as int;
  }

  static String getUserToken() {
    if (!isLogin()) {
      return '';
    }
    return SpUtil.getString(Constant.accessToken)!;
  }

  static Map<String, dynamic> getUserInfo() {
    Map<dynamic, dynamic>? userInfo = SpUtil.getObject(Constant.userInfoKey);
    return (userInfo ?? {}) as Map<String, dynamic>;
  }

  static String getUserAvatar() {
    Map<String, dynamic> userInfo = getUserInfo();
    return userInfo['headimgurl'] ?? '';
  }
}
