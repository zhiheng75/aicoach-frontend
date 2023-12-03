import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/my_user_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/my_user_info_entity.g.dart';

@JsonSerializable()
class MyUserInfoEntity {
	late MyUserInfoData data;

	MyUserInfoEntity();

	factory MyUserInfoEntity.fromJson(Map<String, dynamic> json) => $MyUserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $MyUserInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MyUserInfoData {
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

	MyUserInfoData();

	factory MyUserInfoData.fromJson(Map<dynamic, dynamic> json) => $MyUserInfoDataFromJson(json);

	Map<dynamic, dynamic> toJson() => $MyUserInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}