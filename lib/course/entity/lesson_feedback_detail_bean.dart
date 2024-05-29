// To parse this JSON data, do
//
//     final lessonFeedbackDetailBean = lessonFeedbackDetailBeanFromJson(jsonString);

import 'dart:convert';

LessonFeedbackDetailBean lessonFeedbackDetailBeanFromJson(String str) =>
    LessonFeedbackDetailBean.fromJson(json.decode(str));

String lessonFeedbackDetailBeanToJson(LessonFeedbackDetailBean data) =>
    json.encode(data.toJson());

class LessonFeedbackDetailBean {
  int code;
  String msg;
  Data data;

  LessonFeedbackDetailBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonFeedbackDetailBean.fromJson(Map<String, dynamic> json) =>
      LessonFeedbackDetailBean(
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
  int userId;
  int anonymous;
  int lessonId;
  dynamic resources;
  int id;
  int star;
  String feedback;
  DateTime createdAt;

  Data({
    required this.userId,
    required this.anonymous,
    required this.lessonId,
    required this.resources,
    required this.id,
    required this.star,
    required this.feedback,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        anonymous: json["anonymous"],
        lessonId: json["lesson_id"],
        resources: json["resources"],
        id: json["id"],
        star: json["star"],
        feedback: json["feedback"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "anonymous": anonymous,
        "lesson_id": lessonId,
        "resources": resources,
        "id": id,
        "star": star,
        "feedback": feedback,
        "created_at": createdAt.toIso8601String(),
      };
}
