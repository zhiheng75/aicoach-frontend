// To parse this JSON data, do
//
//     final mistakeRecordsBean = mistakeRecordsBeanFromJson(jsonString);

import 'dart:convert';

MistakeRecordsBean mistakeRecordsBeanFromJson(String str) =>
    MistakeRecordsBean.fromJson(json.decode(str));

String mistakeRecordsBeanToJson(MistakeRecordsBean data) =>
    json.encode(data.toJson());

class MistakeRecordsBean {
  int code;
  String msg;
  List<MistakeDatum> data;

  MistakeRecordsBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory MistakeRecordsBean.fromJson(Map<String, dynamic> json) =>
      MistakeRecordsBean(
        code: json["code"],
        msg: json["msg"],
        data: List<MistakeDatum>.from(
            json["data"].map((x) => MistakeDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MistakeDatum {
  String levelName;
  List<DatumList> list;

  MistakeDatum({
    required this.levelName,
    required this.list,
  });

  factory MistakeDatum.fromJson(Map<String, dynamic> json) => MistakeDatum(
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
  String lessonType;
  String objectives;
  int isUserBuy;
  int completed;

  ListList({
    required this.userId,
    required this.levelId,
    required this.levelName,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.lessonName,
    required this.lessonType,
    required this.objectives,
    required this.isUserBuy,
    required this.completed,
  });

  factory ListList.fromJson(Map<String, dynamic> json) => ListList(
        userId: json["user_id"],
        levelId: json["level_id"],
        levelName: json["level_name"],
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        lessonType: json["lesson_type"],
        objectives: json["objectives"],
        isUserBuy: json["is_user_buy"],
        completed: json["completed"],
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
        "is_user_buy": isUserBuy,
        "completed": completed,
      };
}
