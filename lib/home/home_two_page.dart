import 'dart:math';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/presenter/home_two_page_presenter.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/view/home_two_page_view.dart';
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
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/group_avatar_widget.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/exam/exam_router.dart';

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
  List<String> headData = [];
  List<CategoryEntity> _categoryList = [];
  List<SceneEntity> sceneList = [];
  final ScrollController _scrollController = ScrollController();

  Widget barWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      // color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "https://img1.baidu.com/it/u=2286755736,2807423982&fm=253&fmt=auto&app=138&f=JPEG?w=650&h=487",
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {
          NavigatorUtils.goWebViewPage(context, "百度", "https://www.baidu.com");
          // showModalBottomSheet(
          //   context: context,
          //   backgroundColor: Colors.transparent,
          //   barrierColor: Colors.transparent,
          //   isScrollControlled: true,
          //   isDismissible: false,
          //   enableDrag: false,
          //   builder: (_) => const SelectScene(),
          // );
        },
        itemCount: 3,
        autoplay: true,
        pagination: const SwiperPagination(),
        // control: SwiperControl(),
      ),
    );
  }

  Widget classWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
        NavigatorUtils.push(
          context,
          HomeRouter.coursePurchasePage,
        );
        // NavigatorUtils.goWebViewPage(context, "百度", "https://www.baidu.com");
      },
      child: Image.network(
        "http://t15.baidu.com/it/u=3515177818,2652149588&fm=224&app=112&f=JPEG?w=500&h=249",
        fit: BoxFit.fill,
      ),
    );
  }

  Widget peopleWidget(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        // height: 100,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(characterList[0].slogan)),
                LoadImage(
                  characterList[0].imageUrl,
                  holderImg: "teacher",
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            Row(
              children: [
                GroupAvatarWidget(
                  data: headData,
                  isShowNum: false,
                ),
                GestureDetector(
                    onTap: () {
                      EventBus().emit(NotificationUtils.taberThree);
                    },
                    child: const Text("更多角色")),
                const Expanded(child: Gaps.empty),
                GestureDetector(
                    onTap: () {
                      NavigatorUtils.push(
                        context,
                        "${HomeRouter.homePage}?index=0",
                      );
                    },
                    child: const Text("自由对话")),
                Gaps.hGap15,
              ],
            ),
          ],
        ));
  }

  Widget mokaoWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtils.push(
          context,
          ExamRouter.examPage,
        );
      },
      child: const SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("KET模考"),
              Text("实景还原考试全流程"),
            ],
          )),
    );
  }

  // Widget barItem(String label, bool isSelected, int idx) {
  //   // bool isSelected = tabType == type;
  //   return GestureDetector(
  //     behavior: HitTestBehavior.opaque,
  //     onTap: () {
  //       if (isSelected) {
  //         return;
  //       }
  //       setState(() {
  //         // curTabIndex = idx;
  //       });
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Row(
  //           children: [
  //             const SizedBox(
  //               width: 8.0,
  //             ),
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 fontSize: 16.0,
  //                 fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
  //                 color: isSelected
  //                     ? const Color(0xFF000000)
  //                     : const Color(0xFF333333),
  //                 height: 18.0 / 16.0,
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 8.0,
  //             ),
  //           ],
  //         ),
  //         // const SizedBox(
  //         //   height: 8.0,
  //         // ),
  //         // Container(
  //         //   width: 56.0,
  //         //   height: 3.0,
  //         //   decoration: BoxDecoration(
  //         //     borderRadius: BorderRadius.circular(10.0),
  //         //     gradient: isSelected
  //         //         ? const LinearGradient(
  //         //             begin: Alignment.topLeft,
  //         //             end: Alignment.bottomRight,
  //         //             colors: [
  //         //               Colours.color_9AC3FF,
  //         //               Colours.color_FF71E0,
  //         //             ],
  //         //           )
  //         //         : null,
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // Widget tabbar() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text("口语联系精品课"),
  //       Row(
  //         // mainAxisAlignment: MainAxisAlignment.center,
  //         // mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           barItem('热门推荐', curTabIndex == 0 ? true : false, 0),
  //           barItem('爱好娱乐', curTabIndex == 1 ? true : false, 1),
  //           barItem('学校生活', curTabIndex == 2 ? true : false, 2),
  //           barItem('热门推荐', curTabIndex == 0 ? true : false, 3),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget tabbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 15,
          ),
          child: Text("口语联系精品课"),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 0,
          ),
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    changeCategory(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8.0),
                    child: Text(_categoryList[index].name),
                  ),
                );
              },
              itemCount: _categoryList.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
            ),
          ),
        )
        // Row(
        //   // mainAxisAlignment: MainAxisAlignment.center,
        //   // mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     ,
        //     barItem('爱好娱乐', curTabIndex == 1 ? true : false, 1),
        //     barItem('学校生活', curTabIndex == 2 ? true : false, 2),
        //     barItem('热门推荐', curTabIndex == 0 ? true : false, 3),
        //   ],
        // ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  // void getCharacterList() {
  //   _chatPagePresenter.requestNetwork<ResultData>(Method.get,
  //       url: HttpApi.characterList,
  //       isShow: false,
  //       isClose: false, onSuccess: (result) {
  //     Map<String, dynamic> characterListMap = json.decode(result.toString());
  //     CharacterListBean goodsListBean =
  //         CharacterListBean.fromJson(characterListMap);
  //     Log.e(goodsListBean.msg);
  //     if (goodsListBean.code == 200) {
  //       characterList.addAll(goodsListBean.data);
  //       setState(() {});
  //     } else {}
  //   }, onError: (code, msg) {});
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // if (isloading) {
    //   return const Scaffold(
    //     body: Center(
    //       child: LoadData(),
    //     ),
    //   );
    // }
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
            child: extended.ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // return buildSliverHeader();
            return [
              // const SliverToBoxAdapter(
              //   child: Text("Hello Tommy"),
              // ),
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 25, //收起的高度
                    maxHeight: 25,
                    child: Container(
                        color: Colors.white, child: const Text("Hello Tommy")),
                  )),
              SliverToBoxAdapter(
                child: barWidget(context),
              ),
              SliverToBoxAdapter(
                child: classWidget(context),
              ),
              SliverToBoxAdapter(
                child: characterList.length > 2
                    ? peopleWidget(context)
                    : Container(),
              ),
              SliverToBoxAdapter(
                child: mokaoWidget(context),
              ),
              _categoryList.length > 1
                  ? SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 60, //收起的高度
                        maxHeight: 60,
                        child: Container(color: Colors.white, child: tabbar()),
                      ))
                  : SliverToBoxAdapter(
                      child: Container(),
                    ),
            ];
          },
          // pinnedHeaderSliverHeightBuilder: () {
          //   return 100;
          // },
          body: GridView.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                  onTap: () {
                    selectScene(sceneList[index]);
                  },
                  child: Center(child: Text(sceneList[index].name)));
            },
            itemCount: sceneList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18.0,
                crossAxisSpacing: 5,
                childAspectRatio: 2),
          ),
        )),
      ),
    );
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

      _homeProvider.sceneStreamController
          .add({'type': 'scene', 'data': scene.toJson()});

      _homeProvider.resetChatParams();

      // SceneEntity scene1 = SceneEntity.fromJson(value['data']);
      _homeProvider.scene = scene;
      // ScenePage(onEnd: () {  },);
      // NavigatorUtils.push(
      //   context,
      //   HomeRouter.scenePage,
      // );
      // scenePage
      //homePage
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
    characterList.addAll(data.data);
    for (int i = 0; i < characterList.length; i++) {
      headData.add(characterList[i].avatarImage);
    }

    setState(() {});

    String characterId = characterList[0].characterId;
    _homeProvider.character.characterId = characterId;

    getCategoryList(characterId);
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
    currentIndex = index;
    getSceneListByCategory(index);
    setState(() {});
  }

  void getSceneListByCategory(int index) {
    CategoryEntity category = _categoryList.elementAt(currentIndex);
    sceneList = category.sceneList;
    setState(() {});
    //注释了后期看为什么
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   _scrollController.jumpTo(0);
    // });
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
