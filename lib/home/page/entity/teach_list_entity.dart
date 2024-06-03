import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/teach_list_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/teach_list_entity.g.dart';

@JsonSerializable()
class TeachListEntity {
	@JSONField(name: "character_id")
	late String characterId;
	late String name;
	late String source;
	@JSONField(name: "voice_id")
	late String voiceId;
	@JSONField(name: "author_name")
	late List<String> authorName;
	@JSONField(name: "image_url")
	late String imageUrl;
	@JSONField(name: "avatar_id")
	late String avatarId;
	late String tts;
	@JSONField(name: "is_author")
	late bool isAuthor;

	late String slogan;
	late String character;

	TeachListEntity();

	factory TeachListEntity.fromJson(Map<String, dynamic> json) => $TeachListEntityFromJson(json);

	Map<String, dynamic> toJson() => $TeachListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}