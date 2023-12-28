class OrderEntity {

  int id = 0;
  String name = '';
  String no = '';
  num amount = 0;
  String payTime = '';
  String payType = '';
  num price = 0;
  String unit = '';

  OrderEntity();

  factory OrderEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    OrderEntity entity = OrderEntity();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['name'] != null) {
      entity.name = json['name'];
    }
    if (json['order_no'] != null) {
      entity.no = json['order_no'];
    }
    if (json['order_price'] != null) {
      entity.amount = json['order_price'];
    }
    if (json['created_at'] != null) {
      entity.payTime = json['created_at'];
    }
    if (json['payment_method'] != null) {
      entity.payType = json['payment_method'];
    }
    if (json['goods_price'] != null) {
      entity.price = json['goods_price'];
    }
    if (json['unit'] != null) {
      entity.unit = json['unit'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order_no': no,
      'order_price': amount,
      'created_at': payTime,
      'payment_method': payType,
      'goods_price': price,
      'unit': unit,
    };
  }

}