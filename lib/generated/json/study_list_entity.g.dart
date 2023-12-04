import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/study_list_entity.dart';

StudyListEntity $StudyListEntityFromJson(Map<String, dynamic> json) {
  final StudyListEntity studyListEntity = StudyListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyListEntity.code = code;
  }
  final StudyListData? data = jsonConvert.convert<StudyListData>(json['data']);
  if (data != null) {
    studyListEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    studyListEntity.message = message;
  }
  return studyListEntity;
}

Map<String, dynamic> $StudyListEntityToJson(StudyListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension StudyListEntityExtension on StudyListEntity {
  StudyListEntity copyWith({
    int? code,
    StudyListData? data,
    String? message,
  }) {
    return StudyListEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

StudyListData $StudyListDataFromJson(Map<String, dynamic> json) {
  final StudyListData studyListData = StudyListData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    studyListData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    studyListData.msg = msg;
  }
  final List<StudyListDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<StudyListDataData>(e) as StudyListDataData)
      .toList();
  if (data != null) {
    studyListData.data = data;
  }
  return studyListData;
}

Map<String, dynamic> $StudyListDataToJson(StudyListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension StudyListDataExtension on StudyListData {
  StudyListData copyWith({
    int? code,
    String? msg,
    List<StudyListDataData>? data,
  }) {
    return StudyListData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

StudyListDataData $StudyListDataDataFromJson(Map<String, dynamic> json) {
  final StudyListDataData studyListDataData = StudyListDataData();
  final String? sessionId = jsonConvert.convert<String>(json['session_id']);
  if (sessionId != null) {
    studyListDataData.sessionId = sessionId;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    studyListDataData.message = message;
  }
  final double? score = jsonConvert.convert<double>(json['score']);
  if (score != null) {
    studyListDataData.score = score;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    studyListDataData.createdAt = createdAt;
  }
  return studyListDataData;
}

Map<String, dynamic> $StudyListDataDataToJson(StudyListDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['session_id'] = entity.sessionId;
  data['message'] = entity.message;
  data['score'] = entity.score;
  data['created_at'] = entity.createdAt;
  return data;
}

extension StudyListDataDataExtension on StudyListDataData {
  StudyListDataData copyWith({
    String? sessionId,
    String? message,
    double? score,
    String? createdAt,
  }) {
    return StudyListDataData()
      ..sessionId = sessionId ?? this.sessionId
      ..message = message ?? this.message
      ..score = score ?? this.score
      ..createdAt = createdAt ?? this.createdAt;
  }
}