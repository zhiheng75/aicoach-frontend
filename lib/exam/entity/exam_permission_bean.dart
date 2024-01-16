// To parse this JSON data, do
//
//     final examPermissionBean = examPermissionBeanFromJson(jsonString);

import 'dart:convert';

ExamPermissionBean examPermissionBeanFromJson(String str) =>
    ExamPermissionBean.fromJson(json.decode(str));

String examPermissionBeanToJson(ExamPermissionBean data) =>
    json.encode(data.toJson());

class ExamPermissionBean {
  int code;
  String msg;
  Data data;

  ExamPermissionBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ExamPermissionBean.fromJson(Map<String, dynamic> json) =>
      ExamPermissionBean(
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
  int leftTime;
  int status;

  Data({
    required this.leftTime,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leftTime: json["left_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "left_time": leftTime,
        "status": status,
      };
}
