import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/scene/entity/category_entity.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/chat_view.dart';

class ChatPagePresenter extends BasePagePresenter<ChatView> {
  @override
  void afterInit() {
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
        view.sendSuccess(goodsListBean);
        // characterList.addAll(goodsListBean.data);
        String characterId = goodsListBean.data[0].characterId;
        // _homeProvider.character.characterId = characterId;
        // _homeProvider.character.imageUrl = characterList[0].imageUrl;

        getCategoryList(characterId);
        getCategoryTopicList(characterId);
        // setState(() {});
      } else {
        view.sendFail(goodsListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail(msg);
    });
  }

  Future getCategoryTopicList(String characterId) {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.topicOrScene,
        isShow: false,
        queryParameters: {'character_id': characterId, 'type': 1},
        onSuccess: (result) {
      if (result == null || result.data == null) {
        return;
      }
      List<dynamic> data = result.data as List<dynamic>;
      List<TopicEntity> list =
          data.map((item) => TopicEntity.fromJson(item)).toList();
      // _topicList = list;
      view.sendTopicEntitySuccess(list);
    }, onError: (code, msg) {});
  }

  Future getCategoryList(String characterId) {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.topicOrScene,
        isShow: false,
        queryParameters: {
          'character_id': characterId,
          'type': 2,
        }, onSuccess: (result) {
      if (result == null || result.data == null) {
        return;
      }
      List<dynamic> data = result.data as List<dynamic>;
      List<CategoryEntity> list =
          data.map((item) => CategoryEntity.fromJson(item)).toList();
      view.sendCategoryEntitySuccess(list);
      // _categoryList = list;
    }, onError: (code, msg) {});
  }
}
