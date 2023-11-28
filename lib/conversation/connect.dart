// ignore_for_file: argument_type_not_assignable_to_error_handler, must_be_immutable

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../routers/fluro_navigator.dart';
import '../util/websocket_utils.dart';
import '../widgets/load_image.dart';
import 'conversation_router.dart';
import 'model/character_entity.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({
    Key? key,
    required this.character,
  }) : super(key: key);

  CharacterEntity character;

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
    String sessionId = const Uuid().v4().replaceAll('-', '');
    String model = 'shenmo-llm01';
    String language = 'en-US';
    String token = '';
    String url = 'wss://api.demo.shenmo-ai.net/ws/$sessionId?llm_model=$model&platform=web&use_search=false&use_quivr=false&use_multion=false&character_id=${widget.character.characterId}&language=$language&token=$token';
    WebsocketUtils.createWebsocket(
      'CONVERSATION',
      Uri.parse(url),
      onSuccess: () {
        Future.delayed(const Duration(seconds: 1), () {
          NavigatorUtils.push(
            context,
            ConversationRouter.conversationPage,
            replace: true,
            arguments: {
              'character': widget.character,
              'sessionId': sessionId,
            },
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
            top: size.height * (192 / 812),
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 128.0,
                    height: 128.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(128.0),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 28.0,
                  ),
                  Text(
                    '正在呼叫${widget.character.name}...',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size.height * (144 / 812),
            left: (size.width - 63.0) * 0.5,
            child: IconButton(
              icon: const LoadAssetImage(
                'guaduan',
                width: 63.0,
                height: 63.0,
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}