import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/order_list_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/order_list_entity.g.dart';

@JsonSerializable()
class OrderListEntity {
	late int code;
	late OrderListData data;
	late String message;

	OrderListEntity();

	factory OrderListEntity.fromJson(Map<String, dynamic> json) => $OrderListEntityFromJson(json);

	Map<String, dynamic> toJson() => $OrderListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OrderListData {
	late int code;
	late String msg;
	late List<OrderListDataData> data;

	OrderListData();

	factory OrderListData.fromJson(Map<String, dynamic> json) => $OrderListDataFromJson(json);

	Map<String, dynamic> toJson() => $OrderListDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OrderListDataData {
	late int id;
	@JSONField(name: "order_no")
	late String orderNo;
	@JSONField(name: "payment_method")
	late String paymentMethod;
	late int status;
	@JSONField(name: "created_at")
	late String createdAt;
	late String name;
	@JSONField(name: "order_price")
	late double orderPrice;
	@JSONField(name: "goods_price")
	late double goodsPrice;
	late String unit;

	OrderListDataData();

	factory OrderListDataData.fromJson(Map<String, dynamic> json) => $OrderListDataDataFromJson(json);

	Map<String, dynamic> toJson() => $OrderListDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}