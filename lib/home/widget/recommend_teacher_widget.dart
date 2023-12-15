import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/widgets/load_data.dart';
import 'package:Bubble/widgets/load_fail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';

import '../../res/dimens.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/image_utils.dart';
import '../../util/toast_utils.dart';
import '../entity/teach_list_entity.dart';
import '../provider/selecter_teacher_provider.dart';
import 'teacher_widget.dart';

class RecommendTeacherWidget extends StatefulWidget {

  const RecommendTeacherWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RecommendTeacherWidget> createState() => _RecommendTeacherWidgetState();
}

class _RecommendTeacherWidgetState extends State<RecommendTeacherWidget> {
  final cancelToken = CancelToken();
  List<TeachListEntity> allTeacher = [];
  // 状态 loading-加载中 fail-失败 success-成功
  String state = 'loading';

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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTeacherProvider>(
      builder: (_, provider, __) {
        Widget child = const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoadData(),
          ],
        );

        if (state == 'fail') {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadFail(
                reload: init,
              )
            ],
          );
        }

        if (state == 'success') {
          child = allTeacher.isNotEmpty ? GridView.builder(
              itemCount: allTeacher.length,
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
                TeachListEntity item = allTeacher.elementAt(index);
                return TeacherWidget(
                  teacher: item,
                  selected: item.characterId == provider.selectedTeacher?.characterId,
                  onTap: (teacher) {
                    provider.chooseTeacher(teacher);
                  },
                );
              }) : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoadAssetImage(
                  'no_data',
                  width: 77.0,
                  height: 77.0,
                  fit: BoxFit.fill,
                ),
              ],
            );
        }

        return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.65,
            expand: false,
            builder: (_, scrollController) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colours.color_300EF4D1,
                              Colours.color_3053C5FF,
                              Colours.color_30E0AEFF,
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
                                  provider.chooseTeacher(null);
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
                              child: child,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                if (provider.selectedTeacher == null) {
                                  Toast.show(
                                    '请选择老师',
                                    duration: 1000,
                                  );
                                  return;
                                }
                                NavigatorUtils.goBack(context);
                                provider.updateTeacher();
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
                  )
                ],
              )

              ;
            });
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
}
