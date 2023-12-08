import 'package:flutter/material.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';

import '../../home/entity/teach_list_entity.dart';

class RecommendTeacherWidget2 extends StatefulWidget {
  final TeachListEntity entity;
  final Function callBack;

  const RecommendTeacherWidget2(
      this.entity, this.callBack,
      {Key? key})
      : super(key: key);

  @override
  State<RecommendTeacherWidget2> createState() => _RecommendTeacherWidgetState();
}

class _RecommendTeacherWidgetState extends State<RecommendTeacherWidget2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.callBack();
      },
      child:
      Container(
        decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            // border: Border.all(
            //     width: widget.entity.isSelect? 2:1,
            //     color:  widget.entity.isSelect ? Colours.color_00E6D0:Colours.color_5B8BD2
            // ),
            // color: widget.entity.isSelect ?Colours.color_70white:Colors.transparent
        ),
        child:

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: LoadImage(
                widget.entity.imageUrl,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            Gaps.vGap10,
            Text(
              widget.entity.name??"",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 16, color: Colours.color_111B44,fontWeight: FontWeight.bold),
            ),
            Text(widget.entity.slogan??"",    overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colours.color_546092,fontSize: 12),),
            Text(widget.entity.character??widget.entity.character.replaceAll(",", " "),    overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colours.color_546092,fontSize: 12),)
          ],
        ),
      ),
    );
  }
}
