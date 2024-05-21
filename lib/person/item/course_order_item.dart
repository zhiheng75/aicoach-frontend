import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/person/entity/order_list_bean.dart';

class CourseOrderItem extends StatelessWidget {
  final Datum datum;
  const CourseOrderItem({super.key, required this.datum});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colours.color_F9F8FF,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      // height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            datum.name,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Gaps.vGap5,
          Text(
            "课程金额: ${datum.orderPrice}元",
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colours.color_666666,
            ),
          ),
          Gaps.vGap2,
          Row(
            children: [
              const Text(
                "课程有效期: ",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colours.color_666666,
                ),
              ),
              Text(
                datum.endTime,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Gaps.vGap2,
          Text(
            "交易时间: ${datum.createdAt}",
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colours.color_666666,
            ),
          ),
          Gaps.vGap2,
          Text(
            "支付方式: ${datum.paymentMethod}",
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colours.color_666666,
            ),
          ),
          Gaps.vGap5,
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colours.color_FFD076,
                ),
                child: const Text(
                  "赠品",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colours.color_333333,
                  ),
                ),
              ),
              Gaps.hGap5,
              Text(
                datum.giftDesc,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
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
