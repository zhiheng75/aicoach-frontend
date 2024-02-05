import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/colors.dart';
import '../widgets/navbar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScreenUtil _screenUtil = ScreenUtil();
  String version = 'V1.0.1';

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
    Widget aboutUs = Container(
      width: _screenUtil.screenWidth - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bubble AI',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                version,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_999999,
                  height: 14.0 / 11.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            '是一款基于人工智能的个性化教育APP。$version版本我们首先推出的是英语口语学习功能，通过与孩子们喜欢的IP绘本角色智能体对话，完成有趣且高效的个性化口语学习。\n\n我们致力于使用人工智能技术创作一款有趣的、符合个性化学习规律的APP。AI科技的浪潮里，希望与您和孩子一路同行。欢迎加入Bubble AI 金种子用户社群，与我们一起见证AI时代的未来教育！',
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              height: 18.0 / 13.0,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );

    Widget customerService = Container(
      width: _screenUtil.screenWidth - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(24.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '欢迎添加客服微信',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          Text(
            '加入Bubble AI 金种子用户社群\n客服微信：Bubble AI',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 13.0,
            ),
          ),
        ],
      ),
    );

    Widget footer = const Column(
      children: [
        Text(
          '客服邮箱：help@shenmo-ai.com',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          'ICP备案号：京ICP备2023024660号-1',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          '深模科技 版权所有',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/person_bg.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 60.0,
                ),
                const Navbar(
                  title: '关于我们',
                ),
                const SizedBox(
                  height: 16.0,
                ),
                aboutUs,
                const SizedBox(
                  height: 16.0,
                ),
                customerService,
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                footer,
                SizedBox(
                  height: _screenUtil.bottomBarHeight + 30.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
