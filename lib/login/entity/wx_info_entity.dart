import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/wx_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/wx_info_entity.g.dart';

@JsonSerializable()
class WxInfoEntity {
  late int code;
  late WxInfoData data;
  late String message;

  WxInfoEntity();

  factory WxInfoEntity.fromJson(Map<String, dynamic> json) =>
      $WxInfoEntityFromJson(json);

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

  factory WxInfoData.fromJson(Map<String, dynamic> json) =>
      $WxInfoDataFromJson(json);

  Map<String, dynamic> toJson() => $WxInfoDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WxInfoDataData {
  late dynamic name = "";
  late String openid;
  late String nickname;
  late int sex;
  // late String language;
  late String city;
  late String province;
  late String country;
  late String headimgurl;
  // late List<dynamic> privilege;
  late String unionid;

  late String school = "";
  late String token;
  late String phone;
  late dynamic description;
  late dynamic membership_type;
  @JSONField(name: "created_at")
  late String createdAt;
  @JSONField(name: "updated_at")
  late String updatedAt;
  late int id;

  WxInfoDataData();

  factory WxInfoDataData.fromJson(Map<String, dynamic> json) =>
      $WxInfoDataDataFromJson(json);

  Map<String, dynamic> toJson() => $WxInfoDataDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
