// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/base_config_entity.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:Bubble/login/entity/my_user_info_entity.dart';
import 'package:Bubble/login/entity/user_info_entity.dart';
import 'package:Bubble/login/entity/wx_info_entity.dart';
import 'package:Bubble/order/entity/order_list_entity.dart';
import 'package:Bubble/person/entity/ali_pay_entity.dart';
import 'package:Bubble/person/entity/good_list_entity.dart';
import 'package:Bubble/person/entity/oss_token_entity.dart';
import 'package:Bubble/person/entity/send_img_result_entity.dart';
import 'package:Bubble/person/entity/study_info_entity.dart';
import 'package:Bubble/person/entity/study_list_entity.dart';
import 'package:Bubble/person/entity/wx_pay_entity.dart';
import 'package:Bubble/report/entity/study_report_entity.dart';
import 'package:Bubble/setting/entity/updata_info_entity.dart';

JsonConvert jsonConvert = JsonConvert();

typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);
typedef ConvertExceptionHandler = void Function(
    Object error, StackTrace stackTrace);

class JsonConvert {
  static ConvertExceptionHandler? onError;
  JsonConvertClassCollection convertFuncMap = JsonConvertClassCollection();

  /// When you are in the development, to generate a new model class, hot-reload doesn't find new generation model class, you can build on MaterialApp method called jsonConvert. ReassembleConvertFuncMap (); This method only works in a development environment
  /// https://flutter.cn/docs/development/tools/hot-reload
  /// class MyApp extends StatelessWidget {
  ///    const MyApp({Key? key})
  ///        : super(key: key);
  ///
  ///    @override
  ///    Widget build(BuildContext context) {
  ///      jsonConvert.reassembleConvertFuncMap();
  ///      return MaterialApp();
  ///    }
  /// }
  void reassembleConvertFuncMap() {
    bool isReleaseMode = const bool.fromEnvironment('dart.vm.product');
    if (!isReleaseMode) {
      convertFuncMap = JsonConvertClassCollection();
    }
  }

  T? convert<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    try {
      return _asT<T>(value, enumConvert: enumConvert);
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return null;
    }
  }

  List<T?>? convertList<T>(List<dynamic>? value,
      {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return value
          .map((dynamic e) => _asT<T>(e, enumConvert: enumConvert))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>)
          .map((dynamic e) => _asT<T>(e, enumConvert: enumConvert)!)
          .toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  T? _asT<T extends Object?>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    final String type = T.toString();
    final String valueS = value.toString();
    if (enumConvert != null) {
      return enumConvert(valueS) as T;
    } else if (type == "String") {
      return valueS as T;
    } else if (type == "int") {
      final int? intValue = int.tryParse(valueS);
      if (intValue == null) {
        return double.tryParse(valueS)?.toInt() as T?;
      } else {
        return intValue as T;
      }
    } else if (type == "double") {
      return double.parse(valueS) as T;
    } else if (type == "DateTime") {
      return DateTime.parse(valueS) as T;
    } else if (type == "bool") {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (type == "Map" || type.startsWith("Map<")) {
      return value as T;
    } else {
      if (convertFuncMap.containsKey(type)) {
        if (value == null) {
          return null;
        }
        return convertFuncMap[type]!(Map<String, dynamic>.from(value)) as T;
      } else {
        throw UnimplementedError(
            '$type unimplemented,you can try running the app again');
      }
    }
  }

  //list is returned by type
  static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
    if (<EmptyResponseEntity>[] is M) {
      return data
          .map<EmptyResponseEntity>(
              (Map<String, dynamic> e) => EmptyResponseEntity.fromJson(e))
          .toList() as M;
    }
    if (<EmptyResponseData>[] is M) {
      return data
          .map<EmptyResponseData>(
              (Map<String, dynamic> e) => EmptyResponseData.fromJson(e))
          .toList() as M;
    }
    if (<EmptyResponseDataData>[] is M) {
      return data
          .map<EmptyResponseDataData>(
              (Map<String, dynamic> e) => EmptyResponseDataData.fromJson(e))
          .toList() as M;
    }
    if (<ResultData>[] is M) {
      return data
          .map<ResultData>((Map<String, dynamic> e) => ResultData.fromJson(e))
          .toList() as M;
    }
    if (<BaseConfigEntity>[] is M) {
      return data
          .map<BaseConfigEntity>(
              (Map<String, dynamic> e) => BaseConfigEntity.fromJson(e))
          .toList() as M;
    }
    if (<BaseConfigData>[] is M) {
      return data
          .map<BaseConfigData>(
              (Map<String, dynamic> e) => BaseConfigData.fromJson(e))
          .toList() as M;
    }
    if (<BaseConfigDataData>[] is M) {
      return data
          .map<BaseConfigDataData>(
              (Map<String, dynamic> e) => BaseConfigDataData.fromJson(e))
          .toList() as M;
    }
    if (<TeachListEntity>[] is M) {
      return data
          .map<TeachListEntity>(
              (Map<String, dynamic> e) => TeachListEntity.fromJson(e))
          .toList() as M;
    }
    if (<LoginInfoEntity>[] is M) {
      return data
          .map<LoginInfoEntity>(
              (Map<String, dynamic> e) => LoginInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<LoginInfoData>[] is M) {
      return data
          .map<LoginInfoData>(
              (Map<String, dynamic> e) => LoginInfoData.fromJson(e))
          .toList() as M;
    }
    if (<LoginInfoDataData>[] is M) {
      return data
          .map<LoginInfoDataData>(
              (Map<String, dynamic> e) => LoginInfoDataData.fromJson(e))
          .toList() as M;
    }
    if (<MyUserInfoEntity>[] is M) {
      return data
          .map<MyUserInfoEntity>(
              (Map<String, dynamic> e) => MyUserInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<MyUserInfoData>[] is M) {
      return data
          .map<MyUserInfoData>(
              (Map<String, dynamic> e) => MyUserInfoData.fromJson(e))
          .toList() as M;
    }
    if (<UserInfoEntity>[] is M) {
      return data
          .map<UserInfoEntity>(
              (Map<String, dynamic> e) => UserInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<UserInfoData>[] is M) {
      return data
          .map<UserInfoData>(
              (Map<String, dynamic> e) => UserInfoData.fromJson(e))
          .toList() as M;
    }
    if (<UserInfoDataData>[] is M) {
      return data
          .map<UserInfoDataData>(
              (Map<String, dynamic> e) => UserInfoDataData.fromJson(e))
          .toList() as M;
    }
    if (<WxInfoEntity>[] is M) {
      return data
          .map<WxInfoEntity>(
              (Map<String, dynamic> e) => WxInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<WxInfoData>[] is M) {
      return data
          .map<WxInfoData>((Map<String, dynamic> e) => WxInfoData.fromJson(e))
          .toList() as M;
    }
    if (<WxInfoDataData>[] is M) {
      return data
          .map<WxInfoDataData>(
              (Map<String, dynamic> e) => WxInfoDataData.fromJson(e))
          .toList() as M;
    }
    if (<OrderListEntity>[] is M) {
      return data
          .map<OrderListEntity>(
              (Map<String, dynamic> e) => OrderListEntity.fromJson(e))
          .toList() as M;
    }
    if (<OrderListData>[] is M) {
      return data
          .map<OrderListData>(
              (Map<String, dynamic> e) => OrderListData.fromJson(e))
          .toList() as M;
    }
    if (<OrderListDataData>[] is M) {
      return data
          .map<OrderListDataData>(
              (Map<String, dynamic> e) => OrderListDataData.fromJson(e))
          .toList() as M;
    }
    if (<AliPayEntity>[] is M) {
      return data
          .map<AliPayEntity>(
              (Map<String, dynamic> e) => AliPayEntity.fromJson(e))
          .toList() as M;
    }
    if (<AliPayData>[] is M) {
      return data
          .map<AliPayData>((Map<String, dynamic> e) => AliPayData.fromJson(e))
          .toList() as M;
    }
    if (<AliPayDataData>[] is M) {
      return data
          .map<AliPayDataData>(
              (Map<String, dynamic> e) => AliPayDataData.fromJson(e))
          .toList() as M;
    }
    if (<GoodListEntity>[] is M) {
      return data
          .map<GoodListEntity>(
              (Map<String, dynamic> e) => GoodListEntity.fromJson(e))
          .toList() as M;
    }
    if (<GoodListData>[] is M) {
      return data
          .map<GoodListData>(
              (Map<String, dynamic> e) => GoodListData.fromJson(e))
          .toList() as M;
    }
    if (<GoodListDataData>[] is M) {
      return data
          .map<GoodListDataData>(
              (Map<String, dynamic> e) => GoodListDataData.fromJson(e))
          .toList() as M;
    }
    if (<OssTokenEntity>[] is M) {
      return data
          .map<OssTokenEntity>(
              (Map<String, dynamic> e) => OssTokenEntity.fromJson(e))
          .toList() as M;
    }
    if (<OssTokenData>[] is M) {
      return data
          .map<OssTokenData>(
              (Map<String, dynamic> e) => OssTokenData.fromJson(e))
          .toList() as M;
    }
    if (<OssTokenDataData>[] is M) {
      return data
          .map<OssTokenDataData>(
              (Map<String, dynamic> e) => OssTokenDataData.fromJson(e))
          .toList() as M;
    }
    if (<SendImgResultEntity>[] is M) {
      return data
          .map<SendImgResultEntity>(
              (Map<String, dynamic> e) => SendImgResultEntity.fromJson(e))
          .toList() as M;
    }
    if (<SendImgResultData>[] is M) {
      return data
          .map<SendImgResultData>(
              (Map<String, dynamic> e) => SendImgResultData.fromJson(e))
          .toList() as M;
    }
    if (<SendImgResultDataData>[] is M) {
      return data
          .map<SendImgResultDataData>(
              (Map<String, dynamic> e) => SendImgResultDataData.fromJson(e))
          .toList() as M;
    }
    if (<StudyInfoEntity>[] is M) {
      return data
          .map<StudyInfoEntity>(
              (Map<String, dynamic> e) => StudyInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<StudyInfoData>[] is M) {
      return data
          .map<StudyInfoData>(
              (Map<String, dynamic> e) => StudyInfoData.fromJson(e))
          .toList() as M;
    }
    if (<StudyInfoDataData>[] is M) {
      return data
          .map<StudyInfoDataData>(
              (Map<String, dynamic> e) => StudyInfoDataData.fromJson(e))
          .toList() as M;
    }
    if (<StudyListEntity>[] is M) {
      return data
          .map<StudyListEntity>(
              (Map<String, dynamic> e) => StudyListEntity.fromJson(e))
          .toList() as M;
    }
    if (<StudyListData>[] is M) {
      return data
          .map<StudyListData>(
              (Map<String, dynamic> e) => StudyListData.fromJson(e))
          .toList() as M;
    }
    if (<StudyListDataData>[] is M) {
      return data
          .map<StudyListDataData>(
              (Map<String, dynamic> e) => StudyListDataData.fromJson(e))
          .toList() as M;
    }
    if (<WxPayEntity>[] is M) {
      return data
          .map<WxPayEntity>((Map<String, dynamic> e) => WxPayEntity.fromJson(e))
          .toList() as M;
    }
    if (<WxPayData>[] is M) {
      return data
          .map<WxPayData>((Map<String, dynamic> e) => WxPayData.fromJson(e))
          .toList() as M;
    }
    if (<WxPayDataData>[] is M) {
      return data
          .map<WxPayDataData>(
              (Map<String, dynamic> e) => WxPayDataData.fromJson(e))
          .toList() as M;
    }
    if (<StudyReportEntity>[] is M) {
      return data
          .map<StudyReportEntity>(
              (Map<String, dynamic> e) => StudyReportEntity.fromJson(e))
          .toList() as M;
    }
    if (<StudyReportData>[] is M) {
      return data
          .map<StudyReportData>(
              (Map<String, dynamic> e) => StudyReportData.fromJson(e))
          .toList() as M;
    }
    if (<StudyReportDataData>[] is M) {
      return data
          .map<StudyReportDataData>(
              (Map<String, dynamic> e) => StudyReportDataData.fromJson(e))
          .toList() as M;
    }
    if (<UpdataInfoEntity>[] is M) {
      return data
          .map<UpdataInfoEntity>(
              (Map<String, dynamic> e) => UpdataInfoEntity.fromJson(e))
          .toList() as M;
    }
    if (<UpdataInfoData>[] is M) {
      return data
          .map<UpdataInfoData>(
              (Map<String, dynamic> e) => UpdataInfoData.fromJson(e))
          .toList() as M;
    }
    if (<UpdataInfoDataData>[] is M) {
      return data
          .map<UpdataInfoDataData>(
              (Map<String, dynamic> e) => UpdataInfoDataData.fromJson(e))
          .toList() as M;
    }

    if (<UpdataInfoData>[] is M) {
      return data
          .map<UpdataInfoData>(
              (Map<String, dynamic> e) => UpdataInfoData.fromJson(e))
          .toList() as M;
    }
    if (<NewWxInfoBeanData>[] is M) {
      return data
          .map<NewWxInfoBeanData>(
              (Map<String, dynamic> e) => NewWxInfoBeanData.fromJson(e))
          .toList() as M;
    }

    debugPrint("${M.toString()} not found");

    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json is M) {
      return json;
    }
    if (json is List) {
      return _getListChildType<M>(
          json.map((e) => e as Map<String, dynamic>).toList());
    } else {
      return jsonConvert.convert<M>(json);
    }
  }
}

class JsonConvertClassCollection {
  Map<String, JsonConvertFunction> convertFuncMap = {
    (EmptyResponseEntity).toString(): EmptyResponseEntity.fromJson,
    (EmptyResponseData).toString(): EmptyResponseData.fromJson,
    (EmptyResponseDataData).toString(): EmptyResponseDataData.fromJson,
    (ResultData).toString(): ResultData.fromJson,
    (BaseConfigEntity).toString(): BaseConfigEntity.fromJson,
    (BaseConfigData).toString(): BaseConfigData.fromJson,
    (BaseConfigDataData).toString(): BaseConfigDataData.fromJson,
    (TeachListEntity).toString(): TeachListEntity.fromJson,
    (LoginInfoEntity).toString(): LoginInfoEntity.fromJson,
    (LoginInfoData).toString(): LoginInfoData.fromJson,
    (LoginInfoDataData).toString(): LoginInfoDataData.fromJson,
    (MyUserInfoEntity).toString(): MyUserInfoEntity.fromJson,
    (MyUserInfoData).toString(): MyUserInfoData.fromJson,
    (UserInfoEntity).toString(): UserInfoEntity.fromJson,
    (UserInfoData).toString(): UserInfoData.fromJson,
    (UserInfoDataData).toString(): UserInfoDataData.fromJson,
    (WxInfoEntity).toString(): WxInfoEntity.fromJson,
    (WxInfoData).toString(): WxInfoData.fromJson,
    (WxInfoDataData).toString(): WxInfoDataData.fromJson,
    (OrderListEntity).toString(): OrderListEntity.fromJson,
    (OrderListData).toString(): OrderListData.fromJson,
    (OrderListDataData).toString(): OrderListDataData.fromJson,
    (AliPayEntity).toString(): AliPayEntity.fromJson,
    (AliPayData).toString(): AliPayData.fromJson,
    (AliPayDataData).toString(): AliPayDataData.fromJson,
    (GoodListEntity).toString(): GoodListEntity.fromJson,
    (GoodListData).toString(): GoodListData.fromJson,
    (GoodListDataData).toString(): GoodListDataData.fromJson,
    (OssTokenEntity).toString(): OssTokenEntity.fromJson,
    (OssTokenData).toString(): OssTokenData.fromJson,
    (OssTokenDataData).toString(): OssTokenDataData.fromJson,
    (SendImgResultEntity).toString(): SendImgResultEntity.fromJson,
    (SendImgResultData).toString(): SendImgResultData.fromJson,
    (SendImgResultDataData).toString(): SendImgResultDataData.fromJson,
    (StudyInfoEntity).toString(): StudyInfoEntity.fromJson,
    (StudyInfoData).toString(): StudyInfoData.fromJson,
    (StudyInfoDataData).toString(): StudyInfoDataData.fromJson,
    (StudyListEntity).toString(): StudyListEntity.fromJson,
    (StudyListData).toString(): StudyListData.fromJson,
    (StudyListDataData).toString(): StudyListDataData.fromJson,
    (WxPayEntity).toString(): WxPayEntity.fromJson,
    (WxPayData).toString(): WxPayData.fromJson,
    (WxPayDataData).toString(): WxPayDataData.fromJson,
    (StudyReportEntity).toString(): StudyReportEntity.fromJson,
    (StudyReportData).toString(): StudyReportData.fromJson,
    (StudyReportDataData).toString(): StudyReportDataData.fromJson,
    (UpdataInfoEntity).toString(): UpdataInfoEntity.fromJson,
    (UpdataInfoData).toString(): UpdataInfoData.fromJson,
    (UpdataInfoDataData).toString(): UpdataInfoDataData.fromJson,
    (NewWxInfoBeanData).toString(): NewWxInfoBeanData.fromJson,
  };

  bool containsKey(String type) {
    return convertFuncMap.containsKey(type);
  }

  JsonConvertFunction? operator [](String key) {
    return convertFuncMap[key];
  }
}
