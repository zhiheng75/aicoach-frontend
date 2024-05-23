// To parse this JSON data, do
//
//     final mistakeDetailsBean = mistakeDetailsBeanFromJson(jsonString);

import 'dart:convert';

MistakeDetailsBean mistakeDetailsBeanFromJson(String str) =>
    MistakeDetailsBean.fromJson(json.decode(str));

String mistakeDetailsBeanToJson(MistakeDetailsBean data) =>
    json.encode(data.toJson());

class MistakeDetailsBean {
  int code;
  String msg;
  List<Datum> data;

  MistakeDetailsBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory MistakeDetailsBean.fromJson(Map<String, dynamic> json) =>
      MistakeDetailsBean(
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
  int userId;
  int lessonId;
  String lessonName;
  String sentence;
  int userScore;
  String userSentence;
  String userAudio;
  String? suggestionSentence;
  String suggestionAudio;
  String? userPracticeSentence;
  String userPracticeAudio;
  int? userPracticeScore;
  int completed;

  Datum({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.lessonName,
    required this.sentence,
    required this.userScore,
    required this.userSentence,
    required this.userAudio,
    required this.suggestionSentence,
    required this.suggestionAudio,
    required this.userPracticeSentence,
    required this.userPracticeAudio,
    required this.userPracticeScore,
    required this.completed,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        lessonId: json["lesson_id"],
        lessonName: json["lesson_name"] ?? "",
        sentence: json["sentence"],
        userScore: json["user_score"],
        userSentence: json["user_sentence"],
        userAudio: json["user_audio"],
        suggestionSentence: json["suggestion_sentence"],
        suggestionAudio: json["suggestion_audio"],
        userPracticeSentence: json["user_practice_sentence"],
        userPracticeAudio: json["user_practice_audio"],
        userPracticeScore: json["user_practice_score"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "lesson_id": lessonId,
        "lesson_name": lessonName,
        "sentence": sentence,
        "user_score": userScore,
        "user_sentence": userSentence,
        "user_audio": userAudio,
        "suggestion_sentence": suggestionSentence,
        "suggestion_audio": suggestionAudio,
        "user_practice_sentence": userPracticeSentence,
        "user_practice_audio": userPracticeAudio,
        "user_practice_score": userPracticeScore,
        "completed": completed,
      };
}
