// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../loginManager/login_manager.dart';
import '../../util/device_utils.dart';

class ChatWebsocket {
  factory ChatWebsocket() {
    return _chatWebsocket;
  }
  ChatWebsocket._internal();

  static final ChatWebsocket _chatWebsocket = ChatWebsocket._internal();
  WebSocketChannel? _websocket;
  // opened-已连接 closed-已关闭
  String _status = '';
  // normal-正常 force-强制
  String _endType = '';
  // 心跳
  Timer? _heartbeat;

  Future<String> startChat({
    required String characterId,
    // 话题和场景都用sceneID
    String? sceneId,
    Function()? onConnected,
    required Function(dynamic) onAnswer,
    required Function(String?, String) onEnd,
  }) async {
    // 连接
    _websocket = null;
    _status = '';
    _endType = '';
    String sessionId = '';
    try {
      sessionId = await _connect(characterId, sceneId);
    } catch (e) {
      rethrow;
    }
    if (onConnected != null) {
      onConnected();
    }
    _status = 'opened';
    _startHeartbeat();
    _websocket!.stream.listen(
      (data) {
        // 心跳
        if (data is String &&
            data.contains('[heartbeat]') &&
            _websocket != null &&
            _status == 'opened') {
          _websocket!.sink.add('[heartbeat]pong');
          return;
        }
        onAnswer(data);
      },
      onDone: () {
        _status = 'closed';
        _endHeartBeat();
        // 保留websocket实例，用于处理异步的操作
        String? reason = _websocket!.closeReason;
        onEnd(reason, _endType);
      },
      onError: (error) async {
        _status = 'closed';
        _endHeartBeat();
        await _websocket!.sink
            .close(WebSocketStatus.internalServerError, 'Error');
      },
      cancelOnError: false,
    );
    return sessionId;
  }

  void sendMessage({
    required String text,
    required Function() onUninited,
    required Function() onSuccess,
    required Function() onFail,
  }) async {
    if (_websocket == null && _status == '') {
      onUninited();
      return;
    }
    if (_status == 'closed') {
      onFail();
      return;
    }
    _websocket!.sink.add(text);
    onSuccess();
  }

  Future<void> endChat([bool force = false]) async {
    if (_websocket == null) {
      return;
    }
    _endType = force ? 'force' : 'normal';
    await _websocket!.sink.close(WebSocketStatus.normalClosure, 'Session End');
  }

  Future<String> _connect(String characterId, String? sceneId) async {
    String sessionId = const Uuid().v4().replaceAll('-', '');
    String deviceId = await Device.getDeviceId();
    String token = LoginManager.getUserToken();
    // 测试
    String uri = 'wss://api.bubble.shenmo-ai.net/ws/$sessionId?platform=app&device_id=$deviceId&character_id=$characterId&language=en-US&token=$token&use_search=false&use_quivr=false&use_multion=false';
    // 正式
    // String uri = 'wss://api.bubble.shenmo-ai.com/ws/$sessionId?platform=app&device_id=$deviceId&character_id=$characterId&language=en-US&token=$token&use_search=false&use_quivr=false&use_multion=false';
    if (sceneId != null) {
      uri = '$uri&scene_id=$sceneId';
    }
    try {
      _websocket = WebSocketChannel.connect(Uri.parse(uri));
      return sessionId;
    } catch (e) {
      rethrow;
    }
  }

  void _startHeartbeat() {
    _heartbeat = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_status == 'closed') {
        _endHeartBeat();
        return;
      }
      _websocket!.sink.add('[heartbeat]pong');
    });
  }

  void _endHeartBeat() {
    if (_heartbeat != null) {
      _heartbeat!.cancel();
      _heartbeat = null;
    }
  }
}
