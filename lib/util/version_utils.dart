
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class VersionUtils {
  static const MethodChannel _kChannel = MethodChannel('version');

  /// 应用安装
  static void install(String path) {
    _kChannel.invokeMethod<void>('install', {'path': path});
  }

  /// AppStore跳转
  static void jumpAppStore() {
    _kChannel.invokeMethod<void>('jumpAppStore');
  }




  static Future<String> getAppName() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static Future<String> getpkgName() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> getAppVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getbuildNumber() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }


}
