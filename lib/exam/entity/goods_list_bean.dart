// To parse this JSON data, do
//
//     final goodsListBean = goodsListBeanFromJson(jsonString);

import 'dart:convert';

GoodsListBean goodsListBeanFromJson(String str) =>
    GoodsListBean.fromJson(json.decode(str));

String goodsListBeanToJson(GoodsListBean data) => json.encode(data.toJson());

class GoodsListBean {
  int code;
  String msg;
  List<Datum> data;

  GoodsListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GoodsListBean.fromJson(Map<String, dynamic> json) => GoodsListBean(
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
  int id;
  int type;
  String desc;
  double? price;
  int? term;
  String? name;
  String? tips;
  double? originalPrice;
  int? status;
  int? sort;
  int? productId;
  String? createdAt;
  String? updatedAt;

  Datum({
    required this.id,
    required this.type,
    required this.desc,
    this.price,
    this.term,
    this.productId,
    this.name,
    this.tips,
    this.originalPrice,
    this.status,
    this.sort,
    this.updatedAt,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        desc: json["desc"],
        price: json["price"]?.toDouble(),
        term: json["term"],
        productId: json["product_id"],
        name: json["name"],
        tips: json["tips"],
        originalPrice: json["original_price"]?.toDouble(),
        status: json["status"],
        sort: json["sort"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "desc": desc,
        "price": price,
        "term": term,
        "product_id": productId,
        "name": name,
        "tips": tips,
        "original_price": originalPrice,
        "status": status,
        "sort": sort,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
      };
}
