import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../loginManager/login_manager.dart';
import '../../person/person_router.dart';
import '../../report/report_router.dart';
import '../../res/colors.dart';
import '../../routers/fluro_navigator.dart';
import '../../scene/widget/select_scene.dart';
import '../../widgets/load_image.dart';

class HomeTabbar extends StatefulWidget {
  const HomeTabbar({
    Key? key,
    required this.currentTab,
    required this.changeTab,
  }) : super(key: key);

  final String currentTab;
  final Function(String) changeTab;

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget tabbarItem({
      required String text,
      required String value,
      required isSelected,
    }) {
      TextStyle style = const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 26.0 / 17.0,
      );
      if (isSelected) {
        style = const TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 26.0 / 17.0,
        );
      }
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          LoginManager.checkLogin(context, () {
            // 场景则弹窗
            if (value == 'scene') {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                builder: (_) => const SelectScene(),
              );

              return;
            }
            widget.changeTab(value);
          });
        },
        child: Text(
          text,
          style: style,
        ),
      );
    }

    return Container(
      width: _screenUtil.screenWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              LoginManager.checkLogin(context, () {
                EventBus().emit('LEAVECHATPAGE');
                NavigatorUtils.push(
                  context,
                  PersonalRouter.person,
                );
              });
            },
            child: const LoadAssetImage(
              'gerenzhongxin',
              width: 22.6,
              height: 24.0,
            ),
          ),
          //隐藏
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     tabbarItem(
          //         text: '对话',
          //         value: 'chat',
          //         isSelected: widget.currentTab == 'chat'),
          //     Gaps.hGap32,
          //     tabbarItem(
          //         text: '场景',
          //         value: 'scene',
          //         isSelected: widget.currentTab == 'scene')
          //   ],
          // ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              tabbarItem(
                  text: '对话',
                  value: 'chat',
                  isSelected: widget.currentTab == 'chat'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: tabbarItem(
                    text: '场景',
                    value: 'scene',
                    isSelected: widget.currentTab == 'scene'),
              ),
              tabbarItem(
                  text: '模考',
                  value: 'exam',
                  isSelected: widget.currentTab == 'exam'),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              LoginManager.checkLogin(
                context,
                () {
                  EventBus().emit('LEAVECHATPAGE');
                  NavigatorUtils.push(
                    context,
                    ReportRouter.reportPage,
                  );
                },
              );
            },
            child: Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colours.color_001652.withOpacity(0.23)),
              alignment: Alignment.center,
              child: const LoadAssetImage(
                'baogao',
                width: 20.0,
                height: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
