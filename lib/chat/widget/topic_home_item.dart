import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicHomeItem extends StatefulWidget {
  final TopicEntity data;
  final int idx;

  const TopicHomeItem({super.key, required this.data, required this.idx});

  @override
  State<TopicHomeItem> createState() => _TopicHomeItemState();
}

class _TopicHomeItemState extends State<TopicHomeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: EdgeInsets.only(
        left: widget.idx == 0 ? 20 : 10,
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
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
          Gaps.vGap4,
          Row(
            children: [
              LoadAssetImage(
                'people',
                width: 8.0.w,
                height: 9.0.h,
              ),
              Gaps.hGap3,
              Text(
                "${widget.data.count}次对话",
                style: TextStyle(
                  fontSize: 11.0.sp,
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
