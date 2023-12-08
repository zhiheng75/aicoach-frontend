import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/ali_pay_entity.dart';

AliPayEntity $AliPayEntityFromJson(Map<String, dynamic> json) {
  final AliPayEntity aliPayEntity = AliPayEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    aliPayEntity.code = code;
  }
  final AliPayData? data = jsonConvert.convert<AliPayData>(json['data']);
  if (data != null) {
    aliPayEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    aliPayEntity.message = message;
  }
  return aliPayEntity;
}

Map<String, dynamic> $AliPayEntityToJson(AliPayEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension AliPayEntityExtension on AliPayEntity {
  AliPayEntity copyWith({
    int? code,
    AliPayData? data,
    String? message,
  }) {
    return AliPayEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

AliPayData $AliPayDataFromJson(Map<String, dynamic> json) {
  final AliPayData aliPayData = AliPayData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    aliPayData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    aliPayData.msg = msg;
  }
  final AliPayDataData? data = jsonConvert.convert<AliPayDataData>(
      json['data']);
  if (data != null) {
    aliPayData.data = data;
  }
  return aliPayData;
}

Map<String, dynamic> $AliPayDataToJson(AliPayData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension AliPayDataExtension on AliPayData {
  AliPayData copyWith({
    int? code,
    String? msg,
    AliPayDataData? data,
  }) {
    return AliPayData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

AliPayDataData $AliPayDataDataFromJson(Map<String, dynamic> json) {
  final AliPayDataData aliPayDataData = AliPayDataData();
  final String? prepayUrl = jsonConvert.convert<String>(json['prepay_url']);
  if (prepayUrl != null) {
    aliPayDataData.prepayUrl = prepayUrl;
  }
  final String? orderNo = jsonConvert.convert<String>(json['order_no']);
  if (orderNo != null) {
    aliPayDataData.orderNo = orderNo;
  }
  return aliPayDataData;
}

Map<String, dynamic> $AliPayDataDataToJson(AliPayDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['prepay_url'] = entity.prepayUrl;
  data['order_no'] = entity.orderNo;
  return data;
}

extension AliPayDataDataExtension on AliPayDataData {
  AliPayDataData copyWith({
    String? prepayUrl,
    String? orderNo,
  }) {
    return AliPayDataData()
      ..prepayUrl = prepayUrl ?? this.prepayUrl
      ..orderNo = orderNo ?? this.orderNo;
  }
}