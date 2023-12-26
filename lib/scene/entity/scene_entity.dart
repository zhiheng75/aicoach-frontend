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
    if (json['desc'] != null) {
      entity.desc = json['desc'];
    }
    if (json['cover'] != null) {
      entity.cover = json['cover'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desc': desc,
      'cover': cover,
    };
  }

}