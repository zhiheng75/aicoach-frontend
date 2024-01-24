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
  List<Datum> data;

  BasecOnfigBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory BasecOnfigBean.fromJson(Map<String, dynamic> json) => BasecOnfigBean(
        code: json["code"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String key;
  String value;
  int status;
  String? desc;
  int id;
  DateTime createdAt;

  Datum({
    required this.key,
    required this.value,
    required this.status,
    required this.desc,
    required this.id,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
