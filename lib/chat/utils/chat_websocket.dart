// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../loginManager/login_manager.dart';
import '../../util/device_utils.dart';
import '../../util/log_utils.dart';

class ChatWebsocket {

  factory ChatWebsocket() {
    return _chatWebsocket;
  }
  ChatWebsocket._internal();

  static final ChatWebsocket _chatWebsocket = ChatWebsocket._internal();
  WebSocketChannel? _websocket;
  // 暂离次数
  int _awayCount = 0;
  Timer? _awayTimer;
  // auto-自动断开 manual-手动
  String _disconnectType = 'auto';

  Future<String> startChat({
    required String characterId,
    // 话题和场景都用sceneID
    String? sceneId,
    Function()? onConnected,
    required Function(dynamic) onAnswer,
    required Function() onEnd,
  }) async {
    try {
      String sessionId = const Uuid().v4().replaceAll('-', '');
      await _connect(sessionId, characterId, sceneId);
      if (onConnected != null) {
        onConnected();
      }
      _websocket!.stream.listen(
        onAnswer,
        onDone: () {
          int? code = _websocket!.closeCode;
          if (code == WebSocketStatus.normalClosure) {
            Log.d('normal disconnect');
            if (_disconnectType != 'manual') {
              Log.d('auto disconnect');
              onEnd();
            }
          }
          _websocket = null;
        },
        onError: (error) async {
          Log.d('chat websocket error:[reason]${error.toString()}', tag: '对话Websocket');
          await _disconnect('Error');
        },
        cancelOnError: true,
      );
      _disconnectType = 'auto';
      _resetTimer();
      return sessionId;
    } catch(e) {
      rethrow;
    }
  }

  void sendMessage(String text, Function() onSuccess) async {
    _awayCount = 0;
    _removeAwayTimer();
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

  Future<void> stopChat([String? disconnectType]) async {
    if (disconnectType != null) {
      _disconnectType = disconnectType;
    }
    await _disconnect('Session End');
  }

  Future<void> _connect(String sessionId, String characterId, String? sceneId) async {
    String deviceId = await Device.getDeviceId();
    String token = LoginManager.getUserToken();
    String uri = 'wss://api.demo.shenmo-ai.net/ws/$sessionId?platform=app&device_id=$deviceId&character_id=$characterId&language=en-US&token=$token&use_search=false&use_quivr=false&use_multion=false';
    if (sceneId != null) {
      uri = '$uri&scene_id=$sceneId';
    }
    try {
      Log.d('connect websocket', tag: '连接websocket');
      _websocket = WebSocketChannel.connect(Uri.parse(uri));
    } catch(e) {
      rethrow;
    }
  }

  Future<void> _disconnect(String reason) async {
    _removeAwayTimer();
    if (_websocket != null) {
      await _websocket!.sink.close(WebSocketStatus.normalClosure, reason);
    }
  }

  void addAwayTimer(Function() onAway) {
    _removeAwayTimer();
    _awayTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      _removeAwayTimer();
      _awayCount += 1;
      // 暂离次数超过1
      if (_awayCount > 1) {
        await stopChat();
        Log.d('stop by away');
      } else {
        onAway();
        addAwayTimer(onAway);
      }
    });
  }

  void _removeAwayTimer() {
    if (_awayTimer != null) {
      _awayTimer!.cancel();
      _awayTimer = null;
    }
  }

  void _resetTimer() {
    _awayCount = 0;
    _removeAwayTimer();
  }

}