import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/material.dart';

class CourseOrderItem extends StatelessWidget {
  const CourseOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colours.color_F8F8F8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 26.0,
      ),
      // height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "英语口语系统课L1",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Gaps.vGap5,
          const Text(
            "课程金额: 2160元",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_666666,
            ),
          ),
          const Row(
            children: [
              Text(
                "课程有效期:",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_666666,
                ),
              ),
              Text(
                "2025-04-05",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_893A6E,
                ),
              ),
            ],
          ),
          const Text(
            "交易时间: 2024-4-06",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_666666,
            ),
          ),
          const Text(
            "支付方式:微信支付",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colours.color_666666,
            ),
          ),
          Gaps.vGap5,
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colours.color_FFD076,
                ),
                child: const Text(
                  "赠品",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_333333,
                  ),
                ),
              ),
              Gaps.hGap5,
              const Text(
                "1年期口语练习，2025年4月6号到期",
                style: TextStyle(
                  fontSize: 14.0,
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
