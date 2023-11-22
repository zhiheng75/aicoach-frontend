import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spokid/res/colors.dart';
import 'package:spokid/res/gaps.dart';
import 'package:spokid/widgets/load_image.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadAssetImage(
                  widget.entity.teacherHeader,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                Gaps.vGap10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.entity.teacherName,
                      style: const TextStyle(
                          fontSize: 12, color: Colours.dark_bg_color),
                    ),
                    LoadAssetImage(
                      widget.entity.index == provider.index
                          ? "select_img"
                          : "unselect_img",
                      width: 12,
                      height: 12,
                    )
                  ],
                )
              ],
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
