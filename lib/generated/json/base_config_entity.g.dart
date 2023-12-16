import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/home/entity/base_config_entity.dart';

BaseConfigEntity $BaseConfigEntityFromJson(Map<String, dynamic> json) {
  final BaseConfigEntity baseConfigEntity = BaseConfigEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    baseConfigEntity.code = code;
  }
  final BaseConfigData? data = jsonConvert.convert<BaseConfigData>(
      json['data']);
  if (data != null) {
    baseConfigEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    baseConfigEntity.message = message;
  }
  return baseConfigEntity;
}

Map<String, dynamic> $BaseConfigEntityToJson(BaseConfigEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension BaseConfigEntityExtension on BaseConfigEntity {
  BaseConfigEntity copyWith({
    int? code,
    BaseConfigData? data,
    String? message,
  }) {
    return BaseConfigEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

BaseConfigData $BaseConfigDataFromJson(Map<String, dynamic> json) {
  final BaseConfigData baseConfigData = BaseConfigData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    baseConfigData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    baseConfigData.msg = msg;
  }
  final List<BaseConfigDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<BaseConfigDataData>(e) as BaseConfigDataData)
      .toList();
  if (data != null) {
    baseConfigData.data = data;
  }
  return baseConfigData;
}

Map<String, dynamic> $BaseConfigDataToJson(BaseConfigData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension BaseConfigDataExtension on BaseConfigData {
  BaseConfigData copyWith({
    int? code,
    String? msg,
    List<BaseConfigDataData>? data,
  }) {
    return BaseConfigData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

BaseConfigDataData $BaseConfigDataDataFromJson(Map<String, dynamic> json) {
  final BaseConfigDataData baseConfigDataData = BaseConfigDataData();
  final String? key = jsonConvert.convert<String>(json['key']);
  if (key != null) {
    baseConfigDataData.key = key;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    baseConfigDataData.value = value;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    baseConfigDataData.status = status;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    baseConfigDataData.id = id;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    baseConfigDataData.desc = desc;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    baseConfigDataData.createdAt = createdAt;
  }
  return baseConfigDataData;
}

Map<String, dynamic> $BaseConfigDataDataToJson(BaseConfigDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['key'] = entity.key;
  data['value'] = entity.value;
  data['status'] = entity.status;
  data['id'] = entity.id;
  data['desc'] = entity.desc;
  data['created_at'] = entity.createdAt;
  return data;
}

extension BaseConfigDataDataExtension on BaseConfigDataData {
  BaseConfigDataData copyWith({
    String? key,
    String? value,
    int? status,
    int? id,
    String? desc,
    String? createdAt,
  }) {
    return BaseConfigDataData()
      ..key = key ?? this.key
      ..value = value ?? this.value
      ..status = status ?? this.status
      ..id = id ?? this.id
      ..desc = desc ?? this.desc
      ..createdAt = createdAt ?? this.createdAt;
  }
}