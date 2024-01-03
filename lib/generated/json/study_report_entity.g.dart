import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/report/entity/study_report_entity.dart';

StudyReportEntity $StudyReportEntityFromJson(Map<String, dynamic> json) {
  final StudyReportEntity studyReportEntity = StudyReportEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyReportEntity.code = code;
  }
  final StudyReportData? data = jsonConvert.convert<StudyReportData>(
      json['data']);
  if (data != null) {
    studyReportEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    studyReportEntity.message = message;
  }
  return studyReportEntity;
}

Map<String, dynamic> $StudyReportEntityToJson(StudyReportEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension StudyReportEntityExtension on StudyReportEntity {
  StudyReportEntity copyWith({
    int? code,
    StudyReportData? data,
    String? message,
  }) {
    return StudyReportEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

StudyReportData $StudyReportDataFromJson(Map<String, dynamic> json) {
  final StudyReportData studyReportData = StudyReportData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyReportData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    studyReportData.msg = msg;
  }
  final StudyReportDataData? data = jsonConvert.convert<StudyReportDataData>(
      json['data']);
  if (data != null) {
    studyReportData.data = data;
  }
  return studyReportData;
}

Map<String, dynamic> $StudyReportDataToJson(StudyReportData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension StudyReportDataExtension on StudyReportData {
  StudyReportData copyWith({
    int? code,
    String? msg,
    StudyReportDataData? data,
  }) {
    return StudyReportData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

StudyReportDataData $StudyReportDataDataFromJson(Map<String, dynamic> json) {
  final StudyReportDataData studyReportDataData = StudyReportDataData();
  final dynamic accuracyScore = json['accuracy_score'];
  if (accuracyScore != null) {
    studyReportDataData.accuracyScore = accuracyScore;
  }
  final dynamic fluencyScore = json['fluency_score'];
  if (fluencyScore != null) {
    studyReportDataData.fluencyScore = fluencyScore;
  }
  final dynamic integrityScore = json['integrity_score'];
  if (integrityScore != null) {
    studyReportDataData.integrityScore = integrityScore;
  }
  final dynamic standardScore = json['standard_score'];
  if (standardScore != null) {
    studyReportDataData.standardScore = standardScore;
  }
  final dynamic totalScore = json['total_score'];
  if (totalScore != null) {
    studyReportDataData.totalScore = totalScore;
  }
  final String? sessionTime = jsonConvert.convert<String>(json['sessionTime']);
  if (sessionTime != null) {
    studyReportDataData.sessionTime = sessionTime;
  }
  final num? sessionCount = jsonConvert.convert<num>(json['sessionCount']);
  if (sessionCount != null) {
    studyReportDataData.sessionCount = sessionCount;
  }
  final String? rank = jsonConvert.convert<String>(json['rank']);
  if (rank != null) {
    studyReportDataData.rank = rank;
  }
  return studyReportDataData;
}

Map<String, dynamic> $StudyReportDataDataToJson(StudyReportDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['accuracy_score'] = entity.accuracyScore;
  data['fluency_score'] = entity.fluencyScore;
  data['integrity_score'] = entity.integrityScore;
  data['standard_score'] = entity.standardScore;
  data['total_score'] = entity.totalScore;
  data['sessionTime'] = entity.sessionTime;
  data['sessionCount'] = entity.sessionCount;
  data['rank'] = entity.rank;
  return data;
}

extension StudyReportDataDataExtension on StudyReportDataData {
  StudyReportDataData copyWith({
    dynamic accuracyScore,
    dynamic fluencyScore,
    dynamic integrityScore,
    dynamic standardScore,
    dynamic totalScore,
    String? sessionTime,
    num? sessionCount,
    String? rank,
  }) {
    return StudyReportDataData()
      ..accuracyScore = accuracyScore ?? this.accuracyScore
      ..fluencyScore = fluencyScore ?? this.fluencyScore
      ..integrityScore = integrityScore ?? this.integrityScore
      ..standardScore = standardScore ?? this.standardScore
      ..totalScore = totalScore ?? this.totalScore
      ..sessionTime = sessionTime ?? this.sessionTime
      ..sessionCount = sessionCount ?? this.sessionCount
      ..rank = rank ?? this.rank;
  }
}