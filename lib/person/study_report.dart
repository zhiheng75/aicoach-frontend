import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/study_list_entity.dart';
import 'package:Bubble/person/presneter/study_report_presenter.dart';
import 'package:Bubble/person/view/study_report_view.dart';
import 'package:Bubble/person/widget/study_report_item.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../report/report_router.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/state_layout.dart';

class StudyReportPage extends StatefulWidget {
  const StudyReportPage({Key? key}) : super(key: key);

  @override
  State<StudyReportPage> createState() => _StudyReportPageState();
}

class _StudyReportPageState extends State<StudyReportPage> with BasePageMixin<StudyReportPage,StudyReportPresenter>,
    AutomaticKeepAliveClientMixin<StudyReportPage>
    implements StudyReportView
{

  late StudyReportPresenter _presenter;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colours.color_00E6D0,
                      Colours.color_006CFF,
                      Colours.color_D74DFF,
                    ],
                    stops: [0.0,0.2,1]
                )
            ),
            child: Column(
              children: [
                const MyAppBar(
                  centerTitle: "学习报告",
                  backImgColor: Colors.white,
                  backgroundColor: Colours.transflate,
                ),
                Expanded(
                    child:Container(
                      width: ScreenUtil.getScreenW(context),
                      padding:const EdgeInsets.only(left: Dimens.gap_dp28,right:Dimens.gap_dp28),
                      decoration:const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20)),
                          color: Colors.white
                      ),
                      child: _presenter.mList.isNotEmpty?
                      ListView.builder(
                          shrinkWrap:true,
                          itemCount: _presenter.mList.length,
                          itemBuilder: (context,index){
                            return StudyReportWidget(_presenter.mList[index],(){
                              NavigatorUtils.push(context, MyReportRouter.myReportPage,arguments:_presenter.mList[index],);
                            });
                          }):const StateLayout(
                      type: StateType.empty,
                      hintText: "暂无记录",
                    ),
                    ) ),

              ],
            ),
          ),
        )
    );
  }

  @override
  StudyReportPresenter createPresenter() {
    _presenter = StudyReportPresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void studyListInfo(List<StudyListDataData> list) {
    setState(() {

    });
  }
}
