class SceneEntity {
  int id = 0;
  String name = '';
  String enName = '';
  String desc = '';
  String cover = '';
  String coverImage = '';

  int count = 0;

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
    if (json['cover_image'] != null) {
      entity.coverImage = json['cover_image'];
    }
    if (json['i_count'] != null) {
      entity.count = json['i_count'];
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
      'cover_image': coverImage,
      'i_count': count,
    };
  }
}
