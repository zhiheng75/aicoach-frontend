// To parse this JSON data, do
//
//     final orderListBean = orderListBeanFromJson(jsonString);

import 'dart:convert';

OrderListBean orderListBeanFromJson(String str) =>
    OrderListBean.fromJson(json.decode(str));

String orderListBeanToJson(OrderListBean data) => json.encode(data.toJson());

class OrderListBean {
  int code;
  String msg;
  List<Datum> data;

  OrderListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory OrderListBean.fromJson(Map<String, dynamic> json) => OrderListBean(
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
  String orderNo;
  String paymentMethod;
  int status;
  String createdAt;
  String endTime;
  String name;
  String orderPrice;
  String goodsPrice;
  dynamic unit;
  int type;
  String giftDesc;

  Datum({
    required this.id,
    required this.orderNo,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.endTime,
    required this.name,
    required this.orderPrice,
    required this.goodsPrice,
    required this.unit,
    required this.type,
    required this.giftDesc,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderNo: json["order_no"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        createdAt: json["created_at"],
        endTime: json["end_time"],
        name: json["name"],
        orderPrice: json["order_price"].toString(),
        goodsPrice: json["goods_price"].toString(),
        unit: json["unit"],
        type: json["type"],
        giftDesc: json["gift_desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "payment_method": paymentMethod,
        "status": status,
        "created_at": createdAt,
        "end_time": endTime,
        "name": name,
        "order_price": orderPrice,
        "goods_price": goodsPrice,
        "unit": unit,
        "type": type,
        "gift_desc": giftDesc,
      };
}
