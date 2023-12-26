import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';

class ExpirationReminder extends StatelessWidget {
  ExpirationReminder({
    Key? key,
  }) : super(key: key);

  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    return Consumer<HomeProvider>(
      builder: (_, provider, __) {

        int vipState = provider.vipState;
        int expDay = provider.expDay;

        Widget title = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              vipState == 2 ? '会员过期' : '体验到期',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 26.0 / 20.0,
              ),
            ),
            Text(
              vipState == 2 ? '邀请您继续一路同行' : '与你的专属AI外教开启学习之旅',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
                height: 26.0 / 15.0,
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
          ],
        );

        List<String> descList = vipState == 2 ? [
          '自由选择喜欢的虚拟外教老师\n多场景 多话题无障碍练习\n24小时，随时随地开始练习',
          '地道英语口语，纯真发音，引导式对话\n全方位测评报告',
        ] : [
          '新用户可免费试用3天，每天15分钟\n${expDay > 0 ? '今天赠送的体验时长已经使用完成' : '赠送的体验时长已全部使用完成'}，\n升级会员后，可畅享所有功能。',
          '24小时，随时随地开始练习\n地道英语口语，纯真发音，引导式对话\n全方位测评报告',
          '自由选择喜欢的虚拟外教老师\n多场景 多话题无障碍练习',
        ];

        Widget descItem(String desc) {
          return Container(
            width: screenUtil.screenWidth - 32.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(24.0),
            alignment: Alignment.center,
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
                height: 18.0 / 15.0,
                letterSpacing: 0.05,
              ),
            ),
          );
        }

        Widget indicatorItem(int index, int currentIndex) {
          return Container(
            width: 4.5,
            height: 4.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.5),
              color: index == currentIndex ? Colours.color_FF71E0 : Colors.black.withOpacity(0.85),
            ),
          );
        }

        Widget desc = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(
                minHeight: 79.0,
                maxHeight: 102.0,
              ),
              child: PageView(
                controller: _pageController,
                children: descList.map((desc) => descItem(desc)).toList(),
                onPageChanged: (page) => _currentPage.value = page,
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            ValueListenableBuilder(
              valueListenable: _currentPage,
              builder: (_, page, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    indicatorItem(0, page),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                      ),
                      child: indicatorItem(1, page),
                    ),
                    indicatorItem(2, page),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 19.0,
            ),
          ],
        );

        Widget button = Container(
          width: 239.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              width: 1.0,
              style: BorderStyle.solid,
              color: Colours.color_001652
            ),
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colours.color_9AC3FF,
                Colours.color_FF71E0,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            vipState == 2 ? '会员续费' : '查看会员升级方案',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_001652,
              height: 21.0 / 18.0,
            ),
          ),
        );

        return Container(
          width: screenUtil.screenWidth,
          height: screenUtil.screenHeight,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 16.0,
                  ),
                  child: const LoadAssetImage(
                    'reminder_close',
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  width: screenUtil.screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/reminder_bg.png'
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 32.0,
                      ),
                      const LoadAssetImage(
                        'reminder_icon',
                        width: 56.0,
                        height: 56.0,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      title,
                      desc,
                      button,
                      SizedBox(
                        height: screenUtil.bottomBarHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
