import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
import 'package:Bubble/home/entity/system_maintenance_bean.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/presenter/home_two_page_presenter.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/view/home_two_page_view.dart';
import 'package:Bubble/home/widget/System_Maintenance_view.dart';
import 'package:Bubble/home/widget/home_item.dart';
import 'package:Bubble/home/widget/not_network_show_view.dart';
import 'package:Bubble/home/widget/player_widget.dart';
import 'package:Bubble/home/widget/push_show_view.dart';
import 'package:Bubble/home/widget/teacher_show_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/main.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/version_bean.dart';
import 'package:Bubble/person/widget/illustration.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/test/connectivity_test.dart';
import 'package:Bubble/test/demo.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/douyin_util.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/other_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/group_avatar_widget.dart';
import 'package:Bubble/widgets/load_image.dart';
// import 'package:advertising_info/advertising_info.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:device_identity/device_identity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
// import 'package:jverify/jverify.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wakelock/wakelock.dart';
import '../widgets/load_fail.dart';

import '../person/entity/basec_onfig_bean.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

class HomeTwoPage extends StatefulWidget {
  const HomeTwoPage({super.key});

  @override
  State<HomeTwoPage> createState() => _HomeTwoPageState();
}

class _HomeTwoPageState extends State<HomeTwoPage>
    with
        BasePageMixin<HomeTwoPage, HomeTwoPagePresenter>,
        AutomaticKeepAliveClientMixin<HomeTwoPage>,
        WidgetsBindingObserver,
        RouteAware
    implements HomeTwoPageView {
  int currentIndex = 0;
  late HomeProvider _homeProvider;

  late HomeTwoPagePresenter _homeTwoPagePresenter;

  List<Datum> characterList = [];
  // List<String> headData = [];
  // List<CategoryEntity> _categoryList = [];
  // List<SceneEntity> sceneList = [];
  // final ScrollController _scrollController = ScrollController();

  // List<BBanner> banner = [];
  List<BBanner> lessonList = [];
  List<BBanner> examList = [];
  List<SceneList> sceneList = [];
  late String phone = "";

  // int isChatShow = 0;
  // int isKetShow = 0;
  int isDefault = 0;
  final ScreenUtil _screenUtil = ScreenUtil();
  // bool isLoding = true;
  Fluwx fluwx = Fluwx();
  late String pageState = 'loading';

  late String bubbleAndriodVersionStr = "";
  late String bubbleAndriodVersionApprovalStr = "";

  final JPush jpush = JPush();
  late StreamSubscription<ConnectivityResult> subscription;
  bool isShowNetWork = true;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TeacherShowView(
            () {
              //确定
              String accessToken = SpUtil.getString(Constant.accessToken) ?? "";
              var encoded = Uri.encodeComponent(accessToken);
              String url =
                  "pages/mine/add-weChat/add-weChat?user_token=$encoded";
              // var encoded = Uri.encodeComponent(url);
              fluwx.open(
                  target: MiniProgram(
                      username: "gh_dcd9c62ba779",
                      path: url,
                      miniProgramType: WXMiniProgramType.release));
              EventUMStatistics.umengCommonMapEvent(
                  "click_index_go_to_add_a_tutor");
            },
          );
        });
  }

  showPushDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PushShowView(
            () {
              EventUMStatistics.umengCommonMapEvent("layer_click_message_on");
              //确定
              jpush.openSettingsForNotification();
              // jpush.resumePush();
            },
          );
        });
  }

  bool get isIPad {
    return MediaQuery.of(context).size.width > 500;
  }

  Widget barWidget(BuildContext context) {
    return SizedBox(
      height: isIPad ? 300.h : 215.0.h,
      child: Swiper(
          autoplay: true,
          pagination: SwiperPagination(
              margin: const EdgeInsets.all(
                0,
              ),
              builder: DotSwiperPaginationBuilder(
                  color: Colours.color_D9D9D9,
                  activeColor: Colours.color_7C7C7C,
                  // space: 1,
                  size: 3.h,
                  activeSize: 3.h)),
          outer: true,
          // autoplay: true,
          // fade: 0.8,
          // viewportFraction: 0.85,
          scale: 0.92,
          itemBuilder: (c, i) {
            return GestureDetector(
              onTap: () {
                NavigatorUtils.push(
                  context,
                  "${HomeRouter.homePage}?characterId=${characterList[i].characterId}",
                );
                SpUtil.putString(
                    Constant.avatarId, characterList[i].characterId);

                // EventBus().emit(
                //     NotificationUtils.taberThree, characterList[i].characterId);

                String str = characterList[i].characterId;
                if (str == "eggy") {
                  //蛋仔
                  EventUMStatistics.umengCommonMapEvent(
                      "click_index_carousel_Egg_chat");
                } else if (str == "sophia") {
                  //索菲亚
                  EventUMStatistics.umengCommonMapEvent(
                      "click_index_carousel_Sophie_chat");
                } else if (str == "gg_bond") {
                  //猪猪妹
                  EventUMStatistics.umengCommonMapEvent(
                      "click_index_carousel_GG_chat");
                } else if (str == "harry_potter") {
                  //Harley
                  EventUMStatistics.umengCommonMapEvent(
                      "view_index_carousel_Hally_chat");
                }
              },
              child: LoadImage(
                characterList[i].coverBgImage,
                fit: BoxFit.fitWidth,
              ),
            );
          },
          // pagination: const SwiperPagination(alignment: Alignment.topCenter),
          itemCount: characterList.length),
    );
  }

  onNoNetwork() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NotNetworkShowView(
            () {
              openAppSettings();
            },
          );
        });
  }

  // void onNoNetwork() {
  //   ConfirmUtils.show(
  //     context: context,
  //     title: '网络连接失败',
  //     // buttonDirection: 'vertical',
  //     confirmButtonText: '设置',
  //     cancelButtonText: '取消',
  //     onConfirm: () {
  //       openAppSettings();
  //     },
  //     onCancel: () {},
  //     child: const Text(
  //       "检测到网络权限可能未开启,您可以在${"设置"}中检查蜂窝移动网络",
  //       style: TextStyle(
  //         fontSize: 15.0,
  //         fontWeight: FontWeight.w400,
  //         color: Color(0xFF333333),
  //         height: 18.0 / 15.0,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDio();
    // initUM();
    EventBus().on(NotificationUtils.resetChat, (idx) {
      if (idx == "0") {
        isShowNetWork = true;
      } else {
        isShowNetWork = false;
      }
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 1), () {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        // Got a new connectivity status!
        if (result == ConnectivityResult.none) {
          if (isShowNetWork) {
            onNoNetwork();
          }
        }
      });
    });

    // getBaseConfig();
    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");
    String teacherId = SpUtil.getString(Constant.teacherId)!.nullSafe;
    if (teacherId.isEmpty) {
      SpUtil.putString(Constant.teacherId, "0");
    }
    WidgetsBinding.instance.addObserver(this);

    // 初始化极光推送
    initPlatformState();

    // initPlatformPhoneState();
    // 获取体验时间
    // _homeProvider.getUsageTime();

    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    EventBus().on(NotificationUtils.loginIn, (_) {
      _homeTwoPagePresenter.getBannerList();
      _homeTwoPagePresenter.getCharacterList();
    });
    EventBus().on(NotificationUtils.loginOut, (_) {
      _homeTwoPagePresenter.getBannerList();
      _homeTwoPagePresenter.getCharacterList();
    });
    _initPackageInfo();
    userInfo();
    if (Device.isAndroid) {
      DYUtil().evaluate("0");
    } else {
      // getidfa();
    }
    Future.delayed(const Duration(seconds: 2), () {
      EventUMStatistics.umengCommonOnPageStart("home_two_page");

      // EventUMStatistics.umengCommonOnPageEnd("course_home_page");
      // EventUMStatistics.umengCommonOnPageEnd("home_new_page");
      // EventUMStatistics.umengCommonOnPageEnd("person_page");
      getStandardAnswer();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      systemMaintenance();
    });
  }

  void systemMaintenance() async {
    try {
      final dio = Dio();
      // String douyin = "";
      // if (imei.length == 0) {
      //   douyin = oaid;
      // } else {
      //   douyin = imei;
      // }
      // // 正式
      // String url = "https://statics.shenmo-ai.com/system_maintenance_prod.json";
      // // 测试
      String url = "https://statics.shenmo-ai.com/system_maintenance_dev.json";
      var response = await dio.get(url);
      //转化为Json
      String jsonString = jsonEncode(response.data);
      print(jsonString);

      Map<String, dynamic> systemMaintenanceBeanMap = json.decode(jsonString);
      SystemMaintenanceBean systemMaintenanceBean =
          SystemMaintenanceBean.fromJson(systemMaintenanceBeanMap);
      if (systemMaintenanceBean.status == 1) {
        Log.e(systemMaintenanceBean.remainingTime);
        showSystemMaintenanceDialog(systemMaintenanceBean.remainingTime);
      }
    } catch (e) {
      rethrow;
    }
  }

  showSystemMaintenanceDialog(String msg) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      // ignore: deprecated_member_use
      builder: (_) => WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: SystemMaintenanceView(
          msg: msg,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  void getStandardAnswer() {
    String platformStr = "android";

    if (Device.isAndroid) {
      platformStr = Channel.channelvivo;
    } else {
      platformStr = Channel.channelios;
    }
    _homeTwoPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.version,
      queryParameters: {
        'platform': platformStr,
      },
      isShow: false,
      isClose: false,
      onSuccess: (result) {
        //  _homeTwoPagePresenter.requestNetwork<ResultData>(
        //     Method.get,
        //     HttpApi.version,
        // queryParameters: {
        //   'platform': platformStr,
        // },
        //     onSuccess: (result) {
        Map<String, dynamic> versionBeanMap = json.decode(result.toString());
        VersionBean versionBean = VersionBean.fromJson(versionBeanMap);
        if (versionBean.code == 200) {
          if (versionBean.data.versionCode >
              int.parse(_packageInfo.buildNumber)) {
            showUpViewDialog(versionBean);
          }
        }
      },
      onError: (code, msg) {},
    );
  }

  showUpViewDialog(VersionBean versionBean) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => UpDataView(
        versionBean: versionBean,
        onSuccess: () {
          // String url = "https://www.baidu.com";
          // Utils.launchWebURL(url);

          Utils.launchWebURL(versionBean.data.package);
          // openUrl(versionBean.data.package);
        },
      ),
    );
  }

  // void getidfa() async {
  //   AdvertisingInfo advertisingInfo = await AdvertisingInfo.read();
  //   bool? isLAT = advertisingInfo.isLimitAdTrackingEnabled;
  //   if (!isLAT!) {
  //     DYUtil().evaluate("0");
  //   }
  //   // Log.e();advertisingInfo.authorizationStatus;
  //   // if(advertisingInfo.authorizationStatus == notDetermined)
  // }

  void userInfo() {
    Map<String, dynamic> user = LoginManager.getUserInfo();

    // 用户名显示规则 name > nickname > phone
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  void init() {
    pageState = 'loading';
    setState(() {});
    _homeTwoPagePresenter.getBannerList();
  }

  void getBaseConfig() async {
    final info = await PackageInfo.fromPlatform();

    _homeTwoPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.baseConfig, isShow: false, onSuccess: (result) {
      Map<String, dynamic> ebasecOnfigBeanMap = json.decode(result.toString());
      BasecOnfigBean basecOnfigBean =
          BasecOnfigBean.fromJson(ebasecOnfigBeanMap);
      if (basecOnfigBean != null || basecOnfigBean.data.length != 0) {
        for (int i = 0; i < basecOnfigBean.data.length; i++) {
          BasecDatum datum = basecOnfigBean.data[i];
          if (datum.key == "bubbleAndriodVersion") {
            bubbleAndriodVersionStr = datum.value;
          }
          if (datum.key == "bubbleAndriodVersionApproval") {
            bubbleAndriodVersionApprovalStr = datum.value;
          }
        }
        if (bubbleAndriodVersionStr == info.buildNumber &&
            bubbleAndriodVersionApprovalStr == "1") {
        } else {
          initUM();
        }
      } else {}
    });
  }

  void initDio() async {
    final info = await PackageInfo.fromPlatform();

//手机品牌加型号
    DioUtils.instance.dio.options.headers['version'] = info.version;
    DioUtils.instance.dio.options.headers['buildNumber'] = info.buildNumber;
    String platformStr = Channel.channelios;
    String sysInfo = "";

    if (Device.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;

      platformStr = Channel.channelvivo;
      final Map<String, String> params = <String, String>{};
      params["manufacturer"] = androidDeviceInfo.manufacturer;
      params["id"] = androidDeviceInfo.id;
      params["brand"] = androidDeviceInfo.brand;
      params["board"] = androidDeviceInfo.board;
      params["model"] = androidDeviceInfo.model;
      params["version"] = androidDeviceInfo.version.release;
      params["device"] = androidDeviceInfo.device;
      params["display"] = androidDeviceInfo.display;

      sysInfo = params.toString();
    } else {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      platformStr = Channel.channelios;
      final Map<String, String> params = <String, String>{};
      params["version"] = iosDeviceInfo.systemVersion!;
      params["model"] = iosDeviceInfo.model!;
      params["localizedModel"] = iosDeviceInfo.localizedModel!;
      params["isPhysicalDevice"] = iosDeviceInfo.isPhysicalDevice ? "1" : "0";
      params["systemName"] = iosDeviceInfo.systemName!;
      params["machine"] = iosDeviceInfo.utsname.machine!;

      sysInfo = params.toString();
    }
    DioUtils.instance.dio.options.headers['sysInfo'] = sysInfo;
    DioUtils.instance.dio.options.headers['marketplace'] = platformStr;
  }

  void initUM() {
    EventUMStatistics.umengCommonInit();
  }

  int getCurrentTime() {
    // 获取当前时间
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
      }, onCommandResult: (Map<String, dynamic> message) async {
        print("flutter onCommandResult: $message");
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setAuth(enable: true);
    jpush.setup(
      appKey: "0ce313d976a06a8f651f2252", //你自己应用的 AppKey
      channel: "kouyududu",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.isNotificationEnabled().then((bool value) {
      if (!value) {
        //弹出提示;
        //存储时间记录对比,

        int dateTimer = SpUtil.getInt(Constant.dateTimer) ?? 0;
        if (dateTimer == 0) {
          SpUtil.putInt(Constant.dateTimer, getCurrentTime());
        } else {
          DateTime now = DateTime.now();
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimer);
          Duration difference = now.difference(dateTime);
          int daysDifference = difference.inDays;
          if (daysDifference > 5) {
            SpUtil.putInt(Constant.dateTimer, getCurrentTime());
            showPushDialog();
          }
        }
      }
    }).catchError((onError) {});

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
    });

    jpush.clearNotification();

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    // jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    //从其他页面过来
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
  }

  @override
  void didPop() {
    ///从B退回到A的是调用
    super.didPop();
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.loginIn);
    EventBus().off(NotificationUtils.loginOut);
    EventUMStatistics.umengCommonOnPageEnd("home_two_page");
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // return const ConnectivityTest();

    Widget bg = Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/home_bg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );

    if (pageState == 'loading') {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: Container(
          color: const Color(0xFFEBEDF0),
          alignment: Alignment.center,
          child: lodingView(),
        ),
      );
    }

    if (pageState == 'fail') {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: Container(
          color: const Color(0xFFEBEDF0),
          alignment: Alignment.center,
          child: LoadFail(
            reload: init,
          ),
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      // removeBottom: true,
      child: Scaffold(
          // ignore: deprecated_member_use
          body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: SafeArea(
            child: Stack(
          children: [
            bg,
            Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
              width: _screenUtil.screenWidth,
              height: _screenUtil.screenHeight,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: _screenUtil.statusBarHeight,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: Device.isAndroid ? 8 : 0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      // height: 40,
                      child: Row(
                        children: [
                          Gaps.hGap12,
                          Text("随时都在的口语伙伴",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          // Text(generateMd5(omuids),
                          //     style: const TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black,
                          //     )),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: characterList.isNotEmpty
                        ? barWidget(context)
                        : Container(),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
                      child: Row(
                        children: [
                          Gaps.hGap12,
                          Text("场景练习",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          Gaps.hGap10,
                          Text("超真实情景 练了就会用",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 2)),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                      itemCount: sceneList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              //设置列数
                              crossAxisCount: 2,
                              //设置横向间距
                              crossAxisSpacing: 10,
                              //设置主轴间距
                              mainAxisSpacing: 10,
                              childAspectRatio: 168 / 100
                              // mainAxisExtent: 120,
                              ),
                      itemBuilder: (BuildContext ctx, int index) {
                        return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.transparent,
                                barrierDismissible: false,
                                useSafeArea: false,
                                builder: (_) => SelectScene(
                                    cagegoryId: sceneList[index].cagegoryId,
                                    homePage: "1"),
                              );

                              // showModalBottomSheet(
                              //   context: context,
                              //   backgroundColor: Colors.transparent,
                              //   barrierColor: Colors.transparent,
                              //   isScrollControlled: true,
                              //   isDismissible: false,
                              //   enableDrag: false,
                              //   builder: (_) => SelectScene(
                              //       cagegoryId: sceneList[index].cagegoryId,
                              //       homePage: "1"),
                              // );

                              if (index == 0) {
                                EventUMStatistics.umengCommonMapEvent(
                                    "click_index_scene_1");
                              } else if (index == 1) {
                                EventUMStatistics.umengCommonMapEvent(
                                    "click_index_scene_2");
                              } else if (index == 2) {
                                EventUMStatistics.umengCommonMapEvent(
                                    "click_index_scene_3");
                              } else if (index == 3) {
                                EventUMStatistics.umengCommonMapEvent(
                                    "click_index_scene_4");
                              }
                            },
                            child: HomeMapItem(data: sceneList[index]));
                      }),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 16.h,
                    ),
                  ),
                  SliverList.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          EventBus().emit(NotificationUtils.taberTwo,
                              lessonList[index].param);
                          if (index == 0) {
                            EventUMStatistics.umengCommonMapEvent(
                                "click_index_coursesEx_button");
                          } else if (index == 1) {
                            EventUMStatistics.umengCommonMapEvent(
                                "click_index_coursesL1_button");
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          child: LoadImage(
                            lessonList[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    itemCount: lessonList.length,
                  ),
                  SliverList.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(
                            context,
                            ExamRouter.examPage,
                          );
                          EventUMStatistics.umengCommonMapEvent(
                              "click_index_examKET_button");
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 16.h,
                          ),
                          child: LoadImage(
                            examList[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    itemCount: examList.length,
                  ),
                ],
              ),
            ),
          ],
        )),
      )),
    );
  }

  @override
  HomeTwoPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _homeTwoPagePresenter = HomeTwoPagePresenter();
    return _homeTwoPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendCharacterListSuccess(CharacterListBean data) {
    // TODO: implement sendCharacterListSuccess
    characterList.clear();
    characterList.addAll(data.data);

    pageState = 'success';

    setState(() {});

    String characterId = characterList[0].characterId;
    // _homeProvider.character.characterId = characterId;
    _homeProvider.character.characterId = characterId;
    _homeProvider.character.imageUrl = characterList[0].imageUrl;
    // getCategoryList(characterId);
    if (phone != "17001234567") {
      _homeTwoPagePresenter.getBindTeacherStatus();
    }
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
    pageState = 'fail';
    setState(() {});
  }

  @override
  void sendBannerListSuccess(BannerListBean data) {
    // TODO: implement sendBannerListSuccess
    lessonList.clear();
    examList.clear();
    sceneList.clear();

    lessonList.addAll(data.data.lessonList);
    examList.addAll(data.data.exam);
    sceneList.addAll(data.data.sceneList);
    pageState = 'success';

    SpUtil.putObjectList(Constant.lessonList, data.data.lessonList);
    SpUtil.putObjectList(Constant.exam, data.data.exam);
    SpUtil.putObjectList(Constant.sceneList, data.data.sceneList);

    setState(() {});
    // _homeTwoPagePresenter.getCharacterList();
  }

  @override
  void sendBindTeacherStatusSuccess(int data) {
    // TODO: implement sendBindTeacherStatusSuccess
    if (data > 0) {
      //弹窗
      showImageDialog();
    }
  }

  @override
  void sendError() {
    // TODO: implement sendError
    onNoNetwork();
  }
}
