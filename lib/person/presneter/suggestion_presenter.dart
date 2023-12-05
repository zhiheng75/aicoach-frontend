import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../view/suggestion_view.dart';

class SuggestionPresenter extends BasePagePresenter<SuggestionView>{



  Future pushSuggest(suggest1,contact){
    Map<String,dynamic> map = {};
    map["message"] = suggest1;
    // _map["images"] = "";图片地址
    map["contact"] = contact;

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.suggestion, isShow: true,
        params: map,
        onSuccess: (data) {
          if (data != null ) {
            if(data.code == 200){
              view.sendSuccess();
            }else{
              view.sendFail(data.msg);
            }

          }else {
            view.sendFail("反馈失败");
          }
        });
  }
}