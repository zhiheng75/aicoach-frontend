import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/net/intercept.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:device_identity/device_identity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sp_util/sp_util.dart';

import '../constant/constant.dart';
import '../dialog/agreement_dialog.dart';
import '../routers/fluro_navigator.dart';
import '../setting/provider/device_provider.dart';
import '../util/device_utils.dart';
import '../util/image_utils.dart';
import '../widgets/fractionally_aligned_sized_box.dart';
import '../widgets/load_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SpUtil.getInstance();
      _initSplash();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initSplash() {
    Provider.of<DeviceProvider>(context, listen: false).getDeviceId();
    _subscription =
        Stream.value(1).delay(const Duration(milliseconds: 2000)).listen((_) {
      bool hasAgree =
          SpUtil.getBool(Constant.agreement, defValue: false) ?? false;
      if (hasAgree) {
        _gotoHome();
      } else {
        _showAgreement();
      }
    });
  }

  void _showAgreement() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        // ignore: deprecated_member_use
        builder: (_) => WillPopScope(
              onWillPop: () async {
                //这里可以响应物理返回键
                return false;
              },
              child: AgreementDialog(() {
                DioUtils.instance.requestNetwork<ResultData>(
                    Method.get, HttpApi.baseConfig,
                    onSuccess: (result) {}, onError: (code, msg) {});
                Future.delayed(const Duration(milliseconds: 500), () {
                  SpUtil.putBool(Constant.agreement, true);
                  initUM();
                  EventUMStatistics.umengCommonMapEvent("click_agreement_yes");

                  _gotoHome();
                });
              }),
            ));
  }

  void _gotoHome() async {
    /// device_identity初始化
    await DeviceIdentity.register();
    initDio();
    initUM();
    EventUMStatistics.umengCommonOnPageStart("splash_page");

    await Device.initDeviceInfo();

    // ignore: use_build_context_synchronously
    LoginManager.checkOneLogin(context, () {
      NavigatorUtils.push(context, HomeRouter.tabberPage, replace: true);
    });
    EventUMStatistics.umengCommonOnPageEnd("splash_page");

    // ignore: use_build_context_synchronously
    // NavigatorUtils.push(context, HomeRouter.tabberPage, replace: true);
  }

  void initUM() {
    EventUMStatistics.umengCommonInit();
  }

  void initDio() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    final info = await PackageInfo.fromPlatform();

//手机品牌加型号
    DioUtils.instance.dio.options.headers['version'] = info.version;
    DioUtils.instance.dio.options.headers['buildNumber'] = info.buildNumber;
    String platformStr = Channel.channelios;
    String sysInfo = "";

    if (Device.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;
      // androidDeviceInfo.board;
      // androidDeviceInfo.model;
      // androidDeviceInfo.version.release;
      platformStr = Channel.channelhuawei;
      final Map<String, String> params = <String, String>{};
      params["manufacturer"] = androidDeviceInfo.manufacturer;
      params["id"] = androidDeviceInfo.id;
      params["brand"] = androidDeviceInfo.brand;
      params["board"] = androidDeviceInfo.board;
      params["model"] = androidDeviceInfo.model;
      params["version"] = androidDeviceInfo.version.release;
      params["device"] = androidDeviceInfo.device;
      params["display"] = androidDeviceInfo.display;

      sysInfo = params.toString(); //allInfo.toString();
    } else {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      platformStr = Channel.channelios;
      final Map<String, String> params = <String, String>{};
      params["version"] = iosDeviceInfo.systemVersion!;
      params["model"] = iosDeviceInfo.model!;
      params["localizedModel"] = iosDeviceInfo.localizedModel!;
      params["isPhysicalDevice"] = iosDeviceInfo.isPhysicalDevice ? "1" : "0";
      params["systemName"] = iosDeviceInfo.systemName!;
      params["machine"] = iosDeviceInfo.utsname.machine!;

      sysInfo = params.toString();
    }
    DioUtils.instance.dio.options.headers['sysInfo'] = sysInfo;
    DioUtils.instance.dio.options.headers['marketplace'] = platformStr;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            // ignore: deprecated_member_use
            body: WillPopScope(
          onWillPop: () async {
            //这里可以响应物理返回键
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("splash_bg"),
                    fit: BoxFit.fill)),
            child: const Center(
              child: LoadAssetImage(
                "splash_icon",
                // width: 150,
              ),
            ),
          ),
        )));
  }
}
