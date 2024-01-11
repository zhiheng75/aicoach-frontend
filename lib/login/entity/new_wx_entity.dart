// To parse this JSON data, do
//
//     final newWxInfoBean = newWxInfoBeanFromJson(jsonString);

import 'dart:convert';

import 'package:Bubble/generated/json/base/json_field.dart';

NewWxInfoBean newWxInfoBeanFromJson(String str) =>
    NewWxInfoBean.fromJson(json.decode(str));

String newWxInfoBeanToJson(NewWxInfoBean data) => json.encode(data.toJson());

@JsonSerializable()
class NewWxInfoBean {
  int code;
  String msg;
  NewWxInfoBeanData data;

  NewWxInfoBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory NewWxInfoBean.fromJson(Map<String, dynamic> json) => NewWxInfoBean(
        code: json["code"],
        msg: json["msg"],
        data: NewWxInfoBeanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };
}

class NewWxInfoBeanData {
  String openid;
  String nickname;
  String sex;
  String language;
  String city;
  String province;
  String country;
  String headimgurl;
  // List<dynamic> privilege;
  String unionid;
  String token;
  String id;

  NewWxInfoBeanData({
    required this.openid,
    required this.nickname,
    required this.sex,
    required this.language,
    required this.city,
    required this.province,
    required this.country,
    required this.headimgurl,
    // required this.privilege,
    required this.unionid,
    required this.token,
    required this.id,
  });

  factory NewWxInfoBeanData.fromJson(Map<String, dynamic> json) =>
      NewWxInfoBeanData(
        openid: json["openid"] ?? "",
        nickname: json["nickname"] ?? "",
        sex: json["sex"] ?? "",
        language: json["language"] ?? "",
        city: json["city"],
        province: json["province"] ?? "",
        country: json["country"] ?? "",
        headimgurl: json["headimgurl"] ?? "",
        // privilege: List<dynamic>.from(json["privilege"].map((x) => x)),
        unionid: json["unionid"] ?? "",
        token: json["token"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "openid": openid,
        "nickname": nickname,
        "sex": sex,
        "language": language,
        "city": city,
        "province": province,
        "country": country,
        "headimgurl": headimgurl,
        // "privilege": List<dynamic>.from(privilege.map((x) => x)),
        "unionid": unionid,
        "token": token,
        "id": id,
      };
}
