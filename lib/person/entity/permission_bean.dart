// To parse this JSON data, do
//
//     final permissionBean = permissionBeanFromJson(jsonString);

import 'dart:convert';

PermissionBean permissionBeanFromJson(String str) =>
    PermissionBean.fromJson(json.decode(str));

String permissionBeanToJson(PermissionBean data) => json.encode(data.toJson());

class PermissionBean {
  int code;
  String msg;
  Data data;

  PermissionBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory PermissionBean.fromJson(Map<String, dynamic> json) => PermissionBean(
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
  int allLeftTime;
  int isMember;
  int expDay;
  int totalTime;

  String membershipExpiryDate;

  Data({
    required this.leftTime,
    required this.allLeftTime,
    required this.isMember,
    required this.expDay,
    required this.totalTime,
    required this.membershipExpiryDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leftTime: json["left_time"] ?? 0,
        allLeftTime: json["all_left_time"] ?? 0,
        isMember: json["is_member"] ?? 0,
        expDay: json["exp_day"] ?? 0,
        totalTime: json["total_time"] ?? 0,
        membershipExpiryDate: json["membership_expiry_date"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "left_time": leftTime,
        "all_left_time": allLeftTime,
        "is_member": isMember,
        "exp_day": expDay,
        "total_time": totalTime,
        "membership_expiry_date": membershipExpiryDate,
      };
}
