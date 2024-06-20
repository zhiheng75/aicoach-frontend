import 'dart:convert';
import 'dart:math';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/presenter/home_two_page_presenter.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/view/home_two_page_view.dart';
import 'package:Bubble/home/widget/home_item.dart';
import 'package:Bubble/home/widget/teacher_show_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/other_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/group_avatar_widget.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:common_utils/common_utils.dart';
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
import 'package:jverify/jverify.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
import 'package:sp_util/sp_util.dart';
import '../widgets/load_fail.dart';

import '../person/entity/basec_onfig_bean.dart';

class HomeTwoPage extends StatefulWidget {
  const HomeTwoPage({super.key});

  @override
  State<HomeTwoPage> createState() => _HomeTwoPageState();
}

class _HomeTwoPageState extends State<HomeTwoPage>
    with
        BasePageMixin<HomeTwoPage, HomeTwoPagePresenter>,
        AutomaticKeepAliveClientMixin<HomeTwoPage>
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

  // int isChatShow = 0;
  // int isKetShow = 0;
  int isDefault = 0;
  final ScreenUtil _screenUtil = ScreenUtil();
  // bool isLoding = true;
  Fluwx fluwx = Fluwx();
  late String pageState = 'loading';

  late String bubbleAndriodVersionStr = "";
  late String bubbleAndriodVersionApprovalStr = "";

  late String url = "";
  late String os = "";
  late String omuids = "";

  // Widget barWidget(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     height: 150,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(10.0),
  //       child: Swiper(
  //         itemBuilder: (BuildContext context, int index) {
  // return LoadImage(
  //   banner[index].imageUrl,
  //   fit: BoxFit.cover,
  // );
  //         },
  //         onTap: (index) {
  // if (banner[index].type == 1) {
  //   NavigatorUtils.goWebViewPage(
  //       context, banner[index].title, banner[index].linkUrl);
  // } else if (banner[index].type == 2) {
  //   if (banner[index].linkUrl == "1") {
  //     //单系统课购买页
  //     NavigatorUtils.push(
  //       context,
  //       "${HomeRouter.coursePurchasePage}?levelId=${banner[index].param}",
  //     );
  //   } else if (banner[index].linkUrl == "2") {
  //     //个人中心进入的购买页（引流课购买和课程购买可切换的页面）
  //   } else if (banner[index].linkUrl == "3") {
  //     //试听课页面
  //     NavigatorUtils.push(
  //         context,
  //         // CourseRouter.courseFlowPage,
  //         "${CourseRouter.courseFlowPage}?lessonId=${banner[index].param}");
  //   }
  // }
  //         },
  //         itemCount: banner.length,
  //         autoplay: true,
  //         pagination: const SwiperPagination(),
  //         // viewportFraction: 0.8,
  //         // layout: SwiperLayout.STACK,
  //         // control: SwiperControl(),
  //       ),
  //     ),
  //   );
  // }

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
                      miniProgramType: WXMiniProgramType.preview));
              EventUMStatistics.umengCommonMapEvent("添加辅导老师页面曝光次数");
            },
          );
        });
  }

  Widget barWidget(BuildContext context) {
    return SizedBox(
      // color: Colors.amber,
      height: 215.0.h,
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
                SpUtil.putString(
                    Constant.avatarId, characterList[i].characterId);

                EventBus().emit(
                    NotificationUtils.taberThree, characterList[i].characterId);
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

  // Widget barWidget(BuildContext context) {
  //   return Container(
  //     // color: Colors.amber,
  //     height: 235.0.h,
  //     child: Swiper(
  //         autoplay: true,
  //         pagination: SwiperPagination(
  //             builder: DotSwiperPaginationBuilder(
  //                 color: Colours.color_D9D9D9,
  //                 activeColor: Colours.color_7C7C7C,
  //                 size: 3.h,
  //                 activeSize: 3.h)),
  //         outer: true,
  //         // autoplay: true,
  //         // fade: 0.8,
  //         // viewportFraction: 0.85,
  //         // scale: 0.92,
  //         itemBuilder: (c, i) {
  //           return GestureDetector(
  //             onTap: () {
  //               SpUtil.putString(
  //                   Constant.avatarId, characterList[i].characterId);

  //               EventBus().emit(
  //                   NotificationUtils.taberThree, characterList[i].characterId);
  //             },
  //             child: LoadImage(
  //               characterList[i].coverBgImage,
  //               fit: BoxFit.fitWidth,
  //             ),
  //           );
  //         },
  //         // pagination: const SwiperPagination(alignment: Alignment.topCenter),
  //         itemCount: characterList.length),
  //   );
  // }

  // Widget headWidget(String tit) {
  //   return Padding(
  //     padding: const EdgeInsets.only(
  //       left: 15,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Gaps.hGap6,
  //         Text(
  //           tit,
  //           style: const TextStyle(
  //             fontSize: 18.0,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.black,
  //           ),
  //         ),
  //         Gaps.hGap6,
  //         const LoadAssetImage(
  //           "class_vip_icon",
  //           width: 30.0,
  //           height: 30.0,
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget recommendedWidget() {
  //   return Row(
  //     children: [
  //       Container(
  //         color: Colors.amber,
  //         width: _screenUtil.screenWidth / 2,
  //         height: 200,
  //         child: Column(
  //           children: [
  //             Text(
  //               "AI口语系统课",
  //               style: const TextStyle(
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               "适合1-6年级",
  //               style: const TextStyle(
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               "领取一节体验课",
  //               style: const TextStyle(
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               "我要学",
  //               style: const TextStyle(
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Column(
  //         children: [
  //           Container(
  //             color: Colors.blue,
  //             width: _screenUtil.screenWidth / 2,
  //             height: 100,
  //             child: Column(
  //               children: [
  //                 Text(
  //                   "AI口语系统课",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "适合1-6年级",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "领取一节体验课",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "我要学",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             color: Colors.deepPurple,
  //             width: _screenUtil.screenWidth / 2,
  //             height: 100,
  //             child: Column(
  //               children: [
  //                 Text(
  //                   "AI口语系统课",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "适合1-6年级",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "领取一节体验课",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 Text(
  //                   "我要学",
  //                   style: const TextStyle(
  //                     fontSize: 18.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget courseWidget(BBanner lesson) {
  //   return GestureDetector(
  // onTap: () {
  //   //
  //   NavigatorUtils.push(
  //     context,
  //     "${HomeRouter.coursePurchasePage}?levelId=${lesson.param}",
  //   );
  // },
  //     child: Container(
  //       margin: const EdgeInsets.all(15),
  //       padding: const EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8.0),
  //         color: Colours.color_F8F8F8,
  //       ),
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10.0),
  //             child: Image.network(
  //               lesson.imageUrl,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget peopleWidget(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Container(
  //           margin:
  //               const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
  //           padding: const EdgeInsets.all(15),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(15),
  //               gradient: const LinearGradient(
  //                 colors: [
  //                   Colours.color_E8CCFE,
  //                   Colours.color_ACCDFF,
  //                 ],
  //               )),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                       child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         characterList[isDefault].slogan,
  //                         style: const TextStyle(
  //                           fontSize: 16.0,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colours.color_2C0047,
  //                         ),
  //                       ),
  //                       Gaps.vGap5,
  //                       GestureDetector(
  //                         onTap: () {
  //                           // NavigatorUtils.push(
  //                           //   context,
  //                           //   "${HomeRouter.homePage}?index=$isDefault",
  //                           // );
  //                         },
  //                         child: Container(
  //                             padding: const EdgeInsets.only(
  //                                 top: 5, bottom: 5, left: 15, right: 15),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20.0),
  //                               color: Colours.color_6D388F,
  //                             ),
  //                             child: const Text(
  //                               "自由对话",
  //                               style: TextStyle(
  //                                 fontSize: 15.0,
  //                                 fontWeight: FontWeight.w400,
  //                                 color: Colors.white,
  //                               ),
  //                             )),
  //                       ),
  //                     ],
  //                   )),
  //                   const SizedBox(
  //                     height: 100,
  //                     width: 150,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           )),
  //       const Positioned(
  //           right: 5,
  //           bottom: 10,
  // child: LoadAssetImage(
  //   "suofeiya_head",
  //   width: 170.0,
  //   height: 150.0,
  // ))
  //     ],
  //   );
  // }

  // Widget mokaoWidget(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  // NavigatorUtils.push(
  //   context,
  //   ExamRouter.examPage,
  // );
  //     },
  //     child: Container(
  //         margin: const EdgeInsets.all(8),
  //         // height: 80,
  //         // width: 280,
  //         padding: const EdgeInsets.all(15),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(15),
  //             gradient: const LinearGradient(
  //               colors: [
  //                 Colours.color_FFF3D8,
  //                 Colours.color_E8CCFE,
  //               ],
  //             )),
  //         height: 120,
  //         child: Row(
  //           // mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 60,
  //               height: 60,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 color: Colors.white,
  //               ),
  //               padding: const EdgeInsets.all(15),
  //               child: const LoadAssetImage(
  //                 "mokao_icon",
  //                 width: 24.0,
  //                 height: 24.0,
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text(
  //                     "KET模考",
  //                     style: TextStyle(
  //                       fontSize: 20.0,
  //                       fontWeight: FontWeight.w400,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   RichText(
  //                     text: const TextSpan(children: [
  //                       TextSpan(
  //                           text: "实景",
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w400,
  //                             color: Colours.color_FF71CF,
  //                           )),
  //                       TextSpan(
  //                           text: '还原考试',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w400,
  //                             color: Colours.color_666666,
  //                           )),
  //                       TextSpan(
  //                           text: '全流程',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w400,
  //                             color: Colours.color_FF71CF,
  //                           )),
  //                     ]),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //                 padding: const EdgeInsets.only(
  //                     top: 5, bottom: 5, left: 15, right: 15),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20.0),
  //                   color: Colours.color_6D388F,
  //                 ),
  //                 child: const Text(
  //                   "去看看",
  //                   style: TextStyle(
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.white,
  //                   ),
  //                 )),
  //           ],
  //         )),
  //   );
  // }

  // Widget tabbar() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.only(
  //           left: 15,
  //         ),
  //         child: Text(
  //           "场景模拟练习",
  //           style: TextStyle(
  //             fontSize: 18.0,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.black,
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 40,
  //         child: ListView.builder(
  //           itemBuilder: (ctx, index) {
  //             return _categoryList[index].name.isNotEmpty
  //                 ? GestureDetector(
  //                     onTap: () {
  //                       changeCategory(index);
  //                     },
  //                     child: Container(
  //                         margin: const EdgeInsets.only(
  //                             top: 5, bottom: 5, left: 20, right: 20),
  //                         height: 40,
  //                         child: Text(
  //                           _categoryList[index].name,
  //                           style: TextStyle(
  //                             fontSize: 15.0,
  //                             fontWeight: FontWeight.w400,
  //                             color: currentIndex == index
  //                                 ? Colors.red
  //                                 : Colors.black,
  //                           ),
  //                         )),
  //                   )
  //                 : Container();
  //           },
  //           itemCount: _categoryList.length,
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           physics: const AlwaysScrollableScrollPhysics(),
  //           scrollDirection: Axis.horizontal,
  //         ),
  //       )
  //     ],
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initDio();
    initUM();
    // getBaseConfig();
    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");
    String teacherId = SpUtil.getString(Constant.teacherId)!.nullSafe;
    if (teacherId.isEmpty) {
      SpUtil.putString(Constant.teacherId, "0");
    }

    // 初始化手机号一键登录插件
    initPlatformState();
    // 获取体验时间
    // _homeProvider.getUsageTime();

    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    EventBus().on(NotificationUtils.loginIn, (_) {
      _homeTwoPagePresenter.getBannerList();
    });
    EventBus().on(NotificationUtils.loginOut, (_) {
      _homeTwoPagePresenter.getBannerList();
    });

    // getAD();
    userInfo();
  }

  late String phone = "";

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

  void getAD() async {
    final dio = Dio();

    if (Device.isAndroid) {
      String deviceId;
      int sdk = await getAndroidSdkInt();
      if (sdk >= 10) {
        deviceId = await DeviceIdentity.oaid;
      } else {
        deviceId = await DeviceIdentity.imei;
      }
      os = "android";
      omuids = deviceId;
    } else {
      os = "ios";
      omuids = "";
    }
    //https://ad.oceanengine.com/track/activate/?callback=xxxxx&os=1&muid=xxxxxxx

    // var response = await dio.get('https://www.dmoe.cc/random.php?return=json');
    // //转化为Json
    // String jsonString = jsonEncode(response.data);
    // print(jsonString);
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// 使用前记得初始化
  Future<int> getAndroidSdkInt() async {
    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    if (Constant.isDriverTest) {
      return -1;
    }
    return androidDeviceInfo.version.sdkInt;
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
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    final info = await PackageInfo.fromPlatform();

//手机品牌加型号
    DioUtils.instance.dio.options.headers['version'] = info.version;
    DioUtils.instance.dio.options.headers['buildNumber'] = info.buildNumber;
    String platformStr = Channel.channelios;
    String sysInfo = "";

    if (Device.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;

      platformStr = Channel.channelhuawei;
      final Map<String, String> params = <String, String>{};
      params["manufacturer"] = androidDeviceInfo.manufacturer;
      params["id"] = androidDeviceInfo.id;
      params["brand"] = androidDeviceInfo.brand;
      params["board"] = androidDeviceInfo.board;
      params["model"] = androidDeviceInfo.model;
      params["version"] = androidDeviceInfo.version.release;
      params["device"] = androidDeviceInfo.device;
      params["display"] = androidDeviceInfo.display;

      sysInfo = params.toString(); //allInfo.toString();
    } else {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;

      platformStr = Channel.channelios;
      final Map<String, String> params = <String, String>{};
      params["version"] = iosDeviceInfo.systemVersion;
      params["model"] = iosDeviceInfo.model;
      params["localizedModel"] = iosDeviceInfo.localizedModel;
      params["isPhysicalDevice"] = iosDeviceInfo.isPhysicalDevice ? "1" : "0";
      params["systemName"] = iosDeviceInfo.systemName;
      params["machine"] = iosDeviceInfo.utsname.machine;

      sysInfo = params.toString();
    }
    DioUtils.instance.dio.options.headers['sysInfo'] = sysInfo;
    DioUtils.instance.dio.options.headers['marketplace'] = platformStr;
    // DioUtils.instance.dio.options.headers['applyName'] = info.appName;
  }

  void initUM() {
    EventUMStatistics.umengCommonInit();
  }

  Future<void> initPlatformState() async {
    // 初始化 SDK 之前添加监听
    Constant.jverify.addSDKSetupCallBackListener((JVSDKSetupEvent event) {
      LogUtil.d("receive sdk setup call back event :${event.toMap()}");
    });

    Constant.jverify.setDebugMode(true); // 打开调试模式
    Constant.jverify.setup(
        appKey: "d213d60b209d0807dc4146f4", //"你自己应用的 AppKey",
        channel: "devloper-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效
    if (!mounted) return;

    /// 授权页面点击时间监听
    Constant.jverify.addAuthPageEventListener((JVAuthPageEvent event) {
      LogUtil.d("receive auth page event :${event.toMap()}");
    });
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.loginIn);
    EventBus().off(NotificationUtils.loginOut);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
      return Container(
        color: const Color(0xFFEBEDF0),
        alignment: Alignment.center,
        child: lodingView(),
      );
    }

    if (pageState == 'fail') {
      return Container(
        color: const Color(0xFFEBEDF0),
        alignment: Alignment.center,
        child: LoadFail(
          reload: init,
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      // removeBottom: true,
      child: Scaffold(
          body: SafeArea(
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
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.transparent,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (_) => SelectScene(
                                cagegoryId: sceneList[index].cagegoryId,
                              ),
                            );
                            EventUMStatistics.umengCommonMapEvent(
                                "点击场景模拟练习的次数");
                          },
                          child: HomeMapItem(data: sceneList[index]));
                    }),
                SliverToBoxAdapter(
                  child: Container(
                    height: 16.h,
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: Container(
                //     margin: const EdgeInsets.all(10),
                //     height: 240,
                //     child: GridView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: sceneList.length,
                //         gridDelegate:
                //             const SliverGridDelegateWithFixedCrossAxisCount(
                //           //设置列数
                //           crossAxisCount: 2,
                //           //设置横向间距
                //           crossAxisSpacing: 10,
                //           //设置主轴间距
                //           mainAxisSpacing: 0,
                //           mainAxisExtent: 120,
                //         ),
                //         itemBuilder: (BuildContext ctx, int index) {
                //           return GestureDetector(
                //               onTap: () {
                //                 showModalBottomSheet(
                //                   context: context,
                //                   backgroundColor: Colors.transparent,
                //                   barrierColor: Colors.transparent,
                //                   isScrollControlled: true,
                //                   isDismissible: false,
                //                   enableDrag: false,
                //                   builder: (_) => SelectScene(
                //                     cagegoryId: sceneList[index].cagegoryId,
                //                   ),
                //                 );
                //                 EventUMStatistics.umengCommonMapEvent(
                //                     "点击场景模拟练习的次数");
                //               },
                //               child: HomeMapItem(data: sceneList[index]));
                //         }),
                //   ),
                // ),
                SliverList.builder(
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        EventBus().emit(NotificationUtils.taberTwo,
                            lessonList[index].param);
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
                        // if (examList[index].type == 1) {
                        //   NavigatorUtils.goWebViewPage(
                        //       context,
                        //       examList[index].title,
                        //       examList[index].linkUrl);
                        // } else if (examList[index].type == 2) {
                        //   if (examList[index].linkUrl == "1") {
                        //     //单系统课购买页
                        //     NavigatorUtils.push(
                        //       context,
                        //       "${HomeRouter.coursePurchasePage}?levelId=${examList[index].param}",
                        //     );
                        //   } else if (examList[index].linkUrl == "2") {
                        //     //个人中心进入的购买页（引流课购买和课程购买可切换的页面）
                        //   } else if (examList[index].linkUrl == "3") {
                        //     //试听课页面
                        //     NavigatorUtils.push(
                        //         context,
                        //         // CourseRouter.courseFlowPage,
                        //         "${CourseRouter.courseFlowPage}?lessonId=${examList[index].param}");
                        //   } else if (examList[index].linkUrl == "4") {
                        //     //模考
                        //     NavigatorUtils.push(
                        //       context,
                        //       ExamRouter.examPage,
                        //     );
                        //   } else if (examList[index].linkUrl == "5") {
                        //     //上课页面
                        //     // NavigatorUtils.push(
                        //     //   context,
                        //     //   ExamRouter.examPage,
                        //     // );
                        //   }
                        // }
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
      ))),
    );
    // return AnnotatedRegion(
    //   value: SystemUiOverlayStyle.light,
    //   child: Scaffold(
    //     body: SafeArea(
    //         child: extended.ExtendedNestedScrollView(
    //       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //         // return buildSliverHeader();
    //         return [
    // const SliverToBoxAdapter(
    //   child: Text("   口语嘟嘟 AI",
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //       )),
    // ),
    // SliverToBoxAdapter(
    //   child: banner.isNotEmpty ? barWidget(context) : Container(),
    // ),
    //           SliverToBoxAdapter(
    //             child: isChatShow == 0
    //                 ? Container()
    //                 : characterList.isNotEmpty
    //                     ? peopleWidget(context)
    //                     : Container(),
    //           ),
    // SliverList.builder(
    //   itemBuilder: (ctx, index) {
    //     return GestureDetector(
    //       onTap: () {},
    //       child: courseWidget(lesson[index]),
    //     );
    //   },
    //   itemCount: lesson.length,
    // ),
    //           SliverToBoxAdapter(
    //             child: isKetShow == 1 ? mokaoWidget(context) : Container(),
    //           ),
    //           _categoryList.isNotEmpty
    //               ? SliverPersistentHeader(
    //                   pinned: true,
    //                   floating: false,
    //                   delegate: _SliverAppBarDelegate(
    //                     minHeight: 70, //收起的高度
    //                     maxHeight: 70,
    //                     child: Container(color: Colors.white, child: tabbar()),
    //                   ))
    //               : SliverToBoxAdapter(
    //                   child: Container(),
    //                 ),
    //         ];
    //       },
    //       body: GridView.builder(
    //         itemBuilder: (ctx, index) {
    //           return GestureDetector(
    //               onTap: () {
    //                 selectScene(sceneList[index]);
    //               },
    //               child: Stack(
    //                 children: [
    //                   Container(
    //                     // color: Colors.black,
    //                     margin: const EdgeInsets.only(left: 8, right: 8),
    //                     child: ClipRRect(
    //                         borderRadius: BorderRadius.circular(20.0),
    //                         // margin: const EdgeInsets.only(
    //                         //     top: 0, left: 8, right: 8, bottom: 0),
    //                         // decoration: BoxDecoration(
    //                         //   borderRadius: BorderRadius.circular(8.0),
    //                         // image: const DecorationImage(
    //                         //   image: AssetImage(
    //                         //     'assets/images/mkbg.png',
    //                         //   ),
    //                         //   fit: BoxFit.cover,
    //                         // ),
    //                         // ),
    //                         child: LoadImage(
    //                           sceneList[index].cover,
    //                           fit: BoxFit.cover,
    //                           width: _screenUtil.screenWidth / 2,
    //                           // height: 56.0,
    //                         )),
    //                   ),
    //                   Center(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         Text(
    //                           sceneList[index].name,
    // style: const TextStyle(
    //   fontSize: 15.0,
    //   fontWeight: FontWeight.w400,
    //   color: Colors.white,
    // ),
    //                         ),
    //                         Gaps.vGap10
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ));
    //         },
    //         itemCount: sceneList.length,
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2,
    //             mainAxisSpacing: 20,
    //             crossAxisSpacing: 0,
    //             childAspectRatio: 1.5),
    //       ),
    //     )),
    //   ),
    // );
  }

  void selectScene(SceneEntity scene) {
    LoginManager.checkLogin(context, () {
      _homeProvider.sceneStreamController
          .add({'type': 'scene', 'data': scene.toJson()});

      _homeProvider.resetChatParams();

      _homeProvider.scene = scene;
    });
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

    // for (int i = 0; i < characterList.length; i++) {
    //   headData.add(characterList[i].avatarImage);
    //   if (characterList[i].isDefault == 1) {
    //     isDefault = i;
    //   }
    // }
    // pageState = 'success';
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

  // void getCategoryList(String characterId) async {
  //   DioUtils.instance.requestNetwork<ResultData>(
  //       Method.get, HttpApi.appSceneList, onSuccess: (result) {
  //     if (result == null || result.data == null) {
  //       setState(() {});
  //       return;
  //     }
  //     List<dynamic> data = result.data as List<dynamic>;
  //     List<CategoryEntity> list =
  //         data.map((item) => CategoryEntity.fromJson(item)).toList();
  //     _categoryList = list;
  //     setState(() {});

  //     if (_categoryList.isNotEmpty) {
  //       changeCategory(0);
  //     }
  //   }, onError: (code, msg) {
  //     setState(() {});
  //   });
  // }

  // void changeCategory(int index) {
  //   currentIndex = index;
  //   getSceneListByCategory(index);
  //   setState(() {});
  // }

  // void getSceneListByCategory(int index) {
  //   CategoryEntity category = _categoryList.elementAt(currentIndex);
  //   sceneList = category.sceneList;
  //   setState(() {});
  //   //注释了后期看为什么
  //   // Future.delayed(const Duration(milliseconds: 300), () {
  //   //   _scrollController.jumpTo(0);
  //   // });
  // }

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

    setState(() {});
    _homeTwoPagePresenter.getCharacterList();
  }

  @override
  void sendBindTeacherStatusSuccess(int data) {
    // TODO: implement sendBindTeacherStatusSuccess
    if (data > 0) {
      //弹窗
      showImageDialog();
    }
  }
}

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   @override
//   double get minExtent => minHeight;

//   @override
//   double get maxExtent => max(maxHeight, minHeight);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
