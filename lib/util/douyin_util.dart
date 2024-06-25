import 'dart:convert';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/click_match_bean.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:advertising_info/advertising_info.dart';
// import 'package:advertising_info/advertising_info.dart';
import 'package:crypto/crypto.dart';
import 'package:device_identity/device_identity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
// import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class DYUtil {
  DYUtil();

  late String url = "";
  late String imei = "";
  late String oaid = "";
  late String androidid = "";
  late String os = "";
  late String idfa = "";
  late String macAddress = "";

  void evaluate(String message) {
    getAD(message);
  }

  // WifiInfoWrapper? _wifiObject;
  // Future<void> initPlatformState() async {
  //   WifiInfoWrapper? wifiObject;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     wifiObject = await WifiInfoPlugin.wifiDetails;
  //   } on PlatformException {}
  //   _wifiObject = wifiObject;
  // }

  void getAD(String message) async {
    // initPlatformState();
    //     late String url = "";
    // late String imei = "";
    // late String oaid = "";
    // late String androidid = "";
    // late String os = "";
    // late String idfa = "";
    // late String mac = "";

    if (Device.isAndroid) {
      // int sdk = await getAndroidSdkInt();
      // if (sdk >= 10) {
      oaid = await DeviceIdentity.oaid;
      // } else {
      imei = await DeviceIdentity.imei;
      // }
      androidid = await DeviceIdentity.androidId;
      os = "0";
      // macAddress =
      //     _wifiObject != null ? _wifiObject!.macAddress.toString() : '...';
    } else {
      AdvertisingInfo advertisingInfo = await AdvertisingInfo.read();

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // macAddress = iosInfo.utsname.machine!;
      macAddress = "";

      os = "1";
      // String? advertising_id = advertisingInfo.id;
      idfa = advertisingInfo.id ?? "";
      // idfa = "";
    }

    final Map<String, String> params = <String, String>{};
    params["imei"] = generateMd5(imei);
    params["oaid"] = oaid;
    params["androidid"] = generateMd5(androidid);
    params["os"] = os;
    params["idfa"] = idfa;
    params["mac"] = macAddress;
    params["event_type"] = message;

    DioUtils.instance.requestNetwork<ResultData>(Method.get, HttpApi.clickMatch,
        queryParameters: params, onSuccess: (result) {
      // DioUtils.instance.requestNetwork<ResultData>(Method.get,
      //     url: HttpApi.clickMatch,
      //     queryParameters: params,
      //     isShow: false, onSuccess: (result) {

      Map<String, dynamic> ebasecOnfigBeanMap = json.decode(result.toString());
      ClickMatchBean clickMatchBean =
          ClickMatchBean.fromJson(ebasecOnfigBeanMap);
      if (clickMatchBean.code == 200) {
        douyin(imei, os, oaid, idfa, clickMatchBean.data.callback, message);
      }
    });
  }

  void douyin(String imei, String os, String oaid, String idfa, String callback,
      String eventType) async {
    final dio = Dio();
    // String douyin = "";
    // if (imei.length == 0) {
    //   douyin = oaid;
    // } else {
    //   douyin = imei;
    // }
    url =
        "https://ad.oceanengine.com/track/activate/?callback=$callback&os=$os&imei=${generateMd5(imei)}&oaid=$oaid&idfa=$idfa&event_type=$eventType";
    var response = await dio.get(url);
    //转化为Json
    String jsonString = jsonEncode(response.data);
    print(jsonString);
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// 使用前记得初始化
  Future<int> getAndroidSdkInt() async {
    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    if (Constant.isDriverTest) {
      return -1;
    }
    return androidDeviceInfo.version.sdkInt;
  }
}
