import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class EventUMStatistics {
  static void umengCommonInit() {
    String platformStr = Channel.channelios;
    if (Device.isAndroid) {
      platformStr = Channel.channeloppo;
    } else {
      platformStr = Channel.channelios;
    }
    UmengCommonSdk.initCommon(
        '65bc5ac795b14f599d216dd6', '65bc5a9595b14f599d216d93', platformStr);
    UmengCommonSdk.setPageCollectionModeManual();
  }

// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
  static void umengCommonMapEvent(String name) {
    UmengCommonSdk.onEvent(name, {
      // 'name': name,
    });
  }

// 手动采集页面信息
  static void umengCommonPageCollectionModeManual() {
    UmengCommonSdk.setPageCollectionModeManual();
  }

// 自动采集页面信息
  static void umengCommonPageCollectionModeAuto() {
    UmengCommonSdk.setPageCollectionModeAuto();
  }

// 进入页面统计（手动采集时才可设置）
  static void umengCommonOnPageStart(String name) {
    UmengCommonSdk.onPageStart(name);
  }

// 离开页面统计（手动采集时才可设置）
  static void umengCommonOnPageEnd(String name) {
    UmengCommonSdk.onPageEnd(name);
  }
}
