class GoodEntity {

  int id = 0;
  String productId = '';
  String name = '';
  String desc = '';
  num price = 0;
  num originalPrice = 0;
  String unit = '';

  GoodEntity();

  factory GoodEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    GoodEntity entity = GoodEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['product_id'] != null) {
      entity.productId = json['product_id'];
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
    if (json['original_price'] != null) {
      entity.originalPrice = json['original_price'];
    }
    if (json['unit'] != null) {
      entity.unit = json['unit'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'desc': desc,
      'price': price,
      'original_price': originalPrice,
      'unit': unit,
    };
  }

}