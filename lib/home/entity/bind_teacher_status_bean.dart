// To parse this JSON data, do
//
//     final bindTeacherStatusBean = bindTeacherStatusBeanFromJson(jsonString);

import 'dart:convert';

BindTeacherStatusBean bindTeacherStatusBeanFromJson(String str) =>
    BindTeacherStatusBean.fromJson(json.decode(str));

String bindTeacherStatusBeanToJson(BindTeacherStatusBean data) =>
    json.encode(data.toJson());

class BindTeacherStatusBean {
  int code;
  String msg;
  Data data;

  BindTeacherStatusBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory BindTeacherStatusBean.fromJson(Map<String, dynamic> json) =>
      BindTeacherStatusBean(
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
  int count;
  Detail detail;

  Data({
    required this.count,
    required this.detail,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        detail: Detail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "detail": detail.toJson(),
      };
}

class Detail {
  int id;
  int userId;
  String createdAt;
  int isBind;
  int levelId;
  int teacherId;

  Detail({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.isBind,
    required this.levelId,
    required this.teacherId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        createdAt: json["created_at"],
        isBind: json["is_bind"],
        levelId: json["level_id"],
        teacherId: json["teacher_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt,
        "is_bind": isBind,
        "level_id": levelId,
        "teacher_id": teacherId,
      };
}
