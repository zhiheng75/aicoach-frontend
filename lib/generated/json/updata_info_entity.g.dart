import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/setting/entity/updata_info_entity.dart';

UpdataInfoEntity $UpdataInfoEntityFromJson(Map<String, dynamic> json) {
  final UpdataInfoEntity updataInfoEntity = UpdataInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    updataInfoEntity.code = code;
  }
  final UpdataInfoData? data = jsonConvert.convert<UpdataInfoData>(
      json['data']);
  if (data != null) {
    updataInfoEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    updataInfoEntity.message = message;
  }
  return updataInfoEntity;
}

Map<String, dynamic> $UpdataInfoEntityToJson(UpdataInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension UpdataInfoEntityExtension on UpdataInfoEntity {
  UpdataInfoEntity copyWith({
    int? code,
    UpdataInfoData? data,
    String? message,
  }) {
    return UpdataInfoEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

UpdataInfoData $UpdataInfoDataFromJson(Map<String, dynamic> json) {
  final UpdataInfoData updataInfoData = UpdataInfoData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    updataInfoData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    updataInfoData.msg = msg;
  }
  final UpdataInfoDataData? data = jsonConvert.convert<UpdataInfoDataData>(
      json['data']);
  if (data != null) {
    updataInfoData.data = data;
  }
  return updataInfoData;
}

Map<String, dynamic> $UpdataInfoDataToJson(UpdataInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension UpdataInfoDataExtension on UpdataInfoData {
  UpdataInfoData copyWith({
    int? code,
    String? msg,
    UpdataInfoDataData? data,
  }) {
    return UpdataInfoData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

UpdataInfoDataData $UpdataInfoDataDataFromJson(Map<String, dynamic> json) {
  final UpdataInfoDataData updataInfoDataData = UpdataInfoDataData();
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    updataInfoDataData.version = version;
  }
  final bool? forceUpdate = jsonConvert.convert<bool>(json['force_update']);
  if (forceUpdate != null) {
    updataInfoDataData.forceUpdate = forceUpdate;
  }
  final int? versionCode = jsonConvert.convert<int>(json['version_code']);
  if (versionCode != null) {
    updataInfoDataData.versionCode = versionCode;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    updataInfoDataData.platform = platform;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    updataInfoDataData.createdAt = createdAt;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    updataInfoDataData.id = id;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    updataInfoDataData.message = message;
  }
  final String? package = jsonConvert.convert<String>(json['package']);
  if (package != null) {
    updataInfoDataData.package = package;
  }
  final bool? online = jsonConvert.convert<bool>(json['online']);
  if (online != null) {
    updataInfoDataData.online = online;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    updataInfoDataData.updatedAt = updatedAt;
  }
  return updataInfoDataData;
}

Map<String, dynamic> $UpdataInfoDataDataToJson(UpdataInfoDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['version'] = entity.version;
  data['force_update'] = entity.forceUpdate;
  data['version_code'] = entity.versionCode;
  data['platform'] = entity.platform;
  data['created_at'] = entity.createdAt;
  data['id'] = entity.id;
  data['message'] = entity.message;
  data['package'] = entity.package;
  data['online'] = entity.online;
  data['updated_at'] = entity.updatedAt;
  return data;
}

extension UpdataInfoDataDataExtension on UpdataInfoDataData {
  UpdataInfoDataData copyWith({
    String? version,
    bool? forceUpdate,
    int? versionCode,
    String? platform,
    String? createdAt,
    int? id,
    String? message,
    String? package,
    bool? online,
    String? updatedAt,
  }) {
    return UpdataInfoDataData()
      ..version = version ?? this.version
      ..forceUpdate = forceUpdate ?? this.forceUpdate
      ..versionCode = versionCode ?? this.versionCode
      ..platform = platform ?? this.platform
      ..createdAt = createdAt ?? this.createdAt
      ..id = id ?? this.id
      ..message = message ?? this.message
      ..package = package ?? this.package
      ..online = online ?? this.online
      ..updatedAt = updatedAt ?? this.updatedAt;
  }
}