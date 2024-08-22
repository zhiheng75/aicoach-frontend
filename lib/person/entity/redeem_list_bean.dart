// To parse this JSON data, do
//
//     final redeemListBean = redeemListBeanFromJson(jsonString);

import 'dart:convert';

RedeemListBean redeemListBeanFromJson(String str) =>
    RedeemListBean.fromJson(json.decode(str));

String redeemListBeanToJson(RedeemListBean data) => json.encode(data.toJson());

class RedeemListBean {
  int code;
  String msg;
  Data data;

  RedeemListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory RedeemListBean.fromJson(Map<String, dynamic> json) => RedeemListBean(
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
  List<String> desc;
  List<ListElement> list;

  Data({
    required this.desc,
    required this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        desc: List<String>.from(json["desc"].map((x) => x)),
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "desc": List<dynamic>.from(desc.map((x) => x)),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  String goodsName;
  String redeemedAt;

  ListElement({
    required this.goodsName,
    required this.redeemedAt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        goodsName: json["goods_name"],
        redeemedAt: json["redeemed_at"],
      );

  Map<String, dynamic> toJson() => {
        "goods_name": goodsName,
        "redeemed_at": redeemedAt,
      };
}
