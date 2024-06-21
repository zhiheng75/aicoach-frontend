// To parse this JSON data, do
//
//     final lessonTimeBean = lessonTimeBeanFromJson(jsonString);

import 'dart:convert';

LessonTimeBean lessonTimeBeanFromJson(String str) =>
    LessonTimeBean.fromJson(json.decode(str));

String lessonTimeBeanToJson(LessonTimeBean data) => json.encode(data.toJson());

class LessonTimeBean {
  int code;
  String msg;
  Data data;

  LessonTimeBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonTimeBean.fromJson(Map<String, dynamic> json) => LessonTimeBean(
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
  int lessonId;
  String createdAt;
  int classId;
  String startDate;
  int id;

  Data({
    required this.lessonId,
    required this.createdAt,
    required this.classId,
    required this.startDate,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lessonId: json["lesson_id"],
        createdAt: json["created_at"],
        classId: json["class_id"],
        startDate: json["start_date"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "lesson_id": lessonId,
        "created_at": createdAt,
        "class_id": classId,
        "start_date": startDate,
        "id": id,
      };
}
