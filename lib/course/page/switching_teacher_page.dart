import 'package:Bubble/course/item/switching_teacher_item.dart';
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
            // Container(
            //     width: _screenUtil.screenWidth,
            //     height: 50,
            //     color: Colors.black,
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         LoadAssetImage(
            //           "nv_sele_icon",
            //           width: 72.0,
            //           height: 40.0,
            //         ),
            //         LoadAssetImage(
            //           "nan_nor_icon",
            //           width: 72.0,
            //           height: 40.0,
            //         )
            //       ],
            //     )),
            Expanded(
              child: Container(
                  // width: _screenUtil.screenWidth,
                  color: Colors.black,
                  child: GridView.builder(
                    itemBuilder: (ctx, index) {
                      return const SwitchingTeacherItem();
                    },
                    itemCount: 10,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        childAspectRatio: (_screenUtil.screenWidth / 2 - 20) /
                            (_screenUtil.screenWidth / 2 + 30)),
                  )),
            ),
            // const Text("data"),
            // const Text("data"),
          ],
        ));
  }
}
