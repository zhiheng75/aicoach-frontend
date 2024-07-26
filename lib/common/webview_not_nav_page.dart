import 'dart:convert';

import 'package:Bubble/chat/utils/recognize_util.dart';
import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/utils/class_evaluate_util.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sp_util/sp_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewNotNavPage extends StatefulWidget {
  final String url;
  final StepDetailBean stepDetailData;
  final int idx;
  final String type;

  const WebviewNotNavPage({
    super.key,
    required this.url,
    required this.stepDetailData,
    required this.idx,
    required this.type,
  });

  @override
  State<WebviewNotNavPage> createState() => _WebviewNotNavPageState();
}

class _WebviewNotNavPageState extends State<WebviewNotNavPage> {
  late final WebViewController _controller;
  int _progressValue = 0;
  bool finished = false;
  final MediaUtils _mediaUtils = MediaUtils();
  List<Uint8List> _bufferList = [];
  RecognizeUtil _recognizeUtil = RecognizeUtil();
  // bool isInSendButton = true;
  late bool isTalk = false;

  final ScreenUtil _screenUtil = ScreenUtil();
  late String textStr = "";

  late String numberStr = "";
  @override
  void initState() {
    super.initState();
    oneStartRecord();
    // _recognizeUtil.setLanguage('en');
    // _homeProvider = Provider.of<HomeProvider>(context, listen: false);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            finished = true;
            double top = MediaQuery.of(context).padding.top;
            // _controller.runJavaScriptReturningResult('callJStop($top)');
            _controller.runJavaScript('callJStop($top)');
            setState(() {});
          },
          onProgress: (int progress) {
            if (!mounted) {
              return;
            }
            debugPrint('WebView is loading (progress : $progress%)');
            setState(() {
              _progressValue = progress;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            ///提交成功后JS回调 submit://doAction?success=true
            if (request.url.startsWith('submit://')) {
              ///在返回submit://doAction?格式时要阻止其跳转，不然会报错
              ///not allowing navigation to $request(submit://doAction?.......)
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('goBack', onMessageReceived: (message) {
        if (message.message == "finish") {
          //发个请求
          postStepUpdate();
        }

        //回到上一页
        Navigator.of(context).pop();
        if (widget.type == "1") {
          int next = widget.idx;
          next = next + 1;
          if (next < widget.stepDetailData.data.data.length) {
            //退出这一页去聊天
            NavigatorUtils.push(context,
                "${HomeRouter.instructionalVideoDialoguePage}?index=$next",
                arguments: widget.stepDetailData);
          }
        } else {
          //只是退出这一页 发通知
          //发一个进行下一步的通知
          int next = widget.idx;
          next = next + 1;
          EventBus().emit(NotificationUtils.nextClass, next.toString());
        }
      })
      ..addJavaScriptChannel('goHome', onMessageReceived: (message) {
        if (message.message == "finish") {
          //发个请求
          postStepUpdate();
        }

        //回到目录页
        if (widget.type == "1") {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      })
      ..addJavaScriptChannel('startRecord', onMessageReceived: (message) {
        textStr = "";
        startRecord(message.message);
      })
      ..addJavaScriptChannel('finshRecord', onMessageReceived: (message) {
        numberStr = message.message;
        finshRecord();
      })
      ..addJavaScriptChannel('cancelRecord', onMessageReceived: (message) {
        cancelRecord();
      })
      ..loadRequest(Uri.parse(widget.url));
  }

  void cancelRecord() async {
    setState(() {
      isTalk = true;
    });
    await _mediaUtils.stopRecord();
  }

  void finshRecord() async {
    isTalk = false;
    await _mediaUtils.stopRecord();
  }

  void startRecord(String params) async {
    try {
      bool hasAgree =
          SpUtil.getBool(Constant.mediaUtils, defValue: false) ?? false;
      if (!hasAgree) {
        Toast.show("录音音频使用说明:用于对话场景", duration: 6000);
        SpUtil.putBool(Constant.mediaUtils, true);
      }

      // 检查权限
      bool isRequest = await _mediaUtils.checkMicrophonePermission();
      if (isRequest) {
        Toast.show("录音音频使用说明:用于对话场景", duration: 5000);
        return;
      }
      _recognizeUtil = RecognizeUtil();
      _recognizeUtil.setLanguage('en');
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
        textStr = result['text'];
        //检测出来的音频
        if (params.isNotEmpty) {
          sendTwoMessage(result['text'], params);
        } else {
          _postUploadText(textStr);
        }
      });
      isTalk = true;
    } catch (e) {
      Toast.show(
        e.toString().substring(11),
        duration: 1000,
      );
    }
  }

  void sendTwoMessage(String msg, String word) {
    insertTwoUserMessage(word, (message) {
      ClassEvaluateUtil().evaluate(message, (Map<String, dynamic> map) {
        try {
          double value = double.parse(map["total_score"]);
          if (value > 60) {
            _postUploadText(word);
          } else {
            _postUploadText(msg);
          }
        } catch (e) {
          _postUploadText(msg);
        }
        // evaluation['total_score']
        Log.e("============");
      });
    });
  }

  void insertTwoUserMessage(
      String text, Function(ClassMessageEntity) onSuccess) {
    ClassMessageEntity message = ClassMessageEntity();
    message.text = text;
    message.audio = [..._bufferList];
    onSuccess(message);
  }

  void _postUploadText(String textStr) {
    String istextStr = "1";
    Map<String, dynamic> params;
    if (textStr.isEmpty) {
      params = {
        "istextStr": istextStr,
      };
    } else {
      istextStr = "2";
      params = {
        "text": textStr,
        "istextStr": istextStr,
        "numberStr": numberStr,
      };
    }
    String str = json.encode(params);

    // _controller.runJavaScriptReturningResult('callJS($str)');
    _controller.runJavaScript('callJS($str)');
  }

  void oneStartRecord() async {
    bool hasAgree =
        SpUtil.getBool(Constant.mediaUtils, defValue: false) ?? false;
    if (!hasAgree) {
      Toast.show("录音音频使用说明:用于对话场景", duration: 6000);
      SpUtil.putBool(Constant.mediaUtils, true);
    }

    // 检查权限
    bool isRequest = await _mediaUtils.checkMicrophonePermission();
    if (isRequest) {
      Toast.show("录音音频使用说明:用于对话场景", duration: 5000);
      return;
    }
  }

  void postStepUpdate() {
    int next = widget.idx;

    String lessonId = widget.stepDetailData.data.lessonId.toString();
    String stepId = widget.stepDetailData.data.data[next].stepId.toString();

    final Map<String, dynamic> params = <String, dynamic>{};
    params["lesson_id"] = lessonId;
    params["step_id"] = stepId;
    params["completed"] = "1";

    DioUtils.instance.requestNetwork<ResultData>(
        Method.post, HttpApi.stepUpdate,
        params: params, onSuccess: (result) {
      EventBus().emit(NotificationUtils.nextResetChat);
    }, onError: (code, msg) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      // onWillPop: () async {
      //   final bool canGoBack = await _controller.canGoBack();
      //   if (canGoBack) {
      //     // 网页可以返回时，优先返回上一页
      //     await _controller.goBack();
      //     return Future.value(false);
      //   }
      //   return Future.value(true);
      // },
      child: Material(
        child: Stack(
          children: [
            WebViewWidget(
              controller: _controller,
            ),
            if (_progressValue != 100)
              LinearProgressIndicator(
                value: _progressValue / 100,
                backgroundColor: Colors.transparent,
                minHeight: 2,
              )
            else
              Gaps.empty,
          ],
        ),
      ),
    );
  }
}
