import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/core/app_constants.dart';
import 'package:Bubble/home/home_new.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/tabmain/bottom_bar_item.dart';
import 'package:Bubble/chat/chat_home_page.dart';
import 'package:Bubble/course/course_home_page.dart';
import 'package:Bubble/exam/exam.dart';
import 'package:Bubble/home/home.dart';
import 'package:Bubble/home/home_two_page.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/person.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

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
    BottomBarItem("tab_spoken", "伙伴"),
    BottomBarItem("tab_course", "课程"),
    BottomBarItem("tab_mine", "我的"),
  ];
  List<Widget> pages = [
    const HomeTwoPage(),
    const ChatHomePage(),
    const CourseHomePage(),
    // const CourseHomePage(),

    // const HomeNewPage(),
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
    tabUMSelect(currentIndex);

    EventBus().on(NotificationUtils.loginOut, (_) {
      // setState(() {
      //   currentIndex = 0;
      //   _controller!.index = 0;
      //   tabSelect(currentIndex);
      //   tabUMSelect(currentIndex);
      // });
    });

    EventBus().on(NotificationUtils.loginOutTwo, (_) {
      setState(() {
        currentIndex = 0;
        _controller!.index = 0;
        tabSelect(currentIndex);
        tabUMSelect(currentIndex);
      });
    });

    EventBus().on(NotificationUtils.taberThree, (_) {
      setState(() {
        currentIndex = 2;
        _controller!.index = 2;
        tabSelect(currentIndex);
        tabUMSelect(currentIndex);
      });
    });

    EventBus().on(NotificationUtils.taberTwo, (_) {
      setState(() {
        currentIndex = 1;
        _controller!.index = 1;
        tabSelect(currentIndex);
        tabUMSelect(currentIndex);
      });
    });
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.loginOut);
    EventBus().off(NotificationUtils.taberThree);
    EventBus().off(NotificationUtils.taberTwo);

    super.dispose();
  }

  void tabSelect(int index) {
    MediaUtils().stopPlay();
    SpUtil.putString(Constant.netWorkTos, index.toString());

    if (index == 3) {
      if (LoginManager.isLogin()) {
        EventBus().emit(NotificationUtils.resetChat, index.toString());

        setState(() {
          currentIndex = index;
          _controller!.index = index;
        });
      } else {
        LoginManager.checkLogin(context, () {
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

  void tabUMSelect(int index) {
    if (index == 0) {
      EventUMStatistics.umengCommonOnPageStart("home_two_page");

      EventUMStatistics.umengCommonOnPageEnd("chat_home_page");
      EventUMStatistics.umengCommonOnPageEnd("course_home_page");
      EventUMStatistics.umengCommonOnPageEnd("person_page");
    } else if (index == 1) {
      EventUMStatistics.umengCommonOnPageEnd("home_two_page");

      EventUMStatistics.umengCommonOnPageStart("chat_home_page");
      EventUMStatistics.umengCommonOnPageEnd("course_home_page");
      EventUMStatistics.umengCommonOnPageEnd("person_page");
    } else if (index == 2) {
      EventUMStatistics.umengCommonOnPageEnd("home_two_page");

      EventUMStatistics.umengCommonOnPageEnd("chat_home_page");
      EventUMStatistics.umengCommonOnPageStart("course_home_page");
      EventUMStatistics.umengCommonOnPageEnd("person_page");
    } else if (index == 3) {
      EventUMStatistics.umengCommonOnPageEnd("home_two_page");

      EventUMStatistics.umengCommonOnPageEnd("chat_home_page");
      EventUMStatistics.umengCommonOnPageEnd("course_home_page");
      EventUMStatistics.umengCommonOnPageStart("person_page");
    }
  }

  @override
  Widget build(BuildContext context) {
    // tabContext = context;

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
    //         activeColor: Colours.color_8003FD,
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
        selectedFontSize: 11,
        unselectedFontSize: 11,
        // useLegacyColorScheme: false,
        selectedItemColor: Colours.color_8003FD,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        //可设置颜色items
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: (index) {
          tabSelect(index);
          if (index == 0) {
            EventUMStatistics.umengCommonMapEvent("click_Nav_Index_button");
          } else if (index == 1) {
            EventUMStatistics.umengCommonMapEvent("click_Nav_Course_button");
          } else if (index == 2) {
            EventUMStatistics.umengCommonMapEvent("click_Nav_Exercise_button");
          } else if (index == 3) {
            EventUMStatistics.umengCommonMapEvent("click_Nav_Profile_button");
          }
          // tabUMSelect(index);
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
