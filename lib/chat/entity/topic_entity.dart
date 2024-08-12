class TopicEntity {
  int id = 0;
  String title = '';
  String cover = '';
  String desc = '';
  int count = 0;
  String coverImage = '';

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
    if (json['cover_image'] != null) {
      entity.coverImage = json['cover_image'];
    }
    if (json['desc'] != null) {
      entity.desc = json['desc'];
    }
    if (json['i_count'] != null) {
      entity.count = json['i_count'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail_image': cover,
      'cover_image': coverImage,
      'desc': desc,
      'i_count': count,
    };
  }
}
