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
    if (json['detail_image'] != null) {
      entity.cover = json['detail_image'];
    }
    if (json['desc'] != null) {
      entity.desc = json['desc'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail_image': cover,
      'desc': desc,
    };
  }

}