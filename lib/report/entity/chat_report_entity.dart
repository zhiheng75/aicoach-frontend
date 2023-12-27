class ChatReportEntity {

  int id = 0;
  String topicCover = '';
  String topicName = '';
  int duration = 0;
  int star = 0;
  int score = 0;
  String characterName = '';
  String characterAvatar = '';
  String createTime = '';

  ChatReportEntity();

  factory ChatReportEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    ChatReportEntity entity = ChatReportEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['topic_cover'] != null) {
      entity.topicCover = json['topic_cover'];
    }
    if (json['topic_name'] != null) {
      entity.topicName = json['topic_name'];
    }
    if (json['duration'] != null) {
      entity.duration = json['duration'];
    }
    if (json['star'] != null) {
      entity.star = json['star'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['character_name'] != null) {
      entity.characterName = json['character_name'];
    }
    if (json['character_avatar'] != null) {
      entity.characterAvatar = json['character_avatar'];
    }
    if (json['create_time'] != null) {
      entity.createTime = json['create_time'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_cover': topicCover,
      'topic_name': topicName,
      'duration': duration,
      'star': star,
      'score': score,
      'character_name': characterName,
      'character_avatar': characterAvatar,
      'create_time': createTime,
    };
  }

}