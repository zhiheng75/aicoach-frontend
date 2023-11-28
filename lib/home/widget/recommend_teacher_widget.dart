import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';

import '../../util/image_utils.dart';
import '../model/select_teacher_entity.dart';
import '../provider/selecter_teacher_provider.dart';

class RecommendTeacherWidget extends StatefulWidget {
  final SelectTeacherEntity entity;
  final Function callBack;
  final HomeTeacherProvider homeTeacherProvider;

  const RecommendTeacherWidget(
      this.entity, this.callBack, this.homeTeacherProvider,
      {Key? key})
      : super(key: key);

  @override
  State<RecommendTeacherWidget> createState() => _RecommendTeacherWidgetState();
}

class _RecommendTeacherWidgetState extends State<RecommendTeacherWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTeacherProvider>(
        create: (_) => widget.homeTeacherProvider,
        child: Consumer<HomeTeacherProvider>(builder: (_, provider, __) {
          return InkWell(
            onTap: () {
              widget.callBack();
            },
            child:
            Container(
              height: 100,
              padding:const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
              decoration: BoxDecoration(
                borderRadius:const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: widget.entity.index == provider.index? 3:1,
                  color:  widget.entity.index == provider.index? Colours.color_00E6D0:Colours.color_5B8BD2
                ),
                color: widget.entity.index == provider.index?Colours.color_70white:Colors.transparent
              ),
              child:

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: LoadAssetImage(
                      widget.entity.teacherHeader,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gaps.vGap10,
                  Text(
                    widget.entity.teacherName,
                    style: const TextStyle(
                        fontSize: 16, color: Colours.color_111B44,fontWeight: FontWeight.bold),
                  ),
                  Text(widget.entity.school,style: const TextStyle(color: Colours.color_546092,fontSize: 12),),
                  Text(widget.entity.category,style: const TextStyle(color: Colours.color_546092,fontSize: 12),)
                ],
              ),
            ),
          );
        }));
  }
  @override
  void dispose() {
    super.dispose();
    widget.homeTeacherProvider.dispose();
  }
}
