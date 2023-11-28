import 'package:flutter/material.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/report/report_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';

import '../../res/colors.dart';
import '../../setting/widgets/update_dialog.dart';
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
      duration: const Duration(milliseconds: 200),
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
    final Color backgroundColor = context.backgroundColor;
    final Color? iconColor = ThemeUtils.getIconColor(context);

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: LoadAssetImage('jt', width: 8.0, height: 4.0,
            color: ThemeUtils.getDarkColor(context, Colours.dark_bg_color),
          ),
        ),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
            onPressed: () {
              NavigatorUtils.push(context, LoginRouter.loginPage,replace: true);
            },
            icon: LoadAssetImage('unselect_img', width: 16.0, height: 16.0, color: iconColor,),
            label: const Text('设置页面'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              disabledForegroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
        Container(width: 120.0, height: 0.6, color: Colours.line),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
            onPressed: () {
              // widget._press();
              NavigatorUtils.push(context, MyReportRouter.myReportPage);
            },
            icon: LoadAssetImage('unselect_img', width: 16.0, height: 16.0, color: iconColor,),
            label: const Text('评分页面'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              disabledForegroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
        Container(width: 120.0, height: 0.6, color: Colours.line),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
            onPressed: () {
              NavigatorUtils.goBack(context);
              _showUpdateDialog();
            },
            icon: LoadAssetImage('unselect_img', width: 16.0, height: 16.0, color: iconColor,),
            label: const Text('版本更新'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              disabledForegroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: body,
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
