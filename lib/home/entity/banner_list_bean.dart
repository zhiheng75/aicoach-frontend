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
  String title;
  String? buttonTitle;
  String linkUrl;
  int typeId;
  int type;
  DateTime createdAt;
  String imageUrl;
  int id;
  int sort;
  dynamic position;
  int status;

  BBanner({
    required this.title,
    required this.buttonTitle,
    required this.linkUrl,
    required this.typeId,
    required this.type,
    required this.createdAt,
    required this.imageUrl,
    required this.id,
    required this.sort,
    required this.position,
    required this.status,
  });

  factory BBanner.fromJson(Map<String, dynamic> json) => BBanner(
        title: json["title"],
        buttonTitle: json["button_title"],
        linkUrl: json["link_url"],
        typeId: json["type_id"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        imageUrl: json["image_url"],
        id: json["id"],
        sort: json["sort"],
        position: json["position"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "button_title": buttonTitle,
        "link_url": linkUrl,
        "type_id": typeId,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "image_url": imageUrl,
        "id": id,
        "sort": sort,
        "position": position,
        "status": status,
      };
}
