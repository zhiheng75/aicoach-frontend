// To parse this JSON data, do
//
//     final lessonListBean = lessonListBeanFromJson(jsonString);

import 'dart:convert';

LessonListBean lessonListBeanFromJson(String str) =>
    LessonListBean.fromJson(json.decode(str));

String lessonListBeanToJson(LessonListBean data) => json.encode(data.toJson());

class LessonListBean {
  int code;
  String msg;
  List<Datum> data;

  LessonListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonListBean.fromJson(Map<String, dynamic> json) => LessonListBean(
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
  String levelName;
  int levelId;

  List<LevelList> list;

  Datum({
    required this.levelName,
    required this.levelId,
    required this.list,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        levelName: json["level_name"],
        levelId: json["level_id"],
        list: List<LevelList>.from(
            json["list"].map((x) => LevelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "level_id": levelId,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class LevelList {
  String unitName;
  List<UnitList> list;

  LevelList({
    required this.unitName,
    required this.list,
  });

  factory LevelList.fromJson(Map<String, dynamic> json) => LevelList(
        unitName: json["unit_name"],
        list:
            List<UnitList>.from(json["list"].map((x) => UnitList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unit_name": unitName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class UnitList {
  // int userId;
  int levelId;
  String levelName;
  int goodsLabel;

  int unitId;
  String unitName;
  int lessonId;
  String lessonName;
  String lessonLabel;
  // String unlockDate;

  String lessonType;
  String lessonDescription;

  int isUserBuy;
  int completed;
  int isLocked;
  Objectives objectives;

  UnitList({
    // required this.userId,
    required this.levelId,
    required this.levelName,
    required this.goodsLabel,
    required this.lessonLabel,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.lessonName,
    // required this.unlockDate,
    required this.lessonType,
    required this.lessonDescription,
    required this.isUserBuy,
    required this.completed,
    required this.isLocked,
    required this.objectives,
  });

  factory UnitList.fromJson(Map<String, dynamic> json) => UnitList(
        // userId: json["user_id"],
        levelId: json["level_id"],
        levelName: json["level_name"],
        goodsLabel: json["goods_label"] ?? 0,
        lessonLabel: json["lesson_label"],
        lessonDescription: json["lesson_description"],
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        // unlockDate: json["unlock_date"],

        lessonType: json["lesson_type"] ?? "",
        isUserBuy: json["is_user_buy"] ?? 0,
        completed: json["completed"],
        isLocked: json["is_locked"],
        objectives: Objectives.fromJson(json["objectives"]),
      );

  Map<String, dynamic> toJson() => {
        // "user_id": userId,
        "level_id": levelId,
        "level_name": levelName,
        "lesson_label": lessonLabel,
        "goods_label": goodsLabel,
        "lesson_description": lessonDescription,
        "unit_id": unitId,
        "unit_name": unitName,
        // "unlock_date": unlockDate,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "lesson_type": lessonType,
        "is_user_buy": isUserBuy,
        "completed": completed,
        "is_locked": isLocked,
        "objectives": objectives.toJson(),
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
