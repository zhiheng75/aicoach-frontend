import 'package:flutter/material.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/load_image.dart';

import '../../res/colors.dart';

class Scene extends StatelessWidget {
  const Scene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final List<dynamic> target = [
      {
        'zh': '自我介绍，了解大学生活。',
        'en': 'Introduce yourself and learn about college life.',
      },
    ];
    final List<dynamic> mission = [
      {
        'zh': '1.告诉年级主任你的名字，和从哪里来？',
        'en': 'Tell the grade director your name and where you are from.',
      },
      {
        'zh': '2.向年级主任询问学校俱乐部和组织的情况。',
        'en': 'Ask the grade director about school clubs and organizations.',
      },
      {
        'zh': '3.询问学校的社交活动。',
        'en': 'Ask about school social events.',
      },
    ];
    final Color mainColor = Colours.hex2color('#111B44');
    final Color subColor = Colours.hex2color('#546092');

    text({
      required String zh,
      required String en,
      required double spacing,
      required TextStyle zhTextStyle,
      required TextStyle enTextStyle,
    }) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            zh,
            style: zhTextStyle,
          ),
          SizedBox(
            height: spacing,
          ),
          Text(
            en,
            style: enTextStyle,
          ),
        ],
      );
    }

    label(String text, {required double width}) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            height: 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colours.hex2color('#0EF4D1'),
                  Colours.hex2color('#53C5FF'),
                  Colours.hex2color('#AF88FF'),
                ],
              ),
            ),
          ),
          Positioned(
            left: 6.0,
            bottom: 3.0,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: mainColor,
                height: 1,
              ),
            ),
          ),
        ],
      );
    }

    header() {
      return Padding(
        padding: const EdgeInsets.only(
          left: 27.0,
          right: 19.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '您的自定义场景',
              style: TextStyle(
                fontSize: 15.0,
                color: mainColor,
                letterSpacing: 16.0 / 15.0,
                height: 18.0 / 15.0,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtils.goBack(context);
              },
              child: const LoadAssetImage(
                'guanbi_hei',
                width: 13.0,
                height: 13.0,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      );
    }

    title() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 39.0,
        ),
        child: Row(
          children: <Widget>[
            const LoadAssetImage(
              'changjingfenlei',
              width: 51.0,
              height: 51.0,
            ),
            const SizedBox(
              width: 13.0,
            ),
            text(
              zh: '大学生活',
              en: 'College life',
              spacing: 7.0,
              zhTextStyle: TextStyle(
                fontSize: 18.0,
                color: mainColor,
              ),
              enTextStyle: TextStyle(
                fontSize: 13.0,
                color: mainColor,
                letterSpacing: 16.0 / 13.0,
                height: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    roleItem({
      required String role,
      required String zh,
      required String en,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                role,
                style: TextStyle(
                  fontSize: 10.0,
                  color: subColor,
                  letterSpacing: 16.0 / 10.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(
                height: 7.0,
              ),
              Text(
                zh,
                style: TextStyle(
                  fontSize: 13.0,
                  color: mainColor,
                  height: 1.0,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Text(
                en,
                style: TextStyle(
                  fontSize: 10.0,
                  color: subColor,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    role() {
      return Container(
        width: size.width - 54.0,
        height: 77.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/role_bg.png'
            ),
            fit: BoxFit.fill,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 27.0,
        ),
        child: Row(
          children: <Widget>[
             Container(
              width: 13.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: const Text(
                '角色扮演',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                  letterSpacing: 26.0 / 13.0,
                  height: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  roleItem(
                    role: 'AI机器人',
                    zh: '年级主任',
                    en: 'Grade director',
                  ),
                  const SizedBox(
                    width: 1.0,
                  ),
                  roleItem(
                    role: '我的角色',
                    zh: '大一新生',
                    en: 'Freshman in college',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    contentItem({
      required String zh,
      required String en
    }) {
      return SizedBox(
        width: size.width - 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(
              zh: zh,
              en: en,
              spacing: 9,
              zhTextStyle: TextStyle(
                fontSize: 13.0,
                color: mainColor,
                height: 18.0 / 13.0,
              ),
              enTextStyle: TextStyle(
                fontSize: 12.0,
                color: subColor,
                height: 15.0 / 13.0,
              ),
            ),
          ],
        ),
      );
    }

    content(List<dynamic> contentList) {
      List<Widget> children = <Widget>[];
      for (int i = 0; i < contentList.length; i++) {
        dynamic item = contentList.elementAt(i);
        children.add(contentItem(zh: item['zh'] ?? '', en: item['en'] ?? ''));
        if (i < contentList.length - 1) {
          children.add(const SizedBox(height: 16.0,));
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    bottom() {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          NavigatorUtils.goBack(context);
        },
        child: Container(
          width: size.width - 54.0,
          height: 45.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colours.hex2color('#9E79FC'),
                Colours.hex2color('#9276F8'),
                Colours.hex2color('#8B74FF'),
                Colours.hex2color('#787DFF'),
                Colours.hex2color('#5B8BFE'),
                Colours.hex2color('#20A4EA'),
                Colours.hex2color('#06C4DA'),
                Colours.hex2color('#04D0D7'),
              ],
            ),
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 27.0,
          ),
          child: const Text(
            '开始对话',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colours.hex2color('#111B44').withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/changjing_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 19.0,
              ),
              child: Column(
                children: <Widget>[
                  header(),
                  const SizedBox(
                    height: 28.0,
                  ),
                  title(),
                  const SizedBox(
                    height: 19.0,
                  ),
                  role(),
                  const SizedBox(
                    height: 36.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      label('目标', width: 38.0),
                      const SizedBox(
                        height: 13.0,
                      ),
                      content(target),
                    ],
                  ),
                  const SizedBox(
                    height: 23.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      label('闯关任务', width: 71.0),
                      const SizedBox(
                        height: 13.0,
                      ),
                      content(mission),
                    ],
                  ),
                  const SizedBox(
                    height: 27.0,
                  ),
                  bottom(),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
