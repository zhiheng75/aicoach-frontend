import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHomeTwoItem extends StatefulWidget {
  final SceneEntity data;
  const ChatHomeTwoItem({super.key, required this.data});

  @override
  State<ChatHomeTwoItem> createState() => _ChatHomeTwoItemState();
}

class _ChatHomeTwoItemState extends State<ChatHomeTwoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     gradient: const LinearGradient(
      //       colors: [
      //         Colours.color_E0D5FF,
      //         Colours.color_DCF2FE,
      //       ],
      //     )),
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ImageUtils.getAssetImage("chat_scene_bg"),
              fit: BoxFit.fitWidth)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: 40.h,
                width: 90.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.vGap2,
              Row(
                children: [
                  const LoadAssetImage(
                    'people',
                    width: 8.0,
                    height: 8.0,
                  ),
                  Gaps.hGap2,
                  Text(
                    "${widget.data.count}次对话",
                    style: TextStyle(
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_333333,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: LoadImage(
              widget.data.coverImage,
              // fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
