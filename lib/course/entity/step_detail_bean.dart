// To parse this JSON data, do
//
//     final stepDetailBean = stepDetailBeanFromJson(jsonString);

import 'dart:convert';

StepDetailBean stepDetailBeanFromJson(String str) =>
    StepDetailBean.fromJson(json.decode(str));

String stepDetailBeanToJson(StepDetailBean data) => json.encode(data.toJson());

class StepDetailBean {
  int code;
  String msg;
  Data data;

  StepDetailBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory StepDetailBean.fromJson(Map<String, dynamic> json) => StepDetailBean(
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
  List<Datum> data;
  int userId;
  int levelId;
  String levelName;
  int unitId;
  String unitName;
  int lessonId;
  String lessonName;
  String lessonType;
  String objectives;

  Data({
    required this.data,
    required this.userId,
    required this.levelId,
    required this.levelName,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.lessonName,
    required this.lessonType,
    required this.objectives,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        userId: json["user_id"],
        levelId: json["level_id"],
        levelName: json["level_name"],
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        lessonType: json["lesson_type"],
        objectives: json["objectives"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "user_id": userId,
        "level_id": levelId,
        "level_name": levelName,
        "unit_id": unitId,
        "unit_name": unitName,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "lesson_type": lessonType,
        "objectives": objectives,
      };
}

class Datum {
  bool completed;
  int stepId;
  String stepName;
  String sceneIds;
  dynamic resources;

  Datum({
    required this.completed,
    required this.stepId,
    required this.stepName,
    required this.sceneIds,
    required this.resources,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        completed: json["completed"],
        stepId: json["step_id"],
        stepName: json["step_name"],
        sceneIds: json["scene_ids"],
        resources: json["resources"],
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "step_id": stepId,
        "step_name": stepName,
        "scene_ids": sceneIds,
        "resources": resources,
      };
}
