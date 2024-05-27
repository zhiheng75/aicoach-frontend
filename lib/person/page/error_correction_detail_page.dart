import 'package:Bubble/chat/utils/chat_websocket.dart';
import 'package:Bubble/chat/widget/bottom_bar.dart';
import 'package:Bubble/chat/widget/bottom_error_bar.dart';
import 'package:Bubble/chat/widget/record.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/mistake_details_bean.dart';
import 'package:Bubble/person/item/error_correction_detail_item.dart';
import 'package:Bubble/person/presneter/error_correction_detail_page_presenter.dart';
import 'package:Bubble/person/view/error_correction_detail_page_view.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:Bubble/widgets/photo_view_simple_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCorrectionDetailPage extends StatefulWidget {
  final String lessonId;
  const ErrorCorrectionDetailPage({
    super.key,
    required this.lessonId,
  });

  @override
  State<ErrorCorrectionDetailPage> createState() =>
      _ErrorCorrectionDetailPageState();
}

class _ErrorCorrectionDetailPageState extends State<ErrorCorrectionDetailPage>
    with
        BasePageMixin<ErrorCorrectionDetailPage,
            ErrorCorrectionDetailPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<ErrorCorrectionDetailPage>
    implements
        ErrorCorrectionDetailPageView {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  // 底部按钮控制器
  final BottomErrorBarController _bottomBarControll =
      BottomErrorBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();
  final ScreenUtil _screenUtil = ScreenUtil();
  late ErrorCorrectionDetailPagePresenter _errorCorrectionDetailPagePresenter;
  bool isLoding = true;
  late List<Datum> errorDetailData;

  late int idx = 0;

  late String coverUrl = "";
  late String repeatWord = "";
  late String repeatText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomBarControll.setDisabled(false);
    _errorCorrectionDetailPagePresenter.getMistakeDetails(widget.lessonId);
  }

  void repeatTextStr(String str) {
    String one = str;
    RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
    if (one.contains("<image>") && one.contains("<word>")) {
      for (int i = 0; i < 2; i++) {
        RegExpMatch? match = pattern.firstMatch(one);

        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          if (tag == "image") {
            //去出来图片content
            coverUrl = content!;
          }
          if (tag == "word") {
            //取出来文字content
            repeatWord = content!;
          }
          String reStr = "<$tag>$content</$tag>";
          String replacedString = one.replaceAll(reStr, "");
          one = replacedString;
        }
      }
      repeatText = one;
    } else if (one.contains("<word>")) {
      RegExpMatch? match = pattern.firstMatch(one);

      if (match != null) {
        String? tag = match.group(1); // 获取标签名
        String? content = match.group(2); // 获取内容
        Log.e('===============Tag: $tag, Content: $content');
        repeatWord = content!;
        String reStr = "<$tag>$content</$tag>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
      }
      coverUrl = "";

      repeatText = one;
    } else if (one.contains("<image>")) {
      RegExpMatch? match = pattern.firstMatch(one);

      if (match != null) {
        String? tag = match.group(1); // 获取标签名
        String? content = match.group(2); // 获取内容
        Log.e('===============Tag: $tag, Content: $content');
        coverUrl = content!;
        String reStr = "<$tag>$content</$tag>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
      }
      repeatText = one;
      repeatWord = "";
    } else {
      coverUrl = "";
      repeatWord = "";
      repeatText = str;
    }
    setState(() {});
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      child: Scaffold(
          body: CustomPaint(
        painter: TopOriginPainter(),
        size: Size.infinite,
        child: isLoding
            ? lodingView()
            : Stack(
                children: [
                  //MyScrollView
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MyScrollView(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const XTCupertinoNavigationBar(
                          backgroundColor: Color(0xFFFFFFFF),
                          border: null,
                          padding: EdgeInsetsDirectional.zero,
                          leading: NavigationBackWidget(),
                          middle: Text(
                            "纠错",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Expanded(child: Text("data")),
                            Text(
                              "${idx + 1}/${errorDetailData.length}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Gaps.hGap26
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colours.color_F9F8FF,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const LoadAssetImage(
                                    'lisu_icon',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                  Gaps.hGap6,
                                  const Text(
                                    "AI教师",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                repeatText,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colours.color_666666,
                                ),
                              ),
                              coverUrl == ""
                                  ? Container()
                                  : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          barrierColor: Colors.transparent,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          builder: (_) => PhotoViewSimpleScreen(
                                            imageProvider:
                                                NetworkImage(coverUrl),
                                          ),
                                        );
                                      },
                                      child: LoadImage(
                                        coverUrl,
                                        // width: 48.0,
                                      ),
                                    ),
                              ErrorCorrectionDetailItem(
                                data: errorDetailData[idx],
                              ),
                              ErrorCorrectionOneDetailItem(
                                data: errorDetailData[idx],
                              ),
                              errorDetailData[idx].userPracticeAudio == ""
                                  ? const ErrorCorrectionNotDetailItem()
                                  : ErrorCorrectionThreeDetailItem(
                                      data: errorDetailData[idx],
                                    ),
                              errorDetailData[idx].userPracticeAudio.isEmpty
                                  ? BottomErrorBar(
                                      repeatWord: repeatWord,
                                      suggestionSentenceStr:
                                          errorDetailData[idx]
                                                  .suggestionSentence ??
                                              "",
                                      suggestionAudioStr:
                                          errorDetailData[idx].suggestionAudio,
                                      idStr: errorDetailData[idx].id.toString(),
                                      // chatWebsocket: _chatWebsocket,
                                      controller: _bottomBarControll,
                                      recordController: _recordController,
                                      onScrollEnd: () {},
                                      onMapEnd: (data) {
                                        setState(() {
                                          errorDetailData[idx]
                                                  .userPracticeSentence =
                                              data["user_practice_sentence"];
                                          errorDetailData[idx]
                                                  .userPracticeAudio =
                                              // ignore: prefer_interpolation_to_compose_strings
                                              "https://statics.shenmo-ai.com/" +
                                                  data["user_practice_audio"];
                                          double value = double.parse(
                                              data["user_practice_score"]);
                                          int intValue =
                                              value.toInt(); // intValue 的值为 123
                                          errorDetailData[idx]
                                              .userPracticeScore = intValue;
                                        });
                                      },
                                    )
                                  : Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.white,
                                        ),
                                        width: 200,
                                        height: 40,
                                        child: const Center(
                                            child: Text(
                                          "已更正",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colours.color_999999,
                                          ),
                                        )),
                                      ),
                                    ),
                              Gaps.vGap10,
                            ],
                          ),
                        ),
                        Gaps.vGap10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (idx != 0) {
                                  idx = idx - 1;
                                  repeatTextStr(errorDetailData[idx].sentence);

                                  if (errorDetailData[idx]
                                      .suggestionAudio
                                      .isEmpty) {
                                    _errorCorrectionDetailPagePresenter
                                        .postSuggestAnswer(
                                            errorDetailData[idx].sentence);
                                  } else {
                                    setState(() {});
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colours.color_F8F8F8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "上一页",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: idx == 0
                                        ? Colours.color_999999
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (idx + 1 < errorDetailData.length) {
                                  idx = idx + 1;
                                  repeatTextStr(errorDetailData[idx].sentence);

                                  if (errorDetailData[idx]
                                      .suggestionAudio
                                      .isEmpty) {
                                    _errorCorrectionDetailPagePresenter
                                        .postSuggestAnswer(
                                            errorDetailData[idx].sentence);
                                  } else {
                                    setState(() {});
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colours.color_F8F8F8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "下一页",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: idx + 1 < errorDetailData.length
                                        ? Colors.black
                                        : Colours.color_999999,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gaps.vGap30,
                      ],
                    ),
                  ),
                  Positioned(
                    // top: 0,
                    left: 0,
                    bottom: 0,
                    child: ValueListenableBuilder(
                      valueListenable: _bottomBarControll.showRecord,
                      builder: (_, show, __) =>
                          Record(show: show, controller: _recordController),
                    ),
                  ),
                ],
              ),
      )),
    );
  }

  @override
  ErrorCorrectionDetailPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _errorCorrectionDetailPagePresenter = ErrorCorrectionDetailPagePresenter();
    return _errorCorrectionDetailPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(MistakeDetailsBean data) {
    // TODO: implement sendSuccess

    setState(() {
      errorDetailData = data.data;
      repeatTextStr(errorDetailData[idx].sentence);
      // repeatTextStr(
      //     "Great! Let's start with the first word. One<word>one</word><image>https://statics.shenmo-ai.com/courses/level1/unit0/lesson1/Group%202.jpg</image>");
      // errorDetailData[idx].userPracticeAudio = "";
      if (errorDetailData.isNotEmpty) {
        if (errorDetailData[0].suggestionAudio.isEmpty) {
          _errorCorrectionDetailPagePresenter
              .postSuggestAnswer(errorDetailData[idx].sentence);
        } else {
          isLoding = false;
        }
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void sendSuggestAnsweSuccess(String standardAnswerStr, String speechUrlStr) {
    // TODO: implement sendSuggestAnsweSuccess
    errorDetailData[idx].suggestionSentence = standardAnswerStr;
    errorDetailData[idx].suggestionAudio = speechUrlStr;
    isLoding = false;

    setState(() {});
  }
}

class TopOriginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义新的坐标系原点
    canvas.translate(0.0, size.height);
    // 绘制操作从这里开始
    // ...
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
