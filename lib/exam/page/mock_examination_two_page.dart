import 'dart:async';
import 'dart:io';

import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
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
  const MockExaminationTwoPage({super.key});

  @override
  State<MockExaminationTwoPage> createState() => _MockExaminationTwoPageState();
}

class _MockExaminationTwoPageState extends State<MockExaminationTwoPage> {
  late String numberType = "2";

  late bool isTalk = false;

  late BuildContext bcontext;

//初始化录音对象
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  //监听录音
  StreamSubscription? _recorderSubscription;
  var _maxLength = 180.0;
  var _path = "";
  RecordPlayState _state = RecordPlayState.record;

  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  StreamSubscription? _playerSubscription;

//  StreamController<Food> streamController = StreamController<Food>();
  // StreamSubscription? streamSubscription;
  ///启动倒计时器
  // void _startTimer() {
  //   _seconds = 10;
  //   // canResend = false;
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     Log.e(":111111111");
  //     _seconds = _seconds! - 1;

  //     if (_seconds == 0) {
  //       _timer?.cancel();
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  Future<void> init() async {
    //开启录音
    await recorderModule.openRecorder();
    //设置订阅计时器
    await recorderModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<bool> getPermissionStatus() async {
    Permission permission = Permission.microphone;
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      requestPermission(permission);
    } else {}
    return false;
  }

  ///申请权限
  void requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// 开始录音
  _startRecorder() async {
    try {
      //获取麦克风权限
      await getPermissionStatus().then((value) async {
        if (!value) {
          return;
        }
        //用户允许使用麦克风之后开始录音
        Directory tempDir = await getTemporaryDirectory();
        var time = DateTime.now().millisecondsSinceEpoch;
        String path = '${tempDir.path}/$time${ext[Codec.aacADTS.index]}';

        //这里我录制的是aac格式的，还有其他格式
        await recorderModule.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          bitRate: 8000,
          numChannels: 1,
          sampleRate: 8000,
        );

        /// 监听录音
        _recorderSubscription = recorderModule.onProgress!.listen((e) {
          var date = DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);
          var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          //设置了最大录音时长
          if (date.second >= _maxLength) {
            _stopRecorder();
            return;
          }
          // setState(() {
          //   //更新录音时长
          //   _recordText = txt.substring(1, 5);
          // });
        });
        setState(() {
          //更新录音状态和录音文件路径
          _state = RecordPlayState.recording;
          _path = path;
        });
      });
    } catch (err) {
      setState(() {
        _stopRecorder();
        _state = RecordPlayState.record;
        _cancelRecorderSubscriptions();
      });
    }
  }

  /// 结束录音
  _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      _cancelRecorderSubscriptions();
      // _getDuration();
    } catch (err) {}
    setState(() {
      _state = RecordPlayState.record;
    });
  }

  /// 取消录音监听
  void _cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  /// 释放录音
  Future<void> _releaseFlauto() async {
    try {
      await recorderModule.closeRecorder();
    } catch (e) {}
  }

  /// 判断文件是否存在
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }

  //播放
  void initPlayer() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
//这块是设置音频，暂时没用到可以不用设置
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    //   avAudioSessionCategoryOptions:
    //       AVAudioSessionCategoryOptions.allowBluetooth |
    //           AVAudioSessionCategoryOptions.defaultToSpeaker,
    //   avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    //   avAudioSessionRouteSharingPolicy:
    //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
    //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    //   androidAudioAttributes: const AndroidAudioAttributes(
    //     contentType: AndroidAudioContentType.speech,
    //     flags: AndroidAudioFlags.none,
    //     usage: AndroidAudioUsage.voiceCommunication,
    //   ),
    //   androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    //   androidWillPauseWhenDucked: true,
    // ));
  }

  ///开始播放，这里做了一个播放状态的回调
  void startPlayer() async {
    try {
      if (_path.contains('http')) {
        await playerModule.startPlayer(
            fromURI: _path,
            codec: Codec.mp3,
            sampleRate: 44000,
            whenFinished: () {
              stopPlayer();
            });
      } else {
        //判断文件是否存在
        if (await _fileExists(_path)) {
          if (playerModule.isPlaying) {
            playerModule.stopPlayer();
          }
          await playerModule.startPlayer(
              fromURI: _path,
              codec: Codec.aacADTS,
              sampleRate: 44000,
              whenFinished: () {
                stopPlayer();
              });
        } else {}
      }
      //监听播放进度
      _playerSubscription = playerModule.onProgress!.listen((e) {});
      // callBack(1);
    } catch (err) {
      // callBack(0);
    }
  }

  /// 结束播放
  void stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      cancelPlayerSubscriptions();
    } catch (err) {}
  }

  /// 取消播放监听
  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      // _playerSubscription = null;
    }
  }

  ///获取播放状态
  Future<PlayerState> getPlayState() async {
    return await playerModule.getPlayerState();
  }

  /// 释放播放器
  void releaseFlauto() async {
    try {
      await playerModule.closePlayer();
    } catch (e) {
      print(e);
    }
  }
// /// 判断文件是否存在
// Future<bool> _fileExists(String path) async {
//   return await File(path).exists();
// }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _startTimer();
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

  ///销毁录音
  void dispose() {
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement dispose
    super.dispose();
    _cancelRecorderSubscriptions();
    _releaseFlauto();
  }

  Widget peopleWidget(bool isVector, String name) {
    return Stack(
      children: [
        const LoadAssetImage(
          'personal_center_bg',
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
                'shengbo_pink',
                width: 147,
                height: 56,
              ),
            ),
          );
        });
  }

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
                  const Center(
                    child: LoadAssetImage(
                      'personal_center_bg',
                      width: 512, height: 288,
                      // fit: BoxFit.cover
                    ),
                  ),
                  Positioned(
                      // top: 0,
                      // right: 0,
                      // left: 0,
                      // height: 32,
                      // width: 512,
                      child: Center(
                    child: Container(
                      width: 512,
                      height: 32,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   color: Colors.white,
                      // ),
                      child: const Center(
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      numberType == "2"
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
                                      numberType == "2"
                                          ? 'assets/images/number_n_icon.png'
                                          : 'assets/images/number_s_icon.png',
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
                                  peopleWidget(true, "口语考官：Andy老师"),
                                  Gaps.vGap10,
                                  peopleWidget(true, "计分考官：Andy老师"),
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
                                      numberType == "2"
                                          ? const Text("请你提问一个问题")
                                          : Center(
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
                                                    child: const Text(
                                                      " 倒计时: 20s ",
                                                      style: TextStyle(
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
                                                    child: const LoadAssetImage(
                                                      'jpgicon',
                                                      width: 82,
                                                      height: 100,
                                                    ),
                                                  ),
                                                  Gaps.vGap10,
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            top: 10,
                                                            bottom: 10),
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
                                            ),
                                      const Expanded(child: Gaps.empty),
                                      Center(
                                        child: GestureDetector(
                                          onTapUp: (details) {
                                            setState(() {
                                              isTalk = false;
                                            });
                                          },
                                          onTapDown: (details) {
                                            setState(() {
                                              isTalk = true;
                                            });
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
                                  peopleWidget(true, "口语考官：Andy老师"),
                                  Gaps.vGap10,
                                  peopleWidget(true, "计分考官：Andy老师"),
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
