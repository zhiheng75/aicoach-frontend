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
  int sex;
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
        openid: json["openid"].toString() ?? "",
        nickname: json["nickname"].toString() ?? "",
        sex: json["sex"] ?? "",
        language: json["language"].toString() ?? "",
        city: json["city"].toString(),
        province: json["province"].toString() ?? "",
        country: json["country"].toString() ?? "",
        headimgurl: json["headimgurl"].toString() ?? "",
        // privilege: List<dynamic>.from(json["privilege"].map((x) => x)),
        unionid: json["unionid"].toString() ?? "",
        token: json["token"].toString() ?? "",
        id: json["id"].toString() ?? "",
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
