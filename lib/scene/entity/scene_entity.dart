class SceneEntity {

  int id = 0;
  String name = '';
  String enName = '';
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
      entity.name = json['title'];
    }
    if (json['en_title'] != null) {
      entity.enName = json['en_title'];
    }
    if (json['desc'] != null) {
      entity.desc = json['desc'];
    }
    if (json['detail_image'] != null) {
      entity.cover = json['detail_image'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'en_title': enName,
      'desc': desc,
      'detail_image': cover,
    };
  }

}