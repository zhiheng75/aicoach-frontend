import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/login/entity/wx_info_entity.dart';

WxInfoEntity $WxInfoEntityFromJson(Map<String, dynamic> json) {
  final WxInfoEntity wxInfoEntity = WxInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    wxInfoEntity.code = code;
  }
  final WxInfoData? data = jsonConvert.convert<WxInfoData>(json['data']);
  if (data != null) {
    wxInfoEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    wxInfoEntity.message = message;
  }
  return wxInfoEntity;
}

Map<String, dynamic> $WxInfoEntityToJson(WxInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension WxInfoEntityExtension on WxInfoEntity {
  WxInfoEntity copyWith({
    int? code,
    WxInfoData? data,
    String? message,
  }) {
    return WxInfoEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

WxInfoData $WxInfoDataFromJson(Map<String, dynamic> json) {
  final WxInfoData wxInfoData = WxInfoData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    wxInfoData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    wxInfoData.msg = msg;
  }
  final WxInfoDataData? data = jsonConvert.convert<WxInfoDataData>(
      json['data']);
  if (data != null) {
    wxInfoData.data = data;
  }
  return wxInfoData;
}

Map<String, dynamic> $WxInfoDataToJson(WxInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension WxInfoDataExtension on WxInfoData {
  WxInfoData copyWith({
    int? code,
    String? msg,
    WxInfoDataData? data,
  }) {
    return WxInfoData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

WxInfoDataData $WxInfoDataDataFromJson(Map<String, dynamic> json) {
  final WxInfoDataData wxInfoDataData = WxInfoDataData();
  final String? openid = jsonConvert.convert<String>(json['openid']);
  if (openid != null) {
    wxInfoDataData.openid = openid;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    wxInfoDataData.nickname = nickname;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    wxInfoDataData.sex = sex;
  }
  final String? language = jsonConvert.convert<String>(json['language']);
  if (language != null) {
    wxInfoDataData.language = language;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    wxInfoDataData.city = city;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    wxInfoDataData.province = province;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    wxInfoDataData.country = country;
  }
  final String? headimgurl = jsonConvert.convert<String>(json['headimgurl']);
  if (headimgurl != null) {
    wxInfoDataData.headimgurl = headimgurl;
  }
  final List<dynamic>? privilege = (json['privilege'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (privilege != null) {
    wxInfoDataData.privilege = privilege;
  }
  final String? unionid = jsonConvert.convert<String>(json['unionid']);
  if (unionid != null) {
    wxInfoDataData.unionid = unionid;
  }
  final String? school = jsonConvert.convert<String>(json['school']);
  if (school != null) {
    wxInfoDataData.school = school;
  }

  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    wxInfoDataData.token = token;
  }

  return wxInfoDataData;
}

Map<String, dynamic> $WxInfoDataDataToJson(WxInfoDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['openid'] = entity.openid;
  data['nickname'] = entity.nickname;
  data['sex'] = entity.sex;
  data['language'] = entity.language;
  data['city'] = entity.city;
  data['province'] = entity.province;
  data['country'] = entity.country;
  data['headimgurl'] = entity.headimgurl;
  data['privilege'] = entity.privilege;
  data['unionid'] = entity.unionid;
  data['school'] = entity.school;
  data['token'] = entity.token;
  return data;
}

extension WxInfoDataDataExtension on WxInfoDataData {
  WxInfoDataData copyWith({
    String? openid,
    String? nickname,
    int? sex,
    String? language,
    String? city,
    String? province,
    String? country,
    String? headimgurl,
    List<dynamic>? privilege,
    String? unionid,
    String? school,
    String? token,
  }) {
    return WxInfoDataData()
      ..openid = openid ?? this.openid
      ..nickname = nickname ?? this.nickname
      ..sex = sex ?? this.sex
      ..language = language ?? this.language
      ..city = city ?? this.city
      ..province = province ?? this.province
      ..country = country ?? this.country
      ..headimgurl = headimgurl ?? this.headimgurl
      ..privilege = privilege ?? this.privilege
      ..unionid = unionid ?? this.unionid
      ..school = school ?? this.school
      ..token = unionid ?? this.token;
  }
}