import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/exam_permission_bean.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/exam/page/mock_test_purchase_page.dart';
import 'package:Bubble/exam/view/bar_chart.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/report/report_router.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import 'exam_purchase.dart';
import 'presenter/exam_page_presenter.dart';
import 'view/exam_view.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage>
    with
        BasePageMixin<ExamPage, ExamPagePresenter>,
        AutomaticKeepAliveClientMixin<ExamPage>
    implements ExamView {
  late ExamPagePresenter _examPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // late HomeProvider _homeProvider;
  String _type = 'ket';

  // late bool isExam = true;

  late int number = 0;

  List<String> ketDescList = [
    '1V1真实还原考试全流程',
    '详细讲解考试流程和注意事项',
    '全方位展示和练习真实考试的各种情况',
    '严格按照评分标准和评分体系进行评分',
  ];
  List<String> petDescList = [
    '1V1真实还原考试全流程',
    '详细讲解考试流程和注意事项',
    '全方位展示和练习真实考试的各种情况',
    '严格按照评分标准和评分体系进行评分',
  ];
  late String phone = "";

  // Future getExamPermission() {
  //   final Map<String, String> params = <String, String>{};

  //   return requestNetwork<ResultData>(Method.get,
  //       url: HttpApi.examPermission,
  //       queryParameters: params,
  //       isShow: true, onSuccess: (result) {
  //     Map<String, dynamic> examPermissionMap = json.decode(result.toString());
  //     ExamPermissionBean examPermissioBean =
  //         ExamPermissionBean.fromJson(examPermissionMap);
  //     Log.e("=============");
  //     Log.e(examPermissioBean.data.leftTime.toString());
  //     Log.e("=============");

  //     if (examPermissioBean != null) {
  //       view.sendSuccess(
  //           examPermissioBean.data.leftTime, examPermissioBean.data.status);
  //     } else {
  //       view.sendFail("");
  //     }
  //   }, onError: (code, msg) {
  //     view.sendFail("");
  //   });
  // }

  void getStudyInfo() {
    final Map<String, String> params = <String, String>{};

    _examPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.examPermission,
        queryParameters: params,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Map<String, dynamic> examPermissionMap = json.decode(result.toString());
      ExamPermissionBean examPermissioBean =
          ExamPermissionBean.fromJson(examPermissionMap);
      Log.e("=============");
      Log.e(examPermissioBean.data.leftTime.toString());
      Log.e("=============");
      number = examPermissioBean.data.leftTime;
      setState(() {});
    }, onError: (code, msg) {});
  }

// 防止二次点击
  DateTime? _lastTime;
  preventDoubleTap({required int interval}) {
    DateTime _nowTime = DateTime.now();
    if (_lastTime == null ||
        _nowTime.difference(_lastTime!) >
            Duration(milliseconds: interval ?? 6000)) {
      _lastTime = _nowTime;
      return true;
    } else {
      _lastTime = _nowTime;
      return false;
    }
  }

  void startExam() {
    // isExam = true;
    if (LoginManager.isLogin()) {
      if (!preventDoubleTap(interval: 10000)) {
        //  toast('请勿重复点击');
        return;
      }
      stopVoice();
      _examPagePresenter.getExamPermission();
    } else {
      Toast.show("请登录");
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      if (LoginManager.isLogin()) {
        Map<String, dynamic> user = LoginManager.getUserInfo();
        if (validateInput(user['phone'])) {
          phone = user['phone'];
        }
      } else {
        phone = "17001234567";
      }
    });

    // _examPagePresenter.getExamPermission();

    // _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    getStudyInfo();
  }

  void stopVoice() async {
    await MediaUtils().stopPlay();
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Widget barItem(String label, String type) {
    //   bool isSelected = _type == type;
    //   return GestureDetector(
    //     behavior: HitTestBehavior.opaque,
    //     onTap: () {
    //       if (isSelected) {
    //         return;
    //       }
    //       _type = type;
    //       setState(() {});
    //     },
    //     child: Container(
    //       width: 88.0,
    //       height: 34.0,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(40.0),
    //         color:
    //             isSelected ? const Color(0xFF007AFF) : const Color(0xFFF3F5F7),
    //       ),
    //       alignment: Alignment.center,
    //       child: Text(
    //         label,
    //         style: TextStyle(
    //           fontSize: 15.0,
    //           fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
    //           color: isSelected ? Colors.white : Colours.color_999999,
    //           height: 20.0 / 15.0,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // Widget tabbar = Padding(
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: 16.0,
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       barItem('KET', 'ket'),
    //       const SizedBox(
    //         width: 10.0,
    //       ),
    //       barItem('PET', 'pet'),
    //     ],
    //   ),
    // );

    Widget descItem(String desc) {
      return Row(
        children: <Widget>[
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colours.color_999999,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 20.0 / 15.0,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      );
    }

    List<Widget> descChildren = [];
    List<String> descList = _type == 'ket' ? ketDescList : petDescList;
    for (int i = 0; i < descList.length; i++) {
      descChildren.add(descItem(descList.elementAt(i)));
      if (i < descList.length - 1) {
        descChildren.add(const SizedBox(
          height: 20.0,
        ));
      }
    }

    Widget desc = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Container(
        width: _screenUtil.screenWidth - 32.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/exam_bg.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 24.0,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              '模拟考试介绍',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 28.0,
            ),
            SizedBox(
              width: 280.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: descChildren,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  const LoadAssetImage(
                    'exam_desc_icon',
                    width: 32.0,
                    height: 32.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '适合人群：备课${_type == 'ket' ? 'KET' : 'PET'}的学生\n考试时长：25分钟 可免费体验1次',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 20.0 / 15.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget titleBar() {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          // tabbar,
          // SizedBox(
          //   height: 12.0,
          // ),
        ],
      );
    }

    Widget score = Container(
      // width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.85),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 48.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colours.color_51D6FF,
                    ),
                    width: 8,
                    height: 8,
                  ),
                  Gaps.hGap6,
                  const Text(
                    '5发音',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Gaps.vGap2,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colours.color_FF71CF,
                    ),
                    width: 8,
                    height: 8,
                  ),
                  Gaps.hGap6,
                  const Text(
                    '5互动',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Gaps.vGap2,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colours.color_E8CCFE,
                    ),
                    width: 8,
                    height: 8,
                  ),
                  Gaps.hGap6,
                  const Text(
                    '4语法词汇',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Gaps.vGap2,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colours.color_8E30FF,
                    ),
                    width: 8,
                    height: 8,
                  ),
                  Gaps.hGap6,
                  const Text(
                    '4整体得分',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.hGap16,
          const SizedBox(
            width: 20.0,
          ),
          Container(
            width: 128.0,
            height: 128.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/caihuan.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${76}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 37.5 / 32.0,
                  ),
                ),
                Text(
                  '  总分',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 14.0 / 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget typeDecoration = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((_screenUtil.screenWidth - 32.0) / 3 - 5) / 2),
            color: Colours.color_E8CCFE,
          ),
          width: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          height: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "B",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Grade",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 2.5,
                      // letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Text(
                "KET证书等级",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Gaps.hGap5,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((_screenUtil.screenWidth - 32.0) / 3 - 5) / 2),
            color: Colours.color_C1EBF7,
          ),
          width: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          height: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "121",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Text(
                "剑桥考试成绩",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Gaps.hGap5,
        Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((_screenUtil.screenWidth - 32.0) / 3 - 5) / 2),
            color: Colours.color_DDF3D2,
          ),
          width: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          height: (_screenUtil.screenWidth - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A2",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Text(
                "欧洲语言共同参考标准",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    List<String> xData = [
      "语法与词汇",
      "发音",
      "互动",
      "整体得分",
    ];
    List<double> peopleData = [
      85,
      45,
      65,
      25,
    ];
    List<Color> colorData = [
      Colours.color_51D8FF,
      Colours.color_FF71CF,
      Colours.color_8E30FF,
      Colours.color_E8CCFE,
    ];

    Widget contentBar() {
      return Container(
        width: double.infinity,
        // height: double.infinity,
        // color: Colors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Gaps.vGap8,
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoadAssetImage(
                  'zhuangshi_zuo',
                  width: 16.0,
                  height: 16.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Text(
                    '评测报告示例',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ),
                LoadAssetImage(
                  'zhuangshi_you',
                  width: 16.0,
                  height: 16.0,
                ),
              ],
            ),
            Gaps.vGap8,
            score,
            Gaps.vGap8,
            typeDecoration,
            Gaps.vGap10,
            BarChart(xData, peopleData, colorData),
            Gaps.vGap8,
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colours.color_CDEDF4,
                ),
                child: Column(
                  children: [
                    const Text(
                      "您的成绩还不错，口语模考达到了剑桥KET考试的Grade B水平。",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.vGap8,
                    RichText(
                        // RichText
                        text: const TextSpan(
                            text: '建议考前再练习',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: '10',
                              style: TextStyle(
                                color: Colours.color_FF00A8,
                                fontSize: 20.0,
                              )),
                          TextSpan(
                              text: '次模拟考试，争取达到Grade B+水平，加油宝贝！',
                              style: TextStyle(fontSize: 15)),
                        ])),
                  ],
                )),
            Gaps.vGap8,
          ],
        ),
      );
    }

    Widget body() {
      return Column(
        children: [
          desc,
          Gaps.vGap10,
          contentBar(),
          Gaps.vGap10,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: startExam,
                child: Container(
                  width: 231.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Colours.color_001652,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colours.color_9AC3FF,
                        Colours.color_FF71E0,
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'KET口语模考',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_001652,
                    ),
                  ),
                ),
              ),
              Gaps.vGap10,
              GestureDetector(
                onTap: () {
                  if (LoginManager.isLogin()) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.transparent,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (_) => ExamPurchasePage(
                        onPurchased: () {},
                      ),
                    );
                  } else {
                    Toast.show("请登录");
                  }
                },
                child: phone == "17001234567"
                    ? Container()
                    : Container(
                        width: 231.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.black.withOpacity(0.85),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "购买模考训练包",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "剩余训练次数：",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "$number次",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colours.color_FF71CF,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              )
            ],
          ),
          Gaps.vGap30,
        ],
      );
    }

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/mkbg.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        // color: Colours.color_001652.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            titleBar(),
            Expanded(child: SingleChildScrollView(child: body())),
          ],
        ));
  }

  @override
  ExamPagePresenter createPresenter() {
    _examPagePresenter = ExamPagePresenter();
    return _examPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(int leftTime, int state) {
    // setState(() {
    //   number = leftTime;
    // });

    // if (leftTime > 0) {
    NavigatorUtils.push(
      context,
      // ExamRouter.mockExaminationOnePage,
      "${ExamRouter.mockExaminationOnePage}?state=$state",
    );
    // } else {
    //   showModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     barrierColor: Colors.transparent,
    //     isScrollControlled: true,
    //     isDismissible: false,
    //     builder: (_) => ExamPurchasePage(
    //       onPurchased: () {},
    //     ),
    //   );
    // }
  }
}
