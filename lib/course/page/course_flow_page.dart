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
  late String coverStr;
  late String characterCoverStr;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
    _courseDetailsPagePresenter.getStepDetail(widget.lessonId);
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void init() {
    // String characterId = _homeProvider.character.characterId;
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
          coverStr = teacherListBean.data[0].imageUrl;
          characterCoverStr = teacherListBean.data[0].imageUrl;
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
    List<CourseDatum> data = stepDetailData.data.data;
    CourseDatum dataIdx = stepDetailData.data.data[idx];

    // xxx.id = scene.id;
    // xxx.name = scene.name;
    // xxx.enName = scene.enName;
    // xxx.desc = scene.desc;
    // xxx.cover = scene.cover;
//  characterIdStr = characterId;
//                       coverStr = cover;
    SceneEntity scene = SceneEntity();
    scene.id = dataIdx.resource[0].sceneId;
    scene.desc = "";
    scene.name = "";
    scene.enName = "";
    scene.cover = coverStr;
    _homeProvider.character.characterId = characterIdStr.isNotEmpty
        ? characterIdStr
        : dataIdx.resource[0].characterId;
    _homeProvider.heardcover = characterCoverStr.isNotEmpty
        ? characterCoverStr
        : dataIdx.resource[0].characterAvatar;
    _homeProvider.ishread = characterCoverStr.isNotEmpty
        ? characterCoverStr
        : dataIdx.resource[0].characterAvatar;
    // SceneEntity scene = sceneList[idx];
    // scene.desc = "我也不知道啊";
    // scene.name = "你好";
    // scene.enName = "111";

    _homeProvider.resetChatParams();
    _homeProvider.scene = scene;
    // _homeProvider.character.characterId
    NavigatorUtils.push(
        context,
        // HomeRouter.instructionalVideoDialoguePage,
        "${HomeRouter.instructionalVideoDialoguePage}?index=$idx&isUserBuy=${stepDetailData.data.isUserBuy}&levelId=${stepDetailData.data.levelId}",
        arguments: data);
  }

  void selectScene(SceneEntity scene) {
    return;
    LoginManager.checkLogin(context, () {
      // Navigator.of(context).pop();
      // HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
      // if (homeProvider.sessionType == 'chat') {
      //   ConfirmUtils.show(
      //     context: context,
      //     title: '你要切换场景吗？',
      //     onConfirm: () {
      //       _homeProvider.sceneStreamController
      //           .add({'type': 'scene', 'data': scene.toJson()});
      //     },
      //     child: const Text(
      //       '场景切换会结束当前对话',
      //       style: TextStyle(
      //         fontSize: 15.0,
      //         fontWeight: FontWeight.w400,
      //         color: Color(0xFF333333),
      //         height: 18.0 / 15.0,
      //       ),
      //     ),
      //   );

      //   return;
      // }

      // _homeProvider.sceneStreamController
      //     .add({'type': 'scene', 'data': scene.toJson()});

      // _homeProvider.resetChatParams();

      // SceneEntity scene1 = SceneEntity.fromJson(value['data']);

      // scene.desc = "我也不知道啊";
      // scene.name = "你好";
      // scene.enName = "111";
      // SceneEntity scene1;
      // CourseEntity xxx = CourseEntity();
      // xxx.id = scene.id;
      // xxx.name = scene.name;
      // xxx.enName = scene.enName;
      // xxx.desc = scene.desc;
      // xxx.cover = scene.cover;
      // _homeProvider.sceneStreamController
      //     .add({'type': 'course', 'data': scene.toJson()});
      // // _homeProvider.scene = scene;
      // _homeProvider.resetChatParams();

      _homeProvider.resetChatParams();
      _homeProvider.scene = scene;
      // _homeProvider.character.characterId
      NavigatorUtils.push(
        context,
        HomeRouter.instructionalVideoDialoguePage,
      );

//  _homeProvider.sceneStreamController
//           .add({'type': 'scene', 'data': scene.toJson()});
//       _homeProvider.scene = scene;
//       _homeProvider.resetChatParams();

      // _homeProvider.scene = scene;
      // NavigatorUtils.push(
      //   context,
      //   HomeRouter.scenePage,
      // );
    });
  }

  Widget body() {
    return MyScrollView(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Text(
          stepDetailData.data.unitName,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_666666,
          ),
        )),
        Gaps.vGap2,
        Text(
          stepDetailData.data.levelName,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        Gaps.vGap10,
        GestureDetector(
          onTap: () {
            NavigatorUtils.push(
              context,
              CourseRouter.courseDetailsPage,
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
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
                // RichText(
                //   text: const TextSpan(children: [
                //     TextSpan(
                //         text: "本课学习目标 ",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //           color: Colors.black,
                //         )),
                //     TextSpan(
                //         text: "Learning targe",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //           color: Colours.color_666666,
                //         )),
                //   ]),
                // ),
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
                  // selectScene(sceneList[index]);
                  gotoCourse(index);
                  // if (index == 0) {
                  //           _homeProvider.sceneStreamController
                  // .add({'type': 'scene', 'data': scene.toJson()});

                  // _homeProvider.resetChatParams();

                  // // SceneEntity scene1 = SceneEntity.fromJson(value['data']);
                  // _homeProvider.scene = scene;
                  // ScenePage(onEnd: () {  },);
                  // } else if (index == 1) {
                  // NavigatorUtils.push(
                  //   context,
                  //   CourseRouter.courseReportPage,
                  // );
                  // }
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
                    NavigatorUtils.push(
                      context,
                      CourseRouter.courseReportPage,
                    );
                  },
                  child: Container(
                    // margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.0),
                      color: Colours.color_EBCCFE,
                    ),
                    padding: const EdgeInsets.all(30),
                    child: const Column(
                      children: [
                        Text(
                          "报告",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "已发布",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // const Positioned(
                //   right: 0,
                //   child: LoadAssetImage(
                //     "report_icon",
                //     width: 24.0,
                //     height: 24.0,
                //   ),
                // ),
              ],
            ),
            Stack(
              children: [
                // const Positioned(
                //   right: 0,
                //   child: Text(
                //     "+",
                //     style: TextStyle(
                //       fontSize: 14.0,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(
                      context,
                      PersonalRouter.errorCorrectionDetailPage,
                    );
                  },
                  child: Container(
                    // margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.0),
                      color: Colours.color_C1EBF7,
                    ),
                    padding: const EdgeInsets.all(30),
                    child: const Column(
                      children: [
                        Text(
                          "纠错",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "已发布",
                          style: TextStyle(
                            fontSize: 12.0,
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
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, left: 6, right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.0),
                      color: Colors.red,
                    ),
                    child: const Text(
                      "99",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(
                        context, CourseRouter.curriculumEvaluationPage,
                        arguments: stepDetailData);

                    //     NavigatorUtils.push(
                    // context,
                    // replace: true,
                    // "${ExamRouter.mockExaminationTwoPage}?state=${widget.state}",
                    // arguments: examStepBean);
                  },
                  child: Container(
                    // margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.0),
                      color: Colours.color_DDF3D2,
                    ),
                    padding: const EdgeInsets.all(30),
                    child: const Column(
                      children: [
                        Text(
                          "评价",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "已评价",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // const Positioned(
                //   right: 0,
                //   child: LoadAssetImage(
                //     "evaluate_icon",
                //     width: 24.0,
                //     height: 24.0,
                //   ),
                // ),
              ],
            ),
          ],
        ),
        // const CourseFlowItem(),
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
              // NavigatorUtils.goBack(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                builder: (_) => SwitchingTeacherPage(
                  clickCallBack: (String characterId, String cover) {
                    setState(() {
                      characterIdStr = characterId;
                      coverStr = cover;
                      characterCoverStr = cover;
                    });
                  },
                ),
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
    });
  }
}
