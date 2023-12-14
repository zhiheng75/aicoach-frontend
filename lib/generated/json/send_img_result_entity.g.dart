import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/send_img_result_entity.dart';

SendImgResultEntity $SendImgResultEntityFromJson(Map<String, dynamic> json) {
  final SendImgResultEntity sendImgResultEntity = SendImgResultEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    sendImgResultEntity.code = code;
  }
  final SendImgResultData? data = jsonConvert.convert<SendImgResultData>(
      json['data']);
  if (data != null) {
    sendImgResultEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    sendImgResultEntity.message = message;
  }
  return sendImgResultEntity;
}

Map<String, dynamic> $SendImgResultEntityToJson(SendImgResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension SendImgResultEntityExtension on SendImgResultEntity {
  SendImgResultEntity copyWith({
    int? code,
    SendImgResultData? data,
    String? message,
  }) {
    return SendImgResultEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

SendImgResultData $SendImgResultDataFromJson(Map<String, dynamic> json) {
  final SendImgResultData sendImgResultData = SendImgResultData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    sendImgResultData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    sendImgResultData.msg = msg;
  }
  final List<SendImgResultDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<SendImgResultDataData>(e) as SendImgResultDataData)
      .toList();
  if (data != null) {
    sendImgResultData.data = data;
  }
  return sendImgResultData;
}

Map<String, dynamic> $SendImgResultDataToJson(SendImgResultData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension SendImgResultDataExtension on SendImgResultData {
  SendImgResultData copyWith({
    int? code,
    String? msg,
    List<SendImgResultDataData>? data,
  }) {
    return SendImgResultData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

SendImgResultDataData $SendImgResultDataDataFromJson(
    Map<String, dynamic> json) {
  final SendImgResultDataData sendImgResultDataData = SendImgResultDataData();
  final String? filename = jsonConvert.convert<String>(json['filename']);
  if (filename != null) {
    sendImgResultDataData.filename = filename;
  }
  final String? contentType = jsonConvert.convert<String>(json['content-type']);
  if (contentType != null) {
    sendImgResultDataData.contentType = contentType;
  }
  return sendImgResultDataData;
}

Map<String, dynamic> $SendImgResultDataDataToJson(
    SendImgResultDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['filename'] = entity.filename;
  data['content-type'] = entity.contentType;
  return data;
}

extension SendImgResultDataDataExtension on SendImgResultDataData {
  SendImgResultDataData copyWith({
    String? filename,
    String? contentType,
  }) {
    return SendImgResultDataData()
      ..filename = filename ?? this.filename
      ..contentType = contentType ?? this.contentType;
  }
}