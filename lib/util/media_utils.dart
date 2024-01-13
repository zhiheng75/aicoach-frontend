// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart';

import 'log_utils.dart';

List<Uint8List> _bufferList = [];
bool _playing = false;

class MediaUtils {

  MediaUtils();

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  StreamSubscription? _subscription;
  StreamController<Food>? _controller;

  void play(String audioPath, { Function? whenFinished }) async {
    try {
      FlutterSoundPlayer? player  = await _createPlayer();
      if (player == null) {
        throw Exception();
      }
      _player = player;
      _player!.startPlayer(
        fromURI: audioPath,
        whenFinished: () async {
          await _destroyPlayer();
          if (whenFinished != null) {
            whenFinished();
          }
        },
      );
    } catch (e) {
      if (whenFinished != null) {
        whenFinished();
      }
    }
  }

  void playLoop(Uint8List buffer, { Function()? whenFinished }) async {
    _bufferList.add(buffer);
    if (_playing) {
      return;
    }
    _playLoop(whenFinished);
  }

  void startRecord({
    required Function(Uint8List buffer) onData,
    required Function(Uint8List?) onComplete,
  }) async {
    try {
      _recorder = await _createRecorder();
      if (_recorder == null) {
        throw Exception('录音功能初始化失败，请重启App');
      }
      Log.d('开始录音', tag: 'startRecord');
      // 监听数据流
      _addListener(onData, onComplete);
      // 开始录音
      _recorder!.startRecorder(
        codec: Codec.pcm16,
        toStream: _controller!.sink,
        audioSource: AudioSource.voice_recognition,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopRecord() async {
    if (_recorder == null) {
      return;
    }
    // 是否录音中
    if (_recorder!.isRecording) {
      Log.d('停止录音', tag: 'stopRecord');
      if (_controller != null) {
        await _controller!.sink.close();
      }
      await _recorder!.stopRecorder();
      await _destroyRecorder();
    }
  }

  Future<bool> checkMicrophonePermission() async {
    bool isRequest = false;
    PermissionStatus status = await Permission.microphone.status;
    if (status == PermissionStatus.denied) {
      isRequest = true;
      status = await Permission.microphone.request();
      if (status == PermissionStatus.denied) {
        throw Exception('用户拒绝权限');
      }
    }
    if (status == PermissionStatus.permanentlyDenied) {
      throw Exception('请前往App权限设置开启录音权限');
    }
    return isRequest;
  }

  Future<FlutterSoundRecorder?> _createRecorder() async {
    FlutterSoundRecorder? recorder;
    try {
      recorder = await FlutterSoundRecorder(logLevel: Level.nothing).openRecorder();
    } catch (e) {
      rethrow;
    }
    return recorder;
  }

  Future<FlutterSoundPlayer?> _createPlayer() async {
    FlutterSoundPlayer? player;
    try {
      player = await FlutterSoundPlayer(logLevel: Level.nothing).openPlayer();
    } catch (e) {
      rethrow;
    }
    return player;
  }

  Future<void> _destroyRecorder() async {
    if (_recorder == null) {
      return;
    }
    await _recorder!.closeRecorder();
    _recorder = null;
  }

  Future<void> _destroyPlayer() async {
    if (_player == null) {
      return;
    }
    await _player!.closePlayer();
    _player = null;
  }

  void _addListener(Function(Uint8List) listener, Function(Uint8List?) complete) {
    _controller = StreamController<Food>();
    _subscription = _controller!.stream.listen(
      (food) {
        if (food is FoodData && food.data != null) {
          listener(food.data!);
        }
      },
      onDone: () async {
        await _removeListener();
        complete(null);
      },
      onError: (_) async {
        await _removeListener();
        complete(null);
      },
      cancelOnError: true,
    );
  }

  Future<void> _removeListener() async {
    if (_controller != null) {
      if (!_controller!.isClosed) {
        await _controller!.close();
      }
      _controller = null;
    }
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
  }

  void _playLoop([Function()? whenFinished]) async {
    if (_bufferList.isEmpty) {
      await _destroyPlayer();
      if (whenFinished != null) {
        whenFinished();
      }
      return;
    }
    try {
      _playing = true;
      Uint8List buffer = _bufferList.removeAt(0);
      if (_player == null) {
        FlutterSoundPlayer? player  = await _createPlayer();
        if (player == null) {
          throw Exception();
        }
        _player = player;
      }
      _player!.startPlayer(
        fromDataBuffer: buffer,
        whenFinished: () {
          _playing = false;
          _playLoop(whenFinished);
        },
      );
    } catch (e) {
      _playing = false;
      _playLoop(whenFinished);
    }
  }

}