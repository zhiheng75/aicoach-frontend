import 'dart:ffi';

import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef KeywordCallback = void Function(String keyword);

class CourseReportVocabularyItem extends StatefulWidget {
  // final StepDetailBean stepDetailBean;
  final List<Vocabulary> vocabulary;

  const CourseReportVocabularyItem({super.key, required this.vocabulary});

  @override
  State<CourseReportVocabularyItem> createState() =>
      _CourseReportVocabularyItemState();
}

class _CourseReportVocabularyItemState
    extends State<CourseReportVocabularyItem> {
  List<Color> colorBackData = [
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_C8F5B1,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colours.color_F9F8FF,
        ),
        // color: Colors.black,
        padding: const EdgeInsets.only(left: 6, right: 6, top: 9, bottom: 25),
        margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.vGap6,
            Row(
              children: [
                Gaps.hGap8,
                const LoadAssetImage(
                  "head_cihui_icon",
                  width: 24.0,
                  height: 24.0,
                ),
                Gaps.hGap8,
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                        text: "词汇  ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    TextSpan(
                        text: "Vocabulary",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                  ]),
                ),
              ],
            ),
            Gaps.vGap11,
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(widget.vocabulary.length, (index) {
                  return KeywordWidget(
                    keyword: widget.vocabulary[index].word,
                    colorStr: colorBackData[index],
                    callback: search,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  search(String keyword) {}
}

///历史搜索词
class KeywordWidget extends StatelessWidget {
  final String keyword;
  final Color colorStr;
  final KeywordCallback? callback;
  const KeywordWidget(
      {super.key,
      required this.keyword,
      this.callback,
      required this.colorStr});
  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      decoration: BoxDecoration(
          // border: Border.all(color: const Color(0xFFD7D7D7), width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: colorStr),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        keyword,
        style: const TextStyle(fontSize: 15, color: Color(0xFF444444)),
      ),
    );
    return GestureDetector(
      child: container,
      onTap: () {
        if (callback != null) {
          callback!(keyword);
        }
      },
    );
  }
}
