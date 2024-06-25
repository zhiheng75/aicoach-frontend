// To parse this JSON data, do
//
//     final clickMatchBean = clickMatchBeanFromJson(jsonString);

import 'dart:convert';

ClickMatchBean clickMatchBeanFromJson(String str) =>
    ClickMatchBean.fromJson(json.decode(str));

String clickMatchBeanToJson(ClickMatchBean data) => json.encode(data.toJson());

class ClickMatchBean {
  int code;
  String msg;
  Data data;

  ClickMatchBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ClickMatchBean.fromJson(Map<String, dynamic> json) => ClickMatchBean(
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
  String callback;

  Data({
    required this.callback,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        callback: json["callback"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "callback": callback,
      };
}
