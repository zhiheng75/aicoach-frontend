// To parse this JSON data, do
//
//     final lessonReportsBean = lessonReportsBeanFromJson(jsonString);

import 'dart:convert';

LessonReportsBean lessonReportsBeanFromJson(String str) =>
    LessonReportsBean.fromJson(json.decode(str));

String lessonReportsBeanToJson(LessonReportsBean data) =>
    json.encode(data.toJson());

class LessonReportsBean {
  int code;
  String msg;
  List<ReportsDatum> data;

  LessonReportsBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonReportsBean.fromJson(Map<String, dynamic> json) =>
      LessonReportsBean(
        code: json["code"],
        msg: json["msg"],
        data: List<ReportsDatum>.from(
            json["data"].map((x) => ReportsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ReportsDatum {
  String levelName;
  List<DatumList> list;

  ReportsDatum({
    required this.levelName,
    required this.list,
  });

  factory ReportsDatum.fromJson(Map<String, dynamic> json) => ReportsDatum(
        levelName: json["level_name"],
        list: List<DatumList>.from(
            json["list"].map((x) => DatumList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class DatumList {
  String unitName;
  List<ListList> list;

  DatumList({
    required this.unitName,
    required this.list,
  });

  factory DatumList.fromJson(Map<String, dynamic> json) => DatumList(
        unitName: json["unit_name"],
        list:
            List<ListList>.from(json["list"].map((x) => ListList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unit_name": unitName,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListList {
  int userId;
  int levelId;
  String levelName;
  int unitId;
  String unitName;
  int lessonId;
  String lessonName;
  String lessonLabel;

  String lessonType;
  String objectives;
  int isUserBuy;
  int score;
  String createdAt;

  ListList({
    required this.userId,
    required this.levelId,
    required this.levelName,
    required this.lessonLabel,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.createdAt,
    required this.lessonName,
    required this.lessonType,
    required this.objectives,
    required this.isUserBuy,
    required this.score,
  });

  factory ListList.fromJson(Map<String, dynamic> json) => ListList(
        userId: json["user_id"],
        levelId: json["level_id"],
        createdAt: json["created_at"],
        levelName: json["level_name"],
        lessonLabel: json["lesson_label"],
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        lessonType: json["lesson_type"],
        objectives: json["objectives"],
        isUserBuy: json["is_user_buy"],
        score: json["score"],
      );

  get completed => null;

  get isLocked => null;

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "level_id": levelId,
        "created_at": createdAt,
        "level_name": levelName,
        "lesson_label": lessonLabel,
        "unit_id": unitId,
        "unit_name": unitName,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "lesson_type": lessonType,
        "objectives": objectives,
        "is_user_buy": isUserBuy,
        "score": score,
      };
}
