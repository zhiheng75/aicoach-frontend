//课程流程
import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/item/course_flow_item.dart';
import 'package:Bubble/course/page/switching_teacher_page.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseFlowPage extends StatefulWidget {
  const CourseFlowPage({super.key});

  @override
  State<CourseFlowPage> createState() => _CourseFlowPageState();
}

class _CourseFlowPageState extends State<CourseFlowPage> {
  late HomeProvider _homeProvider;
  List<CategoryEntity> _categoryList = [];
  List<SceneEntity> sceneList = [];

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
  }

  void init() {
    setState(() {});
    String characterId = _homeProvider.character.characterId;
    if (characterId == '') {
      getDefaultCharacter((id) => getCategoryList(id));
    } else {
      getCategoryList(characterId);
    }
  }

  void getDefaultCharacter(Function(String) onSuccess) {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.get, HttpApi.teacherList, onSuccess: (result) {
      if (result == null || result.data == null) {
        setState(() {});
        return;
      }
      List<dynamic> list = result.data! as List<dynamic>;
      if (list.isEmpty) {
        setState(() {});
        return;
      }
      onSuccess(CharacterEntity.fromJson(list.first).characterId);
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

  void selectScene(SceneEntity scene) {
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

      _homeProvider.sceneStreamController
          .add({'type': 'video', 'data': scene.toJson()});
      _homeProvider.scene = scene;
      _homeProvider.resetChatParams();

      // _homeProvider.scene = scene;
      // ScenePage(onEnd: () {  },);
      // NavigatorUtils.push(
      //   context,
      //   HomeRouter.scenePage,
      // );
      // _homeProvider.scene = scene;
      // NavigatorUtils.push(
      //   context,
      //   HomeRouter.instructionalVideoDialoguePage,
      // );
    });
  }

  Widget body() {
    return MyScrollView(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
            child: Text(
          "Levell-Unit 2-Lesson 7",
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_666666,
          ),
        )),
        Gaps.vGap2,
        const Text(
          "Animals and Human",
          style: TextStyle(
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
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colours.color_F8F8F8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "本课学习目标",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_examination,
                    )),
                TextSpan(
                    text: "Learning targe",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    )),
              ]),
            ),
          ),
        ),
        Gaps.vGap8,
        SizedBox(
          height: 400,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  selectScene(sceneList[index]);

                  if (index == 0) {
                    //           _homeProvider.sceneStreamController
                    // .add({'type': 'scene', 'data': scene.toJson()});

                    // _homeProvider.resetChatParams();

                    // // SceneEntity scene1 = SceneEntity.fromJson(value['data']);
                    // _homeProvider.scene = scene;
                    // ScenePage(onEnd: () {  },);
                  } else if (index == 1) {
                    // NavigatorUtils.push(
                    //   context,
                    //   CourseRouter.courseReportPage,
                    // );
                  }
                },
                child: const CourseFlowItem(),
              );
            },
            itemCount: 4,
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
                const Positioned(
                  right: 0,
                  child: LoadAssetImage(
                    "report_icon",
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                const Positioned(
                  right: 0,
                  child: Text(
                    "+",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
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
                const Positioned(
                  right: 8,
                  top: 8,
                  child: Text(
                    "99",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                      context,
                      CourseRouter.curriculumEvaluationPage,
                    );
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
                const Positioned(
                  right: 0,
                  child: LoadAssetImage(
                    "evaluate_icon",
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
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
                builder: (_) => const SwitchingTeacherPage(),
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
      child: Scaffold(body: SafeArea(child: body())),
    );
  }
}
