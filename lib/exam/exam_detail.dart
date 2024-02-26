import 'package:Bubble/exam/entity/exam_detail_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import 'presenter/exam_detail_page_presenter.dart';
import 'view/exam_detail_view.dart';

class ExamDetailPage extends StatefulWidget {
  const ExamDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage>
    with
        BasePageMixin<ExamDetailPage, ExamDetailPagePresenter>,
        AutomaticKeepAliveClientMixin<ExamDetailPage>
    implements ExamDetailView {
  late ExamDetailPagePresenter _examDetailPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold();
  }

  @override
  ExamDetailPagePresenter createPresenter() {
    _examDetailPagePresenter = ExamDetailPagePresenter();
    return _examDetailPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(ExamDetailBean examDetailBean) {
    // TODO: implement sendSuccess
  }

  @override
  void playAendSuccess(String msg) {
    // TODO: implement playAendSuccess
  }
}
