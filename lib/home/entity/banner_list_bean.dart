// To parse this JSON data, do
//
//     final bannerListBean = bannerListBeanFromJson(jsonString);

import 'dart:convert';

BannerListBean bannerListBeanFromJson(String str) =>
    BannerListBean.fromJson(json.decode(str));

String bannerListBeanToJson(BannerListBean data) => json.encode(data.toJson());

class BannerListBean {
  int code;
  String msg;
  Data data;

  BannerListBean({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory BannerListBean.fromJson(Map<String, dynamic> json) => BannerListBean(
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
  List<BBanner> banner;
  List<BBanner> lesson;
  int isChatShow;
  int isKetShow;

  Data({
    required this.banner,
    required this.lesson,
    required this.isChatShow,
    required this.isKetShow,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        banner:
            List<BBanner>.from(json["banner"].map((x) => BBanner.fromJson(x))),
        lesson:
            List<BBanner>.from(json["lesson"].map((x) => BBanner.fromJson(x))),
        isChatShow: json["is_chat_show"],
        isKetShow: json["is_ket_show"],
      );

  Map<String, dynamic> toJson() => {
        "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
        "lesson": List<dynamic>.from(lesson.map((x) => x.toJson())),
        "is_chat_show": isChatShow,
        "is_ket_show": isKetShow,
      };
}

class BBanner {
  String linkUrl;
  String title;
  String? buttonTitle;
  int typeId;
  String? param;
  int status;
  int id;
  String imageUrl;
  int sort;
  dynamic position;
  int type;
  DateTime createdAt;

  BBanner({
    required this.linkUrl,
    required this.title,
    required this.buttonTitle,
    required this.typeId,
    required this.param,
    required this.status,
    required this.id,
    required this.imageUrl,
    required this.sort,
    required this.position,
    required this.type,
    required this.createdAt,
  });

  factory BBanner.fromJson(Map<String, dynamic> json) => BBanner(
        linkUrl: json["link_url"],
        title: json["title"],
        buttonTitle: json["button_title"],
        typeId: json["type_id"],
        param: json["param"],
        status: json["status"],
        id: json["id"],
        imageUrl: json["image_url"],
        sort: json["sort"],
        position: json["position"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "link_url": linkUrl,
        "title": title,
        "button_title": buttonTitle,
        "type_id": typeId,
        "param": param,
        "status": status,
        "id": id,
        "image_url": imageUrl,
        "sort": sort,
        "position": position,
        "type": type,
        "created_at": createdAt.toIso8601String(),
      };
}
