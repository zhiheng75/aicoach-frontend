
import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/study_report_entity.dart';
import '../view/my_report_view.dart';
import '../widget/radar_map.dart';

class MyReportPresenter extends BasePagePresenter<MyReportView>{


  List<RadarBean> list =[];

  num sessionAmount = 0;
  String sessionTime = "";
  String rank = "";
  int score = 0;
  double rankScore = 0;


  @override
  void initState() {
    super.initState();
      list.add(RadarBean(0,"语法\n与用词"));
      list.add(RadarBean(0,"流畅度"));
      list.add(RadarBean(0,"完整度"));
      list.add(RadarBean(0,"发音"));

  }


  Future getReport(String sessionId) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['session_id'] = sessionId;
    return requestNetwork<StudyReportData>(Method.get,
        url: HttpApi.coinReport,
        queryParameters: params,
         isShow: false,
         onSuccess: (data) {
      if(data!=null){
        if(data.code==200){
          var mData = data.data;
          list[0].score = mData.accuracyScore??0;
          list[1].score = mData.fluencyScore??0;
          list[2].score = mData.integrityScore??0;
          list[3].score = mData.standardScore??0;

          if(mData.totalScore!=null){
            score =  (mData.totalScore as double).round();
            rankScore = score/100;
          }

          sessionAmount = mData.sessionCount;
          sessionTime = mData.sessionTime;
          rank = mData.rank;

          view.getScore(list);
        }
      }
        });
  }

}