import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/oss_token_entity.dart';

OssTokenEntity $OssTokenEntityFromJson(Map<String, dynamic> json) {
  final OssTokenEntity ossTokenEntity = OssTokenEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    ossTokenEntity.code = code;
  }
  final OssTokenData? data = jsonConvert.convert<OssTokenData>(json['data']);
  if (data != null) {
    ossTokenEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    ossTokenEntity.message = message;
  }
  return ossTokenEntity;
}

Map<String, dynamic> $OssTokenEntityToJson(OssTokenEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension OssTokenEntityExtension on OssTokenEntity {
  OssTokenEntity copyWith({
    int? code,
    OssTokenData? data,
    String? message,
  }) {
    return OssTokenEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

OssTokenData $OssTokenDataFromJson(Map<String, dynamic> json) {
  final OssTokenData ossTokenData = OssTokenData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    ossTokenData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    ossTokenData.msg = msg;
  }
  final OssTokenDataData? data = jsonConvert.convert<OssTokenDataData>(
      json['data']);
  if (data != null) {
    ossTokenData.data = data;
  }
  return ossTokenData;
}

Map<String, dynamic> $OssTokenDataToJson(OssTokenData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension OssTokenDataExtension on OssTokenData {
  OssTokenData copyWith({
    int? code,
    String? msg,
    OssTokenDataData? data,
  }) {
    return OssTokenData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

OssTokenDataData $OssTokenDataDataFromJson(Map<String, dynamic> json) {
  final OssTokenDataData ossTokenDataData = OssTokenDataData();
  final String? securityToken = jsonConvert.convert<String>(
      json['SecurityToken']);
  if (securityToken != null) {
    ossTokenDataData.securityToken = securityToken;
  }
  final String? accessKeyId = jsonConvert.convert<String>(json['AccessKeyId']);
  if (accessKeyId != null) {
    ossTokenDataData.accessKeyId = accessKeyId;
  }
  final String? accessKeySecret = jsonConvert.convert<String>(
      json['AccessKeySecret']);
  if (accessKeySecret != null) {
    ossTokenDataData.accessKeySecret = accessKeySecret;
  }
  final String? expiration = jsonConvert.convert<String>(json['Expiration']);
  if (expiration != null) {
    ossTokenDataData.expiration = expiration;
  }
  return ossTokenDataData;
}

Map<String, dynamic> $OssTokenDataDataToJson(OssTokenDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['SecurityToken'] = entity.securityToken;
  data['AccessKeyId'] = entity.accessKeyId;
  data['AccessKeySecret'] = entity.accessKeySecret;
  data['Expiration'] = entity.expiration;
  return data;
}

extension OssTokenDataDataExtension on OssTokenDataData {
  OssTokenDataData copyWith({
    String? securityToken,
    String? accessKeyId,
    String? accessKeySecret,
    String? expiration,
  }) {
    return OssTokenDataData()
      ..securityToken = securityToken ?? this.securityToken
      ..accessKeyId = accessKeyId ?? this.accessKeyId
      ..accessKeySecret = accessKeySecret ?? this.accessKeySecret
      ..expiration = expiration ?? this.expiration;
  }
}