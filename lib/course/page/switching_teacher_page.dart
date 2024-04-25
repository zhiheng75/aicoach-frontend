import 'package:Bubble/res/resources.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchingTeacherPage extends StatefulWidget {
  const SwitchingTeacherPage({super.key});

  @override
  State<SwitchingTeacherPage> createState() => _SwitchingTeacherPageState();
}

class _SwitchingTeacherPageState extends State<SwitchingTeacherPage> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        color: Colors.transparent,
        // color: Colors.black,
        child: Column(
          children: [
            Gaps.vGap60,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadAssetImage(
                    'reminder_close',
                    width: 32.0,
                    height: 32.0,
                  ),
                ],
              ),
            ),
            Gaps.vGap10,
            Container(
                padding: const EdgeInsets.all(10),
                width: _screenUtil.screenWidth,
                height: 50,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "选择一位你喜欢的老师学习吧！",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                )),
            Container(
                width: _screenUtil.screenWidth,
                height: 50,
                color: Colors.black,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LoadAssetImage(
                      "nv_sele_icon",
                      width: 72.0,
                      height: 40.0,
                    ),
                    LoadAssetImage(
                      "nan_nor_icon",
                      width: 72.0,
                      height: 40.0,
                    )
                  ],
                )),
            Expanded(
              child: Container(
                  // width: _screenUtil.screenWidth,
                  color: Colors.black,
                  child: GridView.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                          onTap: () {
                            // selectScene(sceneList[index]);
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 200,
                                // color: Colors.red,
                                margin: const EdgeInsets.all(8),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // margin: const EdgeInsets.only(
                                    //     top: 0, left: 8, right: 8, bottom: 0),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(8.0),
                                    // image: const DecorationImage(
                                    //   image: AssetImage(
                                    //     'assets/images/mkbg.png',
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    // ),
                                    child: const LoadImage(
                                      "https://statics.shenmo-ai.com/sophia.jpg",
                                      fit: BoxFit.fill,
                                      // width: 56.0,
                                      // height: 56.0,
                                    )),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/images/shengwen.gif',
                                      width: 35,
                                      height: 25,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Gaps.vGap10
                                  ],
                                ),
                              ),
                              const Positioned(
                                  right: 15,
                                  bottom: 15,
                                  child: LoadAssetImage(
                                    "play_teacher_icon",
                                    width: 32.0,
                                    height: 32.0,
                                  )),
                            ],
                          ));
                    },
                    itemCount: 10,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1),
                  )),
            ),
            // const Text("data"),
            // const Text("data"),
          ],
        ));
  }
}
