import 'dart:async';

import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/home/presenter/home_page_presenter.dart';
import 'package:Bubble/home/provider/selecter_teacher_provider.dart';
import 'package:Bubble/home/view/home_view.dart';
import 'package:Bubble/home/widget/main_page_select_menu.dart';
import 'package:Bubble/home/widget/recommend_teacher_widget.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import '../conversation/conversation_router.dart';
import '../conversation/model/character_entity.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../res/gaps.dart';
import '../util/image_utils.dart';
import '../util/time_utils.dart';
import '../widgets/double_tap_back_exit_app.dart';
import '../widgets/load_image.dart';
import '../widgets/my_button.dart';
import '../widgets/popup_window.dart';
import 'model/select_teacher_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        BasePageMixin<HomePage, HomePagePresenter>,
        AutomaticKeepAliveClientMixin<HomePage>
    implements HomeView {
  List<SelectTeacherEntity> allTeacher = [];
  final GlobalKey _buttonKey = GlobalKey();

  /// 倒计时秒数
  final int _second = 180;

  /// 当前秒数
  String _currentSecond = "";

  ///试用时间
  bool experienceTimeFinish = false;

  bool startCountDown = false;

  StreamSubscription<dynamic>? _subscription;

  Future<dynamic> _countDown() async {
    _subscription = Stream.periodic(const Duration(seconds: 1), (int i) => i)
        .take(_second)
        .listen((int i) {
      setState(() {
        experienceTimeFinish = (_second - i - 1) == 0;
        _currentSecond = TimeUtils.formatedTime(_second - i - 1);
        if (experienceTimeFinish) {
          _showTimeOutBottomSheet();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleTapBackExitApp(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colours.color_00F3BD,
                Colours.color_00BAFF,
                Colours.color_AD4DFF,
              ],
              stops: [
                0.0,
                0.5,
                1.0
              ]),
        ),
        child: Stack(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     NavigatorUtils.push(context, SettingRouter.themePage);
            //   },
            //   child: LoadAssetImage(
            //     "test_banner_img",
            //     height: ScreenUtil.getScreenH(context),
            //     fit: BoxFit.cover,
            //   ),
            // ),

            Positioned(
              left: 50,
              top: 70,
              child: GestureDetector(
                  onTap: () {
                    // _showSelectMenu();
                    // NavigatorUtils.push(context, SettingRouter.settingPage);
                    NavigatorUtils.push(
                        context, PersonalRouter.personalCenter);
                  },
                  child: LoadAssetImage(
                    "home_more_img",
                    key: _buttonKey,
                    width: 17,
                    height: 17,
                  )),
            ),

            Positioned(
                right: 20,
                top: 68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadAssetImage(
                      "timer_img",
                      width: 17,
                      height: 17,
                    ),
                    Gaps.hGap6,
                    GestureDetector(
                      onTap: () {
                        _showTimeOutBottomSheet();
                      },
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          experienceTimeFinish ? "试用期结束" : _currentSecond,
                          style: const TextStyle(
                              fontSize: Dimens.font_sp17, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )),

            Positioned(
                bottom: 50,
                child: Container(
                  width: ScreenUtil.getScreenW(context),
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 28, right: 28),
                        height: 46,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: ImageUtils.getAssetImage(
                                    "purchase_btn_img"),
                                fit: BoxFit.fill)),
                        child: const Center(
                          child: Text(
                            "与Andy对话",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )),
                ))
          ],
        ),
      )),
    ));
  }

  //选择老师的弹窗
  void _showBottomSheet() {
    HomeTeacherProvider provider = HomeTeacherProvider();
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.65,
            expand: false,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colours.color_0EF4D1,
                          Colours.color_53C5FF,
                          Colours.color_E0AEFF,
                        ],
                        stops: [
                          0.0,
                          0.7,
                          1.0
                        ])),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          const Text(
                            "选择自己喜欢的老师",
                            style: TextStyle(
                                color: Colours.color_111B44,
                                fontSize: Dimens.font_sp15,
                                fontWeight: FontWeight.bold),
                          ),
                          const Expanded(child: Gaps.empty),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtils.goBack(context);
                            },
                            child: const LoadAssetImage(
                              "close_img",
                              width: 15,
                              height: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: GridView.builder(
                          itemCount: allTeacher.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            //设置列数
                            crossAxisCount: 3,
                            //设置横向间距
                            crossAxisSpacing: 10,
                            //设置主轴间距
                            mainAxisSpacing: 20,
                            mainAxisExtent: 150,
                          ),
                          itemBuilder: (BuildContext ctx, int index) {
                            return RecommendTeacherWidget(allTeacher[index],
                                () {
                              provider.setSelectIndex(index);
                            }, provider);
                          }),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                          onTap: () {
                            NavigatorUtils.goBack(context);
                            // 跳转到对话
                            String characterId = 'loki';
                            String name = 'Loki';
                            String source = 'default';
                            String voiceId = 'ErXwobaYiN019PkySvjV';
                            String authorName = '';
                            String imageUrl = '';
                            String tts = 'ELEVEN_LABS';
                            bool isAuthor = false;
                            CharacterEntity entity = CharacterEntity(characterId, name, source, voiceId, authorName, imageUrl, tts, isAuthor);
                            Future.delayed(const Duration(milliseconds: 300), () {
                              NavigatorUtils.push(
                                context,
                                ConversationRouter.connectPage,
                                arguments: entity,
                              );
                            });
                            startCountDown = true;
                            _countDown();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 28, right: 28),
                            height: 46,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.getAssetImage(
                                        "purchase_btn_img"),
                                    fit: BoxFit.fill)),
                            child: const Center(
                              child: Text(
                                "确定",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )),
                    ),
                    Gaps.vGap24,
                  ],
                ),
              );
            }));
  }

  //体验期结束的弹窗
  void _showTimeOutBottomSheet() {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.45,
            expand: false,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colours.color_0EF4D1,
                        Colours.color_53C5FF,
                        Colours.color_E0AEFF,
                      ],
                      stops: [0.0, 0.4, 1.0],
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 50),
                      child: Text(
                        "体验到期, 与你的专属AI外教开启学习之旅",
                        style: TextStyle(
                            color: Colours.color_111B44,
                            fontSize: Dimens.font_sp22),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                      child: Text(
                        "赠送的体验时长已经使用完成，\n升级会员后,可查看完整的个性化学习报告。",
                        style: TextStyle(
                            color: Colours.color_546092,
                            fontSize: Dimens.font_sp13),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ImageUtils.getAssetImage(
                              "experience_board_img",
                            ),
                            fit: BoxFit.fill),
                      ),
                      child: Column(
                        children: [
                          Gaps.vGap15,
                          categoryWidget("自由选择喜欢的虚拟外教老师"),
                          Gaps.vGap15,
                          categoryWidget("自定义话题场景练习"),
                          Gaps.vGap15,
                          categoryWidget("24小时，随时随地开始练习"),
                          Gaps.vGap15,
                          categoryWidget("地道英语口语，纯真发音，引导式对话 "),
                          Gaps.vGap15,
                          categoryWidget("全方位测评报告"),
                          Gaps.vGap15,
                        ],
                      ),
                    ),
                    Gaps.vGap15,
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            NavigatorUtils.goBack(context);
                            NavigatorUtils.push(context, PersonalRouter.personalPurchase);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 400,
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colours.color_DA2FFF,
                                    Colours.color_0E90FF,
                                    Colours.color_00FFB4,
                                  ],
                                )),
                            // child: Center(
                            child: const Text(
                              "查看会员升级方案",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.font_sp18),
                            ),
                            // ),
                          ),
                        )),
                    Gaps.vGap24,
                  ],
                ),
              );
            }));
  }

  @override
  HomePagePresenter createPresenter() {
    return HomePagePresenter();
  }

  void _showSelectMenu() {
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    showPopupWindow<void>(
      context: context,
      isShowBg: false,
      offset: Offset(button.size.width - 100, 0.0),
      anchor: button,
      child: MainPageSelectMenu(() {
        NavigatorUtils.goBack(context);
      }),
    );
  }

  Widget categoryWidget(String content) {
    return Row(
      children: [
        const LoadAssetImage(
          "experience_check_img",
          width: 12,
          height: 12,
        ),
        Gaps.hGap6,
        Text(
          content,
          style: const TextStyle(
              fontSize: Dimens.font_sp14, color: Colours.color_111B44),
        )
      ],
    );
  }

  @override
  void setTeachList(List<SelectTeacherEntity> list) {
    allTeacher.clear();
    allTeacher.addAll(list);
    // _showBottomSheet();
    // setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
