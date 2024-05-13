//课程详情
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/item/course_report_vocabulary_item.dart';
import 'package:Bubble/course/item/play_back_item.dart';
import 'package:Bubble/course/presenter/course_flow_page_presenter.dart';
import 'package:Bubble/course/view/course_flow_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with
        BasePageMixin<CourseDetailsPage, CourseFlowPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CourseDetailsPage>
    implements CourseFlowPageView {
  late CourseFlowPagePresenter _courseDetailsPagePresenter;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程学习目标",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
          child: CourseReportVocabularyItem(),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colours.color_F9F8FF,
              ),
              // color: Colors.red,
              child: Column(
                children: [
                  Row(
                    children: [
                      const LoadAssetImage(
                        "home_head_icon",
                        width: 40.0,
                        height: 40.0,
                      ),
                      // Gaps.hGap8,
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "句型  ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Sentence pattern",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                          // const TextSpan(
                          //     text: "个",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //       color: Colours.color_666666,
                          //     )),
                        ]),
                      ),
                    ],
                  ),
                  Gaps.vGap11,
                  const PlayBackItem(),
                  const PlayBackItem(),
                  const PlayBackItem(),
                ],
              ),
            ),
          ),
        ),
        // headWidget("Speak Skill", "12"),

        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colours.color_F9F8FF,
              ),
              // color: Colors.red,
              child: Column(
                children: [
                  Row(
                    children: [
                      const LoadAssetImage(
                        "home_head_icon",
                        width: 40.0,
                        height: 40.0,
                      ),
                      // Gaps.hGap8,
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "能力  ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Speaking Skills",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                          // const TextSpan(
                          //     text: "个",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //       color: Colours.color_666666,
                          //     )),
                        ]),
                      ),
                    ],
                  ),
                  Gaps.vGap11,
                  const PlayBackItem(),
                  const PlayBackItem(),
                  const PlayBackItem(),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Gaps.vGap30,
        ),
      ]))),
    );
  }

  @override
  CourseFlowPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _courseDetailsPagePresenter = CourseFlowPagePresenter();
    return _courseDetailsPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void sendSuccess(StepDetailBean stepDetailBean) {
    // TODO: implement sendSuccess
  }
}
