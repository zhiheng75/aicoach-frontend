import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/study_info_entity.dart';

StudyInfoEntity $StudyInfoEntityFromJson(Map<String, dynamic> json) {
  final StudyInfoEntity studyInfoEntity = StudyInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyInfoEntity.code = code;
  }
  final StudyInfoData? data = jsonConvert.convert<StudyInfoData>(json['data']);
  if (data != null) {
    studyInfoEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    studyInfoEntity.message = message;
  }
  return studyInfoEntity;
}

Map<String, dynamic> $StudyInfoEntityToJson(StudyInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension StudyInfoEntityExtension on StudyInfoEntity {
  StudyInfoEntity copyWith({
    int? code,
    StudyInfoData? data,
    String? message,
  }) {
    return StudyInfoEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

StudyInfoData $StudyInfoDataFromJson(Map<String, dynamic> json) {
  final StudyInfoData studyInfoData = StudyInfoData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyInfoData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    studyInfoData.msg = msg;
  }
  final StudyInfoDataData? data = jsonConvert.convert<StudyInfoDataData>(
      json['data']);
  if (data != null) {
    studyInfoData.data = data;
  }
  return studyInfoData;
}

Map<String, dynamic> $StudyInfoDataToJson(StudyInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension StudyInfoDataExtension on StudyInfoData {
  StudyInfoData copyWith({
    int? code,
    String? msg,
    StudyInfoDataData? data,
  }) {
    return StudyInfoData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

StudyInfoDataData $StudyInfoDataDataFromJson(Map<String, dynamic> json) {
  final StudyInfoDataData studyInfoDataData = StudyInfoDataData();
  final int? sessionCount = jsonConvert.convert<int>(json['session_count']);
  if (sessionCount != null) {
    studyInfoDataData.sessionCount = sessionCount;
  }
  final int? duration = jsonConvert.convert<int>(json['duration']);
  if (duration != null) {
    studyInfoDataData.duration = duration;
  }
  final String? rank = jsonConvert.convert<String>(json['rank']);
  if (rank != null) {
    studyInfoDataData.rank = rank;
  }
  final String? activeRank = jsonConvert.convert<String>(json['activeRank']);
  if (activeRank != null) {
    studyInfoDataData.activeRank = activeRank;
  }
  final num? activeRankCount = jsonConvert.convert<num>(
      json['activeRankCount']);
  if (activeRankCount != null) {
    studyInfoDataData.activeRankCount = activeRankCount;
  }
  return studyInfoDataData;
}

Map<String, dynamic> $StudyInfoDataDataToJson(StudyInfoDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['session_count'] = entity.sessionCount;
  data['duration'] = entity.duration;
  data['rank'] = entity.rank;
  data['activeRank'] = entity.activeRank;
  data['activeRankCount'] = entity.activeRankCount;
  return data;
}

extension StudyInfoDataDataExtension on StudyInfoDataData {
  StudyInfoDataData copyWith({
    int? sessionCount,
    int? duration,
    String? rank,
    String? activeRank,
    num? activeRankCount,
  }) {
    return StudyInfoDataData()
      ..sessionCount = sessionCount ?? this.sessionCount
      ..duration = duration ?? this.duration
      ..rank = rank ?? this.rank
      ..activeRank = activeRank ?? this.activeRank
      ..activeRankCount = activeRankCount ?? this.activeRankCount;
  }
}