import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spokid/home/widget/home_appbar.dart';
import 'package:spokid/routers/fluro_navigator.dart';
import 'package:spokid/setting/setting_router.dart';
import '../widgets/double_tap_back_exit_app.dart';
import '../widgets/load_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
  }

  @override
  Widget build(BuildContext context) {

    return DoubleTapBackExitApp(child: Scaffold(
appBar:const HomeAppBar(),
      body: Stack(
        children: [
          GestureDetector(
            onTap: (){
              NavigatorUtils.push(context, SettingRouter.themePage);
            },
            child: LoadAssetImage("test_banner_img"),
          )
          ,

        ],
      ) ,
    ));
  }
}
