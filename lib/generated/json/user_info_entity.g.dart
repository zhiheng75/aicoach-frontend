import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/login/entity/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    userInfoEntity.code = code;
  }
  final UserInfoData? data = jsonConvert.convert<UserInfoData>(json['data']);
  if (data != null) {
    userInfoEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    userInfoEntity.message = message;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension UserInfoEntityExtension on UserInfoEntity {
  UserInfoEntity copyWith({
    int? code,
    UserInfoData? data,
    String? message,
  }) {
    return UserInfoEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

UserInfoData $UserInfoDataFromJson(Map<String, dynamic> json) {
  final UserInfoData userInfoData = UserInfoData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    userInfoData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    userInfoData.msg = msg;
  }
  final UserInfoDataData? data = jsonConvert.convert<UserInfoDataData>(
      json['data']);
  if (data != null) {
    userInfoData.data = data;
  }
  return userInfoData;
}

Map<String, dynamic> $UserInfoDataToJson(UserInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension UserInfoDataExtension on UserInfoData {
  UserInfoData copyWith({
    int? code,
    String? msg,
    UserInfoDataData? data,
  }) {
    return UserInfoData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

UserInfoDataData $UserInfoDataDataFromJson(Map<String, dynamic> json) {
  final UserInfoDataData userInfoDataData = UserInfoDataData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userInfoDataData.id = id;
  }
  final dynamic email = json['email'];
  if (email != null) {
    userInfoDataData.email = email;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    userInfoDataData.nickname = nickname;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    userInfoDataData.province = province;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    userInfoDataData.country = country;
  }
  final String? unionid = jsonConvert.convert<String>(json['unionid']);
  if (unionid != null) {
    userInfoDataData.unionid = unionid;
  }
  final dynamic school = json['school'];
  if (school != null) {
    userInfoDataData.school = school;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    userInfoDataData.createdAt = createdAt;
  }
  final String? openid = jsonConvert.convert<String>(json['openid']);
  if (openid != null) {
    userInfoDataData.openid = openid;
  }
  final dynamic name = json['name'];
  if (name != null) {
    userInfoDataData.name = name;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoDataData.phone = phone;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    userInfoDataData.sex = sex;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    userInfoDataData.city = city;
  }
  final String? headimgurl = jsonConvert.convert<String>(json['headimgurl']);
  if (headimgurl != null) {
    userInfoDataData.headimgurl = headimgurl;
  }
  final dynamic description = json['description'];
  if (description != null) {
    userInfoDataData.description = description;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    userInfoDataData.updatedAt = updatedAt;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    userInfoDataData.token = token;
  }
  return userInfoDataData;
}

Map<String, dynamic> $UserInfoDataDataToJson(UserInfoDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['email'] = entity.email;
  data['nickname'] = entity.nickname;
  data['province'] = entity.province;
  data['country'] = entity.country;
  data['unionid'] = entity.unionid;
  data['school'] = entity.school;
  data['created_at'] = entity.createdAt;
  data['openid'] = entity.openid;
  data['name'] = entity.name;
  data['phone'] = entity.phone;
  data['sex'] = entity.sex;
  data['city'] = entity.city;
  data['headimgurl'] = entity.headimgurl;
  data['description'] = entity.description;
  data['updated_at'] = entity.updatedAt;
  data['token'] = entity.token;
  return data;
}

extension UserInfoDataDataExtension on UserInfoDataData {
  UserInfoDataData copyWith({
    int? id,
    dynamic email,
    String? nickname,
    String? province,
    String? country,
    String? unionid,
    dynamic school,
    String? createdAt,
    String? openid,
    dynamic name,
    String? phone,
    int? sex,
    String? city,
    String? headimgurl,
    dynamic description,
    String? updatedAt,
    String? token,
  }) {
    return UserInfoDataData()
      ..id = id ?? this.id
      ..email = email ?? this.email
      ..nickname = nickname ?? this.nickname
      ..province = province ?? this.province
      ..country = country ?? this.country
      ..unionid = unionid ?? this.unionid
      ..school = school ?? this.school
      ..createdAt = createdAt ?? this.createdAt
      ..openid = openid ?? this.openid
      ..name = name ?? this.name
      ..phone = phone ?? this.phone
      ..sex = sex ?? this.sex
      ..city = city ?? this.city
      ..headimgurl = headimgurl ?? this.headimgurl
      ..description = description ?? this.description
      ..updatedAt = updatedAt ?? this.updatedAt
      ..token = token ?? this.token;
  }
}