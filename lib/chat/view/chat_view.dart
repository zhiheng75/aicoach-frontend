import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/scene/entity/category_entity.dart';

import '../../mvp/mvps.dart';

abstract class ChatView implements IMvpView {
  void sendSuccess(CharacterListBean data);

  void sendTopicEntitySuccess(List<TopicEntity> list);
  void sendCategoryEntitySuccess(List<CategoryEntity> list);

  void sendFail(String msg);
}
