class ChatReportEntity {

  int id = 0;
  String topicCover = '';
  String topicName = '';
  int duration = 0;
  int star = 0;
  double score = 0;
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
    if (json['scene_image'] != null) {
      entity.topicCover = json['scene_image'];
    }
    if (json['scene_title'] != null) {
      entity.topicName = json['scene_title'];
    }
    if (json['duration'] != null) {
      entity.duration = json['duration'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['name'] != null) {
      entity.characterName = json['name'];
    }
    if (json['avatar_url'] != null) {
      entity.characterAvatar = json['avatar_url'];
    }
    if (json['created_at'] != null) {
      entity.createTime = json['created_at'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scene_image': topicCover,
      'scene_title': topicName,
      'duration': duration,
      'score': score,
      'name': characterName,
      'avatar_url': characterAvatar,
      'created_at': createTime,
    };
  }

}