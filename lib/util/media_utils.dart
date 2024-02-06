// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments, prefer_final_fields

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/util/log_utils.dart';
import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:volume_controller/volume_controller.dart';

import 'path_utils.dart';

class MediaUtils {
  factory MediaUtils() {
    return _mediaUtils;
  }
  MediaUtils._internal();

  static final MediaUtils _mediaUtils = MediaUtils._internal();
  FlutterSoundRecorder? _recorder;
  StreamSubscription? _subscription;
  StreamController<Food>? _controller;

  // 单一播放
  Player? _currentPlayer;
  // 列表播放（播放多段AI语音）
  ListPlayer? _listPlayer;

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
      _currentPlayer = filePlayerByUrl;
      filePlayerByUrl.play(() => null);
      return;
    }
    if (pcmBuffer != null) {
      BufferPlayer bufferPlayer = BufferPlayer(pcmBuffer, whenFinished);
      _currentPlayer = bufferPlayer;
      bufferPlayer.play(() => null);
      return;
    }
    if (mp3Buffer != null) {
      FilePlayer filePlayerByBuffer = FilePlayer(whenFinished);
      filePlayerByBuffer.buffer = mp3Buffer;
      _currentPlayer = filePlayerByBuffer;
      filePlayerByBuffer.play(() => null);
    }
  }

  ListPlayer createListPlay(Function() whenFinished) {
    ListPlayer listPlayer = ListPlayer(whenFinished);
    // 如果存在单一播放就不赋值
    if (_currentPlayer == null || (_currentPlayer != null && _currentPlayer!.step == 'finished')) {
      listPlayer.notPlaceHolder();
      _listPlayer = listPlayer;
    }
    return listPlayer;
  }

  Future<void> stopPlay() async {
    if (_currentPlayer != null) {
      Player player = _currentPlayer!;
      _currentPlayer = null;
      if (player is BufferPlayer) {
        await player.stop();
      }
      if (player is FilePlayer) {
       await player.stop();
      }
    }
    if (_listPlayer != null) {
      ListPlayer listPlayer = _listPlayer!;
      _listPlayer = null;
      await listPlayer.stop();
    }
  }

  Future<void> stopPlayByAppPaused() async {
    if (_currentPlayer != null) {
      Player player = _currentPlayer!;
      _currentPlayer = null;
      if (player is BufferPlayer) {
        await player.stopByAppPaused();
      }
      if (player is FilePlayer) {
        await player.stopByAppPaused();
      }
    }
    if (_listPlayer != null) {
      ListPlayer listPlayer = _listPlayer!;
      _listPlayer = null;
      await listPlayer.stopByAppPaused();
    }
  }
}

class VolumeUtil {

  static Future<double> getVolume() async {
    return VolumeController().getVolume();
  }

}

class AudioConfig {

  static Future<void> addAudioConfig() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

}

class AudioConvertUtil {

  static Future<String> saveMp3Buffer(Uint8List buffer) async {
    String dirPath = await PathUtils.getTemporaryFolderPath();
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
    String dirPath = await PathUtils.getTemporaryFolderPath();
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
      bytes.addAll(element.toList());
    }
    try {
      Uint8List wav = await FlutterSoundHelper().pcmToWaveBuffer(inputBuffer: Uint8List.fromList(bytes));
      return wav;
    } catch (e) {
      return Uint8List(0);
    }
  }

  static Uint8List convertWavToPcm(Uint8List wavBytes) {
    return FlutterSoundHelper().waveToPCMBuffer(inputBuffer: wavBytes);
  }

}

class Player {

  Player();
  // 步骤 convert-格式转换 waitPlay-等待播放 loadPlay-加载播放 play-播放 finished-结束
  String step = '';

}

class BufferPlayer extends Player {

  BufferPlayer(this.pcm, this.whenFinished);

  FlutterSoundPlayer? player;
  List<Uint8List> pcm;
  Uint8List wav = Uint8List(0);
  Function() whenFinished;
  Function()? onPlayComplete;
  bool isMultiple = false;

  Future<void> play(Function() onComplete) async {
    onPlayComplete = onComplete;
    if (wav.isEmpty) {
      await _convert();
    }
    _play();
  }

  Future<void> stop() async {
    if (step == 'finished') {
      return;
    }
    if (step == 'play') {
      step = 'finished';
      if (isMultiple) {
        _onCallback();
      }
      await player!.stopPlayer();
      await player!.closePlayer();
      return;
    }
    step = 'finished';
  }

  Future<void> stopByAppPaused() async {
    whenFinished();
    await stop();
  }

  Future<void> _convert() async {
    step = 'convert';
    wav = await AudioConvertUtil.convertPcmToWav(pcm);
    if (step == 'convert') {
      step = 'waitPlay';
    }
  }

  Future<void> _play() async {
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
      _onCallback();
      return;
    }
    // 转换失败
    if (step == 'waitPlay' && wav.isEmpty) {
      _onCallback();
      return;
    }
    // 中途被暂停
    if (step == 'finished') {
      if (isMultiple) {
        _onCallback();
      }
      return;
    }
    // 播放
    try {
      player = FlutterSoundPlayer(logLevel: Level.nothing);
      await player!.openPlayer();
      double volume = await VolumeUtil.getVolume();
      await player!.setVolume(volume);
      player!.startPlayer(
        fromDataBuffer: wav,
        codec: Codec.pcm16WAV,
        whenFinished: () async {
          step = 'finished';
          await player!.stopPlayer();
          await player!.closePlayer();
          _onCallback();
        },
      );
      step = 'play';
    } catch (e) {
      _onCallback();
    }
  }

  void _onCallback() {
    Log.d('结束触发回调');
    if (onPlayComplete != null) {
      onPlayComplete!();
    }
    whenFinished();
  }

}

class FilePlayer extends Player {

  FilePlayer(this.whenFinished);

  FlutterSoundPlayer? player;
  String? url;
  Uint8List? buffer;
  String path = '';
  Function() whenFinished;
  Function()? onPlayComplete;
  bool isMultiple = false;

  Future<void> play(Function() onComplete) async {
    onPlayComplete = onComplete;
    // 本地文件
    if (url != null && !RegExp(r'^(http|https)').hasMatch(url!)) {
      path = url!;
    }
    if (path.isEmpty) {
      await _convert();
    }
    _play();
  }

  Future<void> stop() async {
    if (step == 'finished') {
      return;
    }
    if (step == 'play') {
      step = 'finished';
      if (isMultiple) {
        _onCallback();
      }
      await player!.stopPlayer();
      await player!.closePlayer();
      return;
    }
    step = 'finished';
  }

  Future<void> stopByAppPaused() async {
    whenFinished();
    await stop();
  }

  Future<void> _convert() async {
    step = 'convert';
    if (url != null) {
      path = await AudioConvertUtil.downloadMp3(url!);
    }
    if (buffer != null && buffer!.isNotEmpty) {
     path = await AudioConvertUtil.saveMp3Buffer(buffer!);
    }
    if (step == 'convert') {
      step = 'waitPlay';
    }
  }

  Future<void> _play() async {
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
      _onCallback();
      return;
    }
    // 转换失败
    if (step == 'waitPlay' && path == '') {
      _onCallback();
      return;
    }
    // 中途被暂停
    if (step == 'finished') {
      if (isMultiple) {
        _onCallback();
      }
      return;
    }
    // 播放
    try {
      player = FlutterSoundPlayer(logLevel: Level.nothing);
      await player!.openPlayer();
      double volume = await VolumeUtil.getVolume();
      await player!.setVolume(volume);
      player!.startPlayer(
        fromURI: path,
        codec: Codec.mp3,
        whenFinished: () async {
          step = 'finished';
          await player!.stopPlayer();
          await player!.closePlayer();
          _onCallback();
        },
      );
      step = 'play';
    } catch (e) {
      _onCallback();
    }
  }

  void _onCallback() {
    if (onPlayComplete != null) {
      onPlayComplete!();
    }
    whenFinished();
  }
}

class ListPlayer {
  ListPlayer(this._whenFinished);

  List<FilePlayer> _playList = [];
  // 是否所有音频已返回
  bool _isReturnEnd = false;
  Function() _whenFinished;
  FilePlayer? _currentPlayer;
  bool _isDestroyed = false;
  // 当单一播放在执行时，创建一个流程列表播放
  bool _isPlaceHolder = true;

  void play(Uint8List mp3Buffer) {
    // 已销毁
    if (_isDestroyed) {
      return;
    }
    // 流程列表播放
    if (_isPlaceHolder) {
      return;
    }
    // 空音频
    if (mp3Buffer.isEmpty) {
      return;
    }
    FilePlayer filePlayer = FilePlayer(() => null);
    filePlayer.buffer = mp3Buffer;
    filePlayer.isMultiple = true;
    _playList.add(filePlayer);
    if (_currentPlayer != null) {
      return;
    }
    _play();
  }

  Future<void> stop() async {
    _isDestroyed = true;
    // 有播放
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      _playList = [];
      // 当前播放
      return;
    }
    // 全部播放完毕
    if (_isReturnEnd && _playList.isEmpty) {
      return;
    }
  }

  Future<void> stopByAppPaused() async {
    _whenFinished();
    await stop();
  }

  void notPlaceHolder() {
    _isPlaceHolder = false;
  }

  void setReturnEnd() {
    _isReturnEnd = true;
    // 已销毁
    if (_isDestroyed) {
      _whenFinished();
      return;
    }
    // 没有播放
    if (_currentPlayer == null) {
      _whenFinished();
    }
  }

  void _play() {
    if (_isDestroyed) {
      _whenFinished();
      return;
    }
    if (_playList.isEmpty) {
      _currentPlayer = null;
      // 未返回完音频
      if (!_isReturnEnd) {
        return;
      }
      _whenFinished();
      return;
    }
    FilePlayer player = _playList.removeAt(0);
    _currentPlayer = player;
    player.play(_play);
  }
}
