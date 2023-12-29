class AdviseEntity {

  String msgId = '';
  int score = 0;
  String aiText = '';
  String userText = '';

  AdviseEntity();

  factory AdviseEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AdviseEntity entity = AdviseEntity();
    if (json['msg_id'] != null) {
      entity.msgId = json['msg_id'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['ai_text'] != null) {
      entity.aiText = json['ai_text'];
    }
    if (json['user_text'] != null) {
      entity.userText = json['user_text'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'msg_id': msgId,
      'score': score,
      'user_text': userText,
    };
  }

}