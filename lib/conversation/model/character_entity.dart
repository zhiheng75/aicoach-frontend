class CharacterEntity {

  CharacterEntity(this.characterId, this.name, this.source, this.voiceId, this.authorName, this.imageUrl, this.tts, this.isAuthor);

  CharacterEntity.fromJson(Map<String, dynamic> json) {
    characterId = json['character_id'];
    name = json['name'];
    source = json['source'];
    voiceId = json['voice_id'];
    if (json['author_name'] is List<dynamic>) {
      authorName = (json['author_name'] as List<dynamic>).join('');
    } else {
      authorName = json['author_name'];
    }
    imageUrl = json['image_url'];
    tts = json['tts'];
    avatarId = json['avatar_id'];
    isAuthor = json['is_author'];
  }

  String? characterId;
  String? name;
  String? source;
  String? voiceId;
  String? authorName;
  String? imageUrl;
  String? avatarId;
  String? tts;
  bool? isAuthor;
}
