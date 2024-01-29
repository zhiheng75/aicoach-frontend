import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/provider/selecter_teacher_provider.dart';
import 'package:Bubble/setting/provider/device_provider.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:device_identity/device_identity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/routers/routers.dart';
import 'package:Bubble/setting/provider/locale_provider.dart';
import 'package:Bubble/setting/provider/theme_provider.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/handle_error_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/theme_utils.dart';

import 'home/splash_page.dart';
import 'net/dio_utils.dart';
import 'net/intercept.dart';

// 页面切换监听
final RouteObserver<PageRoute> routeObserver = RouteObserver();

Future<void> main() async {
  /// 异常处理
  handleError(() async {
    /// 确保初始化完成
    WidgetsFlutterBinding.ensureInitialized();

    /// sp初始化
    await SpUtil.getInstance();

    /// device_identity初始化
    await DeviceIdentity.register();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 设置音频配置
    await AudioConfig.addAudioConfig();
    runApp(MyApp());
  });

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.home, this.theme}) {
    Log.init();
    initDio();
    Routes.initRoutes();
  }

  final Widget? home;
  final ThemeData? theme;
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    /// 刷新Token
    // interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    configDio(
      // 测试
      baseUrl: 'https://api.demo.shenmo-ai.net/',
      // // 正式
      // baseUrl: 'https://api.demo.shenmo-ai.com/',
      interceptors: interceptors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => HomeTeacherProvider()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: Consumer2<ThemeProvider, LocaleProvider>(
          builder: (_, themeProvider, localeProvider, __) {
            return _buildMaterialApp(themeProvider, localeProvider);
          },
        ),
      ),
    );

    /// Toast 配置
    return OKToast(
        backgroundColor: Colors.black54,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.center,
        child: app);
  }

  Widget _buildMaterialApp(
      ThemeProvider provider, LocaleProvider localeProvider) {
    return MaterialApp(
      title: 'Bubble',
      // showPerformanceOverlay: true, //显示性能标签
      debugShowCheckedModeBanner: false, // 去除右上角debug的标签
      // checkerboardRasterCacheImages: true,
      // showSemanticsDebugger: true, // 显示语义视图
      // checkerboardOffscreenLayers: true, // 检查离屏渲染

      theme: theme ?? provider.getTheme(),
      darkTheme: provider.getTheme(isDarkMode: true),
      themeMode: provider.getThemeMode(),
      home: home ?? const SplashPage(),
      onGenerateRoute: Routes.router.generator,
      // localizationsDelegates: DeerLocalizations.localizationsDelegates,
      // supportedLocales: DeerLocalizations.supportedLocales,
      locale: localeProvider.locale,
      navigatorKey: Constant.navigatorKey,
      builder: (BuildContext context, Widget? child) {
        /// 仅针对安卓
        if (Device.isAndroid) {
          /// 切换深色模式会触发此方法，这里设置导航栏颜色
          ThemeUtils.setSystemNavigationBar(provider.getThemeMode());
        }

        /// 保证文字大小不受手机系统设置影响
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      restorationScopeId: 'app',
      navigatorObservers: [routeObserver],
    );
  }
}
