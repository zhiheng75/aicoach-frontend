import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/intercept.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Stream.value(1).delay(const Duration(milliseconds: 1000)).listen((_) {
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
        builder: (_) => AgreementDialog(() {
              SpUtil.putBool(Constant.agreement, true);
              _gotoHome();
            }));
  }

  void _gotoHome() async {
    initDio();
    await Device.initDeviceInfo();

    // ignore: use_build_context_synchronously
    NavigatorUtils.push(context, HomeRouter.homePage, replace: true);
  }

  void initDio() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
//手机品牌加型号
    DioUtils.instance.dio.options.headers['BubbleAI'] = allInfo.toString();
    DioUtils.instance.dio.options.headers['version'] = "1.1.1";
    DioUtils.instance.dio.options.headers['buildNumber'] = "105";
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage("splash_bg"),
                  fit: BoxFit.fill)),
          child: const FractionallyAlignedSizedBox(
            heightFactor: 0.3,
            widthFactor: 0.6,
            leftFactor: 0.2,
            bottomFactor: 0,
            child: Column(
              children: [
                LoadAssetImage(
                  "splash_icon",
                  width: 150,
                ),
                // Text(
                //   "AI点亮未来",
                //   style: TextStyle(color: Colors.white, fontSize: 16),
                // )
              ],
            ),
          ),
        )));
  }

//FractionallyAlignedSizedBox(
//                 heightFactor: 0.3,
//                 widthFactor: 0.33,
//                 leftFactor: 0.33,
//                 bottomFactor: 0,
//                 child: LoadAssetImage('test_banner_img'))
}
