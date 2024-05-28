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
  List<CourseDatum> data;
  int userId;
  int levelId;
  int stepId;

  int isUserBuy;

  int reportStatus;
  int mistakeStatus;
  int evaluationStatus;
  int mistakeCount;

  String levelName;
  int unitId;
  String unitName;
  int lessonId;
  String lessonName;
  String lessonLabel;

  String lessonType;
  Objectives objectives;
  String title;

  Data({
    required this.data,
    required this.userId,
    required this.stepId,
    required this.isUserBuy,
    required this.reportStatus,
    required this.mistakeStatus,
    required this.evaluationStatus,
    required this.mistakeCount,
    required this.levelId,
    required this.levelName,
    required this.lessonLabel,
    required this.title,
    required this.unitId,
    required this.unitName,
    required this.lessonId,
    required this.lessonName,
    required this.lessonType,
    required this.objectives,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<CourseDatum>.from(
            json["data"].map((x) => CourseDatum.fromJson(x))),
        userId: json["user_id"] ?? 0,
        stepId: json["step_id"] ?? 0,
        levelId: json["level_id"] ?? 0,
        isUserBuy: json["is_user_buy"] ?? 0,
        reportStatus: json["report_status"],
        lessonLabel: json["lesson_label"],
        mistakeStatus: json["mistake_status"],
        evaluationStatus: json["evaluation_status"],
        mistakeCount: json["mistake_count"] ?? 0,
        levelName: json["level_name"],
        title: json["title"] ?? "",
        unitId: json["unit_id"],
        unitName: json["unit_name"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"],
        lessonType: json["lesson_type"],
        objectives: Objectives.fromJson(json["objectives"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "user_id": userId,
        "step_id": stepId,
        "level_id": levelId,
        "lesson_label": lessonLabel,
        "is_user_buy": isUserBuy,
        "report_status": reportStatus,
        "mistake_status": mistakeStatus,
        "evaluation_status": evaluationStatus,
        "mistake_count": mistakeCount,
        "level_name": levelName,
        "title": title,
        "unit_id": unitId,
        "unit_name": unitName,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "lesson_type": lessonType,
        "objectives": objectives.toJson(),
      };
}

class CourseDatum {
  int completed;
  int stepId;
  int isLocked;

  String stepName;
  String sceneIds;
  int stepIcon;
  List<Resource> resource;

  CourseDatum({
    required this.completed,
    required this.stepId,
    required this.isLocked,
    required this.stepName,
    required this.sceneIds,
    required this.stepIcon,
    required this.resource,
  });

  factory CourseDatum.fromJson(Map<String, dynamic> json) => CourseDatum(
        completed: json["completed"],
        stepId: json["step_id"],
        isLocked: json["is_locked"],
        stepName: json["step_name"],
        sceneIds: json["scene_ids"],
        stepIcon: json["step_icon"],
        resource: List<Resource>.from(
            json["resource"].map((x) => Resource.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "step_id": stepId,
        "is_locked": isLocked,
        "step_name": stepName,
        "scene_ids": sceneIds,
        "step_icon": stepIcon,
        "resource": List<dynamic>.from(resource.map((x) => x.toJson())),
      };
}

class Resource {
  int? sceneId;
  String? characterId;
  int resourceType;
  String? gameUrl;
  String? title;
  String? greetingAudio;
  String? greetingText;
  String? introFileType;
  String? introFile;
  String? introAudio;
  String? introText;
  String characterAvatar;
  String introVideoCover;

  Resource({
    required this.sceneId,
    required this.characterId,
    required this.resourceType,
    required this.gameUrl,
    required this.title,
    required this.greetingAudio,
    required this.greetingText,
    required this.introFileType,
    required this.introFile,
    required this.introAudio,
    required this.introText,
    required this.characterAvatar,
    required this.introVideoCover,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        sceneId: json["scene_id"] ?? 0,
        characterId: json["character_id"] ?? "",
        resourceType: json["resource_type"] ?? 1,
        gameUrl: json["game_url"] ?? "",
        title: json["title"] ?? "",
        introVideoCover: json["intro_video_cover"] ?? "",
        greetingAudio: json["greeting_audio"] ?? "999999",
        greetingText: json["greeting_text"] ?? "999999",
        introFileType: json["intro_file_type"] ?? "999999",
        introFile: json["intro_file"] ?? "999999",
        introAudio: json["intro_audio"] ?? "999999",
        introText: json["intro_text"] ?? "999999",
        characterAvatar: json["character_avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "scene_id": sceneId,
        "character_id": characterId,
        "resource_type": resourceType,
        "game_url": gameUrl,
        "title": title,
        "greeting_audio": greetingAudio,
        "greeting_text": greetingText,
        "intro_file_type": introFileType,
        "intro_file": introFile,
        "intro_audio": introAudio,
        "intro_text": introText,
        "intro_video_cover": introVideoCover,
        "character_avatar": characterAvatar,
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
