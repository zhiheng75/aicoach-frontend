// To parse this JSON data, do
//
//     final characterListBean = characterListBeanFromJson(jsonString);

import 'dart:convert';

CharacterListBean characterListBeanFromJson(String str) =>
    CharacterListBean.fromJson(json.decode(str));

String characterListBeanToJson(CharacterListBean data) =>
    json.encode(data.toJson());

class CharacterListBean {
  int code;
  String msg;
  List<Datum> data;

  CharacterListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory CharacterListBean.fromJson(Map<String, dynamic> json) =>
      CharacterListBean(
        code: json["code"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String characterId;
  String name;
  String slogan;
  String character;
  String source;
  String voiceId;
  String authorName;
  String imageUrl;
  String coverImageUrl;
  int sort;
  String stage;
  String stageImg;
  String stillImage;
  String motionImage;
  String avatarImage;
  String avatarId;
  String greetingText;
  String greetingAudio;
  String tts;
  bool isAuthor;
  int isLocked;
  double pCount;
  double iCount;
  int isDefault;

  Datum({
    required this.characterId,
    required this.name,
    required this.slogan,
    required this.character,
    required this.source,
    required this.voiceId,
    required this.authorName,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.sort,
    required this.stage,
    required this.stageImg,
    required this.stillImage,
    required this.motionImage,
    required this.avatarImage,
    required this.avatarId,
    required this.greetingText,
    required this.greetingAudio,
    required this.tts,
    required this.isAuthor,
    required this.isLocked,
    required this.pCount,
    required this.iCount,
    required this.isDefault,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        characterId: json["character_id"],
        name: json["name"],
        slogan: json["slogan"],
        character: json["character"],
        source: json["source"],
        voiceId: json["voice_id"],
        authorName: json["author_name"],
        imageUrl: json["image_url"],
        coverImageUrl: json["cover_image_url"] ?? "",
        sort: json["sort"],
        stage: json["stage"],
        stageImg: json["stage_img"],
        stillImage: json["still_image"],
        motionImage: json["motion_image"],
        avatarImage: json["avatar_image"],
        avatarId: json["avatar_id"] ?? "",
        greetingText: json["greeting_text"],
        greetingAudio: json["greeting_audio"],
        tts: json["tts"],
        isAuthor: json["is_author"] ?? true,
        isLocked: json["is_locked"] ?? 1,
        pCount: json["p_count"] == null ? 1.0 : json["p_count"]?.toDouble(),
        iCount: json["i_count"] == null ? 1.0 : json["i_count"]?.toDouble(),
        isDefault: json["is_default"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "character_id": characterId,
        "name": name,
        "slogan": slogan,
        "character": character,
        "source": source,
        "voice_id": voiceId,
        "author_name": authorName,
        "image_url": imageUrl,
        "cover_image_url": coverImageUrl,
        "sort": sort,
        "stage": stage,
        "stage_img": stageImg,
        "still_image": stillImage,
        "motion_image": motionImage,
        "avatar_image": avatarImage,
        "avatar_id": avatarId,
        "greeting_text": greetingText,
        "greeting_audio": greetingAudio,
        "tts": tts,
        "is_author": isAuthor,
        "is_locked": isLocked,
        "p_count": pCount,
        "i_count": iCount,
        "is_default": isDefault,
      };
}
