// To parse this JSON data, do
//
//     final examDetailBean = examDetailBeanFromJson(jsonString);

import 'dart:convert';

ExamDetailBean examDetailBeanFromJson(String str) =>
    ExamDetailBean.fromJson(json.decode(str));

String examDetailBeanToJson(ExamDetailBean data) => json.encode(data.toJson());

class ExamDetailBean {
  int code;
  String msg;
  Data data;

  ExamDetailBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ExamDetailBean.fromJson(Map<String, dynamic> json) => ExamDetailBean(
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
  int accuracyScoreHundred;
  int standardScore;
  int standardScoreHundred;
  int interactionScore;
  int interactionScoreHundred;
  int overallScore;
  int overallScoreHundred;
  int totalScore;
  int camb;
  String ket;
  String ketNext;
  String europe;
  int trainCount;
  String createTime;
  int duration;

  Data({
    required this.accuracyScore,
    required this.accuracyScoreHundred,
    required this.standardScore,
    required this.standardScoreHundred,
    required this.interactionScore,
    required this.interactionScoreHundred,
    required this.overallScore,
    required this.overallScoreHundred,
    required this.totalScore,
    required this.camb,
    required this.ket,
    required this.ketNext,
    required this.europe,
    required this.trainCount,
    required this.createTime,
    required this.duration,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accuracyScore: json["accuracy_score"] ?? 0,
        accuracyScoreHundred: json["accuracy_score_hundred"] ?? 0,
        standardScore: json["standard_score"] ?? 0,
        standardScoreHundred: json["standard_score_hundred"] ?? 0,
        interactionScore: json["interaction_score"] ?? 0,
        interactionScoreHundred: json["interaction_score_hundred"] ?? 0,
        overallScore: json["overall_score"] ?? 0,
        overallScoreHundred: json["overall_score__hundred"] ?? 0,
        totalScore: json["total_score"] ?? 0,
        camb: json["Camb"] ?? 0,
        ket: json["KET"] ?? '',
        ketNext: json["KET_NEXT"] ?? '',
        europe: json["europe"] ?? '',
        trainCount: json["train_count"] ?? 0,
        createTime: json["create_time"] ?? '',
        duration: json["duration"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "accuracy_score": accuracyScore,
        "accuracy_score_hundred": accuracyScoreHundred,
        "standard_score": standardScore,
        "standard_score_hundred": standardScoreHundred,
        "interaction_score": interactionScore,
        "interaction_score_hundred": interactionScoreHundred,
        "overall_score": overallScore,
        "overall_score__hundred": overallScoreHundred,
        "total_score": totalScore,
        "Camb": camb,
        "KET": ket,
        "KET_NEXT": ketNext,
        "europe": europe,
        "train_count": trainCount,
        "create_time": createTime,
        "duration": duration,
      };
}
