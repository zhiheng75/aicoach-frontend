// To parse this JSON data, do
//
//     final lessonReportDetailBean = lessonReportDetailBeanFromJson(jsonString);

import 'dart:convert';

LessonReportDetailBean lessonReportDetailBeanFromJson(String str) =>
    LessonReportDetailBean.fromJson(json.decode(str));

String lessonReportDetailBeanToJson(LessonReportDetailBean data) =>
    json.encode(data.toJson());

class LessonReportDetailBean {
  int code;
  String msg;
  Data data;

  LessonReportDetailBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LessonReportDetailBean.fromJson(Map<String, dynamic> json) =>
      LessonReportDetailBean(
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
  int accuracyScore;
  int fluencyScore;
  int integrityScore;
  int standardScore;
  int totalScore;
  int sentenceCount;
  String sentenceRank;
  String levelName;
  String unitName;
  String lessonName;
  int goodCount;
  String goodRank;
  List<ExcellentExpression> excellentExpression;
  Objectives objectives;

  Data({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.integrityScore,
    required this.standardScore,
    required this.totalScore,
    required this.sentenceCount,
    required this.sentenceRank,
    required this.levelName,
    required this.unitName,
    required this.lessonName,
    required this.goodCount,
    required this.goodRank,
    required this.excellentExpression,
    required this.objectives,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accuracyScore: json["accuracy_score"],
        fluencyScore: json["fluency_score"],
        integrityScore: json["integrity_score"],
        standardScore: json["standard_score"],
        totalScore: json["total_score"],
        sentenceCount: json["sentence_count"],
        sentenceRank: json["sentence_rank"],
        levelName: json["level_name"],
        unitName: json["unit_name"],
        lessonName: json["lesson_name"],
        goodCount: json["good_count"],
        goodRank: json["good_rank"],
        excellentExpression: List<ExcellentExpression>.from(
            json["excellent_expression"]
                .map((x) => ExcellentExpression.fromJson(x))),
        objectives: Objectives.fromJson(json["objectives"]),
      );

  Map<String, dynamic> toJson() => {
        "accuracy_score": accuracyScore,
        "fluency_score": fluencyScore,
        "integrity_score": integrityScore,
        "standard_score": standardScore,
        "total_score": totalScore,
        "sentence_count": sentenceCount,
        "sentence_rank": sentenceRank,
        "level_name": levelName,
        "unit_name": unitName,
        "lesson_name": lessonName,
        "good_count": goodCount,
        "good_rank": goodRank,
        "excellent_expression":
            List<dynamic>.from(excellentExpression.map((x) => x.toJson())),
        "objectives": objectives.toJson(),
      };
}

class ExcellentExpression {
  String sentence;
  int score;
  String audio;

  ExcellentExpression({
    required this.sentence,
    required this.score,
    required this.audio,
  });

  factory ExcellentExpression.fromJson(Map<String, dynamic> json) =>
      ExcellentExpression(
        sentence: json["sentence"],
        score: json["score"],
        audio: json["audio"],
      );

  Map<String, dynamic> toJson() => {
        "sentence": sentence,
        "score": score,
        "audio": audio,
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
