import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/item/switching_teacher_item.dart';
import 'package:Bubble/course/presenter/switching_teacher_page_presenter.dart';
import 'package:Bubble/course/view/switching_teacher_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sp_util/sp_util.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    idx = int.parse(SpUtil.getString(Constant.teacherId) ?? "0");
    EventUMStatistics.umengCommonPageCollectionModeAuto();
    EventUMStatistics.umengCommonOnPageStart("【AI外教选择】页面停留时长");
  }

  void onBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    MediaUtils().stopPlay();
    EventUMStatistics.umengCommonOnPageEnd("【AI外教选择】页面停留时长");
  }

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
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                bottom: 0,
                child: GridView.builder(
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          idx = index;
                        });
                        EventUMStatistics.umengCommonMapEvent(
                            "外教选择页点击某一外教角色的次数");
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
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: (_screenUtil.screenWidth / 2 - 20) /
                          (_screenUtil.screenWidth / 2 + 30)),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: LoadAssetImage(
                    'mengban_img',
                    fit: BoxFit.cover,
                    height: 65,
                    width: _screenUtil.screenWidth,
                  )),
              Positioned(
                  bottom: 0,
                  left: (_screenUtil.screenWidth - 200) / 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      EventBus().emit(NotificationUtils.teachIdx, idx);
                      Navigator.of(context).pop();
                      EventUMStatistics.umengCommonMapEvent("外教选择页点击确定按钮的次数");
                    },
                    child: const LoadAssetImage(
                      'teach_con_img',
                      fit: BoxFit.cover,
                      width: 200,
                      height: 77.27,
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
