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
    // return Container(
    //   color: Colors.red,
    // );
    return Stack(
      children: [
        Positioned(
          top: 3,
          bottom: 3,
          left: 3,
          right: 3,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: LoadImage(
                isSele == 0
                    ? widget.data.listImage
                    : widget.data.listMotionImage,
                fit: BoxFit.cover,
                // width: _screenUtil.screenWidth / 2 - 20,
                // height: _screenUtil.screenWidth / 2 + 30,
              )),
        ),
        Positioned(
          // right: 15,
          bottom: 3,
          right: 3,
          left: 3,
          // top: 80,
          // width: 50,
          height: 70,
          child: Stack(
            children: <Widget>[
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                child: ClipRect(
                  //背景过滤器
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        // width: 100.0,
                        height: 70.0,
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
                left: 20,
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
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: widget.isSele
              ? const LoadAssetImage(
                  "teach_sele_img",
                )
              : Container(),
        ),
        Positioned(
          right: 25,
          bottom: 55,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              MediaUtils().stopPlay();
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
        ),
      ],
    );
  }
}
