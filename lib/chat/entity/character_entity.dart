class CharacterEntity {

  String characterId = '';
  String name = '';
  String imageUrl = '';
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
    if (json['text'] != null) {
      entity.text = json['text'];
    }
    if (json['audio'] != null) {
      entity.audio = json['audio'];
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
      'text': text,
      'audio': audio,
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