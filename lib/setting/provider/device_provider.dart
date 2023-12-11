// ignore_for_file: prefer_final_fields

import 'package:Bubble/util/device_utils.dart';
import 'package:flutter/material.dart';

class DeviceProvider extends ChangeNotifier {
  String _deviceId = '';

  String get deviceId => _deviceId;

  Future<void> getDeviceId() async {
    _deviceId = await Device.getDeviceId();
  }
}
