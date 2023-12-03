import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';

LoginInfoEntity $LoginInfoEntityFromJson(Map<String, dynamic> json) {
  final LoginInfoEntity loginInfoEntity = LoginInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    loginInfoEntity.code = code;
  }
  final LoginInfoData? data = jsonConvert.convert<LoginInfoData>(json['data']);
  if (data != null) {
    loginInfoEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    loginInfoEntity.message = message;
  }
  return loginInfoEntity;
}

Map<String, dynamic> $LoginInfoEntityToJson(LoginInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension LoginInfoEntityExtension on LoginInfoEntity {
  LoginInfoEntity copyWith({
    int? code,
    LoginInfoData? data,
    String? message,
  }) {
    return LoginInfoEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

LoginInfoData $LoginInfoDataFromJson(Map<String, dynamic> json) {
  final LoginInfoData loginInfoData = LoginInfoData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    loginInfoData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    loginInfoData.msg = msg;
  }
  final LoginInfoDataData? data = jsonConvert.convert<LoginInfoDataData>(
      json['data']);
  if (data != null) {
    loginInfoData.data = data;
  }
  return loginInfoData;
}

Map<String, dynamic> $LoginInfoDataToJson(LoginInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension LoginInfoDataExtension on LoginInfoData {
  LoginInfoData copyWith({
    int? code,
    String? msg,
    LoginInfoDataData? data,
  }) {
    return LoginInfoData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

LoginInfoDataData $LoginInfoDataDataFromJson(Map<dynamic, dynamic> json) {
  final LoginInfoDataData loginInfoDataData = LoginInfoDataData();
  final dynamic name = json['name'];
  if (name != null) {
    loginInfoDataData.name = name;
  }
  final String? openid = jsonConvert.convert<String>(json['openid']);
  if (openid != null) {
    loginInfoDataData.openid = openid;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    loginInfoDataData.phone = phone;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    loginInfoDataData.sex = sex;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    loginInfoDataData.city = city;
  }
  final String? headimgurl = jsonConvert.convert<String>(json['headimgurl']);
  if (headimgurl != null) {
    loginInfoDataData.headimgurl = headimgurl;
  }
  final dynamic description = json['description'];
  if (description != null) {
    loginInfoDataData.description = description;
  }
  final dynamic membershipType = json['membership_type'];
  if (membershipType != null) {
    loginInfoDataData.membershipType = membershipType;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    loginInfoDataData.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    loginInfoDataData.updatedAt = updatedAt;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    loginInfoDataData.id = id;
  }
  final dynamic email = json['email'];
  if (email != null) {
    loginInfoDataData.email = email;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    loginInfoDataData.nickname = nickname;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    loginInfoDataData.province = province;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    loginInfoDataData.country = country;
  }
  final String? unionid = jsonConvert.convert<String>(json['unionid']);
  if (unionid != null) {
    loginInfoDataData.unionid = unionid;
  }
  final dynamic school = json['school'];
  if (school != null) {
    loginInfoDataData.school = school;
  }
  final dynamic membershipExpiryDate = json['membership_expiry_date'];
  if (membershipExpiryDate != null) {
    loginInfoDataData.membershipExpiryDate = membershipExpiryDate;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    loginInfoDataData.token = token;
  }
  return loginInfoDataData;
}

Map<String, dynamic> $LoginInfoDataDataToJson(LoginInfoDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['openid'] = entity.openid;
  data['phone'] = entity.phone;
  data['sex'] = entity.sex;
  data['city'] = entity.city;
  data['headimgurl'] = entity.headimgurl;
  data['description'] = entity.description;
  data['membership_type'] = entity.membershipType;
  data['created_at'] = entity.createdAt;
  data['updated_at'] = entity.updatedAt;
  data['id'] = entity.id;
  data['email'] = entity.email;
  data['nickname'] = entity.nickname;
  data['province'] = entity.province;
  data['country'] = entity.country;
  data['unionid'] = entity.unionid;
  data['school'] = entity.school;
  data['membership_expiry_date'] = entity.membershipExpiryDate;
  data['token'] = entity.token;
  return data;
}

extension LoginInfoDataDataExtension on LoginInfoDataData {
  LoginInfoDataData copyWith({
    dynamic name,
    String? openid,
    String? phone,
    int? sex,
    String? city,
    String? headimgurl,
    dynamic description,
    dynamic membershipType,
    String? createdAt,
    String? updatedAt,
    int? id,
    dynamic email,
    String? nickname,
    String? province,
    String? country,
    String? unionid,
    dynamic school,
    dynamic membershipExpiryDate,
    String? token,
  }) {
    return LoginInfoDataData()
      ..name = name ?? this.name
      ..openid = openid ?? this.openid
      ..phone = phone ?? this.phone
      ..sex = sex ?? this.sex
      ..city = city ?? this.city
      ..headimgurl = headimgurl ?? this.headimgurl
      ..description = description ?? this.description
      ..membershipType = membershipType ?? this.membershipType
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..id = id ?? this.id
      ..email = email ?? this.email
      ..nickname = nickname ?? this.nickname
      ..province = province ?? this.province
      ..country = country ?? this.country
      ..unionid = unionid ?? this.unionid
      ..school = school ?? this.school
      ..membershipExpiryDate = membershipExpiryDate ?? this.membershipExpiryDate
      ..token = token ?? this.token;
  }
}