import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class PeopleItem extends StatefulWidget {
  const PeopleItem({super.key});

  @override
  State<PeopleItem> createState() => _PeopleItemState();
}

class _PeopleItemState extends State<PeopleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colours.color_E8CCFE,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 15.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadAssetImage(
            "jichu_icon",
            width: 20.0,
            height: 20.0,
          ),
          Gaps.vGap8,
          const Text(
            "自拼基础",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const Text("有一定",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
