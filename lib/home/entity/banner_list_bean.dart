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
  List<BBanner> lessonList;
  List<BBanner> exam;
  List<SceneList> sceneList;

  Data({
    required this.banner,
    required this.lesson,
    required this.lessonList,
    required this.exam,
    required this.sceneList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        banner:
            List<BBanner>.from(json["banner"].map((x) => BBanner.fromJson(x))),
        lesson:
            List<BBanner>.from(json["lesson"].map((x) => BBanner.fromJson(x))),
        lessonList: List<BBanner>.from(
            json["lesson_list"].map((x) => BBanner.fromJson(x))),
        exam: List<BBanner>.from(json["exam"].map((x) => BBanner.fromJson(x))),
        sceneList: List<SceneList>.from(
            json["scene_list"].map((x) => SceneList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
        "lesson": List<dynamic>.from(lesson.map((x) => x.toJson())),
        "lesson_list": List<dynamic>.from(lessonList.map((x) => x.toJson())),
        "exam": List<dynamic>.from(exam.map((x) => x.toJson())),
        "scene_list": List<dynamic>.from(sceneList.map((x) => x.toJson())),
      };
}

class BBanner {
  String imageUrl;
  int id;
  int sort;
  dynamic position;
  int type;
  DateTime? createdAt;
  String linkUrl;
  String title;
  String? buttonTitle;
  int typeId;
  String? param;
  int status;

  BBanner({
    required this.imageUrl,
    required this.id,
    required this.sort,
    required this.position,
    required this.type,
    required this.createdAt,
    required this.linkUrl,
    required this.title,
    required this.buttonTitle,
    required this.typeId,
    required this.param,
    required this.status,
  });

  factory BBanner.fromJson(Map<String, dynamic> json) => BBanner(
        imageUrl: json["image_url"],
        id: json["id"],
        sort: json["sort"],
        position: json["position"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        linkUrl: json["link_url"],
        title: json["title"],
        buttonTitle: json["button_title"],
        typeId: json["type_id"],
        param: json["param"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "id": id,
        "sort": sort,
        "position": position,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "link_url": linkUrl,
        "title": title,
        "button_title": buttonTitle,
        "type_id": typeId,
        "param": param,
        "status": status,
      };
}

class SceneList {
  int cagegoryId;
  String cagegoryName;
  String cagegoryDesc;
  String imageUrl;

  SceneList({
    required this.cagegoryId,
    required this.cagegoryName,
    required this.cagegoryDesc,
    required this.imageUrl,
  });

  factory SceneList.fromJson(Map<String, dynamic> json) => SceneList(
        cagegoryId: json["cagegory_id"],
        cagegoryName: json["cagegory_name"],
        cagegoryDesc: json["cagegory_desc"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "cagegory_id": cagegoryId,
        "cagegory_name": cagegoryName,
        "cagegory_desc": cagegoryDesc,
        "image_url": imageUrl,
      };
}
