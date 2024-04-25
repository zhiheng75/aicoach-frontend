import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef KeywordCallback = void Function(String keyword);

class CourseReportVocabularyItem extends StatefulWidget {
  const CourseReportVocabularyItem({super.key});

  @override
  State<CourseReportVocabularyItem> createState() =>
      _CourseReportVocabularyItemState();
}

class _CourseReportVocabularyItemState
    extends State<CourseReportVocabularyItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black,
        ),
        // color: Colors.black,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 8,
          runSpacing: 10,
          children: List.generate(10, (index) {
            return KeywordWidget(
              keyword: "你好",
              callback: search,
            );
          }),
        ),
      ),
    );
  }

  search(String keyword) {}
}

///历史搜索词
class KeywordWidget extends StatelessWidget {
  final String keyword;
  final KeywordCallback? callback;
  const KeywordWidget({super.key, required this.keyword, this.callback});
  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD7D7D7), width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        keyword,
        style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
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
