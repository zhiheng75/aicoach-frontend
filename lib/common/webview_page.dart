import 'dart:async';

import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../res/gaps.dart';
import '../widgets/my_app_bar.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
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
            // _controller.platform.setOnPlatformPermissionRequest((request) {
            //   Permission.speech.request().then((result) {
            //     //如果没有权限就再次发起请求
            //     if (result.isDenied) {
            //       Permission.speech.request();
            //     } else if (result.isGranted) {
            //       request.grant(); //有权限就该干嘛干嘛，不加这句无法语音转文字
            //     }
            //   });
            // });
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
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
      child: Scaffold(
        appBar:
            MyAppBar(centerTitle: widget.title, centerTitleColor: Colors.black),
        body: Stack(
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
