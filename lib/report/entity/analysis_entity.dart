import 'dart:io';

import 'package:Bubble/util/path_utils.dart';
import 'package:dio/dio.dart';

class AnalysisEntity {

  int type = 2;
  String sentence = '';
  String userSentence = '';
  num score = 0;
  List<GrammarEntity> grammar = [];
  List<PronounceEntity> pronounce = [];

  AnalysisEntity();

  factory AnalysisEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AnalysisEntity entity = AnalysisEntity();
    if (json['type'] != null) {
      entity.type = json['type'];
    }
    if (json['sentence'] != null) {
      entity.sentence = json['sentence'];
    }
    if (json['user_sentence'] != null) {
      entity.userSentence = json['user_sentence'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['grammar'] != null && json['grammar'] is List) {
      entity.grammar = (json['grammar'] as List).map((item) => GrammarEntity.fromJson(item)).toList();
    }
    if (json['pronounce'] != null && json['pronounce'] is List) {
      entity.pronounce = (json['pronounce'] as List).map((item) => PronounceEntity.fromJson(item)).toList();
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sentence': sentence,
      'user_sentence': userSentence,
      'grammar': grammar.map((item) => item.toJson()).toList(),
      'pronounce': pronounce.map((item) => item.toJson()).toList(),
    };
  }

}

class GrammarEntity {
  String en = '';
  String zh = '';

  GrammarEntity();

  factory GrammarEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    GrammarEntity entity = GrammarEntity();
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
    };
  }
}

class PronounceEntity {
  String text = '';
  String audio = '';
  int begin = 0;
  int end = 0;
  CancelToken? cancelToken;

  PronounceEntity();

  factory PronounceEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    PronounceEntity entity = PronounceEntity();
    if (json['content'] != null) {
      entity.text = json['content'];
    }
    if (json['beg_pos'] != null) {
      entity.begin = json['beg_pos'] is int ? json['beg_pos'] : int.parse((json['beg_pos']).toString());
    }
    if (json['end_pos'] != null) {
      entity.end = json['end_pos'] is int ? json['end_pos'] : int.parse((json['end_pos']).toString());
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': text,
      'beg_pos': begin,
      'end_pos': end,
    };
  }

  void playUserVoice() {}

  void playStandardVoice() async {
    // 判断本地有没有，没有就下载
    String documentDirPath = await PathUtils.getDocumentFolderPath();
    String path = '$documentDirPath/$text.mp3';
    File file = File(path);
    if (!file.existsSync()) {
      await _download();
    }
  }

  Future<void> _download() async {
  }

}