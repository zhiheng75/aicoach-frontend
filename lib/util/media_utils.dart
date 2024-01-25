// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// 获取临时文件夹
Future<String> getTemDirPath() async {
  Directory dir = await getTemporaryDirectory();
  return dir.path;
}
// 列表播放
List<Player> _playerList = [];
Player? _currentPlayer;

class MediaUtils {
  factory MediaUtils() {
    return _mediaUtils;
  }
  MediaUtils._internal();

  static final MediaUtils _mediaUtils = MediaUtils._internal();
  FlutterSoundRecorder? _recorder;
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

  Future<FlutterSoundRecorder?> _createRecorder() async {
    FlutterSoundRecorder? recorder;
    try {
      recorder =
          await FlutterSoundRecorder(logLevel: Level.nothing).openRecorder();
    } catch (e) {
      rethrow;
    }
    return recorder;
  }

  void _addListener(
      Function(Uint8List) listener, Function(Uint8List?) complete) {
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
    List<Uint8List>? pcmBuffer,
    Uint8List? mp3Buffer,
    Function()? whenFinished,
  }) async {
    whenFinished ??= () {};
    if (url == null && pcmBuffer == null && mp3Buffer == null) {
      whenFinished();
      return;
    }
    // 创建
    if (url != null) {
      FilePlayer filePlayerByUrl = FilePlayer(whenFinished);
      filePlayerByUrl.url = url;
      _playerList.add(filePlayerByUrl);
    }
    if (pcmBuffer != null) {
      _playerList.add(BufferPlayer(pcmBuffer, whenFinished));
    }
    if (mp3Buffer != null) {
      FilePlayer filePlayerByBuffer = FilePlayer(whenFinished);
      filePlayerByBuffer.buffer = mp3Buffer;
      _playerList.add(filePlayerByBuffer);
    }
    if (_currentPlayer != null) {
      return;
    }
    _play();
  }

  void playLoop({
    required Uint8List buffer,
    Function()? whenFinished,
  }) async {
    play(
      mp3Buffer: buffer,
      whenFinished: whenFinished,
    );
  }

  Future<void> stopPlay([bool banUsePlayer = false]) async {
    // 备份未播放
    List<Player> playListForUnplay = _playerList;
    _playerList = [];
    if (_currentPlayer != null) {
      playListForUnplay.insert(0, _currentPlayer!);
    }
    // 停止
    for (Player player in playListForUnplay) {
      if (player is BufferPlayer) {
        await (player as BufferPlayer).stop();
      }
      if (player is FilePlayer) {
        await (player as FilePlayer).stop();
      }
    }
    _currentPlayer = null;
  }

  Future<void> stopPlayLoop([bool banUsePlayer = false]) async {
    await stopPlay(banUsePlayer);
  }

  Future<void> _play() async {
    if (_playerList.isEmpty) {
      return;
    }
    Player player = _playerList.removeAt(0);
    _currentPlayer = player;
    if (_currentPlayer is BufferPlayer) {
      (_currentPlayer as BufferPlayer).play(() {
        _currentPlayer = null;
        _play();
      });
    }
    if (_currentPlayer is FilePlayer) {
      (_currentPlayer as FilePlayer).play(() {
        _currentPlayer = null;
        _play();
      });
    }
  }
}

class AudioConvertUtil {

  static Future<String> saveMp3Buffer(Uint8List buffer) async {
    String dirPath = await getTemDirPath();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1().replaceAll('-', '')}.mp3';
    String path = '$dirPath/$fileName';
    File file = File(path);
    if (!file.existsSync()) {
      file.createSync();
    }
    try {
      file.writeAsBytesSync(buffer.toList(), flush: true);
      return file.path;
    } catch (error) {
      return '';
    }
  }

  static Future<String> downloadMp3(String url) async {
    String dirPath = await getTemDirPath();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1().replaceAll('-', '')}.mp3';
    String path = '$dirPath/$fileName';
    try {
      await Dio().download(url, path);
      File file = File(path);
      if (file.existsSync()) {
        return file.path;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static Future<Uint8List> convertPcmToWav(List<Uint8List> pcm) async {
    List<int> bytes = [];
    for (Uint8List element in pcm) {
      bytes.addAll(element.map((item) => item).toList());
    }
    try {
      return await FlutterSoundHelper().pcmToWaveBuffer(inputBuffer: Uint8List.fromList(bytes));
    } catch (e) {
      return Uint8List(0);
    }
  }

}

class Player {

  Player();
  // 步骤 convert-格式转换 waitPlay-等待播放 play-播放 finished-结束
  String step = '';

}

class BufferPlayer extends Player {

  BufferPlayer(this.pcm, this.whenFinished);

  FlutterSoundPlayer? player;
  List<Uint8List> pcm;
  Uint8List wav = Uint8List(0);
  Function() whenFinished;

  Future<void> play(Function() onComplete) async {
    if (wav.isEmpty) {
      await _convert();
    }
    _play(onComplete);
  }

  Future<void> stop() async {
    if (step == 'play' && player != null) {
      player!.audioPlayerFinished(PlayerState.isPlaying.index);
    } else {
      step = 'finished';
    }
  }

  Future<void> _convert() async {
    step = 'convert';
    wav = await AudioConvertUtil.convertPcmToWav(pcm);
    step = 'waitPlay';
  }

  Future<void> _play(Function() onComplete) async {
    int maxCount = 300;
    // 还在转换中
    while(step == 'convert') {
      if (maxCount == 0) {
        break;
      }
      maxCount--;
      await Future.delayed(const Duration(milliseconds: 10));
    }
    // 等待超时
    if (step == 'convert' && maxCount == 0) {
      _onCallback(onComplete);
      return;
    }
    // 转换失败
    if (step == 'waitPlay' && wav.isEmpty) {
      _onCallback(onComplete);
      return;
    }
    // 中途被暂停
    if (step == 'finished') {
      _onCallback(onComplete);
      return;
    }
    // 播放
    try {
      player = await FlutterSoundPlayer(logLevel: Level.debug).openPlayer();
      if (player == null) {
        throw Exception();
      }
      step = 'play';
      player!.startPlayer(
        fromDataBuffer: wav,
        codec: Codec.pcm16WAV,
        whenFinished: () async {
          await player!.stopPlayer();
          await player!.closePlayer();
          _onCallback(onComplete);
        },
      );
    } catch (e) {
      _onCallback(onComplete);
    }
  }

  void _onCallback(Function() onComplete) {
    step = 'finished';
    whenFinished();
    onComplete();
  }

}

class FilePlayer extends Player {

  FilePlayer(this.whenFinished);

  FlutterSoundPlayer? player;
  String? url;
  Uint8List? buffer;
  String path = '';
  Function() whenFinished;

  Future<void> play(Function() onComplete) async {
    if (path.isEmpty) {
      await _convert();
    }
    _play(onComplete);
  }

  Future<void> stop() async {
    if (step == 'play' && player != null) {
      player!.audioPlayerFinished(PlayerState.isPlaying.index);
    } else {
      step = 'finished';
    }
  }

  Future<void> _convert() async {
    step = 'convert';
    if (url != null) {
      path = await AudioConvertUtil.downloadMp3(url!);
    }
    if (buffer != null && buffer!.isNotEmpty) {
     path = await AudioConvertUtil.saveMp3Buffer(buffer!);
    }
    step = 'waitPlay';
  }

  Future<void> _play(Function() onComplete) async {
    int maxCount = 300;
    // 还在转换中
    while(step == 'convert') {
      if (maxCount == 0) {
        break;
      }
      maxCount--;
      await Future.delayed(const Duration(milliseconds: 10));
    }
    // 等待超时
    if (step == 'convert' && maxCount == 0) {
      _onCallback(onComplete);
      return;
    }
    // 转换失败
    if (step == 'waitPlay' && path == '') {
      _onCallback(onComplete);
      return;
    }
    // 中途被暂停
    if (step == 'finished') {
      _onCallback(onComplete);
      return;
    }
    // 播放
    try {
      player = await FlutterSoundPlayer(logLevel: Level.debug).openPlayer();
      if (player == null) {
        throw Exception();
      }
      step = 'play';
      player!.startPlayer(
        fromURI: path,
        codec: Codec.mp3,
        whenFinished: () async {
          await player!.stopPlayer();
          await player!.closePlayer();
          _onCallback(onComplete);
        },
      );
    } catch (e) {
      _onCallback(onComplete);
    }
  }

  void _onCallback(Function() onComplete) {
    step = 'finished';
    whenFinished();
    onComplete();
  }
}
