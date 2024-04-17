import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/chat/entity/character_list_bean.dart';

class ChatHomeItem extends StatelessWidget {
  final Datum datum;
  const ChatHomeItem({super.key, required this.datum});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: Colors.blue, width: 1.0),
      ),
      // height: 80,
      // color: Colors.blue,
      child: Row(
        children: [
          Gaps.hGap10,
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: LoadImage(
              datum.avatarImage,
              holderImg: "teacher",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.vGap4,
                Text(datum.name),
                Gaps.vGap2,
                Text(datum.slogan,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: Dimens.font_sp14, color: Colours.black)),
                Gaps.vGap2,
                Row(
                  children: [
                    const LoadAssetImage(
                      'message',
                      width: 15.0,
                      height: 15.0,
                    ),
                    Gaps.hGap4,
                    Text(
                      "${datum.iCount}万",
                    ),
                    Gaps.hGap10,
                    const LoadAssetImage(
                      'people',
                      width: 15.0,
                      height: 15.0,
                    ),
                    Gaps.hGap4,
                    Text("${datum.pCount}万"),
                  ],
                ),
                Gaps.vGap4,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
