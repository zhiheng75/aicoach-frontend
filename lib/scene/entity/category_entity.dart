import 'scene_entity.dart';

class CategoryEntity {

  dynamic id = 0;
  String name = '';
  List<SceneEntity> sceneList = [];

  CategoryEntity();

  factory CategoryEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    CategoryEntity entity = CategoryEntity();
    if (json['cagegory_id'] != null) {
      entity.id = json['cagegory_id'];
    }
    if (json['cagegory_name'] != null) {
      entity.name = json['cagegory_name'];
    }
    if (json['scenes'] != null && json['scenes'] is List) {
      entity.sceneList = (json['scenes'] as List).map((item) => SceneEntity.fromJson(item)).toList();
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'cagegory_id': id,
      'cagegory_name': name,
      'scenes': sceneList.map((item) => item.toJson()).toList(),
    };
  }

}