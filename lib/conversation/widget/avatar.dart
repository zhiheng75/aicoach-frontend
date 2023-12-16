import 'dart:convert';

import 'package:Bubble/conversation/utils/avatar_util.dart';
import 'package:Bubble/home/entity/teach_list_entity.dart';
import 'package:Bubble/home/provider/selecter_teacher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  WebViewController? controller;
  final String basePath = 'assets/avatar';
  bool showAvatar = false;

  void init() {
    // 测试
    TeachListEntity? teacher = Provider.of<HomeTeacherProvider>(context, listen: false).teacher;
    if (teacher == null) {
      return;
    }
    String avatarId = teacher.avatarId;
    if (avatarId == '') {
      return;
    }

    final NavigationDelegate delegate = NavigationDelegate(
        onPageFinished: (_) async {
          // 加载js
          List<String> jsList = [
            'live2dcubismcore.js',
            'bundle.js'
          ];
          for (var js in jsList) {
            String jsString = await rootBundle.loadString('$basePath/$js');
            controller!.runJavaScript(jsString);
          }
        },
        onWebResourceError: (_) {
        }
    );
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Channel', onMessageReceived: (_) async {
        if (_.message == 'SUCCESS') {
          String base64Str = await AvatarUtil().loadModelSetting(avatarId);
          try {
            Object setting = await controller!.runJavaScriptReturningResult('window.Live2D.getModelSetting("$base64Str")');
            Map<String, dynamic> params = {};
            while (true) {
              bool isString = setting is String;
              if (!isString) {
                break;
              }
              setting = jsonDecode(setting);
            }
            if (setting is Map<String, dynamic>) {
              params = setting;
            }
            loadModel(avatarId, params);
          } catch (error) {
            if (kDebugMode) {
              print("error:$error");
            }
          }
        }
      })
      ..setNavigationDelegate(delegate)
      ..loadFlutterAsset('assets/avatar/index.html');
    showAvatar = true;
    setState(() {});
  }

  void loadModel(String id, Map<String, dynamic> params) async {
    AvatarAsset avatarAsset = await AvatarUtil().loadModel(id, params);
    renderModel(avatarAsset.toJson());
  }

  void renderModel(Map<String, dynamic> model) async {
    await controller!.runJavaScript('window.Live2DModelData = ${jsonEncode(model)}');
    await controller!.runJavaScript('window.Live2D.loadModel()');
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void deactivate() async {
    super.deactivate();
    if (controller != null) {
      await controller!.runJavaScript('window.Live2D.destroy()');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!showAvatar) {
      return const SizedBox();
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: WebViewWidget(
              controller: controller!,
            ),
          )
        ],
      ),
    );
  }
}