class AdviseEntity {

  int type = 2;
  String userSentence = '';
  String userAudio = '';
  String sentenceAudio = '';
  num score = 0;

  AdviseEntity();

  factory AdviseEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AdviseEntity entity = AdviseEntity();
    if (json['type'] != null) {
      entity.type = json['type'];
    }
    if (json['user_sentence'] != null) {
      entity.userSentence = json['user_sentence'];
    }
    if (json['user_audio'] != null) {
      entity.userAudio = json['user_audio'];
    }
    if (json['sentence_audio'] != null) {
      entity.sentenceAudio = json['sentence_audio'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_sentence': userSentence,
      'user_audio': userAudio,
      'sentence_audio': sentenceAudio,
      'score': score,
    };
  }

}