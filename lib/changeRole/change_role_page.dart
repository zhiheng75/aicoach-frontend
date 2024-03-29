import 'package:Bubble/changeRole/presenter/change_role_presenter.dart';
import 'package:Bubble/changeRole/view/change_role_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';
import 'package:Bubble/home/provider/selecter_teacher_provider.dart';
import 'package:Bubble/home/widget/teacher_widget.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_data.dart';
import 'package:Bubble/widgets/load_fail.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../net/http_api.dart';
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
  final cancelToken = CancelToken();
  // 状态 loading-加载中 success-成功 fail-失败
  String state = 'loading';
  List<TeachListEntity> allTeacher = [];

  void init() {
    state = 'loading';
    setState(() {});
    DioUtils.instance.requestNetwork<ResultData>(
        Method.get,
        HttpApi.teacherList,
        cancelToken: cancelToken,
        onSuccess: (result) {
          if (result != null && result.code == 200) {
            if (result.data != null && result.data is List) {
              List<dynamic> list = result.data as List;
              allTeacher = list.map((item) => TeachListEntity.fromJson(item)).toList();
              state = 'success';
            }
          } else {
            state = 'fail';
          }
          setState(() {});
        },
        onError: (code, msg) {
          state = 'fail';
          setState(() {});
        }
    );
  }

  @override
  void initState() {
    super.initState();
    init();
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

        Widget content = const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadData(),
            ],
          ),
        );
        if (state == 'fail') {
          content = Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoadFail(
                  reload: init,
                )
              ],
            ),
          );
        }
        if (state == 'success') {
          content = allTeacher.isNotEmpty ? Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: allTeacher.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //设置列数
                    crossAxisCount: 3,
                    //设置横向间距
                    crossAxisSpacing: 12,
                    //设置主轴间距
                    mainAxisSpacing: 13,
                    mainAxisExtent: 173,
                  ),
                  itemBuilder: (BuildContext ctx, int index) {
                    TeachListEntity item = allTeacher.elementAt(index);
                    return TeacherWidget(
                      teacher: item,
                      selected: item.characterId == provider.selectedTeacher?.characterId,
                      onTap: (teacher) {
                        provider.chooseTeacher(teacher);
                      },
                    );
                  })
          ) : const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadAssetImage(
                  'no_data',
                  width: 80.0,
                  height: 80.0,
                ),
              ],
            ),
          );
        }

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
                    top: 62.0,
                    left: 28.0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        NavigatorUtils.goBack(context);
                      },
                      child: const LoadAssetImage(
                        'ic_back_white',
                        width: 10.0,
                        height: 17.0,
                      ),
                    ),
                  ),
                  Container(
                      width: ScreenUtil.getScreenW(context),
                      margin: const EdgeInsets.only(top: 230),
                      padding: const EdgeInsets.only(
                        left: Dimens.gap_dp28,
                        right: Dimens.gap_dp28,
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(27),
                              topRight: Radius.circular(27)),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                if (state == 'success' && allTeacher.isNotEmpty)
                                  Gaps.vGap26,
                                content,
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                  height: 47,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: ImageUtils.getAssetImage(
                                              "purchase_btn_img"),
                                          fit: BoxFit.fill)),
                                  child: const Center(
                                    child: Text(
                                      "确定",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.vGap33,
                            ],
                          ),
                        ],
                      ),
                  )
                ],
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  ChangeRolePresenter createPresenter() {
    _presenter = ChangeRolePresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;
}
