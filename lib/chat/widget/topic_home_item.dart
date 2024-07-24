import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicHomeItem extends StatefulWidget {
  final TopicEntity data;
  const TopicHomeItem({super.key, required this.data});

  @override
  State<TopicHomeItem> createState() => _TopicHomeItemState();
}

class _TopicHomeItemState extends State<TopicHomeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.only(
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LoadImage(
              widget.data.coverImage,
              // fit: BoxFit.fitHeight,
              width: 108.w,
              height: 140.h,
            ),
          ),
          Gaps.vGap4,
          Text(widget.data.title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          Gaps.vGap4,
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
    );
  }
}
