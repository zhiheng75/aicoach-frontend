import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/ali_pay_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/ali_pay_entity.g.dart';

@JsonSerializable()
class AliPayEntity {
	late int code;
	late AliPayData data;
	late String message;

	AliPayEntity();

	factory AliPayEntity.fromJson(Map<String, dynamic> json) => $AliPayEntityFromJson(json);

	Map<String, dynamic> toJson() => $AliPayEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AliPayData {
	late int code;
	late String msg;
	late AliPayDataData data;

	AliPayData();

	factory AliPayData.fromJson(Map<String, dynamic> json) => $AliPayDataFromJson(json);

	Map<String, dynamic> toJson() => $AliPayDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AliPayDataData {
	@JSONField(name: "prepay_url")
	late String prepayUrl;
	@JSONField(name: "order_no")
	late String orderNo;

	AliPayDataData();

	factory AliPayDataData.fromJson(Map<String, dynamic> json) => $AliPayDataDataFromJson(json);

	Map<String, dynamic> toJson() => $AliPayDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}