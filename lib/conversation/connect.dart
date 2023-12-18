// ignore_for_file: argument_type_not_assignable_to_error_handler, must_be_immutable

import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/setting/provider/device_provider.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../home/entity/teach_list_entity.dart';
import '../routers/fluro_navigator.dart';
import '../util/websocket_utils.dart';
import '../widgets/load_image.dart';
import 'conversation_router.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  TeachListEntity teacher;

  @override
  State<ConnectPage> createState() => _ConnectState();
}

class _ConnectState extends State<ConnectPage> {
  // -1-失败 0-初始化
  int state = 0;

  void connect() {
    connectWebsocket();
  }

  void connectWebsocket() {
    String deviceId = Provider.of<DeviceProvider>(context, listen: false).deviceId;
    String sessionId = const Uuid().v4().replaceAll('-', '');
    // String model = '';
    String language = 'en-US';
    String token = SpUtil.getString(Constant.accessToken) ?? '';
    // String url = 'wss://api.demo.shenmo-ai.net/ws/$sessionId?device_id=$deviceId&llm_model=$model&platform=app&use_search=false&use_quivr=false&use_multion=false&character_id=${widget.teacher.characterId}&language=$language&token=$token';
    String url = 'wss://api.demo.shenmo-ai.net/ws/$sessionId?device_id=$deviceId&platform=app&use_search=false&use_quivr=false&use_multion=false&character_id=${widget.teacher.characterId}&language=$language&token=$token';
    WebsocketUtils.createWebsocket(
      'CONVERSATION',
      Uri.parse(url),
      onSuccess: () {
        ConversationProvider provider = Provider.of<ConversationProvider>(context, listen: false);
        provider.sessionId = sessionId;
        provider.clear();
        Future.delayed(const Duration(seconds: 1), () {
          NavigatorUtils.push(
            context,
            ConversationRouter.conversationPage,
            replace: true,
          );
        });
      },
      onError: () {
        setState(() {
          state = -1;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LoadAssetImage(
            'huihua_bg',
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 200.0,
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(133.0),
                    child: LoadImage(
                      widget.teacher.imageUrl,
                      width: 133.0,
                      height: 133.0,
                    ),
                  ),
                  const SizedBox(
                    height: 29.0,
                  ),
                  Text(
                    '正在呼叫${widget.teacher.name}...',
                    style: const TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      height: 18.0 / 17.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 150.0,
            left: (size.width - 66.0) * 0.5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                WebsocketManage? manage = WebsocketUtils.getWebsocket('CONVERSATION');
                if (manage != null) {
                  WebsocketUtils.closeWebsocket('CONVERSATION');
                }
              },
              child: const LoadAssetImage(
                'guaduan_big',
                width: 66.0,
                height: 66.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}