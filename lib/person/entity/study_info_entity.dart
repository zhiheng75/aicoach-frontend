import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/study_info_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/study_info_entity.g.dart';

@JsonSerializable()
class StudyInfoEntity {
	late int code;
	late StudyInfoData data;
	late String message;

	StudyInfoEntity();

	factory StudyInfoEntity.fromJson(Map<String, dynamic> json) => $StudyInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $StudyInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyInfoData {
	late int code;
	late String msg;
	late StudyInfoDataData data;

	StudyInfoData();

	factory StudyInfoData.fromJson(Map<String, dynamic> json) => $StudyInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyInfoDataData {
	@JSONField(name: "session_count")
	late int sessionCount;
	late int duration;
	late String rank;

	StudyInfoDataData();

	factory StudyInfoDataData.fromJson(Map<String, dynamic> json) => $StudyInfoDataDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyInfoDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}