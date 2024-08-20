// To parse this JSON data, do
//
//     final bindTeacherBean = bindTeacherBeanFromJson(jsonString);

import 'dart:convert';

BindTeacherBean bindTeacherBeanFromJson(String str) =>
    BindTeacherBean.fromJson(json.decode(str));

String bindTeacherBeanToJson(BindTeacherBean data) =>
    json.encode(data.toJson());

class BindTeacherBean {
  int code;
  String msg;
  Data data;

  BindTeacherBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory BindTeacherBean.fromJson(Map<String, dynamic> json) =>
      BindTeacherBean(
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
  String teacherName;
  String teacherQrCode;
  String teacherAvatar;
  String teacherDesc;
  String lessonTitle;

  Data({
    required this.teacherName,
    required this.teacherQrCode,
    required this.teacherAvatar,
    required this.teacherDesc,
    required this.lessonTitle,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        teacherName: json["teacher_name"],
        teacherQrCode: json["teacher_qr_code"],
        teacherAvatar: json["teacher_avatar"],
        teacherDesc: json["teacher_desc"],
        lessonTitle: json["lesson_title"],
      );

  Map<String, dynamic> toJson() => {
        "teacher_name": teacherName,
        "teacher_qr_code": teacherQrCode,
        "teacher_avatar": teacherAvatar,
        "teacher_desc": teacherDesc,
        "lesson_title": lessonTitle,
      };
}
