import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class PeopleItem extends StatefulWidget {
  final int idx;
  const PeopleItem({super.key, required this.idx});

  @override
  State<PeopleItem> createState() => _PeopleItemState();
}

class _PeopleItemState extends State<PeopleItem> {
  late String imgStr;
  late String titltStr;
  late String msgStr;
  late Color coloStr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.idx == 0) {
      imgStr = "xiaohai_icon";
      titltStr = '6-7岁';
      msgStr = '非零基础';
      coloStr = Colours.color_FAF3FF;
    } else if (widget.idx == 1) {
      imgStr = "en_icon";
      titltStr = '1年';
      msgStr = '学过英语';
      coloStr = Colours.color_EFF9FF;
    } else if (widget.idx == 2) {
      imgStr = "jichu_icon";
      titltStr = '26个';
      msgStr = '学过字母';
      coloStr = Colours.color_E8F9DF;
    } else if (widget.idx == 3) {
      imgStr = "jichu_icon";
      titltStr = '自拼基础';
      msgStr = '有一定';
      coloStr = Colours.color_E8F9DF;
    } else if (widget.idx == 4) {
      imgStr = "cihui_icon";
      titltStr = '词汇量';
      msgStr = '有一些';
      coloStr = Colours.color_EFF9FF;
    } else if (widget.idx == 5) {
      imgStr = "yuedu_icon";
      titltStr = '阅读量';
      msgStr = '有一些';
      coloStr = Colours.color_FAF3FF;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: coloStr,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 15.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.idx != 2
              ? LoadAssetImage(
                  imgStr,
                  width: 20.0,
                  height: 20.0,
                )
              : const Text(
                  "Abc",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
          Gaps.vGap8,
          Text(
            titltStr,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(msgStr,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
