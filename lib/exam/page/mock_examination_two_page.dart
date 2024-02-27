import 'dart:async';
import 'dart:convert';

import 'package:Bubble/chat/utils/recognize_util.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/exam_step_bean.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/exam/presenter/mock_examination_two_page_presenter.dart';
import 'package:Bubble/exam/utils/mock_evaluate_util.dart';
import 'package:Bubble/exam/view/mock_examination_two_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Bubble/widgets/my_alert.dart';
import 'package:oktoast/oktoast.dart';

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}

class MockExaminationTwoPage extends StatefulWidget {
  final int state;

  final ExamStepBean entity;

  const MockExaminationTwoPage(
      {super.key, required this.entity, required this.state});

  @override
  State<MockExaminationTwoPage> createState() => _MockExaminationTwoPageState();
}

class _MockExaminationTwoPageState extends State<MockExaminationTwoPage>
    with
        BasePageMixin<MockExaminationTwoPage, MockExaminationTwoPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<MockExaminationTwoPage>
    implements MockExaminationTwoView {
  final MediaUtils _mediaUtils = MediaUtils();
  final RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];

  late MockExaminationTwoPagePresenter _mockExaminationTwoPagePresenter;
  late Map<String, dynamic> upmap;
  late List mockUP = [];
  late String isOne = "1";

//是否正在答题
  late bool isTalk = false;

  late BuildContext bcontext;

  late List<Part1Phase1> mockPart1Phase1 = [];
  late List<Part1Phase1> mockPart1Phase2 = [];
  late List<Part1Phase1> mockPart2Phase1 = [];
  late List<Part1Phase1> mockPart2Phase2 = [];
  late String image = "";
  late String teacherEn = "";
  late String teacherAudio = "";

  //第几步
  late int numberPle = 0;
  // 第几道题
  late int number = 0;

  ///计时器
  Timer? _timer;

  ///当前倒计时秒数
  int? _seconds;

  late String questionAudio;

  late String answerAudio;
  late String bodyType;
  late String mockID;
  late String questionID;
  late String nameName = "";
  late String serverMessage = "";

  //1老师2考伴3考生
  late int soundPrintType = 0;

  late int first = 0;

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  //启动倒计时器
  void _startTimer() {
    if (numberPle == 2 || numberPle == 3) {
      _seconds = 40;
    } else {
      _seconds = 30;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if (_seconds == 0) {
        _timer?.cancel();
        // if (!isTalk) {
        nextMock();
        // }
      }
      setState(() {});
    });
    setState(() {
      mockflow();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
    // OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);

    upmap = <String, dynamic>{};
    upmap['id'] = widget.entity.data.id.toString();
    upmap['status'] = "2";

    Future.delayed(const Duration(seconds: 2), () {
      _mockExaminationTwoPagePresenter.postExamUpdate(upmap);
      upmap['status'] = "1";
    });
    // mockUP.id = widget.entity.data.id.toString();
    Map<String, dynamic> user = LoginManager.getUserInfo();

    String username = '';
    if (validateInput(user['name'])) {
      username = user['name'];
    } else if (validateInput(user['nickname'])) {
      username = user['nickname'];
    } else {
      String phone = '';
      if (validateInput(user['phone'])) {
        phone = user['phone'];
      }
      username = "用户${phone.toString().substring(7, 11)}";
    }
    nameName = username;

    setState(() {
      mockPart1Phase1 = widget.entity.data.part1Phase1;
      mockPart1Phase2 = widget.entity.data.part1Phase2;
      mockPart2Phase1 = widget.entity.data.part2Phase1.list;
      image = widget.entity.data.part2Phase1.base.image;
      mockPart2Phase2 = widget.entity.data.part2Phase2.list;
      teacherEn = widget.entity.data.part2Phase2.base.en;
      teacherAudio = widget.entity.data.part2Phase2.base.audio;
      mockID = widget.entity.data.id.toString();
    });

    _startTimer();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void nextMock() {
    //第一道题
    if (numberPle == 0) {
      if (number < mockPart1Phase1.length - 1) {
        number = number + 1;
      } else {
        showToast(
          "恭喜你，该环节已完成，即将进入下一考试环节",
        );

        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 1) {
      if (number < mockPart1Phase2.length - 1) {
        number = number + 1;
      } else {
        showToast(
          "恭喜你，该环节已完成，即将进入下一考试环节",
        );

        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 2) {
      if (number < mockPart2Phase1.length - 1) {
        number = number + 1;
      } else {
        showToast(
          "恭喜你，该环节已完成，即将进入下一考试环节",
        );
        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 3) {
      if (number < mockPart2Phase2.length - 1) {
        number = number + 1;
      } else {
        numberPle = 0;
        number = 0;
        //去下一个页面
        Log.e("去下一个页面");
        Log.e("去下一个页面==========${upmap.toString()}===");
        _timer?.cancel();
        upmap["answer"] = json.encode(upmap["answer"]);

        _mockExaminationTwoPagePresenter.postExamUpdate(upmap);
        return;
      }
    } else {
      //去下一个页面
      Log.e("去下一个页面");
      Log.e("去下一个页面==========${upmap.toString()}===");
      _timer?.cancel();
      upmap["answer"] = json.encode(upmap["answer"]);

      _mockExaminationTwoPagePresenter.postExamUpdate(upmap);
      return;
    }
    setState(() {});
    _startTimer();
  }

  void mockflow() {
    if (numberPle == 0) {
      bodyType = mockPart1Phase1[number].to;
      questionID = mockPart1Phase1[number].id.toString();
      //老师问
      questionAudio = mockPart1Phase1[number].questionAudio;
      serverMessage = mockPart1Phase1[number].question;
      setState(() {
        soundPrintType = 1;
      });
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
          setState(() {
            soundPrintType = 0;
          });
          //老师问
          if (bodyType == "A") {
            answerAudio = mockPart1Phase1[number].answerAudio!;
            //考伴回答
            mockKlowPlay(answerAudio);
          } else {
            //学生回答//走到倒计时
          }
        },
      );
    } else if (numberPle == 1) {
      bodyType = mockPart1Phase2[number].to;
      questionID = mockPart1Phase2[number].id.toString();
      //老师问
      questionAudio = mockPart1Phase2[number].questionAudio;
      serverMessage = mockPart1Phase2[number].question;
      setState(() {
        soundPrintType = 1;
      });
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
          setState(() {
            soundPrintType = 0;
          }); //老师问
          if (bodyType == "A") {
            answerAudio = mockPart1Phase2[number].answerAudio!;
            //考伴回答
            mockKlowPlay(answerAudio);
          } else {
            //学生回答//走到倒计时
          }
        },
      );
    } else if (numberPle == 2) {
      bodyType = mockPart2Phase1[number].to;
      questionID = mockPart2Phase1[number].id.toString();

      //老师问
      questionAudio = mockPart2Phase1[number].questionAudio;
      serverMessage = mockPart2Phase1[number].question;
      setState(() {
        soundPrintType = 1;
      });
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
          setState(() {
            soundPrintType = 0;
          }); //老师问
          if (bodyType == "A") {
            answerAudio = mockPart2Phase1[number].answerAudio!;
            //考伴回答
            mockKlowPlay(answerAudio);
          } else {
            //学生回答//走到倒计时
          }
        },
      );
    } else if (numberPle == 3) {
      bodyType = mockPart2Phase2[number].to;
      questionID = mockPart2Phase2[number].id.toString();

      questionAudio = teacherAudio;
      serverMessage = teacherEn;

      if (first == 0) {
        setState(() {
          soundPrintType = 1;
          first = 1;
        });
        _mediaUtils.play(
          url: teacherAudio,
          whenFinished: () {
            setState(() {
              soundPrintType = 0;
            }); //老师问
            if (bodyType == "B2A") {}
          },
        );
      } else {
        if (bodyType == "B2A") {}
      }
    }
  }

  void mockKlowStartAnswer() async {
    try {
      // 检查权限
      bool isRequest = await _mediaUtils.checkMicrophonePermission();
      if (isRequest) {
        return;
      }
      // 开始录音
      _bufferList = [];
      _mediaUtils.startRecord(onData: (buffer) {
        _bufferList.add(buffer);
        _recognizeUtil.pushAudioBuffer(1, buffer);
      }, onComplete: (buffer) {
        _recognizeUtil.pushAudioBuffer(2, buffer ?? Uint8List(0));
      });
      // 设置识别
      _recognizeUtil.recognize((result) async {
        bool shoRecord = isTalk;
        // 录音中
        if (shoRecord) {
          // 识别失败
          if (result['success'] == false) {
            isTalk = false;
            await _mediaUtils.stopRecord();
            Toast.show(
              result['message'],
              duration: 1000,
            );
          }
          return;
        }
        if (result['success'] == false) {
          Toast.show(
            result['message'],
            duration: 1000,
          );
          isTalk = false;
          return;
        }
        Log.e("录音后识别的文字${result['text']}");
        sendMessage(result['text']);
      });
      // widget.controller.setShowRecord(true);
      isTalk = true;
    } catch (e) {
      Toast.show(
        e.toString().substring(11),
        duration: 1000,
      );
    }
  }

  void mockKlowEndAnswer() async {
    await _mediaUtils.stopRecord();
    isTalk = false;
    _timer?.cancel();
    Future.delayed(const Duration(seconds: 1), () {
// 抬起按钮
      if (bodyType != "B2A") {
        //掉一个地道表达接口
        nextMock();
      }
    });
  }

  void sendMessage(String text) async {
    insertUserMessage(text, (message) {
      MockEvaluateUtil().evaluate(message, (Map<String, dynamic> map) {
        if (bodyType == "B2A") {
          //掉一个地道表达接口
          suggestAnswer(text, map);
          // _timer?.cancel();
          // nextMock();
        } else {
          mockUP.add(map);
          upmap['answer'] = mockUP;
        }
        //揉数据
        Log.e("完成后的数据=====${map.toString()}======${upmap.toString()}===");
      });
    });
  }

  void suggestAnswer(String message, Map<String, dynamic> map) {
    CancelToken cancelToken = CancelToken();
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.suggestAnswer,
      cancelToken: cancelToken,
      params: {
        'question': message,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        // map['answer_text'] = data['text'];
        // map['answer_audio'] = data['speech_url'];
        mockUP.add(map);
        upmap['answer'] = mockUP;
        // mockUP.answer.add(map);
        // upmap['answer'] = mockUP.answer;
        //考伴回答
        setState(() {
          mockKlowTwoPlay(data['speech_url']);
        });
      },
      onError: (code, msg) {
        _timer?.cancel();
        nextMock();
      },
    );
  }

  void mockKlowTwoPlay(String answerAudio) {
    showConfirmDialog();
    soundPrintType = 2;
    _mediaUtils.play(
      url: answerAudio,
      whenFinished: () {
        showToast("考伴回答完");
        soundPrintType = 0;
        Navigator.pop(context);
        _timer?.cancel();
        nextMock();
      },
    );
  }

  void insertUserMessage(String text, Function(MockMessageEntity) onSuccess) {
    MockMessageEntity message = MockMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    message.sessionId = mockID;
    message.messageId = questionID;
    message.speechfile = "";
    message.serverMessage = serverMessage;
    onSuccess(message);
  }

  void mockKlowPlay(String answerAudio) {
    Future.delayed(const Duration(seconds: 2), () {
      showConfirmDialog();
      setState(() {
        soundPrintType = 2;
      });
      _mediaUtils.play(
        url: answerAudio,
        whenFinished: () {
          showToast("考伴回答完");
          setState(() {
            soundPrintType = 0;
          });
          Navigator.pop(context);
        },
      );
    });
  }

  ///销毁录音
  void dispose() {
    // 强制横屏

    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // _cancelRecorderSubscriptions();
    // _releaseFlauto();
  }

  Widget peopleWidget(String head, bool isVector, String name) {
    return Stack(
      children: [
        LoadAssetImage(
          head,
          width: 140, height: 100,
          // fit: BoxFit.cover
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isVector
                    ? Image.asset(
                        'assets/images/shengbo.gif',
                        width: 35,
                        height: 18,
                        fit: BoxFit.fitWidth,
                      )
                    : Container(),
                Text(name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ],
            ))
      ],
    );

    // return Container(
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         // color: Colors.black,
    //         image: DecorationImage(
    //             image: ImageUtils.getAssetImage("mkbg"), fit: BoxFit.fill)),
    //     width: 140,
    //     height: 100,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         isVector
    //             ? Image.asset(
    //                 'assets/images/shengbo.gif',
    //                 width: 35,
    //                 height: 18,
    //                 fit: BoxFit.fitWidth,
    //               )
    //             : Container(),
    //         Text(name,
    //             style: const TextStyle(
    //               fontSize: 12,
    //               color: Colors.white,
    //             )),
    //       ],
    //     ));
  }

  //说话的框
  showConfirmDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Navigator.pop(context);
            },
            child: const Center(
              child: LoadAssetImage(
                "shengbo_pink",
                width: 147,
                height: 56,
              ),
            ),
          );
        });
  }

//图片的弹窗
  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 480,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const LoadAssetImage(
                      'reminder_close',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
              Gaps.vGap8,
              Stack(
                children: [
                  Center(
                    child: LoadImage(
                      image,
                      width: 512, height: 288,
                      // fit: BoxFit.cover
                    ),
                  ),
                  const Positioned(
                      // top: 0,
                      // right: 0,
                      // left: 0,
                      // height: 32,
                      // width: 512,
                      child: Center(
                    child: SizedBox(
                      width: 512,
                      height: 32,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   color: Colors.white,
                      // ),
                      child: Center(
                        child: Text(
                          "KET模拟考试 Part2 看图对话",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ],
          );
        });
  }

  ///返回事件
  void onBack() {
    myAlert.showAlert(bcontext,
        title: "离开考场",
        content: "模拟考试进行中,\n请尽可能一次性完成整场模拟考试", clickCallback: (index, text) {
      if (index == 1) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Navigator.pop(context);
      }
    });
  }

  Future<bool> _requestPop() async {
    // 调用原生返回，返回原生页面，根据自身场景自己定义处理函数
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print(e);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bcontext = context;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          onBack();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ImageUtils.getAssetImage("splash_bg"),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    XTCupertinoNavigationBar(
                      backgroundColor: const Color(0xFFFFFFFF),
                      border: null,
                      padding: EdgeInsetsDirectional.zero,
                      leading: NavigationBackWidget(onBack: onBack),
                      middle: const Text(
                        "KET考试模拟现场",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      trailing: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      numberPle == 0
                                          ? 'assets/images/number_s_icon.png'
                                          : 'assets/images/number_n_icon.png',
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      numberPle == 1
                                          ? 'assets/images/number_s_icon.png'
                                          : 'assets/images/number_n_icon.png',
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      numberPle == 2
                                          ? 'assets/images/number_s_icon.png'
                                          : 'assets/images/number_n_icon.png',
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      numberPle == 3
                                          ? 'assets/images/number_s_icon.png'
                                          : 'assets/images/number_n_icon.png',
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
                          )),
                    ),
                    Gaps.vGap3,
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              // color: Colors.white,
                              width: 188,
                              height: double.infinity,
                              // margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Gaps.vGap5,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_E8CCFE,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: const Text(
                                        "考官",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap5,
                                  peopleWidget(
                                      "teach_icon",
                                      soundPrintType == 1 ? true : false,
                                      "口语考官：Andy老师"),
                                  Gaps.vGap5,
                                  peopleWidget(
                                      "invigilate_icon", false, "计分考官：Andy老师"),
                                ],
                              ),
                            ),
                            Gaps.hGap5,
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image:
                                          ImageUtils.getAssetImage("splash_bg"),
                                      fit: BoxFit.fill)),
                              width: MediaQuery.of(context).size.width -
                                  188 * 2 -
                                  6.w * 2,
                              // width: double.infinity,

                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Gaps.vGap10,
                                      numberPle == 3
                                          ? Center(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white),
                                                    child: Text(
                                                      " 倒计时: ${_seconds}s ",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Gaps.vGap4,
                                                  Text(
                                                    numberPle == 3
                                                        ? "请提问第${number + 1}个问题"
                                                        : "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Gaps.vGap4,
                                                  GestureDetector(
                                                    onTap: () {
                                                      showImageDialog();
                                                    },
                                                    child: LoadImage(
                                                      image,
                                                      fit: BoxFit.fill,
                                                      width: 200,
                                                      height: 100,
                                                    ),
                                                  ),
                                                  Gaps.vGap10,
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            top: 6,
                                                            bottom: 6),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Colors.black),
                                                    child: const Text(
                                                      "图片接收成功，可以点击查看大图",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : numberPle == 2
                                              ? Center(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                Colors.white),
                                                        child: Text(
                                                          " 倒计时: ${_seconds}s ",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Gaps.vGap10,
                                                      GestureDetector(
                                                        onTap: () {
                                                          showImageDialog();
                                                        },
                                                        child: LoadImage(
                                                          image,
                                                          fit: BoxFit.fill,
                                                          width: 200,
                                                          height: 100,
                                                        ),
                                                      ),
                                                      Gaps.vGap10,
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 6,
                                                                bottom: 6),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color:
                                                                Colors.black),
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "图片接收成功，可以点击查看大图",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Gaps.vGap2,
                                                            Text(
                                                              bodyType == "A"
                                                                  ? "考伴回答"
                                                                  : "考生回答",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                Colors.white),
                                                        child: Text(
                                                          " 倒计时: ${_seconds}s ",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Gaps.vGap10,
                                                      Text(
                                                        bodyType == "A"
                                                            ? "考伴回答"
                                                            : "考生回答",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                      const Expanded(child: Gaps.empty),
                                      Center(
                                        child: GestureDetector(
                                          onTapUp: (details) {
                                            if (bodyType == "B" ||
                                                bodyType == "B2A") {
                                              mockKlowEndAnswer();
                                              setState(() {
                                                soundPrintType = 0;
                                                isTalk = false;
                                              });
                                            }
                                          },
                                          onTapDown: (details) {
                                            if (bodyType == "B" ||
                                                bodyType == "B2A") {
                                              mockKlowStartAnswer();
                                              setState(() {
                                                soundPrintType = 3;
                                                isTalk = true;
                                              });
                                            } else {
                                              showToast("请倾听..");
                                            }
                                          },
                                          onTap: () {
                                            //点击答题
                                            // showConfirmDialog();

                                            // NavigatorUtils.push(
                                            //   context,
                                            //   replace: true,
                                            //   ExamRouter.mockExaminationendOnePage,
                                            // );

                                            // NavigatorUtils.push(
                                            //   context,
                                            //   replace: true,
                                            //   ExamRouter.mockExaminationendTwoPage,
                                            // );
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                color:
                                                    Colours.color_examination,
                                              ),
                                              width: 180,
                                              height: 40,
                                              // color: Colours.color_examination,
                                              child: const Center(
                                                child: Text(
                                                  "长按答题",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                      Gaps.vGap24,
                                    ],
                                  ),
                                  isTalk
                                      ? Center(
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 40,
                                                  right: 40,
                                                  top: 8,
                                                  bottom: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.black,
                                              ),
                                              width: 160,
                                              height: 56,
                                              child: Image.asset(
                                                'assets/images/shengbo.gif',
                                                width: 30,
                                                height: 18,
                                                // fit: BoxFit.fill,
                                              )),
                                        )
                                      : const Center(),
                                ],
                              ),
                            ),
                            Gaps.hGap5,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              // color: Colors.white,
                              width: 188,
                              height: double.infinity,
                              child: Column(
                                children: [
                                  Gaps.vGap5,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_C1EBF7,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: const Text(
                                        "学生",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap5,
                                  peopleWidget(
                                      "comittee_icon",
                                      soundPrintType == 3 ? true : false,
                                      "考生：$nameName"),
                                  Gaps.vGap5,
                                  peopleWidget(
                                      "myhead_icon",
                                      soundPrintType == 2 ? true : false,
                                      "考伴：peter"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
    if (isOne == "1") {
      isOne = "2";
    }
  }

  @override
  void sendSuccess(String msg) {
    // TODO: implement sendSuccess
    if (isOne == "1") {
      isOne = "2";
    } else {
      if (widget.state == 0) {
        NavigatorUtils.push(
          context,
          replace: true,
          "${ExamRouter.mockExaminationendOnePage}?id=${widget.entity.data.id}",
        );
      } else {
        NavigatorUtils.push(
          context,
          replace: true,
          "${ExamRouter.mockExaminationendTwoPage}?id=${widget.entity.data.id}",
        );
      }
    }
  }

  @override
  MockExaminationTwoPagePresenter createPresenter() {
    _mockExaminationTwoPagePresenter = MockExaminationTwoPagePresenter();
    return _mockExaminationTwoPagePresenter;
  }
}
