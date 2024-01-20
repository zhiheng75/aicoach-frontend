// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/util/log_utils.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';

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

  bool get banUsePlayer => _banUsePlayer;

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

  /** 上传音频 */
  Uint8List toWav(List<int> data) {
    var channels = 1;

    int sampleRate = 16000;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = data.length;

    var fileSize = size + 36;

    return Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      ...data
    ]);
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
    Function()? whenFinished,
  }) async {
    try {
      if (_player == null) {
        FlutterSoundPlayer? player  = await _createPlayer();
        if (player == null) {
          throw Exception();
        }
        _player = player;
      }
      Log.d('播放语音', tag: 'play');
      _player!.startPlayer(
        fromURI: url,
        fromDataBuffer: buffer,
        whenFinished: () async {
          Log.d('播放语音结束', tag: 'play');
          if (whenFinished != null) {
            whenFinished();
          }
        },
      );
    } catch (e) {
      Log.d('播放语音出错', tag: 'play');
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
      Log.d('ban', tag: 'playLoop');
      if (whenFinished != null) {
        whenFinished();
      }
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
      _player!.audioPlayerFinished(PlayerState.isPlaying.index);
      await Future.delayed(const Duration(milliseconds: 300));
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
      Log.d('ban or end', tag: '_playLoop');
      if (whenFinished != null) {
        whenFinished();
      }
      return;
    }
    _playing = true;
    Uint8List buffer = _bufferList.removeAt(0);
    try {
      saveMp3(buffer, (url) {
        play(
          url: url,
          whenFinished: () {
            _playing = false;
            _playLoop(
              whenFinished: whenFinished,
            );
          },
        );
      });
    } catch (e) {
      _playing = false;
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

  /** 格式转换 */
  Future<void> saveMp3(Uint8List buffer, Function(String) onSuccess) async {
    try {
      String dirPath = await _getTemDirPath();
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1().replaceAll('-', '')}.mp3';
      File file = File('$dirPath/$fileName');
      if (!file.existsSync()) {
        file.createSync();
      }
      file.writeAsBytesSync(buffer.toList(), flush: true);
      onSuccess(file.path);
    } catch (error) {
      onSuccess('');
    }
  }

  Future<Uint8List> convertMp3ToPcm(String mp3Path) async {
    try {
      File file = File(mp3Path);
      if (!file.existsSync()) {
        throw Exception('No File');
      }
      String dirPath = await _getTemDirPath();
      String pcmPath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1().replaceAll('-', '')}.pcm';
      FFmpegSession session = await FFmpegKit.execute('-i $mp3Path -f s16le $pcmPath');
      ReturnCode? code = await session.getReturnCode();
      if (code != ReturnCode.success) {
        throw Exception('Convert Fail');
      }
      File pcm = File(pcmPath);
      if (!pcm.existsSync()) {
        throw Exception('Convert Fail');
      }
      return pcm.readAsBytes();
    } catch (error) {
      rethrow;
    }
  }

  Uint8List convertWavToPcm(Uint8List wavBuffer) {
    return FlutterSoundHelper().waveToPCMBuffer(inputBuffer: wavBuffer);
  }

  Future<String> _getTemDirPath() async {
    Directory dir = await getTemporaryDirectory();
    return dir.path;
  }

}