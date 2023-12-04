import 'package:Bubble/generated/json/base/json_convert_content.dart';
import 'package:Bubble/person/entity/wx_pay_entity.dart';

WxPayEntity $WxPayEntityFromJson(Map<String, dynamic> json) {
  final WxPayEntity wxPayEntity = WxPayEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    wxPayEntity.code = code;
  }
  final WxPayData? data = jsonConvert.convert<WxPayData>(json['data']);
  if (data != null) {
    wxPayEntity.data = data;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    wxPayEntity.message = message;
  }
  return wxPayEntity;
}

Map<String, dynamic> $WxPayEntityToJson(WxPayEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.toJson();
  data['message'] = entity.message;
  return data;
}

extension WxPayEntityExtension on WxPayEntity {
  WxPayEntity copyWith({
    int? code,
    WxPayData? data,
    String? message,
  }) {
    return WxPayEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..message = message ?? this.message;
  }
}

WxPayData $WxPayDataFromJson(Map<String, dynamic> json) {
  final WxPayData wxPayData = WxPayData();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    wxPayData.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    wxPayData.msg = msg;
  }
  final WxPayDataData? data = jsonConvert.convert<WxPayDataData>(json['data']);
  if (data != null) {
    wxPayData.data = data;
  }
  return wxPayData;
}

Map<String, dynamic> $WxPayDataToJson(WxPayData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data.toJson();
  return data;
}

extension WxPayDataExtension on WxPayData {
  WxPayData copyWith({
    int? code,
    String? msg,
    WxPayDataData? data,
  }) {
    return WxPayData()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

WxPayDataData $WxPayDataDataFromJson(Map<String, dynamic> json) {
  final WxPayDataData wxPayDataData = WxPayDataData();
  final String? appid = jsonConvert.convert<String>(json['appid']);
  if (appid != null) {
    wxPayDataData.appid = appid;
  }
  final String? partnerid = jsonConvert.convert<String>(json['partnerid']);
  if (partnerid != null) {
    wxPayDataData.partnerid = partnerid;
  }
  final String? timestamp = jsonConvert.convert<String>(json['timestamp']);
  if (timestamp != null) {
    wxPayDataData.timestamp = timestamp;
  }
  final String? noncestr = jsonConvert.convert<String>(json['noncestr']);
  if (noncestr != null) {
    wxPayDataData.noncestr = noncestr;
  }
  final String? prepayId = jsonConvert.convert<String>(json['prepay_id']);
  if (prepayId != null) {
    wxPayDataData.prepayId = prepayId;
  }
  final String? package = jsonConvert.convert<String>(json['package']);
  if (package != null) {
    wxPayDataData.package = package;
  }
  final String? sign = jsonConvert.convert<String>(json['sign']);
  if (sign != null) {
    wxPayDataData.sign = sign;
  }
  final String? order_no = jsonConvert.convert<String>(json['order_no']);
  if (order_no != null) {
    wxPayDataData.order_no = order_no;
  }
  return wxPayDataData;
}

Map<String, dynamic> $WxPayDataDataToJson(WxPayDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appid'] = entity.appid;
  data['partnerid'] = entity.partnerid;
  data['timestamp'] = entity.timestamp;
  data['noncestr'] = entity.noncestr;
  data['prepay_id'] = entity.prepayId;
  data['package'] = entity.package;
  data['sign'] = entity.sign;
  data['order_no'] = entity.order_no;
  return data;
}

extension WxPayDataDataExtension on WxPayDataData {
  WxPayDataData copyWith({
    String? appid,
    String? partnerid,
    String? timestamp,
    String? noncestr,
    String? prepayId,
    String? package,
    String? sign,
    String? order_no,
  }) {
    return WxPayDataData()
      ..appid = appid ?? this.appid
      ..partnerid = partnerid ?? this.partnerid
      ..timestamp = timestamp ?? this.timestamp
      ..noncestr = noncestr ?? this.noncestr
      ..prepayId = prepayId ?? this.prepayId
      ..package = package ?? this.package
      ..sign = sign ?? this.sign
      ..order_no = order_no ?? this.order_no;
  }
}