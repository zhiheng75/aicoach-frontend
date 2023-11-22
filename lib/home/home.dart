import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spokid/home/presenter/home_page_presenter.dart';
import 'package:spokid/home/provider/selecter_teacher_provider.dart';
import 'package:spokid/home/view/home_view.dart';
import 'package:spokid/home/widget/home_appbar.dart';
import 'package:spokid/home/widget/main_page_select_menu.dart';
import 'package:spokid/home/widget/recommend_teacher_widget.dart';
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
          child: Material(
              color: Colours.bg_color,
              child: Scaffold(
                body: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.push(context, SettingRouter.themePage);
                      },
                      child: LoadAssetImage(
                        "test_banner_img",
                        height: ScreenUtil.getScreenH(context),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        left:50,
                        top: 68,
                        child: TextButton(
                          key: _buttonKey,
                          onPressed: () {
                            _showSelectMenu();
                          },
                          child:const Text(
                            "设置",
                            style: TextStyle(fontSize: 14, color: Colours.bg_color),
                          ),
                        )),
                  ],
                ),
              )),
        ));
  }



  void _showBottomSheet() {
    HomeTeacherProvider provider = HomeTeacherProvider();
    showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.65,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Expanded(
                      child: GridView.builder(
                          itemCount: allTeacher.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            //设置列数
                            crossAxisCount: 3,
                            //设置横向间距
                            crossAxisSpacing: 10,
                            //设置主轴间距
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (BuildContext ctx, int index) {
                            return RecommendTeacherWidget(allTeacher[index],
                                    () {
                                  provider.setSelectIndex(index);
                                }, provider);
                          })),

                  Padding(
                    padding:const EdgeInsets.only(left: 20, right: 20),
                    child: MyButton(
                      minHeight: 40,
                      fontSize: 15,
                      onPressed: () {
                        NavigatorUtils.goBack(context);
                      },
                      text: "确定",
                    ),
                  ),

                  // Container(
                  //
                  //   width: ScreenUtil.getScreenW(context)*0.8,
                  //   child: TextButton(onPressed: () {
                  //     NavigatorUtils.goBack(context);
                  //   }, child: Text("确定")),
                  // ),

                  Gaps.vGap24,
                ],
              );
            }));
  }


  @override
  HomePagePresenter createPresenter() {
    return HomePagePresenter();
  }


  void _showSelectMenu() {
    final RenderBox button = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    showPopupWindow<void>(
      context: context,
      isShowBg: false,
      offset: Offset(button.size.width-100, 0.0),
      anchor: button,
      child:  MainPageSelectMenu((){
        NavigatorUtils.goBack(context);
        _showBottomSheet();
      }),
    );
  }

  @override
  void setTeachList(List<SelectTeacherEntity> list) {
    allTeacher.clear();
    allTeacher.addAll(list);
    _showBottomSheet();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
