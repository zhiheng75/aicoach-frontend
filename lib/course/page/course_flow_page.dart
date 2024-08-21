//课程流程
import 'dart:convert';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/item/course_flow_item.dart';
import 'package:Bubble/course/page/switching_teacher_page.dart';
import 'package:Bubble/course/presenter/course_flow_page_presenter.dart';
import 'package:Bubble/course/view/class_show_view.dart';
import 'package:Bubble/course/view/course_flow_page_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/scene/entity/course_entity.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/other_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../main.dart';

class CourseFlowPage extends StatefulWidget {
  final String lessonId;
  const CourseFlowPage({
    super.key,
    required this.lessonId,
  });

  @override
  State<CourseFlowPage> createState() => _CourseFlowPageState();
}

class _CourseFlowPageState extends State<CourseFlowPage>
    with
        BasePageMixin<CourseFlowPage, CourseFlowPagePresenter>,
        RouteAware,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<CourseFlowPage>
    implements CourseFlowPageView {
  late HomeProvider _homeProvider;
  List<CategoryEntity> _categoryList = [];
  List<SceneEntity> sceneList = [];
  late CourseFlowPagePresenter _courseDetailsPagePresenter;
  late StepDetailBean stepDetailData;
  bool isLoding = true;

  late String characterIdStr;
  late String characterImgCoverStr;
  late String characterCoverStr;
  late String characterCoverStillImageStr;
  late String characterCovermotionImageStr;

  late int characterSceneIdStr;
  late String characterSceneDescStr;
  late String characterSceneNameStr;
  late String characterSceneenNameStr;

  late CharacterListBean _teacherListBean;

  late int mistakeCountInt = 0;

  late String titleStr = "";
  final MediaUtils _mediaUtils = MediaUtils();

  late String teacherId = "0";

  late List<CourseDatum> dataList;
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    EventUMStatistics.umengCommonOnPageStart("course_flow_page");

    teacherId = SpUtil.getString(Constant.teacherId) ?? "0";

    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
    _courseDetailsPagePresenter.getStepDetail(widget.lessonId);

    EventBus().on(NotificationUtils.teachIdx, (idx) {
      teacherId = idx.toString();
      SpUtil.putString(Constant.teacherId, idx.toString());
      // idx
      setState(() {
        characterIdStr =
            _teacherListBean.data[int.parse(teacherId)].characterId;
        characterImgCoverStr =
            _teacherListBean.data[int.parse(teacherId)].imageUrl;
        characterCoverStr =
            _teacherListBean.data[int.parse(teacherId)].avatarImage;
        characterCoverStillImageStr =
            _teacherListBean.data[int.parse(teacherId)].stillImage;
        characterCovermotionImageStr =
            _teacherListBean.data[int.parse(teacherId)].motionImage;
        characterSceneDescStr =
            _teacherListBean.data[int.parse(teacherId)].slogan;
        characterSceneNameStr =
            _teacherListBean.data[int.parse(teacherId)].name;
        characterSceneenNameStr =
            _teacherListBean.data[int.parse(teacherId)].authorName;
      });
    });

    EventBus().on(NotificationUtils.nextResetChat, (_) {
      _courseDetailsPagePresenter.getStepDetail(widget.lessonId);
    });
    intPermission();

    // isIPad = MediaQuery.of(context).size.width > 500 ? true : false;
  }

  bool get isIPad {
    return MediaQuery.of(context).size.width > 500 ? true : false;
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    _courseDetailsPagePresenter.getStepDetail(widget.lessonId);
  }

  void intPermission() async {
    bool hasAgree =
        SpUtil.getBool(Constant.mediaUtils, defValue: false) ?? false;
    if (!hasAgree) {
      Toast.show("录音音频使用说明:用于对话场景", duration: 6000);
      SpUtil.putBool(Constant.mediaUtils, true);
    }

    // 检查权限
    bool isRequest = await _mediaUtils.checkMicrophonePermission();
    if (isRequest) {
      Toast.show("录音音频使用说明:用于对话场景", duration: 5000);
      return;
    }
  }

  @override
  void dispose() {
    EventUMStatistics.umengCommonOnPageEnd("course_flow_page");

    EventBus().off(NotificationUtils.teachIdx);
    EventBus().off(NotificationUtils.nextResetChat);
    routeObserver.unsubscribe(this); //取消订阅
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void init() {
    getDefaultCharacter();
    setState(() {});
  }

  void getDefaultCharacter() {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.get, HttpApi.teacherTwoList, onSuccess: (result) {
      Map<String, dynamic> characterListMap = json.decode(result.toString());
      CharacterListBean teacherListBean =
          CharacterListBean.fromJson(characterListMap);
      if (teacherListBean.code == 200) {
        if (teacherListBean.data.isNotEmpty) {
          characterIdStr =
              teacherListBean.data[int.parse(teacherId)].characterId;
          characterImgCoverStr =
              teacherListBean.data[int.parse(teacherId)].imageUrl;
          characterCoverStr =
              teacherListBean.data[int.parse(teacherId)].avatarImage;
          characterCoverStillImageStr =
              teacherListBean.data[int.parse(teacherId)].stillImage;
          characterCovermotionImageStr =
              teacherListBean.data[int.parse(teacherId)].motionImage;
          characterSceneDescStr =
              teacherListBean.data[int.parse(teacherId)].slogan;
          characterSceneNameStr =
              teacherListBean.data[int.parse(teacherId)].name;
          characterSceneenNameStr =
              teacherListBean.data[int.parse(teacherId)].authorName;

          _teacherListBean = teacherListBean;
        }
      } else {}
      setState(() {});
    }, onError: (code, msg) {
      setState(() {});
    });
  }

  void getCategoryList(String characterId) async {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.get, HttpApi.topicOrScene,
        queryParameters: {
          'character_id': characterId,
          'type': 2,
        }, onSuccess: (result) {
      if (result == null || result.data == null) {
        setState(() {});
        return;
      }
      List<dynamic> data = result.data as List<dynamic>;
      List<CategoryEntity> list =
          data.map((item) => CategoryEntity.fromJson(item)).toList();
      _categoryList = list;
      setState(() {});

      if (_categoryList.isNotEmpty) {
        changeCategory(0);
      }
    }, onError: (code, msg) {
      setState(() {});
    });
  }

  void changeCategory(int index) {
    getSceneListByCategory(index);
  }

  void getSceneListByCategory(int index) {
    setState(() {});
    CategoryEntity category = _categoryList.elementAt(index);
    sceneList = category.sceneList;

    setState(() {});
  }

  void gotoCourse(int idx) {
    // _homeProvider.resetChatParams();
    List<CourseDatum> data = stepDetailData.data.data;
    CourseDatum dataIdx = stepDetailData.data.data[idx];
    characterSceneIdStr = dataIdx.resource[0].sceneId!;
    EventUMStatistics.umengCommonMapEvent("click_index_go_to_class");

    SceneEntity scene = SceneEntity();
    scene.id = characterSceneIdStr;
    scene.desc = "";
    scene.name = "";
    scene.enName = "";
    scene.cover = characterImgCoverStr;
    _homeProvider.character.characterId = characterIdStr;
    _homeProvider.character.motionImage = characterCovermotionImageStr;
    _homeProvider.character.stillImage = characterCoverStillImageStr;
    _homeProvider.heardcover = characterCoverStr;
    _homeProvider.ishread = characterCoverStr;

    _homeProvider.resetChatParams();
    _homeProvider.scene = scene;
    //
    if (dataIdx.resource[0].resourceType == 2) {
      NavigatorUtils.push(context,
          "${HomeRouter.webviewNotNavPage}?url=${Uri.encodeComponent(dataIdx.resource[0].gameUrl ?? "")}&index=$idx&type=1",
          arguments: stepDetailData);
    } else {
      String isIPad;
      if (MediaQuery.of(context).size.width > 500) {
        isIPad = "1";
      } else {
        isIPad = "0";
      }
      NavigatorUtils.push(context,
          "${HomeRouter.instructionalVideoDialoguePage}?index=$idx&isIPad=$isIPad",
          arguments: stepDetailData);
    }
  }

  Widget body() {
    return MyScrollView(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gaps.vGap4,
        Text(
          stepDetailData.data.lessonName,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        // Gaps.vGap10,
        GestureDetector(
          onTap: () {
            EventUMStatistics.umengCommonMapEvent(
                "click_index_foreign_teacher_switching");

            NavigatorUtils.push(context, CourseRouter.courseDetailsPage,
                arguments: stepDetailData);
          },
          child: Container(
            // height: 40,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 18),
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_B2E3FF,
                    Colours.color_FFA7EC,
                  ],
                )),
            padding:
                const EdgeInsets.only(left: 30, right: 20, top: 15, bottom: 15),
            child: const Row(
              children: [
                Text("本课学习目标   ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                Expanded(
                  child: Text("Learning target",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colours.color_666666,
                      )),
                ),
                LoadAssetImage(
                  "goal_Icon",
                  width: 6.0,
                  height: 12.0,
                )
              ],
            ),
          ),
        ),
        // Gaps.vGap8,
        SizedBox(
          height: 100.0 * stepDetailData.data.data.length,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  LoginManager.checkLogin(context, () {
                    if (stepDetailData.data.data[index].isLocked == 0) {
                      gotoCourse(index);
                    } else {
                      Toast.show(
                        '请按顺序完成',
                      );
                    }
                  });
                },
                child: CourseFlowItem(data: stepDetailData.data.data[index]),
              );
            },
            itemCount: stepDetailData.data.data.length,
          ),
        ),
        Gaps.vGap10,
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  EventUMStatistics.umengCommonMapEvent(
                      "click_index_go_to_study_report");

                  LoginManager.checkLogin(context, () {
                    if (stepDetailData.data.reportStatus == 0) {
                      Toast.show("课程完成后才可查看学习报告");
                    } else {
                      NavigatorUtils.push(context,
                          "${CourseRouter.courseReportPage}?lessonId=${widget.lessonId}");
                    }
                  });
                },
                child: Container(
                  height: isIPad ? 55.w : 100.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colours.color_ECCDFF,
                          Colours.color_F3E4FF,
                        ],
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadAssetImage(
                        "baogao_flow",
                        height: isIPad ? 18.w : 28.w,
                        // height: 12.0,
                      ),
                      Gaps.vGap4,
                      Text(
                        "学习报告",
                        style: TextStyle(
                          fontSize: isIPad ? 9.sp : 14.0.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      EventUMStatistics.umengCommonMapEvent(
                          "click_index_go_to_error_correction");

                      LoginManager.checkLogin(context, () {
                        if (stepDetailData.data.mistakeStatus == 0) {
                          Toast.show("课程完成后才可以纠错");
                        } else {
                          NavigatorUtils.push(context,
                              "${PersonalRouter.errorCorrectionDetailPage}?lessonId=${widget.lessonId}");
                        }
                      });
                    },
                    child: Container(
                      height: isIPad ? 55.w : 100.w,
                      width: 100.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colours.color_A8DFFF,
                              Colours.color_D4EFFF,
                            ],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadAssetImage(
                            "jiucuo_flow",
                            height: isIPad ? 18.w : 28.w,
                            // height: 12.0,
                          ),
                          Gaps.vGap4,
                          Text(
                            "纠错",
                            style: TextStyle(
                              fontSize: isIPad ? 8.sp : 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: mistakeCountInt > 0
                        ? Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                mistakeCountInt.toString(),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  LoginManager.checkLogin(context, () {
                    // selectScene(sceneList[index]);
                    EventUMStatistics.umengCommonMapEvent(
                        "click_index_go_to_curriculum_evaluation");

                    if (stepDetailData.data.evaluationStatus == 0) {
                      Toast.show("课程完成后才可评价");
                    } else {
                      NavigatorUtils.push(
                          context, CourseRouter.curriculumEvaluationPage,
                          arguments: stepDetailData);
                    }
                  });
                },
                child: Container(
                  height: isIPad ? 55.w : 100.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colours.color_CBF7B4,
                          Colours.color_E2FFD4,
                        ],
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadAssetImage(
                        "pingjia_flow",
                        height: isIPad ? 18.w : 28.w,
                        // height: 12.0,
                      ),
                      Gaps.vGap4,
                      Text(
                        "课程评价",
                        style: TextStyle(
                          fontSize: isIPad ? 9.sp : 14.0.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              // Stack(
              //   children: [
              //     GestureDetector(
              // onTap: () {
              //   EventUMStatistics.umengCommonMapEvent(
              //       "click_index_go_to_study_report");

              //   LoginManager.checkLogin(context, () {
              //     if (stepDetailData.data.reportStatus == 0) {
              //       Toast.show("课程完成后才可查看学习报告");
              //     } else {
              //       NavigatorUtils.push(context,
              //           "${CourseRouter.courseReportPage}?lessonId=${widget.lessonId}");
              //     }
              //   });
              // },
              //       child: Container(
              //         width: (_screenUtil.screenWidth - 60) / 3,
              //         height: (_screenUtil.screenWidth - 60) / 3,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(
              //               'assets/images/baogao_flow.png',
              //             ),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         // padding: const EdgeInsets.all(30),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              // Text(
              //   "学习报告",
              //   style: TextStyle(
              //     fontSize: 14.0.sp,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.black,
              //   ),
              // ),
              //             Container(
              //               height: 20.h,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Stack(
              //   children: [
              //     GestureDetector(
              // onTap: () {
              //   EventUMStatistics.umengCommonMapEvent(
              //       "click_index_go_to_error_correction");

              //   LoginManager.checkLogin(context, () {
              //     if (stepDetailData.data.mistakeStatus == 0) {
              //       Toast.show("课程完成后才可以纠错");
              //     } else {
              //       NavigatorUtils.push(context,
              //           "${PersonalRouter.errorCorrectionDetailPage}?lessonId=${widget.lessonId}");
              //     }
              //   });
              // },
              //       child: Container(
              //         width: (_screenUtil.screenWidth - 60) / 3,
              //         height: (_screenUtil.screenWidth - 60) / 3,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(
              //               'assets/images/jiucuo_flow.png',
              //             ),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             // LottieBuilder.asset(name)
              //             Text(
              //               "纠错",
              //               style: TextStyle(
              //                 fontSize: 14.0.sp,
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             Container(
              //               height: 20.h,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              // Positioned(
              //   right: 5,
              //   top: 1,
              //   child: mistakeCountInt > 0
              //       ? Container(
              //           width: 26,
              //           height: 26,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(100.0),
              //             color: Colors.red,
              //           ),
              //           child: Center(
              //             child: Text(
              //               mistakeCountInt.toString(),
              //               style: const TextStyle(
              //                 fontSize: 14.0,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         )
              //       : Container(),
              // ),
              //   ],
              // ),
              // Stack(
              //   children: [
              //     GestureDetector(
              // onTap: () {
              //   LoginManager.checkLogin(context, () {
              //     // selectScene(sceneList[index]);
              //     EventUMStatistics.umengCommonMapEvent(
              //         "click_index_go_to_curriculum_evaluation");

              //     if (stepDetailData.data.evaluationStatus == 0) {
              //       Toast.show("课程完成后才可评价");
              //     } else {
              //       NavigatorUtils.push(
              //           context, CourseRouter.curriculumEvaluationPage,
              //           arguments: stepDetailData);
              //     }
              //   });
              // },
              //       child: Container(
              //         width: (_screenUtil.screenWidth - 60) / 3,
              //         height: (_screenUtil.screenWidth - 60) / 3,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(
              //               'assets/images/pingjia_flow.png',
              //             ),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Text(
              //               "课程评价",
              //               style: TextStyle(
              //                 fontSize: 14.sp,
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             Container(
              //               height: 20.h,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: const NavigationBackWidget(),
        trailing: Container(
          margin: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NavigatorUtils.push(
                context,
                CourseRouter.switchingTeacherPage,
              );
            },
            child: const LoadAssetImage(
              "switching_teacher_icon",
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        middle: Text(
          titleStr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
      child: Scaffold(
          body: SafeArea(child: isLoding == true ? lodingView() : body())),
    );
  }

  @override
  CourseFlowPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _courseDetailsPagePresenter = CourseFlowPagePresenter();
    return _courseDetailsPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void sendSuccess(StepDetailBean stepDetailBean) {
    // TODO: implement sendSuccess
    isLoding = false;
    stepDetailData = stepDetailBean;
    // dataList.clear();
    // dataList.addAll(stepDetailBean.data.data);
    mistakeCountInt = stepDetailData.data.mistakeCount;
    titleStr = "Lesson ${stepDetailData.data.lessonLabel}";
    setState(() {});
  }
}
