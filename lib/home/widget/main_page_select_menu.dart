import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/report/report_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';

import '../../loginManager/login_manager.dart';
import '../../res/colors.dart';
import '../../setting/widgets/update_dialog.dart';
import '../../util/image_utils.dart';
import '../../util/theme_utils.dart';
import '../../widgets/load_image.dart';

/// 选择跳转哪个页面
class MainPageSelectMenu extends StatefulWidget {

  final Function _press;
  const MainPageSelectMenu(this._press,{
    super.key,
  });


  @override
  State<MainPageSelectMenu> createState() => _MainPageSelectMenuState();
}

class _MainPageSelectMenuState extends State<MainPageSelectMenu> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: moreBtnWidget(),
    );
  }

  Widget moreBtnWidget(){
    return Container(
      padding: const EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ImageUtils.getAssetImage(
                  "more_btn_bg"),
              fit: BoxFit.fill)
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              NavigatorUtils.goBack(context);
            },
            child:const LoadAssetImage("up_more_img",width: 26,height: 26,),
          ),
          Gaps.vGap10,
          GestureDetector(
            onTap: (){
              NavigatorUtils.push(context, LoginRouter.loginPage);
            },
            child:const LoadAssetImage("change_role_img",width: 20,height: 20,),
          ),
          Gaps.vGap10,
          GestureDetector(
            onTap: (){
              NavigatorUtils.push(context, PersonalRouter.personalPurchase);
            },
            child:const LoadAssetImage("study_center_img",width: 20,height: 20,),
          ),
          Gaps.vGap10,
          GestureDetector(
            onTap: () {
              NavigatorUtils.goBack(context);
              LoginManager.checkLogin(context, (){
                NavigatorUtils.push(context, PersonalRouter.personalCenter);
              });

            },
            child:const LoadAssetImage("personal_info_more_img",width: 20,height: 20,),
          ),
        ],
      ),
    );
  }




  void _showUpdateDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const UpdateDialog()
    );
  }

}
