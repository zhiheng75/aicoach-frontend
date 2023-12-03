import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/login_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/login_info_entity.g.dart';

@JsonSerializable()
class LoginInfoEntity {
	late int code;
	late LoginInfoData data;
	late String message;

	LoginInfoEntity();

	factory LoginInfoEntity.fromJson(Map<String, dynamic> json) => $LoginInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LoginInfoData {
	late int code;
	late String msg;
	late LoginInfoDataData data;

	LoginInfoData();

	factory LoginInfoData.fromJson(Map<String, dynamic> json) => $LoginInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $LoginInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LoginInfoDataData {
	dynamic name;
	late String openid;
	late String phone;
	late int sex;
	late String city;
	late String headimgurl;
	dynamic description;
	@JSONField(name: "membership_type")
	dynamic membershipType;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
	late int id;
	dynamic email;
	late String nickname;
	late String province;
	late String country;
	late String unionid;
	dynamic school;
	@JSONField(name: "membership_expiry_date")
	dynamic membershipExpiryDate;
	late String token;

	LoginInfoDataData();

	factory LoginInfoDataData.fromJson(Map<dynamic, dynamic> json) => $LoginInfoDataDataFromJson(json);

	Map<String, dynamic> toJson() => $LoginInfoDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}