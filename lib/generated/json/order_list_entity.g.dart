import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/order/entity/order_list_entity.dart';

OrderListEntity $OrderListEntityFromJson(Map<String, dynamic> json) {
  final OrderListEntity orderListEntity = OrderListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    orderListEntity.code = code;
  }
  final OrderListData? data = jsonConvert.convert<OrderListData>(json['data']);
  if (data != null) {
    orderListEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    orderListEntity.message = message;
  }
  return orderListEntity;
}

Map<String, dynamic> $OrderListEntityToJson(OrderListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension OrderListEntityExtension on OrderListEntity {
  OrderListEntity copyWith({
    int? code,
    OrderListData? data,
    String? message,
  }) {
    return OrderListEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

OrderListData $OrderListDataFromJson(Map<String, dynamic> json) {
  final OrderListData orderListData = OrderListData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    orderListData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    orderListData.msg = msg;
  }
  final List<OrderListDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<OrderListDataData>(e) as OrderListDataData)
      .toList();
  if (data != null) {
    orderListData.data = data;
  }
  return orderListData;
}

Map<String, dynamic> $OrderListDataToJson(OrderListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension OrderListDataExtension on OrderListData {
  OrderListData copyWith({
    int? code,
    String? msg,
    List<OrderListDataData>? data,
  }) {
    return OrderListData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

OrderListDataData $OrderListDataDataFromJson(Map<String, dynamic> json) {
  final OrderListDataData orderListDataData = OrderListDataData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    orderListDataData.id = id;
  }
  final String? orderNo = jsonConvert.convert<String>(json['order_no']);
  if (orderNo != null) {
    orderListDataData.orderNo = orderNo;
  }
  final String? paymentMethod = jsonConvert.convert<String>(
      json['payment_method']);
  if (paymentMethod != null) {
    orderListDataData.paymentMethod = paymentMethod;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    orderListDataData.status = status;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    orderListDataData.createdAt = createdAt;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    orderListDataData.name = name;
  }
  final double? orderPrice = jsonConvert.convert<double>(json['order_price']);
  if (orderPrice != null) {
    orderListDataData.orderPrice = orderPrice;
  }
  final double? goodsPrice = jsonConvert.convert<double>(json['goods_price']);
  if (goodsPrice != null) {
    orderListDataData.goodsPrice = goodsPrice;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    orderListDataData.unit = unit;
  }
  return orderListDataData;
}

Map<String, dynamic> $OrderListDataDataToJson(OrderListDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['order_no'] = entity.orderNo;
  data['payment_method'] = entity.paymentMethod;
  data['status'] = entity.status;
  data['created_at'] = entity.createdAt;
  data['name'] = entity.name;
  data['order_price'] = entity.orderPrice;
  data['goods_price'] = entity.goodsPrice;
  data['unit'] = entity.unit;
  return data;
}

extension OrderListDataDataExtension on OrderListDataData {
  OrderListDataData copyWith({
    int? id,
    String? orderNo,
    String? paymentMethod,
    int? status,
    String? createdAt,
    String? name,
    double? orderPrice,
    double? goodsPrice,
    String? unit,
  }) {
    return OrderListDataData()
      ..id = id ?? this.id
      ..orderNo = orderNo ?? this.orderNo
      ..paymentMethod = paymentMethod ?? this.paymentMethod
      ..status = status ?? this.status
      ..createdAt = createdAt ?? this.createdAt
      ..name = name ?? this.name
      ..orderPrice = orderPrice ?? this.orderPrice
      ..goodsPrice = goodsPrice ?? this.goodsPrice
      ..unit = unit ?? this.unit;
  }
}