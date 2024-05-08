//课程购买

import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/widget/course_equity_item.dart';
import 'package:Bubble/home/widget/people_item.dart';
import 'package:Bubble/home/widget/problem_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursePurchasePage extends StatefulWidget {
  const CoursePurchasePage({super.key});

  @override
  State<CoursePurchasePage> createState() => _CoursePurchasePageState();
}

class _CoursePurchasePageState extends State<CoursePurchasePage> {
  RenderBox? boxTab;
  late Offset offsetTab;
  GlobalKey keyTab = GlobalKey(debugLabel: "university");
  bool isUpdateAppBar = false;
  bool _checked = false;
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget classImgWidget(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GestureDetector(
        onTap: () {},
        child: Image.network(
          "http://t15.baidu.com/it/u=3515177818,2652149588&fm=224&app=112&f=JPEG?w=500&h=249",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget aiTeacherWidget() {
    return Stack(
      children: [
        Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            // height: 80,
            // width: 280,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_E8CCFE,
                    Colours.color_ACCDFF,
                  ],
                )),
            // height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 100,
                      width: 150,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "嗨，我是Andy老师， 由我来陪伴你英语学习!",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_2C0047,
                          ),
                        ),
                        Gaps.vGap5,
                        Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colours.color_6D388F,
                            ),
                            child: const Text(
                              "Andy老师",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )),
                  ],
                ),
              ],
            )),
        const Positioned(
            left: 5,
            bottom: 10,
            child: LoadAssetImage(
              "suofeiya_head",
              width: 170.0,
              height: 150.0,
            ))
      ],
    );
  }

  Widget teacherWidget() {
    return Stack(
      children: [
        Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            // height: 80,
            // width: 280,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_E8CCFE,
                    Colours.color_ACCDFF,
                  ],
                )),
            // height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "每周六 晚19:00-21:00 报名后分配",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_2C0047,
                          ),
                        ),
                        Gaps.vGap5,
                        Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colours.color_6D388F,
                            ),
                            child: const Text(
                              "辅导老师",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )),
                    const SizedBox(
                      height: 100,
                      width: 150,
                    ),
                  ],
                ),
              ],
            )),
        const Positioned(
            right: 5,
            bottom: 10,
            child: LoadAssetImage(
              "suofeiya_head",
              width: 170.0,
              height: 150.0,
            ))
      ],
    );
  }

  Widget classDetaileWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "L1英语口语系统课",
            key: keyTab,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Gaps.vGap4,
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colours.color_FFD076,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                  vertical: 2.0,
                ),
                child: const Text(
                  "附赠",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              Gaps.hGap6,
              const Text(
                "1年口语练习",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Gaps.vGap4,
          const Text(
            "￥2109元",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_108F4C,
            ),
          ),
          aiTeacherWidget(),
          const LoadAssetImage(
            "vs_teacher",
            // width: 170.0,
            // height: 150.0,
          ),
          teacherWidget()
        ],
      ),
    );
  }

  Widget headWidget(String headStr) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Gaps.hGap8,
          const LoadAssetImage(
            "zhuangshi_ke",
            width: 20.0,
            height: 20.0,
          ),
          Gaps.hGap8,
          Text(
            headStr,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget problemWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colours.color_F8F8F8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 5,
        ),
        child: const Column(
          children: [
            ProblemItem(),
            ProblemItem(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        body: CustomPaint(
          painter: TopOriginPainter(),
          size: Size.infinite,
          child: Stack(children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                boxTab ??=
                    keyTab.currentContext!.findRenderObject() as RenderBox?;
                offsetTab = boxTab!.localToGlobal(Offset.zero);

                if (offsetTab.dy < 110.0) {
                  isUpdateAppBar = true;
                  // isUpdatePage = false;
                  // isUpdateTheme = true;
                } else {
                  isUpdateAppBar = false;
                  // isUpdatePage = true;
                  // isUpdateTheme = false;
                }
                setState(() {});

                return true;
              },
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: classImgWidget(context),
                ),
                SliverToBoxAdapter(
                  child: classDetaileWidget(context),
                ),
                headWidget("用户评价"),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 100.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 150.0,
                          child: Card(
                            color: Colors.primaries[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                headWidget("课程详情"),
                SliverGrid.builder(
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      //设置列数
                      crossAxisCount: 3,
                      //设置横向间距
                      crossAxisSpacing: 0,
                      //设置主轴间距
                      mainAxisSpacing: 0,
                      // mainAxisExtent: 173,
                    ),
                    itemBuilder: (BuildContext ctx, int index) {
                      return PeopleItem(
                        idx: index,
                      );
                    }),
                headWidget("权益"),
                SliverList.builder(
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: CourseEquityItem(
                        idx: index,
                      ),
                    );
                  },
                  itemCount: 5,
                ),
                headWidget("常见问题"),
                problemWidget(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gaps.vGap80,
                      SizedBox(
                        height: _screenUtil.bottomBarHeight,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            isUpdateAppBar
                ? const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: XTCupertinoNavigationBar(
                      backgroundColor: Color(0xFFFFFFFF),
                      border: null,
                      padding: EdgeInsetsDirectional.zero,
                      leading: NavigationBackWidget(),
                      middle: Text(
                        "L1英语口语系统课",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                : Positioned(
                    top: 50,
                    left: 20,
                    child: GestureDetector(
                        onTap: () {
                          NavigatorUtils.goBack(context);
                        },
                        child: const LoadAssetImage(
                          "ic_back_icon",
                          width: 20.0,
                          height: 20.0,
                        ))),
            Positioned(
                bottom: 0,
                // width: _screenUtil.screenWidth,
                child: Container(
                  color: Colours.color_F9F8FF,
                  width: _screenUtil.screenWidth,
                  child: Column(
                    children: [
                      Gaps.vGap10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const LoadAssetImage(
                            "zixun_icon",
                            width: 40.0,
                            height: 40.0,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              NavigatorUtils.push(
                                context,
                                HomeRouter.coursePaysPage,
                              );
                            },
                            child: Container(
                              width: 250.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colours.color_001652,
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
                              child: const Text(
                                '立即支付',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colours.color_001652,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _checked = !_checked;
                              setState(() {});
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              padding: const EdgeInsets.all(10),
                              child: LoadAssetImage(
                                _checked ? 'yigouxuan' : 'weigouxuan',
                                width: 15.0,
                                height: 15.0,
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 8.0,
                          // ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '我已阅读并同意',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                TextSpan(
                                  text: '会员协议',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0047FF),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      NavigatorUtils.goWebViewPage(
                                          context,
                                          "会员协议",
                                          "http://www.shenmo-ai.com/tos/");
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _screenUtil.bottomBarHeight - 10,
                      ),
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}

class TopOriginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义新的坐标系原点
    canvas.translate(0.0, size.height);
    // 绘制操作从这里开始
    // ...
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
