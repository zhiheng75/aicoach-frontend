import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/study_list_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/study_list_entity.g.dart';

@JsonSerializable()
class StudyListEntity {
	late int code;
	late StudyListData data;
	late String message;

	StudyListEntity();

	factory StudyListEntity.fromJson(Map<String, dynamic> json) => $StudyListEntityFromJson(json);

	Map<String, dynamic> toJson() => $StudyListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyListData {
	late int code;
	late String msg;
	late List<StudyListDataData> data;

	StudyListData();

	factory StudyListData.fromJson(Map<String, dynamic> json) => $StudyListDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyListDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyListDataData {
	@JSONField(name: "session_id")
	late String sessionId;
	late String message;
	late double score;
	@JSONField(name: "created_at")
	late String createdAt;

	StudyListDataData();

	factory StudyListDataData.fromJson(Map<String, dynamic> json) => $StudyListDataDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyListDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}