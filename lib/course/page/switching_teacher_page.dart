import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/item/switching_teacher_item.dart';
import 'package:Bubble/course/presenter/switching_teacher_page_presenter.dart';
import 'package:Bubble/course/view/switching_teacher_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/resources.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        color: Colors.transparent,
        // color: Colors.black,
        child: Column(
          children: [
            Gaps.vGap60,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadAssetImage(
                    'reminder_close',
                    width: 32.0,
                    height: 32.0,
                  ),
                ],
              ),
            ),
            Gaps.vGap10,
            Container(
                padding: const EdgeInsets.all(10),
                width: _screenUtil.screenWidth,
                height: 50,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "选择一位你喜欢的老师学习吧！",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                )),
            // Container(
            //     width: _screenUtil.screenWidth,
            //     height: 50,
            //     color: Colors.black,
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         LoadAssetImage(
            //           "nv_sele_icon",
            //           width: 72.0,
            //           height: 40.0,
            //         ),
            //         LoadAssetImage(
            //           "nan_nor_icon",
            //           width: 72.0,
            //           height: 40.0,
            //         )
            //       ],
            //     )),
            Expanded(
              child: Container(
                  // width: _screenUtil.screenWidth,
                  color: Colors.black,
                  child: GridView.builder(
                    itemBuilder: (ctx, index) {
                      return SwitchingTeacherItem(
                        data: teacherData[index],
                      );
                    },
                    itemCount: teacherData.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        childAspectRatio: (_screenUtil.screenWidth / 2 - 20) /
                            (_screenUtil.screenWidth / 2 + 30)),
                  )),
            ),
          ],
        ));
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
