// To parse this JSON data, do
//
//     final systemMaintenanceBean = systemMaintenanceBeanFromJson(jsonString);

import 'dart:convert';

SystemMaintenanceBean systemMaintenanceBeanFromJson(String str) =>
    SystemMaintenanceBean.fromJson(json.decode(str));

String systemMaintenanceBeanToJson(SystemMaintenanceBean data) =>
    json.encode(data.toJson());

class SystemMaintenanceBean {
  int status;
  String remainingTime;

  SystemMaintenanceBean({
    required this.status,
    required this.remainingTime,
  });

  factory SystemMaintenanceBean.fromJson(Map<String, dynamic> json) =>
      SystemMaintenanceBean(
        status: json["status"] ?? 0,
        remainingTime: json["remaining_time"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "remaining_time": remainingTime,
      };
}
