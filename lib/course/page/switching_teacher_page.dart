import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/item/switching_teacher_item.dart';
import 'package:Bubble/course/presenter/switching_teacher_page_presenter.dart';
import 'package:Bubble/course/view/switching_teacher_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchingTeacherPage extends StatefulWidget {
  const SwitchingTeacherPage({super.key});

  @override
  State<SwitchingTeacherPage> createState() => _SwitchingTeacherPageState();
}

class _SwitchingTeacherPageState extends State<SwitchingTeacherPage>
    with
        BasePageMixin<SwitchingTeacherPage, SwitchingTeacherPagePresenter>,
        AutomaticKeepAliveClientMixin<SwitchingTeacherPage>
    implements SwitchingTeacherPageView {
  final ScreenUtil _screenUtil = ScreenUtil();

  late SwitchingTeacherPagePresenter _switchingTeacherPagePresenter;

  late List<Datum> teacherData = [];
  late int idx = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "选择外教角色",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GridView.builder(
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        idx = index;
                      });
                    },
                    child: SwitchingTeacherItem(
                      data: teacherData[index],
                      isSele: idx == index ? true : false,
                    ),
                  );
                },
                itemCount: teacherData.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: (_screenUtil.screenWidth / 2 - 20) /
                        (_screenUtil.screenWidth / 2 + 30)),
              ),
              Positioned(
                  bottom: 0,
                  left: (_screenUtil.screenWidth - 160) / 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      EventBus().emit(NotificationUtils.teachIdx, idx);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50.0,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: const Color(0xFFF8F8F8),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colours.color_8256FF,
                            Colours.color_FF5CDB,
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '确定',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SwitchingTeacherPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _switchingTeacherPagePresenter = SwitchingTeacherPagePresenter();
    return _switchingTeacherPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(CharacterListBean characterListBean) {
    // TODO: implement sendSuccess
    setState(() {
      teacherData.addAll(characterListBean.data);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
