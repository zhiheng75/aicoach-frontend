import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/path_utils.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

class AnalysisEntity {

  int type = 2;
  String sentence = '';
  String userSentence = '';
  num score = 0;
  List<GrammarEntity> grammar = [];
  List<PronounceEntity> pronounce = [];

  AnalysisEntity();

  factory AnalysisEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    AnalysisEntity entity = AnalysisEntity();
    if (json['type'] != null) {
      entity.type = json['type'];
    }
    if (json['sentence'] != null) {
      entity.sentence = json['sentence'];
    }
    if (json['user_sentence'] != null) {
      entity.userSentence = json['user_sentence'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['grammar'] != null && json['grammar'] is List) {
      entity.grammar = (json['grammar'] as List).map((item) => GrammarEntity.fromJson(item)).toList();
    }
    if (json['pronounce'] != null && json['pronounce'] is List) {
      entity.pronounce = (json['pronounce'] as List).map((item) => PronounceEntity.fromJson(item)).toList();
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sentence': sentence,
      'user_sentence': userSentence,
      'grammar': grammar.map((item) => item.toJson()).toList(),
      'pronounce': pronounce.map((item) => item.toJson()).toList(),
    };
  }

}

class GrammarEntity {
  String en = '';
  String zh = '';

  GrammarEntity();

  factory GrammarEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    GrammarEntity entity = GrammarEntity();
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
    };
  }
}

class PronounceEntity {
  String text = '';
  String audio = '';
  int begin = 0;
  int end = 0;
  CancelToken? cancelToken;
  // download-下载 convert-转换 waitPlay-等待播放 play-播放 finished-结束
  String _userAudioStep = '';
  String _standardAudioStep = '';
  final MediaUtils _mediaUtils = MediaUtils();
  String _playType = '';

  PronounceEntity();

  factory PronounceEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    PronounceEntity entity = PronounceEntity();
    if (json['content'] != null) {
      entity.text = json['content'];
    }
    if (json['beg_pos'] != null) {
      entity.begin = json['beg_pos'] is int ? json['beg_pos'] : int.parse((json['beg_pos']).toString());
    }
    if (json['end_pos'] != null) {
      entity.end = json['end_pos'] is int ? json['end_pos'] : int.parse((json['end_pos']).toString());
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': text,
      'beg_pos': begin,
      'end_pos': end,
    };
  }

  void playUserVoice() async {
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
    String key = md5.convert(utf8.encode(audio)).toString();
    String path = '$documentDirPath/$key.wav';
    File file = File(path);
    if (!file.existsSync()) {
      _userAudioStep = 'download';
      try {
        await Dio().download(audio, path);
        if (_userAudioStep == 'finished') {
          return;
        }
        Uint8List pcmBytes = await _clipUserAudio(file);
        if (_userAudioStep == 'finished') {
          return;
        }
        _userAudioStep = 'play';
        _mediaUtils.play(pcmBuffer: [pcmBytes], whenFinished: () => _userAudioStep = 'finished');
      } catch (e) {
        _userAudioStep = 'finished';
      }
    } else {
      Uint8List pcmBytes = await _clipUserAudio(file);
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
    // 判断本地有没有，没有就下载
    String documentDirPath = await PathUtils.getDocumentFolderPath();
    String key = md5.convert(utf8.encode(text)).toString();
    String path = '$documentDirPath/$key.mp3';
    File file = File(path);
    if (!file.existsSync()) {
      _download(path, () {
        _standardAudioStep = 'play';
        _mediaUtils.play(url: path, whenFinished: () => _standardAudioStep = 'finished');
      });
    } else {
      _standardAudioStep = 'play';
      _mediaUtils.play(url: path, whenFinished: () => _standardAudioStep = 'finished');
    }
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

  Future<void> _download(String path, Function() onComplete) async {
    if (cancelToken != null) {
      cancelToken!.cancel();
    }
    _standardAudioStep = 'download';
    cancelToken = CancelToken();
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.generateAudio,
      params: {
        'text': text,
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
      },
      onError: (_, __) {
        cancelToken = null;
      },
    );
  }

  Future<Uint8List> _clipUserAudio(file) async {
    _userAudioStep = 'convert';
    Uint8List wavBytes = await file.readAsBytes();
    Uint8List pcmBytes = AudioConvertUtil.convertWavToPcm(wavBytes);
    if (_userAudioStep == 'convert') {
      _userAudioStep = 'waitPlay';
    }
    int frameStart = (begin * 0.5 * 640).floor();
    int frameEnd = (end * 0.5 * 640).ceil();
    return pcmBytes.sublist(frameStart, frameEnd);
  }

}