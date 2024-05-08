//课程详情
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/presenter/course_flow_page_presenter.dart';
import 'package:Bubble/course/view/course_flow_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
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
    return const CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程介绍",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Text("介绍"),
          Text("好的"),
        ],
      ))),
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
