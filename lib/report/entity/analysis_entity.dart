class AnalysisEntity {

  String msgId = '';
  String userText = '';
  List<GrammarEntity> grammar = [];
  List<PronounceEntity> pronounce = [];

  AnalysisEntity();

  factory AnalysisEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AnalysisEntity entity = AnalysisEntity();
    if (json['msg_id'] != null) {
      entity.msgId = json['msg_id'];
    }
    if (json['user_text'] != null) {
      entity.userText = json['user_text'];
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
      'msg_id': msgId,
      'user_text': userText,
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
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
    };
  }
}