// To parse this JSON data, do
//
//     final redeemCodeBean = redeemCodeBeanFromJson(jsonString);

import 'dart:convert';

RedeemCodeBean redeemCodeBeanFromJson(String str) =>
    RedeemCodeBean.fromJson(json.decode(str));

String redeemCodeBeanToJson(RedeemCodeBean data) => json.encode(data.toJson());

class RedeemCodeBean {
  int code;
  String msg;
  DataCode data;

  RedeemCodeBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory RedeemCodeBean.fromJson(Map<String, dynamic> json) => RedeemCodeBean(
        code: json["code"],
        msg: json["msg"],
        data: DataCode.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };
}

class DataCode {
  int goodsType;
  String goodsName;

  DataCode({
    required this.goodsType,
    required this.goodsName,
  });

  factory DataCode.fromJson(Map<String, dynamic> json) => DataCode(
        goodsType: json["goods_type"] ?? 0,
        goodsName: json["goods_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "goods_type": goodsType,
        "goods_name": goodsName,
      };
}
