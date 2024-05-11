import 'package:Bubble/core/app_constants.dart';
import 'package:Bubble/home/home_new.dart';
import 'package:Bubble/tabmain/bottom_bar_item.dart';
import 'package:Bubble/chat/chat_home_page.dart';
import 'package:Bubble/course/course_home_page.dart';
import 'package:Bubble/exam/exam.dart';
import 'package:Bubble/home/home.dart';
import 'package:Bubble/home/home_two_page.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/person.dart';
import 'package:Bubble/util/event_bus.dart';
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
    BottomBarItem("tab_home", "首页"),
    BottomBarItem("tab_course", "上课"),
    BottomBarItem("tab_spoken", "练口语"),
    BottomBarItem("tab_mine", "我的"),
  ];
  List<Widget> pages = [
    // const MyWidget(),
    const HomeTwoPage(),
    const CourseHomePage(),
    // const MyWidget(),
    // const ChatHomePage(),
    const HomeNewPage(),
    // const ExamPage(),
    const PersonPage(),
  ];
  //

  @override
  void initState() {
    super.initState();
    _controller = CupertinoTabController();

    _controller!.index = 0;
    currentIndex = 0;
    tabSelect(currentIndex);
    EventBus().on(NotificationUtils.loginOut, (_) {
      setState(() {
        currentIndex = 0;
        _controller!.index = 0;
      });
    });

    EventBus().on(NotificationUtils.taberThree, (_) {
      setState(() {
        currentIndex = 2;
        _controller!.index = 2;
      });
    });
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.loginOut);
    EventBus().off(NotificationUtils.taberThree);

    super.dispose();
  }

  void tabSelect(int index) {
    if (index == 3) {
      if (LoginManager.isLogin()) {
        EventBus().emit(NotificationUtils.resetChat, index.toString());

        setState(() {
          currentIndex = index;
          _controller!.index = index;
        });
      } else {
        LoginManager.checkLogin(tabContext!, () {
          // setState(() {
          //   currentIndex = index;
          //   _controller!.index = index;
          // });
          EventBus().emit(NotificationUtils.resetChat, index.toString());
        });
        // return;
      }
    } else {
      EventBus().emit(NotificationUtils.resetChat, index.toString());

      setState(() {
        currentIndex = index;
        _controller!.index = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    tabContext = context;

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
        selectedItemColor: const Color.fromRGBO(216, 69, 166, 1),
        //可设置颜色items
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: (index) {
          tabSelect(index);
          // if (index == 3) {
          //   if (LoginManager.isLogin()) {
          //     setState(() {
          //       currentIndex = index;
          //       _controller!.index = index;
          //     });
          //   } else {
          //     LoginManager.checkLogin(context, () {
          //       setState(() {
          //         currentIndex = index;
          //         _controller!.index = index;
          //       });
          //     });
          //     // return;
          //   }
          // } else {
          //   setState(() {
          //     currentIndex = index;
          //     _controller!.index = index;
          //   });
          // }
        },
      ),
    );
  }
}
