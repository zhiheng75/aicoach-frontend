import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/user_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
	late int code;
	late UserInfoData data;
	late String message;

	UserInfoEntity();

	factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UserInfoData {
	late int code;
	late String msg;
	late UserInfoDataData data;

	UserInfoData();

	factory UserInfoData.fromJson(Map<String, dynamic> json) => $UserInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UserInfoDataData {
	late int id;
	dynamic email;
	late String nickname;
	late String province;
	late String country;
	late String unionid;
	dynamic school;
	@JSONField(name: "created_at")
	late String createdAt;
	late String openid;
	dynamic name;
	late String phone;
	late int sex;
	late String city;
	late String headimgurl;
	dynamic description;
	@JSONField(name: "updated_at")
	late String updatedAt;
	late String token;

	UserInfoDataData();

	factory UserInfoDataData.fromJson(Map<String, dynamic> json) => $UserInfoDataDataFromJson(json);

	Map<dynamic, dynamic> toJson() => $UserInfoDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}