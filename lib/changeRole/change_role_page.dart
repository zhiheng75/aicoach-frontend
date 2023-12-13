import 'package:Bubble/changeRole/presenter/change_role_presenter.dart';
import 'package:Bubble/changeRole/view/change_role_view.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';
import 'package:Bubble/home/provider/selecter_teacher_provider.dart';
import 'package:Bubble/home/widget/teacher_widget.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../res/dimens.dart';
import '../routers/fluro_navigator.dart';
import '../util/image_utils.dart';
import '../widgets/load_image.dart';

class ChangeRolePage extends StatefulWidget {
  const ChangeRolePage({Key? key}) : super(key: key);

  @override
  State<ChangeRolePage> createState() => _ChangeRolePageState();
}

class _ChangeRolePageState extends State<ChangeRolePage>
    with BasePageMixin<ChangeRolePage, ChangeRolePresenter>, AutomaticKeepAliveClientMixin<ChangeRolePage> implements ChangeRoleView {

  late ChangeRolePresenter _presenter;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<HomeTeacherProvider>(context, listen: false).chooseTeacher(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeTeacherProvider>(
      builder: (_, provider, __) {
        final Size size = MediaQuery.of(context).size;
        return AnnotatedRegion(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              body: Stack(
                children: [
                  LoadAssetImage(
                    "change_role_bg_img",
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 45.0,
                    left: 16.0,
                    child: GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                      },
                      child: IconButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final isBack = await Navigator.maybePop(context);
                          if (!isBack) {
                            await SystemNavigator.pop();
                          }
                        },
                        icon: Image.asset(
                          'assets/images/ic_back_white.png',
                          width: 10,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: ScreenUtil.getScreenW(context),
                      margin: const EdgeInsets.only(top: 221),
                      padding: const EdgeInsets.only(
                        left: Dimens.gap_dp20,
                        right: Dimens.gap_dp20,
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white),
                      child:
                      Column(
                        children: [
                          Expanded(
                              child: GridView.builder(
                                  itemCount: _presenter.allTeacher.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    //设置列数
                                    crossAxisCount: 3,
                                    //设置横向间距
                                    crossAxisSpacing: 10,
                                    //设置主轴间距
                                    mainAxisSpacing: 20,
                                    mainAxisExtent: 180,
                                  ),
                                  itemBuilder: (BuildContext ctx, int index) {
                                    TeachListEntity item = _presenter.allTeacher.elementAt(index);
                                    return TeacherWidget(
                                      teacher: item,
                                      selected: item.characterId == provider.selectedTeacher?.characterId,
                                      onTap: (teacher) {
                                        provider.chooseTeacher(teacher);
                                      },
                                    );
                                  })
                          ),
                          Gaps.vGap15,
                          GestureDetector(
                            onTap: () {
                              if (provider.selectedTeacher == null) {
                                Toast.show(
                                  '请选择老师',
                                  duration: 1000,
                                );
                                return;
                              }
                              provider.updateTeacher();
                              NavigatorUtils.goBack(context);
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
                            ),
                          )
                          ,
                          Gaps.vGap15,
                        ],
                      )
                  )
                ],
              ),
            ));
      },
    );
  }

  @override
  ChangeRolePresenter createPresenter() {
    _presenter = ChangeRolePresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setTeachList(List<TeachListEntity> list) {
    setState(() {
    });
  }
}
