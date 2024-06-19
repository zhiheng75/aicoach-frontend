// To parse this JSON data, do
//
//     final goodsBean = goodsBeanFromJson(jsonString);

import 'dart:convert';

GoodsBean goodsBeanFromJson(String str) => GoodsBean.fromJson(json.decode(str));

String goodsBeanToJson(GoodsBean data) => json.encode(data.toJson());

class GoodsBean {
  int code;
  String msg;
  List<Datum> data;

  GoodsBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GoodsBean.fromJson(Map<String, dynamic> json) => GoodsBean(
        code: json["code"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String name;
  String desc;
  double price;
  int status;
  DateTime createdAt;
  String? unit;
  int sort;
  String tips;
  String? productId;
  int term;
  int originalPrice;
  int channelPrice;
  int type;
  int limit;
  int levelId;
  int purchaseTime;
  Detail detail;

  Datum({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.unit,
    required this.sort,
    required this.tips,
    required this.productId,
    required this.term,
    required this.originalPrice,
    required this.channelPrice,
    required this.type,
    required this.limit,
    required this.levelId,
    required this.purchaseTime,
    required this.detail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"]?.toDouble(),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        unit: json["unit"],
        sort: json["sort"],
        tips: json["tips"],
        productId: json["product_id"],
        term: json["term"],
        originalPrice: json["original_price"],
        channelPrice: json["channel_price"],
        type: json["type"],
        limit: json["limit"],
        levelId: json["level_id"] ?? 6666666666,
        purchaseTime: json["purchase_time"],
        detail: Detail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "unit": unit,
        "sort": sort,
        "tips": tips,
        "product_id": productId,
        "term": term,
        "original_price": originalPrice,
        "channel_price": channelPrice,
        "type": type,
        "limit": limit,
        "level_id": levelId,
        "purchase_time": purchaseTime,
        "detail": detail.toJson(),
      };
}

class Detail {
  int id;
  int levelId;
  int goodsId;
  String? levelName;
  String? tips;
  double? price;
  String? banner;
  String teacherImg;
  String? lessonTimeImg;
  List<String> userFeedbackImg;
  List<String> detailImg;
  List<Question> questions;

  Detail({
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

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        levelId: json["level_id"] ?? 66666666666,
        goodsId: json["goods_id"],
        levelName: json["level_name"],
        tips: json["tips"],
        price: json["price"]?.toDouble(),
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
