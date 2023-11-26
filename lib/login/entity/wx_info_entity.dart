import 'package:spokid/generated/json/base/json_field.dart';
import 'package:spokid/generated/json/wx_info_entity.g.dart';
import 'dart:convert';
export 'package:spokid/generated/json/wx_info_entity.g.dart';

@JsonSerializable()
class WxInfoEntity {
	late int code;
	late WxInfoData data;
	late String message;

	WxInfoEntity();

	factory WxInfoEntity.fromJson(Map<String, dynamic> json) => $WxInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $WxInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WxInfoData {
	late int code;
	late String msg;
	late WxInfoDataData data;

	WxInfoData();

	factory WxInfoData.fromJson(Map<String, dynamic> json) => $WxInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $WxInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WxInfoDataData {
	late String openid;
	late String nickname;
	late int sex;
	late String language;
	late String city;
	late String province;
	late String country;
	late String headimgurl;
	late List<dynamic> privilege;
	late String unionid;
	late String school;
	late String token;

	WxInfoDataData();

	factory WxInfoDataData.fromJson(Map<String, dynamic> json) => $WxInfoDataDataFromJson(json);

	Map<String, dynamic> toJson() => $WxInfoDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}