import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/wx_pay_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/wx_pay_entity.g.dart';

@JsonSerializable()
class WxPayEntity {
	late int code;
	late WxPayData data;
	late String message;

	WxPayEntity();

	factory WxPayEntity.fromJson(Map<String, dynamic> json) => $WxPayEntityFromJson(json);

	Map<String, dynamic> toJson() => $WxPayEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WxPayData {
	late int code;
	late String msg;
	late WxPayDataData data;

	WxPayData();

	factory WxPayData.fromJson(Map<String, dynamic> json) => $WxPayDataFromJson(json);

	Map<String, dynamic> toJson() => $WxPayDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WxPayDataData {
	late String appid;
	late String partnerid;
	late String timestamp;
	late String noncestr;
	@JSONField(name: "prepay_id")
	late String prepayId;
	late String package;
	late String sign;
	late String order_no;

	WxPayDataData();

	factory WxPayDataData.fromJson(Map<String, dynamic> json) => $WxPayDataDataFromJson(json);

	Map<String, dynamic> toJson() => $WxPayDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}