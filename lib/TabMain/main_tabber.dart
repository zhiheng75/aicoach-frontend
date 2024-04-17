import 'package:Bubble/TabMain/bottom_bar_item.dart';
import 'package:Bubble/chat/chat_home_page.dart';
import 'package:Bubble/class/class_home_page.dart';
import 'package:Bubble/exam/exam.dart';
import 'package:Bubble/home/home.dart';
import 'package:Bubble/home/home_two_page.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/person.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabber extends StatefulWidget {
  const MainTabber({super.key});

  @override
  State<MainTabber> createState() => _MainTabberState();
}

class _MainTabberState extends State<MainTabber> {
  int currentIndex = 0;

  CupertinoTabController? _controller;

  Color activeColor = const Color(0xff1769fe);
  Color inactiveColor = const Color(0xffe0e0e0);

  List<BottomNavigationBarItem> items = [
    BottomBarItem("tabBar_icon_mine", "首页"),
    BottomBarItem("tabBar_icon_mine", "课程"),
    BottomBarItem("tabBar_icon_mine", "自由练"),
    BottomBarItem("tabBar_icon_mine", "我的"),
  ];
  List<Widget> pages = [
    const HomeTwoPage(),
    const ClassHomePage(),
    const ChatHomePage(),
    // const ExamPage(),
    const PersonPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = CupertinoTabController();

    _controller!.index = 0;
    currentIndex = 0;

    EventBus().on(NotificationUtils.loginOut, (_) {
      setState(() {
        currentIndex = 0;
        _controller!.index = 0;
      });
    });
  }

  void tabSelect(int index) {
    if (index == 3) {
      if (LoginManager.isLogin()) {
        setState(() {
          currentIndex = index;
          _controller!.index = index;
        });
      } else {
        LoginManager.checkLogin(context, () {
          setState(() {
            currentIndex = index;
            _controller!.index = index;
          });
        });
        // return;
      }
    } else {
      setState(() {
        currentIndex = index;
        _controller!.index = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //   Widget body = Scaffold(
    //     body: CupertinoTabScaffold(
    //       controller: _controller,
    //       tabBuilder: (context, index) {
    //         return SafeArea(
    //           top: false,
    //           child: pages[index],
    //         );
    //       },
    //       tabBar: CupertinoTabBar(
    //         border: null,
    //         currentIndex: currentIndex,
    //         inactiveColor: inactiveColor,
    //         activeColor: activeColor,
    //         backgroundColor: const Color(0xffffffff),
    //         onTap: tabSelect,
    //         items: items,
    //       ),
    //     ),
    //   );
    //   return body;
    // }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: const Color.fromRGBO(74, 74, 74, 1),
        //可设置颜色items
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: (index) {
          if (index == 3) {
            if (LoginManager.isLogin()) {
              setState(() {
                currentIndex = index;
                _controller!.index = index;
              });
            } else {
              LoginManager.checkLogin(context, () {
                setState(() {
                  currentIndex = index;
                  _controller!.index = index;
                });
              });
              // return;
            }
          } else {
            setState(() {
              currentIndex = index;
              _controller!.index = index;
            });
          }
        },
      ),
    );
  }
}
