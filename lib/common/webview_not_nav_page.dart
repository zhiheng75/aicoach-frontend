import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            finished = true;
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
        //发个请求
        postStepUpdate();
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
          EventBus().emit(NotificationUtils.nextClass);
        }
      })
      ..addJavaScriptChannel('goHome', onMessageReceived: (message) {
        // 发个请求
        postStepUpdate();

        //回到目录页
        if (widget.type == "1") {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      })
      ..loadRequest(Uri.parse(widget.url));
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
        Method.post, HttpApi.stepUpdate, params: params, onSuccess: (result) {},
        onError: (code, msg) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          // 网页可以返回时，优先返回上一页
          await _controller.goBack();
          return Future.value(false);
        }
        return Future.value(true);
      },
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
