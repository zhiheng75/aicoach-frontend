
import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../view/my_report_view.dart';

class MyReportPresenter extends BasePagePresenter<MyReportView>{

  @override
  void initState() {
    super.initState();
    getReport("567710cca1474b53bda63b0d2c5eb44d");
  }


  Future getReport(String sessionId) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['session_id'] = sessionId;
    return requestNetwork(Method.post,
        url: HttpApi.coinReport,
        queryParameters: params,
         onSuccess: (data) {

        });
  }

}