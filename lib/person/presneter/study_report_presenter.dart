import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/util/device_utils.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/study_list_entity.dart';
import '../view/study_report_view.dart';

class StudyReportPresenter extends BasePagePresenter<StudyReportView>{

  List<StudyListDataData> mList = [];


  @override
  void afterInit() {
    super.afterInit();
    getStudyInfo();
  }

  Future getStudyInfo() async {
    String deviceId = await Device.getDeviceId();
    return requestNetwork<StudyListData>(Method.get,
        url: HttpApi.studyReportList,
        queryParameters: {
          'device_id': deviceId,
        },
        onSuccess: (data) {
          if (data != null && data.code == 200) {
            mList.clear();
            mList.addAll(data.data);
            view.studyListInfo(data.data);
          }
        });
  }

}