
import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/study_report_entity.dart';
import '../view/my_report_view.dart';
import '../widget/radar_map.dart';

class MyReportPresenter extends BasePagePresenter<MyReportView>{


  List<RadarBean> list =[];

  @override
  void initState() {
    super.initState();

      list.add(RadarBean(0,"accuracy"));
      list.add(RadarBean(0,"fluency"));
      list.add(RadarBean(0,"integrity"));
      list.add(RadarBean(0,"standard"));

    getReport("567710cca1474b53bda63b0d2c5eb44d");
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
          list[0].score = data.data.accuracyScore??0;
          list[1].score = data.data.fluencyScore??0;
          list[2].score = data.data.integrityScore??0;
          list[3].score = data.data.standardScore??0;
          view.getScore(list);
        }
      }
        });
  }

}