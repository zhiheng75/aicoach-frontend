import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';



class Constant {

  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction  = kReleaseMode;

  static bool isDriverTest  = false;
  static bool isUnitTest  = false;
  
  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';
  
  static const String agreement = 'agreement';
  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String theme = 'AppTheme';
  static const String locale = 'locale';

  static const String userInfoKey = "user_info_key";

  static const String baseConfig = "base_config";

  static const String deviceId = 'device_id';

  static const String teacher = 'teacher';

  static const String isFirstUseApp = 'is_first_use_app';

  static const String avatarParams = 'avatar-params';

  static const String avatarModel = 'avatar-model';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

}
