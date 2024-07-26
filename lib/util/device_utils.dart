import 'dart:io';
import 'dart:math';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:device_identity/device_identity.dart';
import 'package:sp_util/sp_util.dart';

import '../constant/constant.dart';

class Device {
  static bool get isMobile => isAndroid || isIOS;

  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;

  static Future<void> initDeviceInfo() async {}

  ///获取设备ID，
  static Future<String> getDeviceId() async {
    String? deviceId = SpUtil.getString(Constant.deviceId, defValue: null);
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

    deviceId = "";
    for (var i = 0; i < 20; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      deviceId = (deviceId! + alphabet[Random().nextInt(alphabet.length)]);
    }

    if (deviceId == null) {
      // 安卓，IMEI（Android 10之前） > OAID（Android 10之后） > AndroidId

      // iOS，IDFA（需要同意追踪权限） > IDFV
      // if (Platform.isIOS) {
      //   // 是否允许追踪权限
      //   if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      //       TrackingStatus.authorized) {
      //     deviceId = await AppTrackingTransparency.getAdvertisingIdentifier();
      //   } else {}
      // }
      // 缓存设备ID
      if (deviceId != null && deviceId != '') {
        SpUtil.putString(Constant.deviceId, deviceId);
      }
    }
    return deviceId ?? '';
  }

  /// 使用前记得初始化
  static int getAndroidSdkInt() {
    return -1;
  }
}
