import 'package:Bubble/generated/json/base/json_field.dart';
import 'package:Bubble/generated/json/study_report_entity.g.dart';
import 'dart:convert';
export 'package:Bubble/generated/json/study_report_entity.g.dart';

@JsonSerializable()
class StudyReportEntity {
	late int code;
	late StudyReportData data;
	late String message;

	StudyReportEntity();

	factory StudyReportEntity.fromJson(Map<String, dynamic> json) => $StudyReportEntityFromJson(json);

	Map<String, dynamic> toJson() => $StudyReportEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyReportData {
	late int code;
	late String msg;
	late StudyReportDataData data;

	StudyReportData();

	factory StudyReportData.fromJson(Map<String, dynamic> json) => $StudyReportDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyReportDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class StudyReportDataData {
	@JSONField(name: "accuracy_score")
	dynamic accuracyScore;
	@JSONField(name: "fluency_score")
	dynamic fluencyScore;
	@JSONField(name: "integrity_score")
	dynamic integrityScore;
	@JSONField(name: "standard_score")
	dynamic standardScore;
	@JSONField(name: "total_score")
	dynamic totalScore;

	late String sessionTime;
	late num  sessionCount;
	late String rank;

	StudyReportDataData();

	factory StudyReportDataData.fromJson(Map<String, dynamic> json) => $StudyReportDataDataFromJson(json);

	Map<String, dynamic> toJson() => $StudyReportDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}