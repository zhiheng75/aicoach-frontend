import 'package:Bubble/exam/entity/exam_step_bean.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/exam/presenter/mock_examination_page_presenter.dart';
import 'package:Bubble/exam/view/mock_examination_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/change_notifier_manage.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/my_alert.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class MockExaminationOnePage extends StatefulWidget {
  final int state;
  const MockExaminationOnePage({super.key, required this.state});

  @override
  State<MockExaminationOnePage> createState() => _MockExaminationOnePageState();
}

class _MockExaminationOnePageState extends State<MockExaminationOnePage>
    with
        BasePageMixin<MockExaminationOnePage, ExamExaminationPagePresenter>,
        AutomaticKeepAliveClientMixin<MockExaminationOnePage>
    implements MockExaminationView {
  // CancelToken? _cancelToken; // 取消令牌

  late BuildContext bcontext;

  late ExamExaminationPagePresenter _examExaminationPagePresenter;
  late String ZHText = "";
  late String ENText = "";
  late String instructionsAudio = "";

  final MediaUtils _mediaUtils = MediaUtils();
  int next = 1;

  Widget numberWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_s_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "1",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "2",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "3",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "4",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );

  ///返回事件
  void onBack() {
    myAlert.showAlert(bcontext,
        title: "离开考场",
        content: "模拟考试进行中,\n请尽可能一次性完成整场模拟考试", clickCallback: (index, text) {
      if (index == 1) {
        next = 2;
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    next = 1;
    // _cancelToken = CancelToken(); // 创建取消令牌
  }

  @override
  void dispose() {
    // _cancelToken!.cancel(); // 取消延迟操作
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bcontext = context;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Stack(
        children: [
          const LoadImage(
            "teacher",
            holderImg: "teacher",
            // height: double.infinity,
            // width: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Gaps.vGap50,
              Row(
                children: [
                  NavigationBackWidget(onBack: onBack),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 100,
                  ),
                  // numberWidget,
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     // NavigatorUtils.push(
              //     //   context,
              //     //   replace: true,
              //     //   ExamRouter.mockExaminationendTwoPage,

              //     // );
              //     NavigatorUtils.push(
              //       context,
              //       replace: true,
              //       ExamRouter.mockExaminationTwoPage,
              //     );
              //   },
              //   child: const Text(
              //     "下一步",
              //     style: TextStyle(
              //         color: Colours.color_0047FF,
              //         fontSize: 20,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
              const Expanded(child: Gaps.empty),
              Container(
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.85),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ENText,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colours.color_FFF5BF,
                        ),
                      ),
                      Gaps.vGap8,
                      Text(
                        ZHText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Gaps.vGap10,
                    ],
                  )),
            ],
          )
        ],
      )),
    );
  }

  @override
  ExamExaminationPagePresenter createPresenter() {
    _examExaminationPagePresenter = ExamExaminationPagePresenter();
    return _examExaminationPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(ExamStepBean examStepBean) {
    // TODO: implement sendSuccess
    Log.e("examStepBean.data.id.toString()");
    Log.e(examStepBean.data.id.toString());
    ZHText = examStepBean.data.introduction.zh;
    ENText = examStepBean.data.introduction.en;
    instructionsAudio = examStepBean.data.introduction.instructions;

    _mediaUtils.play(
      url: examStepBean.data.introduction.audio,
      whenFinished: () {
        _mediaUtils.play(
          url: examStepBean.data.introduction.instructionsAudio,
          whenFinished: () {
            if (next == 2) {
              return;
            }
            // _bottomBarControll.setDisabled(false);
            // if (!_cancelToken!.isCancelled) {
            showToast("恭喜你，该环节已完成，即将进入下一考试环节");
            // }

            Future.delayed(const Duration(seconds: 2), () {
              //   // // 强制横屏
              //   // SystemChrome.setPreferredOrientations([
              //   //   DeviceOrientation.landscapeLeft,
              //   //   // DeviceOrientation.landscapeRight
              //   // ]);
              // if (!_cancelToken!.isCancelled) {
              NavigatorUtils.push(
                  context,
                  replace: true,
                  "${ExamRouter.mockExaminationTwoPage}?state=${widget.state}",
                  arguments: examStepBean);
              // }
            });
          },
        );

        // if (next == 2) {
        //   return;
        // }
        // // _bottomBarControll.setDisabled(false);
        // // if (!_cancelToken!.isCancelled) {
        // showToast("恭喜你，该环节已完成，即将进入下一考试环节");
        // // }

        // Future.delayed(const Duration(seconds: 2), () {
        //   //   // // 强制横屏
        //   //   // SystemChrome.setPreferredOrientations([
        //   //   //   DeviceOrientation.landscapeLeft,
        //   //   //   // DeviceOrientation.landscapeRight
        //   //   // ]);
        //   // if (!_cancelToken!.isCancelled) {
        //   NavigatorUtils.push(
        //       context,
        //       replace: true,
        //       "${ExamRouter.mockExaminationTwoPage}?state=${widget.state}",
        //       arguments: examStepBean);
        //   // }
        // });
      },
    );
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
