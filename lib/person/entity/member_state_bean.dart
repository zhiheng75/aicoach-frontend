// To parse this JSON data, do
//
//     final memberStateBean = memberStateBeanFromJson(jsonString);

import 'dart:convert';

MemberStateBean memberStateBeanFromJson(String str) =>
    MemberStateBean.fromJson(json.decode(str));

String memberStateBeanToJson(MemberStateBean data) =>
    json.encode(data.toJson());

class MemberStateBean {
  int code;
  String msg;
  Data data;

  MemberStateBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory MemberStateBean.fromJson(Map<String, dynamic> json) =>
      MemberStateBean(
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
  int isMember;
  int isLessonMember;

  Data({
    required this.isMember,
    required this.isLessonMember,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isMember: json["is_member"],
        isLessonMember: json["is_lesson_member"],
      );

  Map<String, dynamic> toJson() => {
        "is_member": isMember,
        "is_lesson_member": isLessonMember,
      };
}
