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
  final StepDetailBean stepDetailBean;

  const CourseDetailsPage({super.key, required this.stepDetailBean});

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

  List<Widget> _buildPatternItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < widget.stepDetailBean.data.objectives.sentencePattern.length;
        i++) {
      list.add(PlayBackItem(
          title:
              widget.stepDetailBean.data.objectives.sentencePattern[i].sentence,
          isPaly: false));
    }
    return list;
  }

  List<Widget> _buildSkillsItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < widget.stepDetailBean.data.objectives.speakingSkills.length;
        i++) {
      list.add(PlayBackItem(
          title: widget.stepDetailBean.data.objectives.speakingSkills[i].skill,
          isPaly: false));
    }
    return list;
  }

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
        SliverToBoxAdapter(
          child: CourseReportVocabularyItem(
              vocabulary: widget.stepDetailBean.data.objectives.vocabulary),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colours.color_F9F8FF,
              ),
              // color: Colors.red,
              child: Column(
                children: [
                  Gaps.vGap8,
                  Row(
                    children: [
                      Gaps.hGap12,
                      const LoadAssetImage(
                        "head_juxing_icon",
                        width: 24.0,
                        height: 24.0,
                      ),
                      Gaps.hGap8,
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "句型  ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Sentence pattern",
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
                  Column(
                    children: _buildPatternItems(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colours.color_F9F8FF,
              ),
              // color: Colors.red,
              child: Column(
                children: [
                  Gaps.vGap8,
                  Row(
                    children: [
                      Gaps.hGap8,
                      const LoadAssetImage(
                        "head_nengli_icon",
                        width: 24.0,
                        height: 24.0,
                      ),
                      Gaps.hGap8,
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "能力  ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Speaking Skills",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                        ]),
                      ),
                    ],
                  ),
                  Gaps.vGap11,
                  Column(
                    children: _buildSkillsItems(),
                  ),
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
