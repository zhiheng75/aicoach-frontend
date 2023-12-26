class CategoryEntity {

  int id = 0;
  String name = '';

  CategoryEntity();

  factory CategoryEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    CategoryEntity entity = CategoryEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['name'] != null) {
      entity.name = json['name'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

}