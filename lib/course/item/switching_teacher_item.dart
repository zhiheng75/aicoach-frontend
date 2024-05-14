import 'dart:ui';

import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Bubble/chat/entity/character_list_bean.dart';

class SwitchingTeacherItem extends StatefulWidget {
  final Datum data;
  final bool isSele;
  const SwitchingTeacherItem(
      {super.key, required this.data, required this.isSele});

  @override
  State<SwitchingTeacherItem> createState() => _SwitchingTeacherItemState();
}

class _SwitchingTeacherItemState extends State<SwitchingTeacherItem> {
  final ScreenUtil _screenUtil = ScreenUtil();

  late int isSele = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSele = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: widget.isSele
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Colours.color_E00094,
                    ))
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
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
                child: LoadImage(
                  widget.data.imageUrl,
                  fit: BoxFit.fill,
                  width: _screenUtil.screenWidth / 2 - 20,
                  height: _screenUtil.screenWidth / 2 + 30,
                )),
          ),
        ),
        // Gaps.vGap4,

        Positioned(
            right: 20,
            top: 20,
            child: isSele == 0
                ? Container()
                : Image.asset(
                    'assets/images/shengwen.gif',
                    width: 35,
                    height: 25,
                    fit: BoxFit.fitWidth,
                  )),
        Positioned(
          // right: 15,
          bottom: 8,
          right: 10,
          left: 10,
          // top: 80,
          // width: 50,
          height: 85,
          child: Stack(
            children: <Widget>[
              //约束性盒子
              // ConstrainedBox(
              //   constraints: const BoxConstraints.expand(),
              //   child: Text("111"),
              // ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: ClipRect(
                  //背景过滤器
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Opacity(
                      opacity: 0.2,
                      child: Container(
                        // width: 100.0,
                        height: 80.0,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        /*  child: Center(
                        child: Text("天河区扛把子",style:TextStyle(fontSize: 40,color: Colors.black),),
                      ),*/
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.vGap4,
                    Text(
                      widget.data.name,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.vGap4,
                    Text(
                      widget.data.slogan,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.vGap4,
                    Row(
                      children: [
                        const LoadAssetImage(
                          'message',
                          width: 15.0,
                          height: 15.0,
                        ),
                        Gaps.hGap4,
                        Text(
                          "${widget.data.iCount}万",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Gaps.hGap10,
                        const LoadAssetImage(
                          'people',
                          width: 15.0,
                          height: 15.0,
                        ),
                        Gaps.hGap4,
                        Text(
                          "${widget.data.pCount}万",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          // Container(
          //   decoration: BoxDecoration(
          //       // borderRadius: BorderRadius.circular(20.0),
          //       color: Colors.grey.shade200.withOpacity(0.9)),
          //   // decoration: isSele == 0
          //   //     ? const BoxDecoration(
          //   //         borderRadius: BorderRadius.only(
          //   //             bottomLeft: Radius.circular(20.0),
          //   //             bottomRight: Radius.circular(20.0)),
          //   //         color: Colours.color_292A2E,
          //   //       )
          //   //     : const BoxDecoration(
          //   //         borderRadius: BorderRadius.only(
          //   //             bottomLeft: Radius.circular(20.0),
          //   //             bottomRight: Radius.circular(20.0)),
          //   //       ),
          //   padding: const EdgeInsets.all(10),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     // Gaps.vGap4,
          //     Text(
          //       widget.data.name,
          //       style: const TextStyle(
          //         fontSize: 14.0,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //       ),
          //     ),
          //     Text(
          //       widget.data.slogan,
          //       maxLines: 1,
          //       style: const TextStyle(
          //         fontSize: 12.0,
          //         fontWeight: FontWeight.w400,
          //         color: Colours.color_999999,
          //       ),
          //     ),
          //     // Gaps.vGap4,
          //     Text("11"),
          //   ],
          // ),
          // ),
        ),
        Positioned(
          right: 15,
          bottom: 75,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isSele == 0) {
                isSele = 1;
                //播放
                MediaUtils().play(
                  url: widget.data.greetingAudio,
                  useAvatar: true,
                  whenFinished: () {
                    setState(() {
                      isSele = 0;
                    });
                  },
                );
              } else {
                isSele = 0;
                //暂停
              }
              setState(() {});
            },
            child: Container(
                child: isSele == 0
                    ? const LoadAssetImage(
                        "play_teacher_icon",
                        width: 32.0,
                        height: 32.0,
                      )
                    : const LoadAssetImage(
                        "pause_teacher_icon",
                        width: 32.0,
                        height: 32.0,
                      )),
          ),
        )
      ],
    );
  }
}
