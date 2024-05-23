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
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomBarControll.setDisabled(false);
    _errorCorrectionDetailPagePresenter.getMistakeDetails(widget.lessonId);
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
                  Column(
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
                              errorDetailData[idx].sentence,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colours.color_666666,
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
                                    suggestionSentenceStr: errorDetailData[idx]
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
                                        errorDetailData[idx].userPracticeAudio =
                                            // ignore: prefer_interpolation_to_compose_strings
                                            "https://statics.shenmo-ai.com/" +
                                                data["user_practice_audio"];
                                        errorDetailData[idx].userPracticeScore =
                                            int.parse(
                                                data["user_practice_score"]);
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
      isLoding = false;
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
