import 'dart:math';

import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';

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

  List<BBanner> banner = [];
  List<BBanner> lesson = [];
  int isChatShow = 0;
  int isKetShow = 0;
  int isDefault = 0;
  final ScreenUtil _screenUtil = ScreenUtil();

  Widget barWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return LoadImage(
              banner[index].imageUrl,
              fit: BoxFit.cover,
              // width: 56.0,
              // height: 56.0,
            );
            // Image.network(
            //   "https://img1.baidu.com/it/u=2286755736,2807423982&fm=253&fmt=auto&app=138&f=JPEG?w=650&h=487",
            //   fit: BoxFit.cover,
            // );
          },
          onTap: (index) {
            if (banner[index].type == 1) {
              NavigatorUtils.goWebViewPage(
                  context, banner[index].title, banner[index].linkUrl);
            } else if (banner[index].type == 2) {
              if (banner[index].linkUrl == "1") {
                //单系统课购买页
                NavigatorUtils.push(
                  context,
                  "${HomeRouter.coursePurchasePage}?levelId=${banner[index].param}",
                );
              } else if (banner[index].linkUrl == "2") {
                //个人中心进入的购买页（引流课购买和课程购买可切换的页面）
              } else if (banner[index].linkUrl == "3") {
                //试听课页面
                NavigatorUtils.push(
                    context,
                    // CourseRouter.courseFlowPage,
                    "${CourseRouter.courseFlowPage}?lessonId=${banner[index].param}");
              }
            }
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
          itemCount: banner.length,
          autoplay: true,
          pagination: const SwiperPagination(),
          // control: SwiperControl(),
        ),
      ),
    );
  }

  Widget headWidget(String tit) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gaps.hGap6,
          Text(
            tit,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Gaps.hGap6,
          const LoadAssetImage(
            "class_vip_icon",
            width: 30.0,
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget recommendedWidget() {
    return Row(
      children: [
        Container(
          color: Colors.amber,
          width: _screenUtil.screenWidth / 2,
          height: 200,
          child: Column(
            children: [
              Text(
                "AI口语系统课",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                "适合1-6年级",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                "领取一节体验课",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                "我要学",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              color: Colors.blue,
              width: _screenUtil.screenWidth / 2,
              height: 100,
              child: Column(
                children: [
                  Text(
                    "AI口语系统课",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "适合1-6年级",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "领取一节体验课",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "我要学",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.deepPurple,
              width: _screenUtil.screenWidth / 2,
              height: 100,
              child: Column(
                children: [
                  Text(
                    "AI口语系统课",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "适合1-6年级",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "领取一节体验课",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "我要学",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget courseWidget(BBanner lesson) {
    return GestureDetector(
      onTap: () {
        //
        NavigatorUtils.push(
          context,
          "${HomeRouter.coursePurchasePage}?levelId=${lesson.param}",
        );
        // NavigatorUtils.goWebViewPage(context, "百度", "https://www.baidu.com");
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colours.color_F8F8F8,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   lesson.title,
            //   style: const TextStyle(
            //     fontSize: 16.0,
            //     fontWeight: FontWeight.w400,
            //     color: Colors.black,
            //   ),
            // ),
            // Gaps.vGap8,
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                lesson.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Gaps.vGap8,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Container(
            //         padding: const EdgeInsets.all(8),
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.black, width: 1.0),
            //           borderRadius:
            //               const BorderRadius.all(Radius.circular(30.0)),
            //         ),
            //         child: const Text(
            //           "去选课",
            //           style: TextStyle(
            //             fontSize: 15.0,
            //             fontWeight: FontWeight.w400,
            //             color: Colors.black,
            //           ),
            //         )),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget peopleWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            // height: 80,
            // width: 280,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color_E8CCFE,
                    Colours.color_ACCDFF,
                  ],
                )),
            // height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          characterList[isDefault].slogan,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_2C0047,
                          ),
                        ),
                        Gaps.vGap5,
                        GestureDetector(
                          onTap: () {
                            // NavigatorUtils.push(
                            //   context,
                            //   "${HomeRouter.homePage}?index=$isDefault",
                            // );
                          },
                          child: Container(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colours.color_6D388F,
                              ),
                              child: const Text(
                                "自由对话",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 100,
                      width: 150,
                    ),
                    // LoadImage(
                    //   characterList[0].imageUrl,
                    //   holderImg: "teacher",
                    //   height: 100,
                    //   width: 100,
                    //   fit: BoxFit.fill,
                    // ),
                  ],
                ),
                // Row(
                //   children: [
                //     GroupAvatarWidget(
                //       data: headData,
                //       isShowNum: false,
                //     ),
                //     GestureDetector(
                //         onTap: () {
                //           EventBus().emit(NotificationUtils.taberThree);
                //         },
                //         child: const Text("更多角色")),
                //     const Expanded(child: Gaps.empty),
                //     GestureDetector(
                //         onTap: () {
                // NavigatorUtils.push(
                //   context,
                //   "${HomeRouter.homePage}?index=0",
                // );
                //         },
                //         child: const Text("自由对话")),
                //     Gaps.hGap15,
                //   ],
                // ),
              ],
            )),
        const Positioned(
            right: 5,
            bottom: 10,
            child: LoadAssetImage(
              "suofeiya_head",
              width: 170.0,
              height: 150.0,
            ))
      ],
    );
  }

  Widget mokaoWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtils.push(
          context,
          ExamRouter.examPage,
        );
      },
      child: Container(
          margin: const EdgeInsets.all(8),
          // height: 80,
          // width: 280,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Colours.color_FFF3D8,
                  Colours.color_E8CCFE,
                ],
              )),
          height: 120,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(15),
                child: const LoadAssetImage(
                  "mokao_icon",
                  width: 24.0,
                  height: 24.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "KET模考",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "实景",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colours.color_FF71CF,
                            )),
                        TextSpan(
                            text: '还原考试',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colours.color_666666,
                            )),
                        TextSpan(
                            text: '全流程',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colours.color_FF71CF,
                            )),
                      ]),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colours.color_6D388F,
                  ),
                  child: const Text(
                    "去看看",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  )),
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
          child: Text(
            "场景模拟练习",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
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
                          margin: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          // height: 80,
                          // width: 280,
                          // padding: const EdgeInsets.only(
                          //     left: 10, right: 10, top: 5, bottom: 5),
                          // decoration: currentIndex == index
                          //     ? BoxDecoration(
                          //         borderRadius: BorderRadius.circular(15),
                          //         gradient: const LinearGradient(
                          //           colors: [
                          //             Colours.color_E8CCFE,
                          //             Colours.color_ACCDFF,
                          //           ],
                          //         ))
                          //     : BoxDecoration(
                          //         borderRadius: BorderRadius.circular(15.0),
                          //         color: Colours.color_F8F8F8,
                          //       ),
                          height: 40,
                          child: Text(
                            _categoryList[index].name,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: currentIndex == index
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          )),
                    )
                  : Container();
            },
            itemCount: _categoryList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
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
    EventBus().on(NotificationUtils.loginIn, (_) {
      _homeTwoPagePresenter.getBannerList();
    });
    EventBus().on(NotificationUtils.loginOut, (_) {
      _homeTwoPagePresenter.getBannerList();
    });
  }

  @override
  void dispose() {
    EventBus().off(NotificationUtils.loginIn);
    EventBus().off(NotificationUtils.loginOut);

    super.dispose();
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
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SafeArea(
            child: extended.ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // return buildSliverHeader();
            return [
              const SliverToBoxAdapter(
                child: Text("   口语嘟嘟 AI",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
              // SliverPersistentHeader(
              //     pinned: true,
              //     floating: false,
              //     delegate: _SliverAppBarDelegate(
              //       minHeight: 25, //收起的高度
              //       maxHeight: 25,
              //       child: Container(
              //           color: Colors.white, child: const Text("Hello Tommy")),
              //     )),
              SliverToBoxAdapter(
                child: banner.isNotEmpty ? barWidget(context) : Container(),
              ),

              // SliverToBoxAdapter(
              //   child: headWidget("精品推荐"),
              // ),
              // SliverToBoxAdapter(
              //   child: recommendedWidget(),
              // ),
              // SliverToBoxAdapter(
              //   child: headWidget("AI学伴"),
              // ),
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     // margin: const EdgeInsets.only(top: 10),
              //     height: 150.0,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: characterList.length,
              //       itemBuilder: (context, index) {
              //         return Container(
              //           // color: Colors.black,
              //           margin: const EdgeInsets.all(10),
              //           child: LoadImage(
              //             characterList[isDefault].coverImageUrl,
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: isChatShow == 0
                    ? Container()
                    : characterList.isNotEmpty
                        ? peopleWidget(context)
                        : Container(),
              ),
              SliverList.builder(
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: courseWidget(lesson[index]),
                  );
                },
                itemCount: lesson.length,
              ),
              // SliverToBoxAdapter(
              //   child: courseWidget(context),
              // ),
              SliverToBoxAdapter(
                child: isKetShow == 1 ? mokaoWidget(context) : Container(),
              ),
              _categoryList.isNotEmpty
                  ? SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 70, //收起的高度
                        maxHeight: 70,
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
                  child: Stack(
                    children: [
                      Container(
                        // color: Colors.black,
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            // margin: const EdgeInsets.only(
                            //     top: 0, left: 8, right: 8, bottom: 0),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(8.0),
                            // image: const DecorationImage(
                            //   image: AssetImage(
                            //     'assets/images/mkbg.png',
                            //   ),
                            //   fit: BoxFit.cover,
                            // ),
                            // ),
                            child: LoadImage(
                              sceneList[index].cover,
                              fit: BoxFit.cover,
                              width: _screenUtil.screenWidth / 2,
                              // height: 56.0,
                            )),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              sceneList[index].name,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.vGap10
                          ],
                        ),
                      )
                    ],
                  ));
            },
            itemCount: sceneList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 0,
                childAspectRatio: 1.5),
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
      if (characterList[i].isDefault == 1) {
        isDefault = i;
      }
    }

    setState(() {});

    String characterId = characterList[0].characterId;
    // _homeProvider.character.characterId = characterId;
    _homeProvider.character.characterId = characterId;
    _homeProvider.character.imageUrl = characterList[0].imageUrl;
    getCategoryList(characterId);
  }

  void getCategoryList(String characterId) async {
    DioUtils.instance.requestNetwork<ResultData>(
        Method.get, HttpApi.appSceneList, onSuccess: (result) {
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

  @override
  void sendBannerListSuccess(BannerListBean data) {
    // TODO: implement sendBannerListSuccess
    banner.addAll(data.data.banner);
    lesson.addAll(data.data.lesson);
    isKetShow = data.data.isKetShow;
    isChatShow = data.data.isChatShow;
    setState(() {});
    _homeTwoPagePresenter.getCharacterList();
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
