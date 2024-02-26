import 'package:Bubble/exam/entity/exam_detail_bean.dart';
import 'package:Bubble/exam/exam_purchase.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/exam/presenter/exam_detail_page_presenter.dart';
import 'package:Bubble/exam/view/exam_detail_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/widgets/my_alert.dart';

class MockExaminationendOnePage extends StatefulWidget {
  final String mockId;

  const MockExaminationendOnePage({super.key, required this.mockId});

  @override
  State<MockExaminationendOnePage> createState() =>
      _MockExaminationendOnePageState();
}

class _MockExaminationendOnePageState extends State<MockExaminationendOnePage>
    with
        BasePageMixin<MockExaminationendOnePage, ExamDetailPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<MockExaminationendOnePage>
    implements ExamDetailView {
  late BuildContext bcontext;

  late ExamDetailPagePresenter _examDetailPagePresenter;
  late ExamDetailBean _examDetailBean;
  late bool isloading = true;
  late String name = "";
  late String phone = '';

  late String drtailStr = '';

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    MediaUtils().stopPlay();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Map<String, dynamic> user = LoginManager.getUserInfo();

    String userName = '';
    if (validateInput(user['name'])) {
      userName = user['name'];
    } else if (validateInput(user['nickname'])) {
      userName = user['nickname'];
    } else {
      if (validateInput(user['phone'])) {
        phone = user['phone'];
      }
      userName = "用户${phone.toString().substring(7, 11)}";
    }
    name = userName;
    // name = user['nickname'] != ""
    //     ? user['nickname']
    //     : "用户${user['phone'].toString().substring(7, 11)}";

    Future.delayed(const Duration(microseconds: 200), () {
      _examDetailPagePresenter.getExamDetail(widget.mockId);
    });
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

  Widget numberWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
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
              'assets/images/number_s_icon.png',
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
    // myAlert.showAlert(bcontext,
    //     title: "离开考场",
    //     content: "模拟考试进行中,\n请尽可能一次性完成整场模拟考试", clickCallback: (index, text) {
    //   if (index == 1) {
    //   }
    // });\
    Navigator.pop(context);
    EventBus().emit('PAY');
  }

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              const LoadImage(
                "teacher",
                holderImg: "teacher",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  Gaps.vGap50,
                  Row(
                    children: [
                      NavigationBackWidget(onBack: onBack),
                      // NavigationBackWidget(),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 2 - 100,
                      // ),
                      // numberWidget,
                      // GestureDetector(
                      //   onTap: () {
                      //     // NavigatorUtils.push(
                      //     //   context,
                      //     //   ExamRouter.mockExaminationTwoPage,
                      //     // );
                      //   },
                      //   child: const Text(
                      //     "提交",
                      //     style: TextStyle(
                      //         color: Colours.color_0047FF,
                      //         fontSize: 20,
                      //         decoration: TextDecoration.underline),
                      //   ),
                      // ),
                    ],
                  ),
                  Gaps.vGap168,
                  // const Expanded(child: Gaps.empty),
                  isloading
                      ? const Center()
                      : Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(25),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.black.withOpacity(0.85),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      drtailStr,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colours.color_FFF5BF,
                                      ),
                                    ),
                                    Gaps.vGap10,
                                    phone == "17001234567"
                                        ? Container()
                                        : GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                barrierColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                builder: (_) =>
                                                    ExamPurchasePage(
                                                  onPurchased: () {
                                                    EventBus().emit('PAY');
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 231.0,
                                              height: 48.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
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
                                                '点击购买模考训练包',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colours.color_001652,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              )),
                        ),
                ],
              )
            ],
          )),
    );
  }

  @override
  ExamDetailPagePresenter createPresenter() {
    _examDetailPagePresenter = ExamDetailPagePresenter();
    return _examDetailPagePresenter;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(ExamDetailBean examDetailBean) {
    // TODO: implement sendSuccess
    setState(() {
      isloading = false;
      _examDetailBean = examDetailBean;
      drtailStr = _examDetailBean.data.ket == "卓越A"
          ? "Congratulations, your free trial of the KET Speaking simulated exam has come to an end.\n恭喜你，完成了KET模拟考试。\nOur KET PET simulated exams accurately replicate the entire exam process, providing a comprehensive demonstration and practice of various scenarios that occur in real exams. We strictly adhere to the scoring criteria and grading system, predicting the overall score and level, thus providing meticulous support and precise improvement for your exam preparation.\n我们的KET PET模拟考试可以真实还原考试全流程，\n全方位展示和练习真实考试中出现的各种情况，我们会严格按照评分标准和评分体系进行评分，并预测整卷成绩和级别，为您的考试周密护航，精准提升。\nSimulated exam training is a continuous process that allows you to achieve excellent results in your exams.\n模拟考试训练是一项需要持续进行的训练，这样您才可以在考试中取得优异的成绩。\nYour performance is quite good, and your speaking mock exam has reached the Grade B level of the Cambridge KET exam. I suggest practicing 10 more mock exams before the actual test to aim for a Grade A level. Keep up the good work, and best of luck!\n您的成绩还不错，口语模考达到了剑桥KET考试的Grade【${_examDetailBean.data.ket}】水平。\n建议考前继续练习，保持住优异成绩，加油宝贝！"
          : "Congratulations, your free trial of the KET Speaking simulated exam has come to an end.\n恭喜你，完成了KET模拟考试。\nOur KET PET simulated exams accurately replicate the entire exam process, providing a comprehensive demonstration and practice of various scenarios that occur in real exams. We strictly adhere to the scoring criteria and grading system, predicting the overall score and level, thus providing meticulous support and precise improvement for your exam preparation.\n我们的KET PET模拟考试可以真实还原考试全流程，\n全方位展示和练习真实考试中出现的各种情况，我们会严格按照评分标准和评分体系进行评分，并预测整卷成绩和级别，为您的考试周密护航，精准提升。\nSimulated exam training is a continuous process that allows you to achieve excellent results in your exams.\n模拟考试训练是一项需要持续进行的训练，这样您才可以在考试中取得优异的成绩。\nYour performance is quite good, and your speaking mock exam has reached the Grade B level of the Cambridge KET exam. I suggest practicing 10 more mock exams before the actual test to aim for a Grade A level. Keep up the good work, and best of luck!\n您的成绩还不错，口语模考达到了剑桥KET考试的Grade【${_examDetailBean.data.ket}】水平。\n建议考前再练习${_examDetailBean.data.trainCount}次模拟考试，争取达到Grade【${_examDetailBean.data.ketNext}】水平，加油宝贝！";
    });
    _examDetailPagePresenter.getGenerateAudio(drtailStr);
  }

  @override
  void playAendSuccess(String msg) {
    // TODO: implement playAendSuccess
    MediaUtils().play(
      url: msg,
      whenFinished: () {},
    );
  }
}
