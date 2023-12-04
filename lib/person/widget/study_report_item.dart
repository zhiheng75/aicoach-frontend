import 'package:Bubble/res/resources.dart';
import 'package:Bubble/util/time_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../widgets/round_picture_widget.dart';
import '../entity/study_list_entity.dart';

class StudyReportWidget extends StatefulWidget {

  final Function _press;
  final StudyListDataData _entity;

  const StudyReportWidget(this._entity,this._press,{Key? key, required }) : super(key: key);

  @override
  State<StudyReportWidget> createState() => _StudyReportWidgetState();
}

class _StudyReportWidgetState extends State<StudyReportWidget> {

  double star = 0;
  @override
  void initState() {
    super.initState();
    if(widget._entity!=null){
      double score =  widget._entity.score;
      if(score>=91){
        star = 5;
      }else if(score>=80&&score<91){
        star = 4;
      }else if(score>=60&&score<80){
        star = 3;
      }else if(score>=50&&score<60){
        star = 2;
      }else{
        star = 1;
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget._press();
      },
      child: Container(
        margin:const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(
              color: Colours.color_5B8BD2,
              width: 0.4
          ),
        ),
        child: Row(
          children: [
            const RoundPictureWidget(
              url: "study_list_img",
              holderImg: "study_list_img",
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
                  padding:const EdgeInsets.only(left: 17,top: 10,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._entity.message,
                        style: TextStyles.text12_11B44,
                      ),
                      Gaps.vGap5,
                      Text(
                        "时长：${TimeUtils.formatedMinute(widget._entity.duration)}min",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Text(
                        "时间：${widget._entity.createdAt}",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Row(
                        children: [
                         const Text(
                            "星级：",
                            style: TextStyles.text12_546092,
                          ),
                  Expanded(
                      child:RatingBar(
                        initialRating: star,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 10,
                        ignoreGestures: true,
                        ratingWidget: RatingWidget(
                          full:const LoadAssetImage('full_star_img'),
                          half: const LoadAssetImage('full_star_img'),
                          empty: const LoadAssetImage('empty_star_img'),
                        ),
                        itemPadding:const EdgeInsets.symmetric(horizontal: 2.0),
                        onRatingUpdate: (rating) {
                        },
                      )
                  )
                  ,
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
