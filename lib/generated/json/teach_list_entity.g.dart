import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';

TeachListEntity $TeachListEntityFromJson(Map<String, dynamic> json) {
  final TeachListEntity teachListEntity = TeachListEntity();
  final String? characterId = jsonConvert.convert<String>(json['character_id']);
  if (characterId != null) {
    teachListEntity.characterId = characterId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    teachListEntity.name = name;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    teachListEntity.source = source;
  }
  final String? voiceId = jsonConvert.convert<String>(json['voice_id']);
  if (voiceId != null) {
    teachListEntity.voiceId = voiceId;
  }
  List<String>? authorName = [];
  if (json['author_name'] is List) {
    authorName = (json['author_name'] as List<dynamic>?)?.map(
            (e) => jsonConvert.convert<String>(e) as String).toList();
  }
  if (authorName != null) {
    teachListEntity.authorName = authorName;
  }
  final String? imageUrl = jsonConvert.convert<String>(json['image_url']);
  if (imageUrl != null) {
    teachListEntity.imageUrl = imageUrl;
  }
  final String? avatarId = jsonConvert.convert<String>(json['avatar_id']);
  if (avatarId != null) {
    teachListEntity.avatarId = avatarId;
  }
  final String? tts = jsonConvert.convert<String>(json['tts']);
  if (tts != null) {
    teachListEntity.tts = tts;
  }
  final bool? isAuthor = jsonConvert.convert<bool>(json['is_author']);
  if (isAuthor != null) {
    teachListEntity.isAuthor = isAuthor;
  }
  final String? slogan = jsonConvert.convert<String>(json['slogan']);
  if (slogan != null) {
    teachListEntity.slogan = slogan;
  }
  final String? character = jsonConvert.convert<String>(json['character']);
  if (character != null) {
    teachListEntity.character = character;
  }
  return teachListEntity;
}

Map<String, dynamic> $TeachListEntityToJson(TeachListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['character_id'] = entity.characterId;
  data['name'] = entity.name;
  data['source'] = entity.source;
  data['voice_id'] = entity.voiceId;
  data['author_name'] = entity.authorName;
  data['image_url'] = entity.imageUrl;
  data['avatar_id'] = entity.avatarId;
  data['tts'] = entity.tts;
  data['is_author'] = entity.isAuthor;
  data['slogan'] = entity.slogan;
  data['character'] = entity.character;
  return data;
}

extension TeachListEntityExtension on TeachListEntity {
  TeachListEntity copyWith({
    String? characterId,
    String? name,
    String? source,
    String? voiceId,
    List<String>? authorName,
    String? imageUrl,
    String? avatarId,
    String? tts,
    bool? isAuthor,
    String? slogan,
    String? character,
  }) {
    return TeachListEntity()
      ..characterId = characterId ?? this.characterId
      ..name = name ?? this.name
      ..source = source ?? this.source
      ..voiceId = voiceId ?? this.voiceId
      ..authorName = authorName ?? this.authorName
      ..imageUrl = imageUrl ?? this.imageUrl
      ..avatarId = avatarId ?? this.avatarId
      ..tts = tts ?? this.tts
      ..isAuthor = isAuthor ?? this.isAuthor
      ..slogan = slogan ?? this.slogan
      ..character = character ?? this.character;
  }
}