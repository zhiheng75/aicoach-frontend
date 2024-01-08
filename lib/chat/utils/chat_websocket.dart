import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../loginManager/login_manager.dart';
import '../../util/device_utils.dart';
import '../../util/log_utils.dart';

class ChatWebsocket {

  ChatWebsocket();

  WebSocketChannel? _websocket;

  Future<String> startChat({
    required String characterId,
    // 话题和场景都用sceneID
    String? sceneId,
    required Function(dynamic) onAnswer,
  }) async {
    try {
      String sessionId = const Uuid().v4().replaceAll('-', '');
      await _connect(sessionId, characterId, sceneId);
      _websocket!.stream.listen(
        onAnswer,
        onDone: () {
          _websocket = null;
        },
        onError: (error) async {
          Log.d('chat websocket error:[reason]${error.toString()}', tag: '对话Websocket');
          await _disconnect('Error');
        },
        cancelOnError: true,
      );
      return sessionId;
    } catch(e) {
      rethrow;
    }
  }

  void sendMessage(String text, Function() onSuccess) async {
    bool canSend = true;
    int tryCount = 5;
    while(_websocket == null) {
      if (tryCount == 0) {
        canSend = false;
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      tryCount--;
    }
    if (canSend) {
      try {
        _websocket!.sink.add(text);
        onSuccess();
      } catch (error) {
        Log.d('send message error:[reason]${error.toString()}', tag: '发送消息');
        rethrow;
      }
    }
  }

  Future<void> stopChat() async {
    await _disconnect('Stop');
  }

  Future<void> _connect(String sessionId, String characterId, String? sceneId) async {
    String deviceId = await Device.getDeviceId();
    String token = LoginManager.getUserToken();
    String uri = 'wss://api.demo.shenmo-ai.net/ws/$sessionId?platform=app&device_id=$deviceId&character_id=$characterId&language=en-US&token=$token&use_search=false&use_quivr=false&use_multion=false';
    if (sceneId != null) {
      uri = '$uri&scene_id=$sceneId';
    }
    try {
      _websocket = WebSocketChannel.connect(Uri.parse(uri));
    } catch(e) {
      rethrow;
    }
  }

  Future<void> _disconnect(String reason) async {
    if (_websocket != null) {
      await _websocket!.sink.close(WebSocketStatus.normalClosure, reason);
    }
  }

}