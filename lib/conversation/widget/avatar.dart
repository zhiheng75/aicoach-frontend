import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    Key? key,
    required this.avatarId,
    this.width,
    this.height,
  }) : super(key: key);

  final String avatarId;
  final double? width;
  final double? height;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  late WebViewController controller;
  final String basePath = 'assets/avatar';

  void init() {
    final NavigationDelegate delegate = NavigationDelegate(
        onPageFinished: (_) async {
          // 加载js
          List<String> jsList = [
            'live2dcubismcore.js',
            'bundle.js'
          ];
          for (var js in jsList) {
            String jsString = await rootBundle.loadString('$basePath/$js');
            controller.runJavaScript(jsString);
          }
        },
        onWebResourceError: (_) {
        }
    );
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Channel', onMessageReceived: (_) async {
        if (_.message == 'SUCCESS') {
          String base64Str = await getBase64ForAsset('Haru.model3.json');
          try {
            Object setting = await controller.runJavaScriptReturningResult('window.Live2D.getModelSetting("$base64Str")');
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
            loadModel(params);
          } catch (error) {
            if (kDebugMode) {
              print("error:$error");
            }
          }
        }
      })
      ..setNavigationDelegate(delegate)
      ..loadFlutterAsset('assets/avatar/index.html');
  }

  Future<String> getBase64ForAsset(String path) async {
    String assetPath = '$basePath/resource/${widget.avatarId}/$path';
    final asset = await rootBundle.load(assetPath);
    return base64.encode(asset.buffer.asUint8List());
  }

  bool checkString(String? string) {
    return string != null && string != '';
  }

  void loadModel(Map<String, dynamic> params) async {
    String? moc;
    // moc
    if (checkString(params['moc'])) {
      moc = await getBase64ForAsset(params['moc']);
    }
    // exp
    List<String> exp = [];
    if (checkString(params['exp'])) {
      List<String> expList = (params['exp'] as String).split(',');
      for (String expPath in expList) {
        exp.add(await getBase64ForAsset(expPath));
      }
    }
    // physic
    String? physic;
    if (checkString(params['physic'])) {
      physic = await getBase64ForAsset(params['physic']);
    }
    // pose
    String? pose;
    if (checkString(params['pose'])) {
      pose = await getBase64ForAsset(params['pose']);
    }
    // user
    String? user;
    if (checkString(params['user'])) {
      user = await getBase64ForAsset(params['user']);
    }
    // motion
    List<String> motion = [];
    if (checkString(params['motion'])) {
      List<String> motionList = (params['motion'] as String).split(',');
      for (String motionPath in motionList) {
        motion.add(await getBase64ForAsset(motionPath));
      }
    }
    // texture
    List<String> texture = [];
    if (checkString(params['texture'])) {
      List<String> textureList = (params['texture'] as String).split(',');
      for (String texturePath in textureList) {
        texture.add(await getBase64ForAsset(texturePath));
      }
    }

    Map<String, String> live2DModelData = {
      'moc': moc ?? '',
      'exp': exp.join(','),
      'physic': physic ?? '',
      'pose': pose ?? '',
      'user': user ?? '',
      'motion': motion.join(','),
      'texture': texture.join(','),
    };

    await controller.runJavaScript('window.Live2DModelData = ${jsonEncode(live2DModelData)}');
    await controller.runJavaScript('window.Live2D.loadModel()');
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void deactivate() async {
    super.deactivate();
    await controller.runJavaScript('window.Live2D.destroy()');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}