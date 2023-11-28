import 'package:Bubble/res/resources.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/styles.dart';
import '../../widgets/round_picture_widget.dart';

class StudyReportWidget extends StatefulWidget {

  final Function _press;

  const StudyReportWidget(this._press,{Key? key, required }) : super(key: key);

  @override
  State<StudyReportWidget> createState() => _StudyReportWidgetState();
}

class _StudyReportWidgetState extends State<StudyReportWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget._press(),
      child: Container(
        margin:const EdgeInsets.only(bottom: 20),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(
              color: Colours.color_5B8BD2,
              width: 0.4
          ),
        ),
        child: Row(
          children: [
            RoundPictureWidget(
              url: "test_banner_img",
              topLeft: 20,
              topRight: 0,
              bottomLeft: 20,
              bottomRight: 0,
              width: 130,
              height: 100,
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 17,top: 10,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "聊聊出国旅游的那些事儿 ",
                        style: TextStyles.text12_11B44,
                      ),
                      Gaps.vGap5,
                      Text(
                        "时长：10min",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Text(
                        "时间：2023-09-09",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Row(
                        children: [
                          Text(
                            "星级：",
                            style: TextStyles.text12_546092,
                          ),
                        ],
                      )
                    ],
                  ),
                )),

            const LoadAssetImage("to_next_img",width: 7,height: 13,color: Colours.color_ADC5E8,),
            Gaps.hGap10,
          ],
        ),
      ),
    );
  }
}
