import 'dart:async';
import 'dart:io';

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/util/apple_pay_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
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
import 'package:jverify/jverify.dart';
import 'package:provider/provider.dart';
import '../conversation/conversation_router.dart';
import '../entity/result_entity.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../res/colors.dart';
import '../res/gaps.dart';
import '../util/image_utils.dart';
import '../widgets/double_tap_back_exit_app.dart';
import '../widgets/load_image.dart';
import '../widgets/popup_window.dart';
import 'entity/teach_list_entity.dart';

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

  final GlobalKey _buttonKey = GlobalKey();
  bool needRefresh = false;

  StreamSubscription<dynamic>? _subscription;

  late HomePagePresenter _homePagePresenter;



  void init() {
    getDefaultTeacher();
    if (Platform.isIOS && LoginManager.isLogin()) {
      // 处理用户苹果支付未处理完的交易
      int userId = LoginManager.getUserId();
      ApplePayUtils.dealtUnCompletedPurchase(userId.toString());
    }
  }

  void getDefaultTeacher() async {
    HomeTeacherProvider provider = Provider.of<HomeTeacherProvider>(context, listen: false);
    String userId = await provider.getUserId();
    Map<dynamic, dynamic>? value = SpUtil.getObject('${Constant.teacher}_$userId');
    if (value != null) {
      TeachListEntity teacher = TeachListEntity.fromJson(value as Map<String, dynamic>);
      provider.updateTeacher(teacher);
      return;
    }

    _homePagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.teacherList,
      onSuccess: (result) {
        if (result != null && result.code == 200) {
          if (result.data != null && result.data is List) {
            List<dynamic> list = result.data as List;
            if (list.isNotEmpty) {
              provider.updateTeacher(TeachListEntity.fromJson(list.first));
            }
          }
        }
        openSelectTeacher();
      },
      onError: (code, msg) {
        openSelectTeacher();
      },
    );
  }

  void openSelectTeacher() {
    String? isFirstUseApp = SpUtil.getString(Constant.isFirstUseApp);
    if (isFirstUseApp != 'Y') {
      SpUtil.putString(Constant.isFirstUseApp, 'Y');
      _showBottomSheet();
    }
  }

  void conversationWithTeacher(TeachListEntity? teacher) {
    if (teacher == null) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      NavigatorUtils.push(
        context,
        ConversationRouter.connectPage,
        arguments: teacher,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    init();
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
      child: Consumer<HomeTeacherProvider>(
        builder: (_, provider, __) {
          TeachListEntity? teacher = provider.teacher;
          return Scaffold(
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
                    Positioned(
                      right: 29,
                      top: 80,
                      child: GestureDetector(
                          onTap: () {
                            _showSelectMenu();
                          },
                          child: LoadAssetImage(
                            "home_more_img",
                            key: _buttonKey,
                            width: 17,
                            height: 17,
                          )),
                    ),

                    Positioned(
                        bottom: 65,
                        child: Container(
                          width: ScreenUtil.getScreenW(context),
                          alignment: Alignment.center,
                          child: GestureDetector(
                              onTap: () async {
                                // 未选择老师（加载失败）
                                if (teacher == null) {
                                  getDefaultTeacher();
                                  return;
                                }
                                showProgress();
                                ConversationProvider provider = Provider.of<ConversationProvider>(context, listen: false);
                                await provider.getAvailableTime();
                                // 体验到期（不在体验期或者当天体验时间为0）
                                if (provider.isVip == 0 && (!provider.hasFreeUsage || provider.availableTime == 0)) {
                                  closeProgress();
                                  _showTimeOutBottomSheet();
                                  return;
                                }
                                // 会员到期
                                if (provider.isVip == 2) {
                                  closeProgress();
                                  _showTimeOutBottomSheet();
                                  return;
                                }
                                // 无使用时间（会员）
                                if (provider.isVip == 1 && provider.availableTime == 0) {
                                  closeProgress();
                                  _showTimeOutBottomSheet();
                                  return;
                                }
                                closeProgress();
                                conversationWithTeacher(teacher);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 28, right: 28),
                                height: 47.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: ImageUtils.getAssetImage(
                                            "purchase_btn_img"),
                                        fit: BoxFit.fill)),
                                child: Center(
                                  child: Text(
                                    teacher != null ? '与${teacher.name}对话' : '刷新加载',
                                    style: const TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                ),
                              )),
                        ))
                  ],
                ),
              ));
        },
      ),
    ));
  }

  //选择老师的弹窗
  void _showBottomSheet() {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        constraints: const BoxConstraints(
          maxHeight: 533,
        ),
        builder: (_) => const RecommendTeacherWidget(),
    );
  }

  //体验期结束的弹窗
  void _showTimeOutBottomSheet() {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (_) => Consumer<ConversationProvider>(builder: (_, provider, __) {
          Widget title = Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Text(
              provider.isVip == 0 ? "体验到期, 与你的专属AI外教开启学习之旅" : (provider.isVip == 2 ? "会员到期，邀请您继续一路同行" : "您的时长已用完"),
              style: TextStyle(
                  color: Colours.color_111B44,
                  fontSize: Dimens.font_sp22),
            ),
          );

          Widget tip = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Text(
                  provider.isVip == 0 ? "新用户可免费试用3天，每天15分钟" : "您购买的会员已到期",
                  style: TextStyle(
                      color: Colours.color_546092,
                      fontSize: Dimens.font_sp13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Text(
                  provider.isVip == 0 ? (provider.hasFreeUsage ? "今天赠送的体验时长已经使用完成" : "赠送的体验时长已全部使用完成") : "续费会员，继续畅享所有功能",
                  style: TextStyle(
                      color: Colours.color_546092,
                      fontSize: Dimens.font_sp13),
                ),
              ),
              if (provider.isVip == 0)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Text(
                    "升级会员后，可畅享所有功能。",
                    style: TextStyle(
                        color: Colours.color_546092,
                        fontSize: Dimens.font_sp13),
                  ),
                ),
            ],
          );

          Widget desc = Container(
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
          );

          Widget button = Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  NavigatorUtils.goBack(context);
                  // NavigatorUtils.push(context, PersonalRouter.personalPurchase);
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
                  child:  Text(
                    provider.isVip == 0 ? "查看会员升级方案" : (provider.isVip == 2 ? "会员续费" : "去购买"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.font_sp18),
                  ),
                  // ),
                ),
              ));

          return Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colours.color_300EF4D1,
                            Colours.color_3053C5FF,
                            Colours.color_30E0AEFF,
                          ],
                          stops: [0.0, 0.4, 1.0],
                        ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        title,
                        if (provider.isVip != 1)
                          ...[
                            tip,
                            desc,
                          ],
                        Gaps.vGap15,
                        button,
                        Gaps.vGap24,
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
    );
  }

  @override
  HomePagePresenter createPresenter() {
    _homePagePresenter = HomePagePresenter();
    return _homePagePresenter;
  }

  void _showSelectMenu() {
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    showPopupWindow<void>(
      context: context,
      isShowBg: false,
      offset: Offset(button.size.width+12 , -28.0),
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
          style:  TextStyle(
              fontSize: Dimens.font_sp14, color: Colours.color_111B44),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // void _showUpdateDialog() {
  //   showDialog<void>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => const UpdateDialog()
  //   );
  // }





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
}
