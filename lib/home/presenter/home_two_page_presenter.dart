import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/view/home_two_page_view.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class HomeTwoPagePresenter extends BasePagePresenter<HomeTwoPageView> {
  @override
  void afterInit() {
    // TODO: implement afterInit
    super.afterInit();
    getCharacterList();
  }

  Future getCharacterList() {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.characterList,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Map<String, dynamic> characterListMap = json.decode(result.toString());
      CharacterListBean goodsListBean =
          CharacterListBean.fromJson(characterListMap);

      if (goodsListBean.code == 200) {
        view.sendCharacterListSuccess(goodsListBean);
      } else {
        view.sendFail(goodsListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("响应异常");
    });
  }
}
