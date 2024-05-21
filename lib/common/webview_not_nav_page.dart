import 'package:Bubble/res/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewNotNavPage extends StatefulWidget {
  final String title;
  final String url;

  const WebviewNotNavPage({
    super.key,
    required this.title,
    required this.url,
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
        //回到上一页
      })
      ..addJavaScriptChannel('goHome', onMessageReceived: (message) {
        //回到目录页
      })
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
      child: CupertinoPageScaffold(
        child: SafeArea(
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
      ),
    );
  }
}
