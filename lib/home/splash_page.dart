import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spokid/home/home_router.dart';
import 'package:sp_util/sp_util.dart';
import '../login/login_router.dart';
import '../util/theme_utils.dart';
import '../res/constant.dart';
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
    _subscription = Stream.value(1).delay(const Duration(milliseconds: 1000)).listen((_) {
      _gotoHome();
    });
  }


  void _gotoHome(){
    NavigatorUtils.push(context, HomeRouter.homePage,replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: context.backgroundColor,
        child:
        const FractionallyAlignedSizedBox(
            heightFactor: 0.3,
            widthFactor: 0.33,
            leftFactor: 0.33,
            bottomFactor: 0,
            child: LoadAssetImage('test_banner_img')
        )
    );
  }
}