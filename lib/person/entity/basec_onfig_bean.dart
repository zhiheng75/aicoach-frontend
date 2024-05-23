// To parse this JSON data, do
//
//     final basecOnfigBean = basecOnfigBeanFromJson(jsonString);

import 'dart:convert';

BasecOnfigBean basecOnfigBeanFromJson(String str) =>
    BasecOnfigBean.fromJson(json.decode(str));

String basecOnfigBeanToJson(BasecOnfigBean data) => json.encode(data.toJson());

class BasecOnfigBean {
  int code;
  String msg;
  List<BasecDatum> data;

  BasecOnfigBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory BasecOnfigBean.fromJson(Map<String, dynamic> json) => BasecOnfigBean(
        code: json["code"],
        msg: json["msg"],
        data: List<BasecDatum>.from(
            json["data"].map((x) => BasecDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BasecDatum {
  String key;
  String value;
  int status;
  String? desc;
  int id;
  DateTime createdAt;

  BasecDatum({
    required this.key,
    required this.value,
    required this.status,
    required this.desc,
    required this.id,
    required this.createdAt,
  });

  factory BasecDatum.fromJson(Map<String, dynamic> json) => BasecDatum(
        key: json["key"],
        value: json["value"],
        status: json["status"],
        desc: json["desc"],
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "status": status,
        "desc": desc,
        "id": id,
        "created_at": createdAt.toIso8601String(),
      };
}
