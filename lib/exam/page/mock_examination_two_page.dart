import 'dart:async';
import 'dart:io';

import 'package:Bubble/chat/entity/message_entity.dart';
import 'package:Bubble/chat/utils/chat_websocket.dart';
import 'package:Bubble/chat/utils/evaluate_util.dart';
import 'package:Bubble/chat/utils/recognize_util.dart';
import 'package:Bubble/exam/entity/exam_step_bean.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/exam/utils/mock_evaluate_util.dart';
import 'package:Bubble/home/provider/home_provider.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Bubble/widgets/my_alert.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}

class MockExaminationTwoPage extends StatefulWidget {
  final ExamStepBean entity;

  const MockExaminationTwoPage({super.key, required this.entity});

  @override
  State<MockExaminationTwoPage> createState() => _MockExaminationTwoPageState();
}

class _MockExaminationTwoPageState extends State<MockExaminationTwoPage> {
  late ChatWebsocket _chatWebsocket;
  final ScreenUtil _screenUtil = ScreenUtil();
  final MediaUtils _mediaUtils = MediaUtils();
  final RecognizeUtil _recognizeUtil = RecognizeUtil();
  List<Uint8List> _bufferList = [];
  late HomeProvider _homeProvider;

//是否正在答题
  late bool isTalk = false;

  late BuildContext bcontext;

  late List<Part1Phase1> mockPart1Phase1 = [];
  late List<Part1Phase1> mockPart1Phase2 = [];
  late List<Part1Phase1> mockPart2Phase1 = [];
  late List<Part1Phase1> mockPart2Phase2 = [];
  late String image = "";

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

  //启动倒计时器
  void _startTimer() {
    Log.e(
        "startTimer()开始====$numberPle============$number=====================");
    _seconds = 12;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;

      if (_seconds == 0) {
        _timer?.cancel();
        if (!isTalk) {
          nextMock();
          Log.e(
              "nextMock()之后====$numberPle============$number=====================");
        }
      }
      setState(() {});
    });
    mockflow();
    Log.e(
        "mockflow()之后====$numberPle============$number===========$questionAudio==========");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mockPart1Phase1 = widget.entity.data.part1Phase1;
    mockPart1Phase2 = widget.entity.data.part1Phase2;
    mockPart2Phase1 = widget.entity.data.part2Phase1.list;
    image = widget.entity.data.part2Phase1.base.image;
    mockPart2Phase2 = widget.entity.data.part2Phase2;
    mockID = widget.entity.data.id.toString();
    _startTimer();

    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

  void nextMock() {
    //第一道题
    if (numberPle == 0) {
      if (number < mockPart1Phase1.length) {
        number = number + 1;
      } else {
        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 1) {
      if (number < mockPart1Phase2.length) {
        number = number + 1;
      } else {
        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 2) {
      if (number < mockPart2Phase1.length) {
        number = number + 1;
      } else {
        numberPle = numberPle + 1;
        number = 0;
      }
    } else if (numberPle == 3) {
      if (number < mockPart2Phase2.length) {
        number = number + 1;
      } else {
        numberPle = 0;
        number = 0;
        //去下一个页面
        Log.e("去下一个页面");
        return;
      }
    } else {
      //去下一个页面
      Log.e("去下一个页面");
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
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
          //老师问
          Log.e("老师问完=====$bodyType=========");
          if (bodyType == "A") {
            Log.e("老师问完=====进来了吗=========");

            answerAudio = mockPart1Phase1[number].answerAudio!;
            Log.e("老师问完=====进来了吗$answerAudio=========");

            //考伴回答
            Log.e("考伴回答==============应该弹窗");
            mockKlowPlay(answerAudio);
          } else {
            //学生回答//走到倒计时
          }
        },
      );
    } else if (numberPle == 1) {
      bodyType = mockPart1Phase2[number].to;
      questionID = mockPart1Phase1[number].id.toString();
      //老师问
      questionAudio = mockPart1Phase2[number].questionAudio;
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
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
    } else if (numberPle == 2) {
      bodyType = mockPart2Phase1[number].to;
      questionID = mockPart1Phase1[number].id.toString();

      //老师问
      questionAudio = mockPart2Phase1[number].questionAudio;
      _mediaUtils.play(
        url: questionAudio,
        whenFinished: () {
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
    } else if (numberPle == 3) {
      bodyType = mockPart2Phase2[number].to;
      questionID = mockPart1Phase1[number].id.toString();

      // 学生问逻辑在按钮里面
      // questionAudio = mockPart2Phase2[number].questionAudio;

      if (bodyType == "B2A") {
        // answerAudio = mockPart2Phase2[number].answerAudio!;
        //考生提问,考办回答
        // mockKlowPlay(answerAudio);
      }
      // else {
      //   //学生回答//走到倒计时
      // }
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

  void sendMessage(String text) async {
    insertUserMessage(text, (message) {
      MockEvaluateUtil().evaluate(message, () {});
    });
  }

  void insertUserMessage(String text, Function(MockMessageEntity) onSuccess) {
    MockMessageEntity message = MockMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    message.sessionId = mockID;
    message.messageId = questionID;
    message.speechfile = "";
    onSuccess(message);
  }

  void mockKlowEndAnswer() async {
    await _mediaUtils.stopRecord();
    // 抬起按钮
    isTalk = false;
    _timer?.cancel();
    nextMock();
  }

  void mockKlowPlay(String answerAudio) {
    Log.e("考伴回答应该弹窗==============");
    showConfirmDialog();
    _mediaUtils.play(
      url: answerAudio,
      whenFinished: () {
        showToast("考办回答完");
        Navigator.pop(context);
      },
    );
  }

  ///销毁录音
  void dispose() {
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement dispose
    super.dispose();
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
                    child: LoadAssetImage(
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

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageUtils.getAssetImage("splash_bg"),
                      fit: BoxFit.fill)),
              child: Expanded(
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
                    Gaps.vGap10,
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
                                  Gaps.vGap20,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_E8CCFE,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      child: const Text(
                                        "考官",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap10,
                                  peopleWidget(
                                      "teach_icon", false, "口语考官：Andy老师"),
                                  Gaps.vGap10,
                                  peopleWidget(
                                      "invigilate_icon", false, "计分考官：Andy老师"),
                                ],
                              ),
                            ),
                            Gaps.hGap5,
                            Container(
                              padding: const EdgeInsets.all(20),
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
                                      numberPle == 4
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
                                                  Gaps.vGap10,
                                                  Text(
                                                    numberPle == 3
                                                        ? "请提问第$number个问题"
                                                        : "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : numberPle == 3
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
                                                        child:
                                                            const LoadAssetImage(
                                                          "jpgicon",
                                                          width: 82,
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
                                                                top: 10,
                                                                bottom: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color:
                                                                Colors.black),
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
                                              : Center(
                                                  child: Container(
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
                                                ),
                                      const Expanded(child: Gaps.empty),
                                      Center(
                                        child: GestureDetector(
                                          onTapUp: (details) {
                                            if (bodyType == "B" ||
                                                bodyType == "B2A") {
                                              mockKlowEndAnswer();
                                              setState(() {
                                                isTalk = false;
                                              });
                                            }
                                          },
                                          onTapDown: (details) {
                                            if (bodyType == "B" ||
                                                bodyType == "B2A") {
                                              mockKlowStartAnswer();
                                              setState(() {
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
                                              width: 207,
                                              height: 48,
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
                                      // Gaps.vGap20,
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
                                  Gaps.vGap20,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_C1EBF7,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      child: const Text(
                                        "学生",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap10,
                                  peopleWidget("comittee_icon", false, "考生：小明"),
                                  Gaps.vGap10,
                                  peopleWidget("myhead_icon", false, "考办：小红"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
