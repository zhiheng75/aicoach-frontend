import 'package:Bubble/changeRole/presenter/change_role_presenter.dart';
import 'package:Bubble/changeRole/view/change_role_view.dart';
import 'package:Bubble/changeRole/widget/recommend_teacher2_widget.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    with BasePageMixin<ChangeRolePage, ChangeRolePresenter>,

AutomaticKeepAliveClientMixin<ChangeRolePage>
implements
    ChangeRoleView{

  late ChangeRolePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Stack(
            children: [
              const LoadAssetImage("change_role_bg_img"),
              Positioned(
                top: 35,
                child: IconButton(
                  onPressed: () {
                    NavigatorUtils.goBack(context);
                  },
                  padding: const EdgeInsets.all(12.0),
                  icon: Image.asset(
                    "assets/images/ic_back_black.png",
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: ScreenUtil.getScreenW(context),
                margin: const EdgeInsets.only(top: 240),
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
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              //设置列数
                              crossAxisCount: 3,
                              //设置横向间距
                              crossAxisSpacing: 10,
                              //设置主轴间距
                              mainAxisSpacing: 20,
                              mainAxisExtent: 180,
                            ),
                            itemBuilder: (BuildContext ctx, int index) {
                              return RecommendTeacherWidget2(_presenter.allTeacher[index], () {
                                for(int i = 0;i<_presenter.allTeacher.length;i++){
                                  _presenter.allTeacher[i].isSelect = false;
                                }
                                _presenter.allTeacher[index].isSelect = true;
                                setState(() {

                                });
                              });
                            })
                    ),
                    Gaps.vGap15,
                    GestureDetector(
                      onTap: (){
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
