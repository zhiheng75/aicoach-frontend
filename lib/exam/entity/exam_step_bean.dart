// To parse this JSON data, do
//
//     final examStepBean = examStepBeanFromJson(jsonString);

import 'dart:convert';

ExamStepBean examStepBeanFromJson(String str) =>
    ExamStepBean.fromJson(json.decode(str));

String examStepBeanToJson(ExamStepBean data) => json.encode(data.toJson());

class ExamStepBean {
  int code;
  String msg;
  Data data;

  ExamStepBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ExamStepBean.fromJson(Map<String, dynamic> json) => ExamStepBean(
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
  int id;
  Introduction introduction;
  List<Part1Phase1> part1Phase1;
  List<Part1Phase1> part1Phase2;
  Part2Phase1 part2Phase1;
  List<Part1Phase1> part2Phase2;

  Data({
    required this.id,
    required this.introduction,
    required this.part1Phase1,
    required this.part1Phase2,
    required this.part2Phase1,
    required this.part2Phase2,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        introduction: Introduction.fromJson(json["Introduction"]),
        part1Phase1: List<Part1Phase1>.from(
            json["Part1Phase1"].map((x) => Part1Phase1.fromJson(x))),
        part1Phase2: List<Part1Phase1>.from(
            json["Part1Phase2"].map((x) => Part1Phase1.fromJson(x))),
        part2Phase1: Part2Phase1.fromJson(json["Part2Phase1"]),
        part2Phase2: List<Part1Phase1>.from(
            json["Part2Phase2"].map((x) => Part1Phase1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Introduction": introduction.toJson(),
        "Part1Phase1": List<dynamic>.from(part1Phase1.map((x) => x.toJson())),
        "Part1Phase2": List<dynamic>.from(part1Phase2.map((x) => x.toJson())),
        "Part2Phase1": part2Phase1.toJson(),
        "Part2Phase2": List<dynamic>.from(part2Phase2.map((x) => x.toJson())),
      };
}

class Introduction {
  String en;
  String zh;
  String audio;

  Introduction({
    required this.en,
    required this.zh,
    required this.audio,
  });

  factory Introduction.fromJson(Map<String, dynamic> json) => Introduction(
        en: json["en"],
        zh: json["zh"],
        audio: json["audio"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "zh": zh,
        "audio": audio,
      };
}

class Part1Phase1 {
  int id;
  String to;
  String question;
  String questionAudio;
  String? answer;
  String? answerAudio;

  Part1Phase1({
    required this.id,
    required this.to,
    required this.question,
    required this.questionAudio,
    this.answer,
    this.answerAudio,
  });

  factory Part1Phase1.fromJson(Map<String, dynamic> json) => Part1Phase1(
        id: json["id"],
        to: json["to"]!,
        question: json["question"],
        questionAudio: json["question_audio"],
        answer: json["answer"],
        answerAudio: json["answer_audio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "to": to,
        "question": question,
        "question_audio": questionAudio,
        "answer": answer,
        "answer_,audio": answerAudio,
      };
}

class Part2Phase1 {
  Base base;
  List<Part1Phase1> list;

  Part2Phase1({
    required this.base,
    required this.list,
  });

  factory Part2Phase1.fromJson(Map<String, dynamic> json) => Part2Phase1(
        base: Base.fromJson(json["base"]),
        list: List<Part1Phase1>.from(
            json["list"].map((x) => Part1Phase1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "base": base.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class Base {
  String title;
  String image;

  Base({
    required this.title,
    required this.image,
  });

  factory Base.fromJson(Map<String, dynamic> json) => Base(
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };
}
