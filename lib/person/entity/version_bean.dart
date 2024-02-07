// To parse this JSON data, do
//
//     final versionBean = versionBeanFromJson(jsonString);

import 'dart:convert';

VersionBean versionBeanFromJson(String str) =>
    VersionBean.fromJson(json.decode(str));

String versionBeanToJson(VersionBean data) => json.encode(data.toJson());

class VersionBean {
  int code;
  String msg;
  Data data;

  VersionBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory VersionBean.fromJson(Map<String, dynamic> json) => VersionBean(
        code: json["code"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  String version;
  int versionCode;
  bool forceUpdate;
  String platform;
  DateTime createdAt;
  String message;
  int id;
  String package;
  bool online;
  DateTime updatedAt;

  Data({
    required this.version,
    required this.versionCode,
    required this.forceUpdate,
    required this.platform,
    required this.createdAt,
    required this.message,
    required this.id,
    required this.package,
    required this.online,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        version: json["version"],
        versionCode: json["version_code"],
        forceUpdate: json["force_update"],
        platform: json["platform"],
        createdAt: DateTime.parse(json["created_at"]),
        message: json["message"],
        id: json["id"],
        package: json["package"],
        online: json["online"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "version_code": versionCode,
        "force_update": forceUpdate,
        "platform": platform,
        "created_at": createdAt.toIso8601String(),
        "message": message,
        "id": id,
        "package": package,
        "online": online,
        "updated_at": updatedAt.toIso8601String(),
      };
}
