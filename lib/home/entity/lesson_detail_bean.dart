// To parse this JSON data, do
//
//     final lessonDetailBean = lessonDetailBeanFromJson(jsonString);

import 'dart:convert';

LessonDetailBean lessonDetailBeanFromJson(String str) =>
    LessonDetailBean.fromJson(json.decode(str));

String lessonDetailBeanToJson(LessonDetailBean data) =>
    json.encode(data.toJson());

class LessonDetailBean {
  int code;
  String msg;
  Data data;

  LessonDetailBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonDetailBean.fromJson(Map<String, dynamic> json) =>
      LessonDetailBean(
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
  int id;
  int levelId;
  int goodsId;
  String levelName;
  String tips;
  double price;
  String banner;
  String teacherImg;
  String lessonTimeImg;
  List<String> userFeedbackImg;
  List<String> detailImg;
  List<Question> questions;

  Data({
    required this.id,
    required this.levelId,
    required this.goodsId,
    required this.levelName,
    required this.tips,
    required this.price,
    required this.banner,
    required this.teacherImg,
    required this.lessonTimeImg,
    required this.userFeedbackImg,
    required this.detailImg,
    required this.questions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        levelId: json["level_id"],
        goodsId: json["goods_id"],
        levelName: json["level_name"],
        tips: json["tips"],
        price: json["price"],
        banner: json["banner"],
        teacherImg: json["teacher_img"],
        lessonTimeImg: json["lesson_time_img"],
        userFeedbackImg:
            List<String>.from(json["user_feedback_img"].map((x) => x)),
        detailImg: List<String>.from(json["detail_img"].map((x) => x)),
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level_id": levelId,
        "goods_id": goodsId,
        "level_name": levelName,
        "tips": tips,
        "price": price,
        "banner": banner,
        "teacher_img": teacherImg,
        "lesson_time_img": lessonTimeImg,
        "user_feedback_img": List<dynamic>.from(userFeedbackImg.map((x) => x)),
        "detail_img": List<dynamic>.from(detailImg.map((x) => x)),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  String questionType;
  List<ListElement> list;

  Question({
    required this.questionType,
    required this.list,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionType: json["question_type"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_type": questionType,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  String q;
  String a;

  ListElement({
    required this.q,
    required this.a,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        q: json["q"],
        a: json["a"],
      );

  Map<String, dynamic> toJson() => {
        "q": q,
        "a": a,
      };
}
