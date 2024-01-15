// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart';

List<Uint8List> _bufferList = [];
bool _playing = false;

class MediaUtils {

  factory MediaUtils() {
    return _mediaUtils;
  }
  MediaUtils._internal();

  static final MediaUtils _mediaUtils = MediaUtils._internal();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  StreamSubscription? _subscription;
  StreamController<Food>? _controller;
  // 是否禁用播放器
  bool _banUsePlayer = false;

  /** 录音器 */
  void startRecord({
    required Function(Uint8List buffer) onData,
    required Function(Uint8List?) onComplete,
  }) async {
    try {
      _recorder = await _createRecorder();
      if (_recorder == null) {
        throw Exception('录音功能初始化失败，请重启App');
      }
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

  Future<void> _destroyRecorder() async {
    if (_recorder == null) {
      return;
    }
    await _recorder!.closeRecorder();
    _recorder = null;
  }

  /** 播放器 */
  void play({
    String? url,
    Uint8List? buffer,
    bool closeAfterFinish = true,
    Function()? whenFinished,
  }) async {
    if (_banUsePlayer) {
      return;
    }
    try {
      if (_player == null) {
        FlutterSoundPlayer? player  = await _createPlayer();
        if (player == null) {
          throw Exception();
        }
        _player = player;
      }
      _player!.startPlayer(
        fromURI: url,
        fromDataBuffer: buffer,
        whenFinished: () async {
          if (whenFinished != null) {
            whenFinished();
          }
          if (closeAfterFinish) {
            await _destroyPlayer();
          }
        },
      );
    } catch (e) {
      if (whenFinished != null) {
        whenFinished();
      }
    }
  }

  void playLoop({
    required Uint8List buffer,
    Function()? whenFinished,
  }) async {
    if (_banUsePlayer) {
      return;
    }
    _bufferList.add(buffer);
    if (_playing) {
      return;
    }
    _playLoop(
      whenFinished: whenFinished,
    );
  }

  Future<void> stopPlay([bool banUsePlayer = false]) async {
    _banUsePlayer = banUsePlayer;
    if (_player == null) {
      return;
    }
    if (_player!.isPlaying) {
      await _player!.stopPlayer();
      await _destroyPlayer();
    }
  }

  Future<void> stopPlayLoop([bool banUsePlayer = false]) async {
    await stopPlay(banUsePlayer);
    _playing = false;
  }

  void resumeUse() {
    _banUsePlayer = false;
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

  void _playLoop({
    Function()? whenFinished,
  }) async {
    if (_banUsePlayer || _bufferList.isEmpty) {
      if (whenFinished != null) {
        whenFinished();
      }
      await _destroyPlayer();
      return;
    }
    try {
      _playing = true;
      Uint8List buffer = _bufferList.removeAt(0);
      play(
        buffer: buffer,
        whenFinished: () {
          _playing = false;
          _playLoop(
            whenFinished: whenFinished,
          );
        },
      );
    } catch (e) {
      _playLoop(
        whenFinished: whenFinished,
      );
    }
  }

  Future<void> _destroyPlayer() async {
    if (_player == null) {
      return;
    }
    await _player!.closePlayer();
    _player = null;
  }

}