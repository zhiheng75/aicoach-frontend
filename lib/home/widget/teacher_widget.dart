import 'package:flutter/material.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';

import '../entity/teach_list_entity.dart';

class TeacherWidget extends StatefulWidget {
  final TeachListEntity teacher;
  final bool selected;
  final Function(TeachListEntity) onTap;

  const TeacherWidget({
    Key? key,
    required this.teacher,
    this.selected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<TeacherWidget> createState() => _TeacherWidgetState();
}

class _TeacherWidgetState extends State<TeacherWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selected;
    return InkWell(
      onTap: () {
        if (isSelected) {
          return;
        }
        widget.onTap(widget.teacher);
      },
      child: Container(
        height: 100,
        padding:const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
        decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                width: isSelected ? 2 : 1,
                color:  isSelected ? Colours.color_00E6D0 : Colours.color_5B8BD2
            ),
            color: isSelected ? Colours.hex2color('#DEFFFC') : Colors.transparent
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: LoadImage(
                widget.teacher.imageUrl,
                height: 71,
                width: 71,
                fit: BoxFit.cover,
              ),
            ),
            Gaps.vGap10,
            Text(
              widget.teacher.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 16, color: Colours.color_111B44,fontWeight: FontWeight.bold),
            ),
            Text(widget.teacher.slogan,    overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colours.color_546092,fontSize: 12),),
            Text(widget.teacher.character.replaceAll(",", " "),    overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colours.color_546092,fontSize: 12),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
