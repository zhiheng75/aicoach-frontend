import 'package:Bubble/course/entity/lesson_report_detail_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef KeywordCallback = void Function(String keyword);

class CourseReportVocabularyTwoItem extends StatefulWidget {
  final List<Vocabulary> vocabulary;

  const CourseReportVocabularyTwoItem({super.key, required this.vocabulary});

  @override
  State<CourseReportVocabularyTwoItem> createState() =>
      _CourseReportVocabularyTwoItemState();
}

class _CourseReportVocabularyTwoItemState
    extends State<CourseReportVocabularyTwoItem> {
  List<Color> colorBackData = [
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
    Colours.color_E8CCFE,
    Colours.color_C1E8F7,
    Colours.color_E8CCFE,
  ];
  bool get isIPad {
    return MediaQuery.of(context).size.width > 500 ? true : false;
  }

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
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.vGap8,
            Row(
              children: [
                Gaps.hGap4,
                LoadAssetImage(
                  "head_cihui_icon",
                  width: isIPad ? 18.w : 24.0.w,
                  // height: 24.0.w,
                ),
                Gaps.hGap8,
                Expanded(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "词汇  ",
                          style: TextStyle(
                            fontSize: isIPad ? 12.sp : 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: "Vocabulary",
                          style: TextStyle(
                            fontSize: isIPad ? 13.sp : 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    String cihuiStr = "";
                    for (int i = 0; i < widget.vocabulary.length; i++) {
                      cihuiStr = "$cihuiStr${widget.vocabulary[i].word},";
                    }

                    DioUtils.instance.requestNetwork<ResultData>(
                        Method.post, HttpApi.generateAudio,
                        params: {
                          'text': cihuiStr,
                        }, onSuccess: (result) {
                      if (result?.code == 200) {
                        Map<String, dynamic> data =
                            result?.data as Map<String, dynamic>;
                        MediaUtils().stopPlay();
                        MediaUtils().play(
                          url: data['speech_url'],
                          useAvatar: true,
                          whenFinished: () {},
                        );
                      }
                    }, onError: (code, msg) {});
                  },
                  child: const LoadAssetImage(
                    "jiucuo_laba_icon",
                    width: 24,
                    height: 24,
                  ),
                ),
                Gaps.hGap8,
              ],
            ),
            Gaps.vGap11,
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: List.generate(widget.vocabulary.length, (index) {
                return KeywordWidget(
                  keyword: widget.vocabulary[index].word,
                  colorStr: colorBackData[index],
                  callback: search,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  search(String keyword) {}
}

class KeywordWidget extends StatefulWidget {
  final String keyword;
  final Color colorStr;

  final KeywordCallback? callback;
  const KeywordWidget(
      {super.key,
      required this.keyword,
      this.callback,
      required this.colorStr});

  @override
  State<KeywordWidget> createState() => _KeywordWidgetState();
}

class _KeywordWidgetState extends State<KeywordWidget> {
  bool get isIPad {
    return MediaQuery.of(context).size.width > 500 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      decoration: BoxDecoration(
          // border: Border.all(color: const Color(0xFFD7D7D7), width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: widget.colorStr),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        widget.keyword,
        style: TextStyle(
            fontSize: isIPad ? 10.sp : 13.h, color: Color(0xFF444444)),
      ),
    );
    return GestureDetector(
      child: container,
      onTap: () {
        if (widget.callback != null) {
          widget.callback!(widget.keyword);
        }
      },
    );
  }
}
