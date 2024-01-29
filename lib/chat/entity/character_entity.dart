class CharacterEntity {

  String characterId = '';
  String name = '';
  String imageUrl = '';
  String stage = '';
  String stageImg = '';
  String slogan = '';
  String text = '';
  String audio = '';
  List<CharacterTopic> topicList = [];

  CharacterEntity();

  factory CharacterEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    CharacterEntity entity = CharacterEntity();
    if (json['character_id'] != null) {
      entity.characterId = json['character_id'];
    }
    if (json['name'] != null) {
      entity.name = json['name'];
    }
    if (json['image_url'] != null) {
      entity.imageUrl = json['image_url'];
    }
    if (json['stage'] != null) {
      entity.stage = json['stage'];
    }
    if (json['stage_img'] != null) {
      entity.stageImg = json['stage_img'];
    }
    if (json['slogan'] != null) {
      entity.slogan = json['slogan'];
    }
    if (json['greeting_text'] != null) {
      entity.text = json['greeting_text'];
    }
    if (json['greeting_audio'] != null) {
      entity.audio = json['greeting_audio'];
    }
    if (json['topic'] != null) {
      List<dynamic> list = json['topic'] as List<dynamic>;
      entity.topicList = list.map((item) => CharacterTopic.fromJson(item)).toList();
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'character_id': characterId,
      'name': name,
      'image_url': imageUrl,
      'stage': stage,
      'stage_img': stageImg,
      'slogan': slogan,
      'greeting_text': text,
      'greeting_audio': audio,
      'topic': topicList,
    };
  }

}

class CharacterTopic {

  String id = '';
  String title = '';
  String desc = '';
  String cover = '';

  CharacterTopic();

  factory CharacterTopic.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    CharacterTopic topic = CharacterTopic();
    if (json['id'] != null) {
      topic.id = json['id'];
    }
    if (json['title'] != null) {
      topic.title = json['title'];
    }
    if (json['desc'] != null) {
      topic.desc = json['desc'];
    }
    if (json['cover'] != null) {
      topic.cover = json['cover'];
    }
    return topic;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'cover': cover,
    };
  }

}