class SceneEntity {

  int id = 0;
  String desc = '';
  String cover = '';

  SceneEntity();

  factory SceneEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    SceneEntity entity = SceneEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['title'] != null) {
      entity.desc = json['title'];
    }
    if (json['title_image'] != null) {
      entity.cover = json['title_image'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': desc,
      'title_image': cover,
    };
  }

}