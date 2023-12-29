class TopicEntity {

  int id = 0;
  String title = '';
  String cover = '';
  String desc = '';

  TopicEntity();

  factory TopicEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    TopicEntity entity = TopicEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['title'] != null) {
      entity.title = json['title'];
    }
    if (json['title_image'] != null) {
      entity.cover = json['title_image'];
    }
    if (json['context'] != null) {
      entity.desc = json['context'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_image': cover,
      'context': desc,
    };
  }

}