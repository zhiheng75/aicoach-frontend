import 'package:Bubble/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/person/entity/goods_bean.dart';

class UserMembershipUpgradeItem extends StatefulWidget {
  final Datum data;
  final bool isSele;
  const UserMembershipUpgradeItem(
      {super.key, required this.data, required this.isSele});

  @override
  State<UserMembershipUpgradeItem> createState() =>
      _UserMembershipUpgradeItemState();
}

class _UserMembershipUpgradeItemState extends State<UserMembershipUpgradeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isSele
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 2.0,
                style: BorderStyle.solid,
                color: Colours.color_8256FF,
              ),
              color: Colours.color_EFE9FF,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
      margin: const EdgeInsets.only(right: 10, left: 10),
      // padding: const EdgeInsets.all(10),
      width: 160,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "￥",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_542DEC,
                ),
              ),
              Text(
                widget.data.price.toString(),
                style: const TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colours.color_542DEC,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
