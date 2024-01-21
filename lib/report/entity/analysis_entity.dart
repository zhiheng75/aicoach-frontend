class AnalysisEntity {

  int type = 2;
  String sentence = '';
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
    if (json['score'] != null) {
      entity.sentence = json['score'];
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

  PronounceEntity();

  factory PronounceEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    PronounceEntity entity = PronounceEntity();
    if (json['word'] != null) {
      entity.text = json['word'];
    }
    if (json['word_audio'] != null) {
      entity.audio = json['word_audio'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'word': text,
      'word_audio': audio,
    };
  }
}