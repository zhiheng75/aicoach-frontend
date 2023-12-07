import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_identity/device_identity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sp_util/sp_util.dart';

import '../constant/constant.dart';

class Device {
  static bool get isMobile => isAndroid || isIOS;


  static bool get isAndroid =>  Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;

  static late AndroidDeviceInfo _androidInfo;
  static late IosDeviceInfo _iosInfo;

  static Future<void> initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isAndroid) {
      _androidInfo = await deviceInfo.androidInfo;
    }
    if (isIOS) {
      _iosInfo = await deviceInfo.iosInfo;
    }
  }

  ///获取设备ID，
  static Future<String> getDeviceId() async {
    String? deviceId = SpUtil.getString(Constant.deviceId, defValue: null);
    if (deviceId == null) {
      // 安卓，IMEI（Android 10之前） > OAID（Android 10之后） > AndroidId
      if (Platform.isAndroid) {
        int sdk = getAndroidSdkInt();
        if (sdk >= 10) {
          deviceId = await DeviceIdentity.oaid;
        } else {
          deviceId = await DeviceIdentity.imei;
        }
        if (deviceId == '') {
          deviceId = await DeviceIdentity.androidId;
        }
      }
      // iOS，IDFA（需要同意追踪权限） > IDFV
      if (Platform.isIOS) {
        // 是否允许追踪权限
        if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.authorized) {
          deviceId = await AppTrackingTransparency.getAdvertisingIdentifier();
        } else {
          deviceId = _iosInfo.identifierForVendor;
        }
      }
      // 缓存设备ID
      if (deviceId != null && deviceId != '') {
        SpUtil.putString(Constant.deviceId, deviceId);
      }
    }
    return deviceId ?? '';
  }

  /// 使用前记得初始化
  static int getAndroidSdkInt() {
    if (Constant.isDriverTest) {
      return -1;
    }
    if (isAndroid) {
      return _androidInfo.version.sdkInt;
    } else {
      return -1;
    }
  }
}
