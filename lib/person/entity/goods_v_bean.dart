// To parse this JSON data, do
//
//     final goodsVBean = goodsVBeanFromJson(jsonString);

import 'dart:convert';

GoodsVBean goodsVBeanFromJson(String str) =>
    GoodsVBean.fromJson(json.decode(str));

String goodsVBeanToJson(GoodsVBean data) => json.encode(data.toJson());

class GoodsVBean {
  int code;
  String msg;
  Data data;

  GoodsVBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GoodsVBean.fromJson(Map<String, dynamic> json) => GoodsVBean(
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
  PackageList packageList;
  LessonList lessonList;

  Data({
    required this.packageList,
    required this.lessonList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        packageList: PackageList.fromJson(json["package_list"]),
        lessonList: LessonList.fromJson(json["lesson_list"]),
      );

  Map<String, dynamic> toJson() => {
        "package_list": packageList.toJson(),
        "lesson_list": lessonList.toJson(),
      };
}

class LessonList {
  String tabName;
  List<LessonListList> list;

  LessonList({
    required this.tabName,
    required this.list,
  });

  factory LessonList.fromJson(Map<String, dynamic> json) => LessonList(
        tabName: json["tab_name"],
        list: List<LessonListList>.from(
            json["list"].map((x) => LessonListList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tab_name": tabName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class LessonListList {
  int id;
  String name;
  String desc;
  String price;
  int status;
  String createdAt;
  String unit;
  int sort;
  int isSelected;
  String tips;
  dynamic productId;
  int term;
  String originalPrice;
  String channelPrice;
  int type;
  int limit;
  int levelId;
  int activityLeftTime;
  int purchaseTime;
  List<Lesson> lessons;
  PurpleDetail detail;

  LessonListList({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.unit,
    required this.sort,
    required this.isSelected,
    required this.tips,
    required this.productId,
    required this.term,
    required this.originalPrice,
    required this.channelPrice,
    required this.type,
    required this.limit,
    required this.levelId,
    required this.activityLeftTime,
    required this.purchaseTime,
    required this.lessons,
    required this.detail,
  });

  factory LessonListList.fromJson(Map<String, dynamic> json) => LessonListList(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"]!.toString(),
        status: json["status"],
        createdAt: json["created_at"],
        unit: json["unit"],
        sort: json["sort"],
        isSelected: json["is_selected"],
        tips: json["tips"],
        productId: json["product_id"],
        term: json["term"],
        originalPrice: json["original_price"].toString(),
        channelPrice: json["channel_price"].toString(),
        type: json["type"],
        limit: json["limit"],
        levelId: json["level_id"] ?? 0,
        activityLeftTime: json["activity_left_time"],
        purchaseTime: json["purchase_time"],
        lessons:
            List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
        detail: PurpleDetail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "status": status,
        "created_at": createdAt,
        "unit": unit,
        "sort": sort,
        "is_selected": isSelected,
        "tips": tips,
        "product_id": productId,
        "term": term,
        "original_price": originalPrice,
        "channel_price": channelPrice,
        "type": type,
        "limit": limit,
        "level_id": levelId,
        "activity_left_time": activityLeftTime,
        "purchase_time": purchaseTime,
        "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
        "detail": detail.toJson(),
      };
}

class PurpleDetail {
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

  PurpleDetail({
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

  factory PurpleDetail.fromJson(Map<String, dynamic> json) => PurpleDetail(
        id: json["id"],
        levelId: json["level_id"],
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
  List<QuestionList> list;

  Question({
    required this.questionType,
    required this.list,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionType: json["question_type"],
        list: List<QuestionList>.from(
            json["list"].map((x) => QuestionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_type": questionType,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class QuestionList {
  String q;
  String a;

  QuestionList({
    required this.q,
    required this.a,
  });

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
        q: json["q"],
        a: json["a"],
      );

  Map<String, dynamic> toJson() => {
        "q": q,
        "a": a,
      };
}

class Lesson {
  String unitName;
  List<LessonListClass> list;

  Lesson({
    required this.unitName,
    required this.list,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        unitName: json["unit_name"],
        list: List<LessonListClass>.from(
            json["list"].map((x) => LessonListClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unit_name": unitName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class LessonListClass {
  int levelId;
  String levelLabel;
  String levelName;
  int goodsLabel;
  int unitId;
  String unitLabel;
  String unitName;
  int lessonId;
  String lessonLabel;
  String lessonName;
  String unlockDate;
  String lessonDescription;
  String lessonType;
  Objectives objectives;
  int isUserBuy;
  int completed;
  int isLocked;

  LessonListClass({
    required this.levelId,
    required this.levelLabel,
    required this.levelName,
    required this.goodsLabel,
    required this.unitId,
    required this.unitLabel,
    required this.unitName,
    required this.lessonId,
    required this.lessonLabel,
    required this.lessonName,
    required this.unlockDate,
    required this.lessonDescription,
    required this.lessonType,
    required this.objectives,
    required this.isUserBuy,
    required this.completed,
    required this.isLocked,
  });

  factory LessonListClass.fromJson(Map<String, dynamic> json) =>
      LessonListClass(
        levelId: json["level_id"],
        levelLabel: json["level_label"],
        levelName: json["level_name"],
        goodsLabel: json["goods_label"],
        unitId: json["unit_id"],
        unitLabel: json["unit_label"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonLabel: json["lesson_label"],
        lessonName: json["lesson_name"],
        unlockDate: json["unlock_date"],
        lessonDescription: json["lesson_description"],
        lessonType: json["lesson_type"],
        objectives: Objectives.fromJson(json["objectives"]),
        isUserBuy: json["is_user_buy"],
        completed: json["completed"],
        isLocked: json["is_locked"],
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "level_label": levelLabel,
        "level_name": levelName,
        "goods_label": goodsLabel,
        "unit_id": unitId,
        "unit_label": unitLabel,
        "unit_name": unitName,
        "lesson_id": lessonId,
        "lesson_label": lessonLabel,
        "lesson_name": lessonName,
        "unlock_date": unlockDate,
        "lesson_description": lessonDescription,
        "lesson_type": lessonType,
        "objectives": objectives.toJson(),
        "is_user_buy": isUserBuy,
        "completed": completed,
        "is_locked": isLocked,
      };
}

class Objectives {
  List<Vocabulary> vocabulary;
  List<SentencePattern> sentencePattern;
  List<SpeakingSkill> speakingSkills;

  Objectives({
    required this.vocabulary,
    required this.sentencePattern,
    required this.speakingSkills,
  });

  factory Objectives.fromJson(Map<String, dynamic> json) => Objectives(
        vocabulary: List<Vocabulary>.from(
            json["Vocabulary"].map((x) => Vocabulary.fromJson(x))),
        sentencePattern: List<SentencePattern>.from(
            json["Sentence Pattern"].map((x) => SentencePattern.fromJson(x))),
        speakingSkills: List<SpeakingSkill>.from(
            json["Speaking Skills"].map((x) => SpeakingSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Vocabulary": List<dynamic>.from(vocabulary.map((x) => x.toJson())),
        "Sentence Pattern":
            List<dynamic>.from(sentencePattern.map((x) => x.toJson())),
        "Speaking Skills":
            List<dynamic>.from(speakingSkills.map((x) => x.toJson())),
      };
}

class SentencePattern {
  String sentence;

  SentencePattern({
    required this.sentence,
  });

  factory SentencePattern.fromJson(Map<String, dynamic> json) =>
      SentencePattern(
        sentence: json["sentence"],
      );

  Map<String, dynamic> toJson() => {
        "sentence": sentence,
      };
}

class SpeakingSkill {
  String skill;

  SpeakingSkill({
    required this.skill,
  });

  factory SpeakingSkill.fromJson(Map<String, dynamic> json) => SpeakingSkill(
        skill: json["skill"],
      );

  Map<String, dynamic> toJson() => {
        "skill": skill,
      };
}

class Vocabulary {
  String word;

  Vocabulary({
    required this.word,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) => Vocabulary(
        word: json["word"],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
      };
}

class PackageList {
  String tabName;
  List<PackageListList> list;

  PackageList({
    required this.tabName,
    required this.list,
  });

  factory PackageList.fromJson(Map<String, dynamic> json) => PackageList(
        tabName: json["tab_name"],
        list: List<PackageListList>.from(
            json["list"].map((x) => PackageListList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tab_name": tabName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class PackageListList {
  int id;
  String name;
  String desc;
  String price;
  int status;
  String createdAt;
  String? unit;
  int sort;
  int isSelected;
  String tips;
  String? productId;
  int term;
  String originalPrice;
  String channelPrice;
  int type;
  int limit;
  int levelId;
  int activityLeftTime;
  int purchaseTime;
  FluffyDetail detail;

  PackageListList({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.unit,
    required this.sort,
    required this.isSelected,
    required this.tips,
    required this.productId,
    required this.term,
    required this.originalPrice,
    required this.channelPrice,
    required this.type,
    required this.limit,
    required this.levelId,
    required this.activityLeftTime,
    required this.purchaseTime,
    required this.detail,
  });

  factory PackageListList.fromJson(Map<String, dynamic> json) =>
      PackageListList(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"]!.toString(),
        status: json["status"],
        createdAt: json["created_at"],
        unit: json["unit"],
        sort: json["sort"],
        isSelected: json["is_selected"],
        tips: json["tips"],
        productId: json["product_id"],
        term: json["term"],
        originalPrice: json["original_price"].toString(),
        channelPrice: json["channel_price"].toString(),
        type: json["type"],
        limit: json["limit"],
        levelId: json["level_id"] ?? 0,
        activityLeftTime: json["activity_left_time"],
        purchaseTime: json["purchase_time"],
        detail: FluffyDetail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "status": status,
        "created_at": createdAt,
        "unit": unit,
        "sort": sort,
        "is_selected": isSelected,
        "tips": tips,
        "product_id": productId,
        "term": term,
        "original_price": originalPrice,
        "channel_price": channelPrice,
        "type": type,
        "limit": limit,
        "level_id": levelId,
        "activity_left_time": activityLeftTime,
        "purchase_time": purchaseTime,
        "detail": detail.toJson(),
      };
}

class FluffyDetail {
  int id;
  int goodsId;
  String teacherImg;
  List<String> userFeedbackImg;
  List<String> detailImg;

  FluffyDetail({
    required this.id,
    required this.goodsId,
    required this.teacherImg,
    required this.userFeedbackImg,
    required this.detailImg,
  });

  factory FluffyDetail.fromJson(Map<String, dynamic> json) => FluffyDetail(
        id: json["id"],
        goodsId: json["goods_id"],
        teacherImg: json["teacher_img"],
        userFeedbackImg:
            List<String>.from(json["user_feedback_img"].map((x) => x)),
        detailImg: List<String>.from(json["detail_img"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "goods_id": goodsId,
        "teacher_img": teacherImg,
        "user_feedback_img": List<dynamic>.from(userFeedbackImg.map((x) => x)),
        "detail_img": List<dynamic>.from(detailImg.map((x) => x)),
      };
}
