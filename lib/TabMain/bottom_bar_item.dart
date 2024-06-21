import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class BottomBarItem extends BottomNavigationBarItem {
  BottomBarItem(String iconName, String title)
      : super(
          label: title,
          icon: Image.asset(
            "assets/images/${iconName}_nor.png",
            width: 24,
            fit: BoxFit.fitWidth,
            gaplessPlayback: true,
          ),
          activeIcon: Image.asset(
            "assets/images/$iconName.png",
            // "assets/images/$iconName.png",
            width: 24,
            fit: BoxFit.fitWidth,
            gaplessPlayback: true,
          ),
        );
}

class CenterBottomBarBigItem extends BottomNavigationBarItem {
  CenterBottomBarBigItem(String iconName, String title)
      : super(
          activeIcon: Image.network(
            iconName,
            width: 40,
            gaplessPlayback: true,
          ),
          icon: Image.asset(
            "assets/images/tabbar_icon_mine.png",
            width: 32,
            gaplessPlayback: true,
          ),
        );
}
