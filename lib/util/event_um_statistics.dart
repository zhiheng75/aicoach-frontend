import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class EventUMStatistics {
  static void umengCommonInit() {
    String platformStr = Channel.channelios;
    if (Device.isAndroid) {
      platformStr = Channel.channelhuawei;
    } else {
      platformStr = Channel.channelios;
    }
    UmengCommonSdk.initCommon(
        '65bc5ac795b14f599d216dd6', '65bc5a9595b14f599d216d93', platformStr);
    UmengCommonSdk.setPageCollectionModeManual();
  }

  static void umengCommonMapEvent(String name) {
    UmengCommonSdk.onEvent('map', {
      'name': name,
    });
  }

  static void umengCommonPageCollectionModeManual() {
    UmengCommonSdk.setPageCollectionModeManual();
  }

  static void umengCommonPageCollectionModeAuto() {
    UmengCommonSdk.setPageCollectionModeAuto();
  }

  static void umengCommonOnPageStart(String name) {
    UmengCommonSdk.onPageStart(name);
  }

  static void umengCommonOnPageEnd(String name) {
    UmengCommonSdk.onPageEnd(name);
  }
}
