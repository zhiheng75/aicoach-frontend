// To parse this JSON data, do
//
//     final getPayCodeBean = getPayCodeBeanFromJson(jsonString);

import 'dart:convert';

GetPayCodeBean getPayCodeBeanFromJson(String str) =>
    GetPayCodeBean.fromJson(json.decode(str));

String getPayCodeBeanToJson(GetPayCodeBean data) => json.encode(data.toJson());

class GetPayCodeBean {
  int code;
  String msg;
  Data data;

  GetPayCodeBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GetPayCodeBean.fromJson(Map<String, dynamic> json) => GetPayCodeBean(
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
  String img;
  String orderNo;

  Data({
    required this.img,
    required this.orderNo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        img: json["img"],
        orderNo: json["order_no"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "order_no": orderNo,
      };
}
