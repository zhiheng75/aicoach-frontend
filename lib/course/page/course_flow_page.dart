//课程流程
import 'dart:convert';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/item/course_flow_item.dart';
import 'package:Bubble/course/page/switching_teacher_page.dart';
import 'package:Bubble/course/presenter/course_flow_page_presenter.dart';
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
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        AutomaticKeepAliveClientMixin<CourseFlowPage>
    implements CourseFlowPageView {
  late HomeProvider _homeProvider;
  List<CategoryEntity> _categoryList = [];
  List<SceneEntity> sceneList = [];
  late CourseFlowPagePresenter _courseDetailsPagePresenter;
  late StepDetailBean stepDetailData;
  bool isLoding = true;

  late String characterIdStr;
  late String characterCoverStr;

  late int characterSceneIdStr;
  late String characterSceneDescStr;
  late String characterSceneNameStr;
  late String characterSceneenNameStr;

  late CharacterListBean _teacherListBean;

  late int mistakeCountInt = 0;

  @override
  void initState() {
    super.initState();

    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
    _courseDetailsPagePresenter.getStepDetail(widget.lessonId);

    EventBus().on(NotificationUtils.teachIdx, (idx) {
      // idx
      setState(() {
        characterIdStr = _teacherListBean.data[idx].characterId;
        characterCoverStr = _teacherListBean.data[idx].imageUrl;
        characterSceneDescStr = _teacherListBean.data[idx].slogan;
        characterSceneNameStr = _teacherListBean.data[idx].name;
        characterSceneenNameStr = _teacherListBean.data[idx].authorName;
      });
    });

    EventBus().on(NotificationUtils.nextResetChat, (_) {
      _courseDetailsPagePresenter.getStepDetail(widget.lessonId);
    });
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.teachIdx);
    EventBus().off(NotificationUtils.nextResetChat);

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
          characterIdStr = teacherListBean.data[0].characterId;
          characterCoverStr = teacherListBean.data[0].imageUrl;
          characterSceneDescStr = teacherListBean.data[0].slogan;
          characterSceneNameStr = teacherListBean.data[0].name;
          characterSceneenNameStr = teacherListBean.data[0].authorName;

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

    SceneEntity scene = SceneEntity();
    scene.id = characterSceneIdStr;
    scene.desc = "";
    scene.name = "";
    scene.enName = "";
    scene.cover = characterCoverStr;
    _homeProvider.character.characterId = characterIdStr;
    _homeProvider.character.motionImageD = characterCoverStr;
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
      NavigatorUtils.push(
          context, "${HomeRouter.instructionalVideoDialoguePage}?index=$idx",
          arguments: stepDetailData);
    }
  }

  void selectScene(SceneEntity scene) {
    LoginManager.checkLogin(context, () {
      _homeProvider.sceneStreamController
          .add({'type': 'scene', 'data': scene.toJson()});

      _homeProvider.resetChatParams();

      _homeProvider.scene = scene;
      return;
    });
  }

  Widget body() {
    return MyScrollView(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Text(
          stepDetailData.data.title,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_666666,
          ),
        )),
        Gaps.vGap2,
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
            NavigatorUtils.push(context, CourseRouter.courseDetailsPage,
                arguments: stepDetailData);
          },
          child: Container(
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
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: const Row(
              children: [
                Text("本课学习目标   ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    )),
                Expanded(
                  child: Text("Learning targe",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_666666,
                      )),
                ),
                LoadAssetImage(
                  "goal_Icon",
                  width: 15.0,
                  height: 15.0,
                )
              ],
            ),
          ),
        ),
        // Gaps.vGap8,
        SizedBox(
          height: 400,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  LoginManager.checkLogin(context, () {
                    gotoCourse(index);
                  });
                },
                child: CourseFlowItem(data: stepDetailData.data.data[index]),
              );
            },
            itemCount: stepDetailData.data.data.length,
          ),
        ),
        Gaps.vGap10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
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
                    width: 110,
                    height: 110,

                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/baogao_flow.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                        ),
                        const Text(
                          "学习报告",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
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
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/jiucuo_flow.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                        ),
                        const Text(
                          "纠错",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: mistakeCountInt > 0
                      ? Container(
                          width: 20,
                          height: 20,
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
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    LoginManager.checkLogin(context, () {
                      // selectScene(sceneList[index]);

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
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pingjia_flow.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                        ),
                        const Text(
                          "课程评价",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          margin: const EdgeInsets.only(right: 10),
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
              width: 30.0,
              height: 30.0,
            ),
          ),
        ),
        middle: const Text(
          "课程流程",
          style: TextStyle(fontWeight: FontWeight.bold),
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
    setState(() {
      isLoding = false;
      stepDetailData = stepDetailBean;
      mistakeCountInt = stepDetailData.data.mistakeCount;
    });
  }
}
