import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/login/entity/my_user_info_entity.dart';

MyUserInfoEntity $MyUserInfoEntityFromJson(Map<String, dynamic> json) {
  final MyUserInfoEntity myUserInfoEntity = MyUserInfoEntity();
  final MyUserInfoData? data = jsonConvert.convert<MyUserInfoData>(
      json['data']);
  if (data != null) {
    myUserInfoEntity.data = data;
  }
  return myUserInfoEntity;
}

Map<String, dynamic> $MyUserInfoEntityToJson(MyUserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data.toJson();
  return data;
}

extension MyUserInfoEntityExtension on MyUserInfoEntity {
  MyUserInfoEntity copyWith({
    MyUserInfoData? data,
  }) {
    return MyUserInfoEntity()
      ..data = data ?? this.data;
  }
}

MyUserInfoData $MyUserInfoDataFromJson(Map<String, dynamic> json) {
  final MyUserInfoData myUserInfoData = MyUserInfoData();
  final dynamic name = json['name'];
  if (name != null) {
    myUserInfoData.name = name;
  }
  final String? openid = jsonConvert.convert<String>(json['openid']);
  if (openid != null) {
    myUserInfoData.openid = openid;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    myUserInfoData.phone = phone;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    myUserInfoData.sex = sex;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    myUserInfoData.city = city;
  }
  final String? headimgurl = jsonConvert.convert<String>(json['headimgurl']);
  if (headimgurl != null) {
    myUserInfoData.headimgurl = headimgurl;
  }
  final dynamic description = json['description'];
  if (description != null) {
    myUserInfoData.description = description;
  }
  final dynamic membershipType = json['membership_type'];
  if (membershipType != null) {
    myUserInfoData.membershipType = membershipType;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    myUserInfoData.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    myUserInfoData.updatedAt = updatedAt;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    myUserInfoData.id = id;
  }
  final dynamic email = json['email'];
  if (email != null) {
    myUserInfoData.email = email;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    myUserInfoData.nickname = nickname;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    myUserInfoData.province = province;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    myUserInfoData.country = country;
  }
  final String? unionid = jsonConvert.convert<String>(json['unionid']);
  if (unionid != null) {
    myUserInfoData.unionid = unionid;
  }
  final dynamic school = json['school'];
  if (school != null) {
    myUserInfoData.school = school;
  }
  final dynamic membershipExpiryDate = json['membership_expiry_date'];
  if (membershipExpiryDate != null) {
    myUserInfoData.membershipExpiryDate = membershipExpiryDate;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    myUserInfoData.token = token;
  }
  return myUserInfoData;
}

Map<String, dynamic> $MyUserInfoDataToJson(MyUserInfoData entity) {
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

extension MyUserInfoDataExtension on MyUserInfoData {
  MyUserInfoData copyWith({
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
    return MyUserInfoData()
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