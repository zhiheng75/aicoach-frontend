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
  List<LevelList> list;

  Datum({
    required this.levelName,
    required this.list,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        levelName: json["level_name"],
        list: List<LevelList>.from(
            json["list"].map((x) => LevelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
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
  int userId;
  int levelId;
  String levelName;
  int unitId;
  String unitName;
  int lessonId;
  String lessonName;
  String lessonType;
  String objectives;
  int isUserBy;
  int completed;
  int isLocked;

  UnitList({
    required this.userId,
    required this.levelId,
    required this.levelName,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.lessonName,
    required this.lessonType,
    required this.objectives,
    required this.isUserBy,
    required this.completed,
    required this.isLocked,
  });

  factory UnitList.fromJson(Map<String, dynamic> json) => UnitList(
        userId: json["user_id"],
        levelId: json["level_id"],
        levelName: json["level_name"],
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        lessonType: json["lesson_type"],
        objectives: json["objectives"],
        isUserBy: json["is_user_by"],
        completed: json["completed"],
        isLocked: json["is_locked"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "level_id": levelId,
        "level_name": levelName,
        "unit_id": unitId,
        "unit_name": unitName,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "lesson_type": lessonType,
        "objectives": objectives,
        "is_user_by": isUserBy,
        "completed": completed,
        "is_locked": isLocked,
      };
}
