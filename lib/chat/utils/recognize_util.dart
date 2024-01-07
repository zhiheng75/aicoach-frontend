import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'xunfei_util.dart';

class RecognizeUtil {

  RecognizeUtil();

  StreamSubscription? _subscription;
  StreamController<UnRecognizedData>? _controller;
  WebSocketChannel? _websocket;
  Map<String, dynamic> _recognizeResult = {};
  String _recognizedText = '';
  // websocket是否主动断开连接中
  bool _isDisconnecting = false;

  void recognize(Function(Map<String, dynamic>) onSuccess) async {
    try {
      _recognizedText = '';
      await _connectXfRecognization(onSuccess);
      _controller = StreamController<UnRecognizedData>();
      _subscription = _controller!.stream.listen(
        (event) {
          if (_isDisconnecting) {
            return;
          }
          if (_websocket != null) {
            Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(event.frame, audio: event.buffer);
            _websocket!.sink.add(jsonEncode(data));
          }
        },
        onDone: () async {
          await _releaseSubscription();
        },
        onError: (_) async {
          await _releaseSubscription();
        },
        cancelOnError: false,
      );
    } catch (e) {
      onSuccess({
        'success': false,
        'message': '发生异常，请重新操作',
      });
    }
  }

  void pushAudioBuffer(int frame, Uint8List buffer) {
    if (_controller != null) {
      UnRecognizedData unRecognizedData = UnRecognizedData(frame, buffer);
      _controller!.sink.add(unRecognizedData);
    }
  }

  Future<void> _connectXfRecognization(Function(Map<String, dynamic>) onSuccess) async {
    try {
      String date = HttpDate.format(DateTime.now());
      String uri = 'wss://iat-api.xfyun.cn:443/v2/iat?host=iat-api.xfyun.cn&date=$date&authorization=${XunfeiUtil.getRecognizeAuthorization(date)}';
      _websocket = WebSocketChannel.connect(Uri.parse(uri));
      // 发送首帧数（参数）
      Map<String, dynamic> data = XunfeiUtil.createFrameDataForRecognization(0);
      _websocket!.sink.add(jsonEncode(data));
      _websocket!.stream.listen(
        (message) async {
          Map<String, dynamic> result = XunfeiUtil.getRecognizeResult(jsonDecode(message));
          if (result['code'] != 0) {
            _recognizeResult = {
              'success': false,
              'message': '发生异常，请重新操作',
            };
            await _disconnectXfRecognization(WebSocketStatus.normalClosure, result['message']);
            return;
          }
          _recognizedText += result['text'];
          if (result['status'] == 2) {
            // 判断是否触发静音检测
            if (_recognizedText == '') {
              _recognizeResult = {
                'success': false,
                'message': '未检测到语音，请重新操作',
              };
              await _disconnectXfRecognization(WebSocketStatus.normalClosure, 'Fail');
              return;
            }
            _recognizeResult = {
              'success': true,
              'text': _recognizedText,
            };
            await _disconnectXfRecognization(WebSocketStatus.normalClosure, 'Normal');
          }
        },
        onDone: () async {
          onSuccess(_recognizeResult);
        },
        onError: (error) async {
          _recognizeResult = {
            'success': false,
            'message': '发生异常，请重新操作',
          };
          await _disconnectXfRecognization(WebSocketStatus.abnormalClosure, error.toString());
        },
        cancelOnError: true,
      );
    } catch (e) {
     rethrow;
    }
  }

  Future<void> cancelRecognize() async {
    _recognizeResult = {
      'success': false,
      'message': '已取消',
    };
    await _disconnectXfRecognization(WebSocketStatus.normalClosure, 'Cancel');
  }

  Future<void> _disconnectXfRecognization(int code, String reason) async {
    _isDisconnecting = true;
    if (_websocket != null) {
      await _websocket!.sink.close(code, reason);
      _websocket = null;
    }
    _isDisconnecting = false;
  }

  Future<void> _releaseSubscription() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
  }

}

class UnRecognizedData {

  UnRecognizedData([int? frame, Uint8List? buffer]) {
    if (frame != null) {
      _frame = frame;
    }
    if (buffer != null) {
      _buffer = buffer;
    }
  }

  // 帧 0-首帧 1-中间帧 2-尾帧
  late int _frame;
  late Uint8List _buffer;

  int get frame => _frame;
  Uint8List get buffer => _buffer;

}