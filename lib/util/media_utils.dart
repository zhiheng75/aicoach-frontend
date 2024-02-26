// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments, prefer_final_fields

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/chat/widget/background.dart';
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
    bool useAvatar = false,
    StreamController? loadingStreamController,
  }) async {
    whenFinished ??= () {};
    if (url == null && pcmBuffer == null && mp3Buffer == null) {
      whenFinished();
      return;
    }
    // 创建
    if (url != null) {
      FilePlayer filePlayerByUrl = FilePlayer(whenFinished, useAvatar);
      filePlayerByUrl.url = url;
      filePlayerByUrl.loadingStreamController = loadingStreamController;
      _currentPlayer = filePlayerByUrl;
      filePlayerByUrl.play(() => null);
      return;
    }
    if (pcmBuffer != null) {
      BufferPlayer bufferPlayer = BufferPlayer(pcmBuffer, whenFinished, useAvatar);
      bufferPlayer.loadingStreamController = loadingStreamController;
      _currentPlayer = bufferPlayer;
      bufferPlayer.play(() => null);
      return;
    }
    if (mp3Buffer != null) {
      FilePlayer filePlayerByBuffer = FilePlayer(whenFinished, useAvatar);
      filePlayerByBuffer.buffer = mp3Buffer;
      filePlayerByBuffer.loadingStreamController = loadingStreamController;
      _currentPlayer = filePlayerByBuffer;
      filePlayerByBuffer.play(() => null);
    }
  }

  ListPlayer createListPlay(Function() whenFinished, [bool isNormalChat = false]) {
    ListPlayer listPlayer = ListPlayer(whenFinished, isNormalChat);
    // 如果存在单一播放就不赋值
    if (_currentPlayer == null || (_currentPlayer != null && _currentPlayer!.isEnd)) {
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
    AvatarController().stopSpeak();
  }

  // Future<void> stopPlayByAppPaused() async {
  //   if (_currentPlayer != null) {
  //     Player player = _currentPlayer!;
  //     _currentPlayer = null;
  //     if (player is BufferPlayer) {
  //       await player.stopByAppPaused();
  //     }
  //     if (player is FilePlayer) {
  //       await player.stopByAppPaused();
  //     }
  //   }
  //   if (_listPlayer != null) {
  //     ListPlayer listPlayer = _listPlayer!;
  //     _listPlayer = null;
  //     await listPlayer.stopByAppPaused();
  //   }
  // }
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
  // String step = '';
  bool isEnd = false;

}

class BufferPlayer extends Player {

  BufferPlayer(this.pcm, this.whenFinished, this.useAvatar);

  List<Uint8List> pcm;
  bool isMultiple = false;
  bool useAvatar;
  Function() whenFinished;
  Function()? onPlayComplete;
  late AudioPlayController audioPlayController;
  StreamController? loadingStreamController;

  Future<void> play(Function() onComplete) async {
    onPlayComplete = onComplete;
    audioPlayController = AudioPlayController(
      pcmBuffer: pcm,
      isMultiple: isMultiple,
      useAvatar: useAvatar,
      loadingStreamController: loadingStreamController,
      whenFinished: _onCallback,
    );
    audioPlayController.run();
  }

  Future<void> stop() async {
    audioPlayController.end();
  }

  void _onCallback() {
    isEnd = true;
    if (onPlayComplete != null) {
      onPlayComplete!();
    }
    whenFinished();
  }

}

class FilePlayer extends Player {

  FilePlayer(this.whenFinished, this.useAvatar);

  String? url;
  Uint8List? buffer;
  bool isMultiple = false;
  // 是否使用语音头像
  bool useAvatar;
  Function()? onPlayComplete;
  Function() whenFinished;
  late AudioPlayController audioPlayController;
  StreamController? loadingStreamController;

  Future<void> play(Function() onComplete) async {
    onPlayComplete = onComplete;
    audioPlayController = AudioPlayController(
      url: url,
      mp3Buffer: buffer,
      useAvatar: useAvatar,
      isMultiple: isMultiple,
      loadingStreamController: loadingStreamController,
      whenFinished: _onCallback,
    );
    audioPlayController.run();
  }

  Future<void> stop() async {
    audioPlayController.end();
  }

  void _onCallback() {
    isEnd = true;
    if (onPlayComplete != null) {
      onPlayComplete!();
    }
    whenFinished();
  }
}

class ListPlayer {
  ListPlayer(this._whenFinished, this._isNormalChat);

  List<FilePlayer> _playList = [];
  // 是否所有音频已返回
  bool _isReturnEnd = false;
  Function() _whenFinished;
  FilePlayer? _currentPlayer;
  bool _isDestroyed = false;
  // 当单一播放在执行时，创建一个流程列表播放
  bool _isPlaceHolder = true;
  // 是否是自由对话
  bool _isNormalChat;

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
    FilePlayer filePlayer = FilePlayer(() => null, _isNormalChat);
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

  // Future<void> stopByAppPaused() async {
  //   _whenFinished();
  //   await stop();
  // }

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

// 利用StreamController进行音频播放流程控制
class AudioPlayController {

  AudioPlayController({
    String? url,
    List<Uint8List>? pcmBuffer,
    Uint8List? mp3Buffer,
    Function()? whenFinished,
    bool useAvatar = false,
    bool isMultiple = false,
    StreamController? loadingStreamController,
  }) {
    _streamController = StreamController.broadcast();
    _url = url;
    _pcmBuffer = pcmBuffer;
    _mp3Buffer = mp3Buffer;
    _whenFinished = whenFinished ?? () {};
    _useAvatar = useAvatar;
    _isMultiple = isMultiple;
    _loadingStreamController = loadingStreamController;
  }

  StreamController? _streamController;
  String? _url;
  List<Uint8List>? _pcmBuffer;
  Uint8List? _mp3Buffer;
  late Function() _whenFinished;
  late bool _useAvatar;
  late bool _isMultiple;
  StreamController? _loadingStreamController;
  String _step = '';
  String _path = '';
  Uint8List _wav = Uint8List(0);
  FlutterSoundPlayer? _player;

  void run() {
    _streamController!.stream.listen(
      _onData,
    );
    _streamController!.add('DOWNLOAD');
    Log.d('执行音频播放流程');
  }

  void end() {
    _streamController?.add('END');
  }

  void _onData(dynamic data) async {
    if (data == 'END') {
      Log.d('强制结束');
      _streamController = null;
      String lastStep = _step;
      _step = data;
      if (lastStep == 'PLAY') {
        Log.d('强制结束时正在播放');
        await _player!.stopPlayer();
        await _player!.closePlayer();
        AvatarController().stopSpeak();
      }
      if (_isMultiple) {
        _whenFinished();
      }
      if (_loadingStreamController != null) {
        _loadingStreamController!.add(false);
      }
      return;
    }
    // 是否已中途结束
    if (_step == 'END') {
      Log.d('已结束');
      return;
    }
    // url远程下载或者流下载
    if (data == 'DOWNLOAD') {
      _step = data;
      if (_url != null) {
        if (RegExp(r'^(http|https)').hasMatch(_url!)) {
          _path = await AudioConvertUtil.downloadMp3(_url!);
        } else {
          _path = _url!;
        }
      }
      if (_mp3Buffer != null && _mp3Buffer!.isNotEmpty) {
        _path = await AudioConvertUtil.saveMp3Buffer(_mp3Buffer!);
      }
      Log.d('下载完成开始转换');
      _streamController?.add('CONVERT');
    }
    if (data == 'CONVERT') {
      _step = data;
      if (_pcmBuffer != null && _pcmBuffer!.isNotEmpty) {
        _wav = await AudioConvertUtil.convertPcmToWav(_pcmBuffer!);
      }
      Log.d('转换完成开始播放');
      _streamController?.add('PLAY');
    }
    if (data == 'PLAY') {
      _step = data;
      try {
        _player = FlutterSoundPlayer(logLevel: Level.nothing);
        await _player!.openPlayer();
        double volume = await VolumeUtil.getVolume();
        await _player!.setVolume(volume);
        if (_path != '') {
          _player!.startPlayer(
            fromURI: _path,
            codec: Codec.mp3,
            whenFinished: () async {
              Log.d('播放结束');
              _streamController = null;
              await _player!.stopPlayer();
              await _player!.closePlayer();
              AvatarController().stopSpeak();
              _whenFinished();
            },
          );
        }
        if (_wav.isNotEmpty) {
          _player!.startPlayer(
            fromDataBuffer: _wav,
            codec: Codec.pcm16WAV,
            whenFinished: () async {
              Log.d('播放结束');
              _streamController = null;
              await _player!.stopPlayer();
              await _player!.closePlayer();
              AvatarController().stopSpeak();
              _whenFinished();
            },
          );
        }
        if (_useAvatar) {
          AvatarController().startSpeak();
        }
        if (_loadingStreamController != null) {
          _loadingStreamController!.add(false);
        }
      } catch(e) {
        Log.d('播放异常而结束');
        _streamController = null;
        _whenFinished();
      }
    }
  }
}
