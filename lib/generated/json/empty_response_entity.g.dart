import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/entity/empty_response_entity.dart';

EmptyResponseEntity $EmptyResponseEntityFromJson(Map<String, dynamic> json) {
  final EmptyResponseEntity emptyResponseEntity = EmptyResponseEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    emptyResponseEntity.code = code;
  }
  final EmptyResponseData? data = jsonConvert.convert<EmptyResponseData>(
      json['data']);
  if (data != null) {
    emptyResponseEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    emptyResponseEntity.message = message;
  }
  return emptyResponseEntity;
}

Map<String, dynamic> $EmptyResponseEntityToJson(EmptyResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension EmptyResponseEntityExtension on EmptyResponseEntity {
  EmptyResponseEntity copyWith({
    int? code,
    EmptyResponseData? data,
    String? message,
  }) {
    return EmptyResponseEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

EmptyResponseData $EmptyResponseDataFromJson(Map<String, dynamic> json) {
  final EmptyResponseData emptyResponseData = EmptyResponseData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    emptyResponseData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    emptyResponseData.msg = msg;
  }
  final EmptyResponseDataData? data = jsonConvert.convert<
      EmptyResponseDataData>(json['data']);
  if (data != null) {
    emptyResponseData.data = data;
  }
  return emptyResponseData;
}

Map<String, dynamic> $EmptyResponseDataToJson(EmptyResponseData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension EmptyResponseDataExtension on EmptyResponseData {
  EmptyResponseData copyWith({
    int? code,
    String? msg,
    EmptyResponseDataData? data,
  }) {
    return EmptyResponseData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

EmptyResponseDataData $EmptyResponseDataDataFromJson(
    Map<String, dynamic> json) {
  final EmptyResponseDataData emptyResponseDataData = EmptyResponseDataData();
  return emptyResponseDataData;
}

Map<String, dynamic> $EmptyResponseDataDataToJson(
    EmptyResponseDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension EmptyResponseDataDataExtension on EmptyResponseDataData {
}