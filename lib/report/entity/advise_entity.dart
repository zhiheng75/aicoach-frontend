import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../entity/result_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/media_utils.dart';
import '../../util/path_utils.dart';

class AdviseEntity {

  int type = 2;
  String sentence = '';
  String userSentence = '';
  String userAudio = '';
  num score = 0;
  String _standardAudio = '';
  CancelToken? cancelToken;
  // download-下载 convert-转换 waitPlay-等待播放 play-播放 finished-结束
  String _userAudioStep = '';
  String _standardAudioStep = '';
  final MediaUtils _mediaUtils = MediaUtils();
  String _playType = '';

  AdviseEntity();

  factory AdviseEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AdviseEntity entity = AdviseEntity();
    if (json['type'] != null) {
      entity.type = json['type'];
    }
    if (json['sentence'] != null) {
      entity.sentence = json['sentence'];
    }
    if (json['user_sentence'] != null) {
      entity.userSentence = json['user_sentence'];
    }
    if (json['user_audio'] != null) {
      entity.userAudio = json['user_audio'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sentence': sentence,
      'user_sentence': userSentence,
      'user_audio': userAudio,
      'score': score,
    };
  }

  void playUserVoice() async {
    if (userAudio == '') {
      return;
    }
    if (_playType == 'user' && _userAudioStep != '' && _userAudioStep != 'finished') {
      return;
    }
    if (_standardAudioStep == 'play') {
      await _mediaUtils.stopPlay();
    }
    _standardAudioStep = 'finished';
    _playType = 'user';
    // 判断本地有没有，没有就下载
    String documentDirPath = await PathUtils.getDocumentFolderPath();
    String key = md5.convert(utf8.encode(userAudio)).toString();
    String path = '$documentDirPath/$key.wav';
    File file = File(path);
    if (!file.existsSync()) {
      _userAudioStep = 'download';
      try {
        await Dio().download(userAudio, path);
        if (_userAudioStep == 'finished') {
          return;
        }
        Uint8List pcmBytes = await _wavToPcm(file);
        if (_userAudioStep == 'finished') {
          return;
        }
        _userAudioStep = 'play';
        _mediaUtils.play(pcmBuffer: [pcmBytes], whenFinished: () => _userAudioStep = 'finished');
      } catch (e) {
        _userAudioStep = 'finished';
      }
    } else {
      Uint8List pcmBytes = await _wavToPcm(file);
      if (_userAudioStep == 'finished') {
        return;
      }
      _userAudioStep = 'play';
      _mediaUtils.play(pcmBuffer: [pcmBytes], whenFinished: () => _userAudioStep = 'finished');
    }
  }

  void playStandardVoice() async {
    if (_playType == 'standard' && _standardAudioStep != '' && _standardAudioStep != 'finished') {
      return;
    }
    if (_userAudioStep == 'play') {
      await _mediaUtils.stopPlay();
    }
    _userAudioStep = 'finished';
    _playType = 'standard';
    _download((path) {
      _standardAudioStep = 'play';
      _mediaUtils.play(url: path, whenFinished: () => _standardAudioStep = 'finished');
    });
  }

  Future<void> stopAll() async {
    if (_userAudioStep == 'play') {
      await _mediaUtils.stopPlay();
    }
    _userAudioStep = 'finished';
    if (_standardAudioStep == 'play') {
      await _mediaUtils.stopPlay();
    }
    _standardAudioStep = 'finished';
    _playType = '';
  }

  Future<void> _download(Function(String path) onComplete) async {
    if (_standardAudio != '') {
      String path = await _getStandardAudioPath();
      File file = File(path);
      if (file.existsSync()) {
        onComplete(file.path);
        return;
      }
      _downloadAndSave(_standardAudio, path, () => onComplete(path));
      return;
    }
    if (cancelToken != null) {
      cancelToken!.cancel();
    }
    _standardAudioStep = 'download';
    _getAudioUrl((url) async {
      _standardAudio = url;
      String path = await _getStandardAudioPath();
      _downloadAndSave(url, path, () => onComplete(path));
    });
  }

  void _getAudioUrl(Function(String) onComplete) async {
    cancelToken = CancelToken();
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.suggestAnswer,
      params: {
        'question': sentence,
      },
      cancelToken: cancelToken,
      onSuccess: (result) async {
        cancelToken = null;
        if (_standardAudioStep == 'finished') {
          return;
        }
        if (result != null && result.data != null && (result.data as Map<String, dynamic>)['speech_url'] != null) {
          _standardAudioStep = 'convert';
          String url = (result.data as Map<String, dynamic>)['speech_url'];
          onComplete(url);
        }
      },
      onError: (_, __) {
        cancelToken = null;
      },
    );
  }

  Future<String> _getStandardAudioPath() async {
    String documentDirPath = await PathUtils.getDocumentFolderPath();
    String key = md5.convert(utf8.encode(_standardAudio)).toString();
    return '$documentDirPath/$key.mp3';
  }

  void _downloadAndSave(String url, String path, Function() onComplete) async {
    try {
      await Dio().download(url, path);
      if (_standardAudioStep == 'finished') {
        return;
      }
      _standardAudioStep = 'waitPlay';
      onComplete();
    } catch (e) {
      _standardAudioStep = 'finished';
    }
  }

  Future<Uint8List> _wavToPcm(file) async {
    _userAudioStep = 'convert';
    Uint8List wavBytes = await file.readAsBytes();
    Uint8List pcmBytes = AudioConvertUtil.convertWavToPcm(wavBytes);
    if (_userAudioStep == 'convert') {
      _userAudioStep = 'waitPlay';
    }
    return pcmBytes;
  }

}