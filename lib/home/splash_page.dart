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
import '../widgets/load_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _status = 0;
  final List<String> _guideList = ['test_banner_img', 'test_banner_img', 'test_banner_img'];
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SpUtil.getInstance();
      await Device.initDeviceInfo();
      if (SpUtil.getBool(Constant.keyGuide, defValue: true)!) {
        /// 预先缓存图片，避免直接使用时因为首次加载造成闪动
        void precacheImages(String image) {
          precacheImage(ImageUtils.getAssetImage(image), context);
        }
        _guideList.forEach(precacheImages);
      }
      _initSplash();
    });

  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initGuide() {
    setState(() {
      _status = 1;
    });
  }

  void _initSplash() {
  //   _subscription = Stream.value(1).delay(const Duration(milliseconds: 1500)).listen((_) {
  //     if (SpUtil.getBool(Constant.keyGuide, defValue: true)! || Constant.isDriverTest) {
  //       SpUtil.putBool(Constant.keyGuide, false);
  //       _initGuide();
  //     } else {
  //       // _goLogin();
  //       _gotoHome();
  //     }
  //   });
  }

  void _goLogin() {
    NavigatorUtils.push(context, LoginRouter.loginPage, replace: true);
  }
  
  void _gotoHome(){
    NavigatorUtils.push(context, HomeRouter.homePage);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.backgroundColor,
      child:
      // _status == 0 ?
      // const FractionallyAlignedSizedBox(
      //   heightFactor: 0.3,
      //   widthFactor: 0.33,
      //   leftFactor: 0.33,
      //   bottomFactor: 0,
      //   child: LoadAssetImage('logo')
      // ) :
      Swiper(
        key: const Key('swiper'),
        itemCount: _guideList.length,
        loop: false,
        itemBuilder: (_, index) {
          return LoadAssetImage(
            _guideList[index],
            key: Key(_guideList[index]),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
        onTap: (index) {
          if (index == _guideList.length - 1) {
            _gotoHome();
          }
        },
      )
    );
  }
}
