import 'dart:convert';
import 'dart:math';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/chat/presenter/chat_page_presenter.dart';
import 'package:Bubble/chat/view/chat_view.dart';
import 'package:Bubble/chat/widget/chat_home_item.dart';
import 'package:Bubble/chat/widget/chat_home_two_item.dart';
import 'package:Bubble/chat/widget/topic_home_item.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/home/widget/home_item.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/entity/category_entity.dart';
import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with
        BasePageMixin<ChatHomePage, ChatPagePresenter>,
        AutomaticKeepAliveClientMixin<ChatHomePage>
    implements ChatView {
  late ChatPagePresenter _chatPagePresenter;

  List<Datum> characterList = [];
  late HomeProvider _homeProvider;
  List<CategoryEntity> _categoryList = [];
  List<SceneEntity> sceneList = [];
  int currentIndex = 0;
  List<TopicEntity> _topicList = [];
  final ScreenUtil _screenUtil = ScreenUtil();
  int peopleIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);

    EventBus().on(NotificationUtils.loginIn, (_) {
      _chatPagePresenter.getCharacterList();
    });
    EventBus().on(NotificationUtils.loginOut, (_) {
      _chatPagePresenter.getCharacterList();
    });

    EventBus().on(NotificationUtils.resetChat, (idx) {
      if (idx == "2") {
        _chatPagePresenter.getCharacterList();
      }
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

  Widget tabbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "主题场景练习",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              return _categoryList[index].name.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        changeCategory(index);
                      },
                      child: Container(
                          margin: const EdgeInsets.only(top: 5, right: 24),
                          height: 40,
                          child: Column(
                            children: [
                              Text(
                                _categoryList[index].name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: currentIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Gaps.vGap4,
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: currentIndex == index
                                          ? [
                                              Colours.color_9F7EFF,
                                              Colours.color_BDA6FF,
                                            ]
                                          : [
                                              Colours.color_0000,
                                              Colours.color_0000,
                                            ],
                                    )),
                                width: 30,
                                height: 4,
                              ),
                            ],
                          )),
                    )
                  : Container();
            },
            itemCount: _categoryList.length,
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }

  Widget barWidget(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: 205.h,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100.h,
                child: Swiper(
                    index: peopleIndex,
                    autoplay: false,
                    autoplayDelay: 8000,
                    // duration: 2000,
                    onIndexChanged: (value) {
                      Log.e("msg==== $value");
                      peopleIndex = value;
                      String characterId =
                          characterList[peopleIndex].characterId;
                      _chatPagePresenter.getCategoryTopicList(characterId);
                    },
                    // duration: 10,
                    // pagination: SwiperPagination(
                    //     margin: const EdgeInsets.all(
                    //       0,
                    //     ),
                    //     builder: DotSwiperPaginationBuilder(
                    //         color: Colours.color_D9D9D9,
                    //         activeColor: Colours.color_7C7C7C,
                    //         // space: 1,
                    //         size: 3.h,
                    //         activeSize: 3.h)),
                    outer: true,
                    // autoplay: true,
                    // fade: 0.6,
                    // viewportFraction: 0.85,
                    // scale: 0.92,
                    viewportFraction: 0.3,
                    scale: 0.05,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   peopleIndex = i;
                          // });
                          Log.e("msg");
                        },
                        child: LoadImage(
                          characterList[i].avatarImage,
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                    // pagination: const SwiperPagination(alignment: Alignment.topCenter),
                    itemCount: characterList.length),
              ),
              Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(10),
                  // height: 120.h,
                  // width: _screenUtil.screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          // Colours.color_94FFF9,
                          Colours.color_7F5FFF,
                          Colours.color_A55FFF,
                        ],
                      )),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadAssetImage(
                        "maohao_lift",
                        width: 21.w,
                      ),
                      Expanded(
                        child: Text(
                          characterList[peopleIndex].slogan,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      LoadAssetImage(
                        "maohao_right",
                        width: 21.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(
                            context,
                            "${HomeRouter.homePage}?characterId=${characterList[peopleIndex].characterId}",
                          );
                        },
                        child: LoadAssetImage(
                          "chat_btn",
                          width: 100.w,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          Center(
              child: Container(
                  width: 140.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ImageUtils.getAssetImage("name_back"),
                          fit: BoxFit.fill)),
                  child: Center(
                      child: Text(
                    characterList[peopleIndex].name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
              body: SafeArea(
            child: Stack(
              children: [
                LoadAssetImage(
                  "chat_home_bg",
                  fit: BoxFit.fill,
                  width: _screenUtil.screenWidth,
                  height: _screenUtil.screenHeight,
                ),
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
                        child: Text(
                          "伙伴对练",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: barWidget(context),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          "角色故事练习",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      _topicList.isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                height: 180.0.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _topicList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        TopicEntity topic = _topicList[index];
                                        _homeProvider.resetChatParams();
                                        _homeProvider.topic = topic;
                                        _homeProvider.character.characterId =
                                            characterList[peopleIndex]
                                                .characterId;
                                        _homeProvider.character.imageUrl =
                                            characterList[peopleIndex].imageUrl;
                                        NavigatorUtils.push(
                                          context,
                                          HomeRouter.topicPage,
                                        );
                                      },
                                      child: TopicHomeItem(
                                          data: _topicList[index]),
                                    );
                                  },
                                ),
                              ),
                            )
                          : SliverToBoxAdapter(
                              child: Container(),
                            ),
                      _categoryList.isNotEmpty
                          ? SliverPersistentHeader(
                              pinned: false,
                              floating: false,
                              delegate: _SliverAppBarDelegate(
                                minHeight: 80, //收起的高度
                                maxHeight: 80,
                                child: Container(child: tabbar()),
                              ))
                          : SliverToBoxAdapter(
                              child: Container(),
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
                                  childAspectRatio: 172 / 80
                                  // mainAxisExtent: 120,
                                  ),
                          itemBuilder: (BuildContext ctx, int index) {
                            return GestureDetector(
                                onTap: () {
                                  SceneEntity scene = sceneList[index];
                                  _homeProvider.resetChatParams();
                                  _homeProvider.scene = scene;
                                  NavigatorUtils.push(
                                    context,
                                    HomeRouter.scenePage,
                                  );
                                },
                                child: ChatHomeTwoItem(data: sceneList[index]));
                          })
                    ],
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendSuccess(CharacterListBean data) {
    // TODO: implement sendSuccess
    characterList.addAll(data.data);
    String characterId = characterList[0].characterId;
    _homeProvider.character.characterId = characterId;
    _homeProvider.character.imageUrl = characterList[0].imageUrl;
    // getCategoryList(characterId);
    // getCategoryTopicList(characterId);
    setState(() {});
  }

  @override
  void sendCategoryEntitySuccess(List<CategoryEntity> list) {
    // TODO: implement sendCategoryEntitySuccess
    _categoryList = list;
    setState(() {});

    if (_categoryList.isNotEmpty) {
      changeCategory(0);
    }
  }

  @override
  void sendTopicEntitySuccess(List<TopicEntity> list) {
    // TODO: implement sendTopicEntitySuccess
    _topicList = list;
    setState(() {});
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
