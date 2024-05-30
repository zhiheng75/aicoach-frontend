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
  int star;
  String feedback;
  int anonymous;
  Data({
    required this.star,
    required this.anonymous,
    required this.feedback,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        star: json["star"] ?? 0,
        anonymous: json["anonymous"] ?? 0,
        feedback: json["feedback"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "star": star,
        "anonymous": anonymous,
        "feedback": feedback,
      };
}
