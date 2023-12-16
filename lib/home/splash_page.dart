import 'dart:async';

import 'package:Bubble/setting/provider/device_provider.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:sp_util/sp_util.dart';
import '../dialog/agreement_dialog.dart';
import '../constant/constant.dart';
import '../routers/fluro_navigator.dart';
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
      await Device.initDeviceInfo();
      _initSplash();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initSplash() {
    // Provider.of<DeviceProvider>(context, listen: false).getDeviceId();
    // _subscription =
    //     Stream.value(1).delay(const Duration(milliseconds: 1000)).listen((_) {
    //   bool hasAgree =
    //       SpUtil.getBool(Constant.agreement, defValue: false) ?? false;
    //   if (hasAgree) {
        _gotoHome();
    //   } else {
    //     _showAgreement();
    //   }
    // });
  }

  void _showAgreement() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AgreementDialog(() {
          SpUtil.putBool(Constant.agreement,true);
              _gotoHome();
            }));
  }

  void _gotoHome() {
    NavigatorUtils.push(context, HomeRouter.homePage, replace: true);
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
            bottomFactor: 0.4,
            child: Column(
              children: [
                LoadAssetImage(
                  "splash_icon",
                  width: 300,
                ),
                Text(
                  "欢迎加入BuBBle AI语伴",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
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
