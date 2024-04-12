import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class EventStatistics {
  static void umengCommonMapEvent(String name) {
    UmengCommonSdk.onEvent('map', {
      'name': name,
    });
  }
}
