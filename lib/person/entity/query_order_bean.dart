// To parse this JSON data, do
//
//     final queryOrderBean = queryOrderBeanFromJson(jsonString);

import 'dart:convert';

QueryOrderBean queryOrderBeanFromJson(String str) =>
    QueryOrderBean.fromJson(json.decode(str));

String queryOrderBeanToJson(QueryOrderBean data) => json.encode(data.toJson());

class QueryOrderBean {
  int code;
  String msg;
  QueryOrdeData data;

  QueryOrderBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory QueryOrderBean.fromJson(Map<String, dynamic> json) => QueryOrderBean(
        code: json["code"],
        msg: json["msg"],
        data: QueryOrdeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };
}

class QueryOrdeData {
  String status;

  QueryOrdeData({
    required this.status,
  });

  factory QueryOrdeData.fromJson(Map<String, dynamic> json) => QueryOrdeData(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
