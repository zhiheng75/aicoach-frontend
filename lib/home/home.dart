import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spokid/home/presenter/home_page_presenter.dart';
import 'package:spokid/home/provider/selecter_teacher_provider.dart';
import 'package:spokid/home/view/home_view.dart';
import 'package:spokid/home/widget/main_page_select_menu.dart';
import 'package:spokid/home/widget/recommend_teacher_widget.dart';
import 'package:spokid/res/dimens.dart';
import 'package:spokid/routers/fluro_navigator.dart';
import 'package:spokid/setting/setting_router.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../res/gaps.dart';
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
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colours.color_00FFB4,
              Colours.color_0E90FF,
              Colours.color_DA2FFF,
            ],
          ),
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
                top: 68,
                child: TextButton(
                  key: _buttonKey,
                  onPressed: () {
                    _showSelectMenu();
                  },
                  child: const Text(
                    "设置",
                    style: TextStyle(fontSize: 14, color: Colours.bg_color),
                  ),
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
                      alignment: Alignment.center,
                      width: 300,
                      height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
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
                      child:const Text(
                        "和Andy对话",
                        style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp18),
                      ),
                      // ),
                    ),
                  ),
                ))
          ],
        ),
      )),
    ));
  }

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
                    borderRadius:BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colours.color_0EF4D1,
                        Colours.color_53C5FF,
                        Colours.color_E0AEFF,
                      ],
                    )),
                child:Column(
                  children: [
                    Padding(
                      padding:const EdgeInsets.only(left: 20, right: 20,top: 20),
                      child: Row(
                        children: [
                        const  Text(
                            "选择自己喜欢的老师",
                            style: TextStyle(
                                color: Colours.color_111B44,
                                fontSize: Dimens.font_sp15),
                          ),
                         const Expanded(child: Gaps.empty),
                          GestureDetector(
                            onTap: (){
                              NavigatorUtils.goBack(context);
                            },
                            child:const LoadAssetImage(
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 10),
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
                    )
                        ),

                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: (){
                            NavigatorUtils.goBack(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 300,
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
                              "确定",
                              style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp18),
                            ),
                            // ),
                          ),
                        )),
                    Gaps.vGap24,
                  ],
                ) ,
              )
                ;
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

  @override
  void setTeachList(List<SelectTeacherEntity> list) {
    allTeacher.clear();
    allTeacher.addAll(list);
    // _showBottomSheet();
    // setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
