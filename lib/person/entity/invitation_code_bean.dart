// To parse this JSON data, do
//
//     final invitationCodeBean = invitationCodeBeanFromJson(jsonString);

import 'dart:convert';

InvitationCodeBean invitationCodeBeanFromJson(String str) =>
    InvitationCodeBean.fromJson(json.decode(str));

String invitationCodeBeanToJson(InvitationCodeBean data) =>
    json.encode(data.toJson());

class InvitationCodeBean {
  int code;
  String msg;
  Data data;

  InvitationCodeBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory InvitationCodeBean.fromJson(Map<String, dynamic> json) =>
      InvitationCodeBean(
        code: json["code"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
