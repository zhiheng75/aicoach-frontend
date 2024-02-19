class ExamGoodEntity {
  int id = 0;
  String icon = '';
  String name = '';
  String desc = '';
  double price = 0;
  double originalPrice = 0;

  ExamGoodEntity();

  factory ExamGoodEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    ExamGoodEntity entity = ExamGoodEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['icon'] != null) {
      entity.icon = json['icon'];
    }
    if (json['name'] != null) {
      entity.name = json['name'];
    }
    if (json['desc'] != null) {
      entity.desc = json['desc'];
    }
    if (json['price'] != null) {
      entity.price = json['price'];
    }
    if (json['originalPrice'] != null) {
      entity.price = json['originalPrice'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'desc': desc,
      'price': price,
      'originalPrice': originalPrice,
    };
  }
}
