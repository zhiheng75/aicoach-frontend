// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/util/media_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../entity/result_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/device_utils.dart';
import '../../util/log_utils.dart';
import '../entity/message_entity.dart';
import 'xunfei_util.dart';

class EvaluateUtil {
  EvaluateUtil();

  WebSocketChannel? _websocket;
  final String _key = 'evaluate_task';
  final String _oss = 'evaluate_oss';
  final String _uploadKey = 'upload_audio_task';
  bool _running = false;

  void evaluate(NormalMessage message, Function() onSuccess) {
    String cacheId = '${message.sessionId}${message.id}';
    Map<String, dynamic> cacheMap = _getEvaluateCacheMap();
    if (cacheMap.containsKey(cacheId)) {
      EvaluateCache cache = EvaluateCache.fromJson(cacheMap[cacheId]);
      if (cache.evaluating) {
        return;
      }
      try {
        _evaluate(
          cache: cache,
          onSuccess: onSuccess,
        );
      } catch (e) {
        cache.evaluating = false;
        _saveEvaluateCache(cache);
      }
      return;
    }
    _createEvaluateCache(message).then((cache) {
      _saveEvaluateCache(cache);
      // 用户语音有中文直接评测为0
      if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(cache.message.text)) {
        Map<String, dynamic> defaultEvaluation = {
          'accuracy_score': '0.0',
          'fluency_score': '0.0',
          'integrity_score': '0.0',
          'standard_score': '0.0',
          'total_score': '0.0',
          'score_detail': '{"sentence":{"word_count":0,"word":[]}}',
        };
        cache.message.evaluation = defaultEvaluation;
        _saveEvaluateCache(cache);
      }
      try {
        _evaluate(
          cache: cache,
          onSuccess: onSuccess,
        );
      } catch (e) {
        cache.evaluating = false;
        _saveEvaluateCache(cache);
      }
    });
  }

  /** 评测缓存 */
  Future<EvaluateCache> _createEvaluateCache(NormalMessage message) async {
    EvaluateCache cache = EvaluateCache();
    cache.id = '${message.sessionId}${message.id}';
    cache.deviceId = await Device.getDeviceId();
    cache.message = message;
    return cache;
  }

  void _saveEvaluateCache(EvaluateCache cache) {
    Map<String, dynamic> cacheMap = _getEvaluateCacheMap();
    cacheMap[cache.id] = cache.toJson();
    SpUtil.putObject(_key, cacheMap);
  }

  void _removeEvaluateCache(EvaluateCache cache) {
    Map<String, dynamic> cacheMap = _getEvaluateCacheMap();
    cacheMap.remove(cache.id);
    SpUtil.putObject(_key, cacheMap);
  }

  Map<String, dynamic> _getEvaluateCacheMap() {
    Map<dynamic, dynamic>? cacheMap = SpUtil.getObject(_key);
    if (cacheMap == null) {
      return {};
    }
    return cacheMap as Map<String, dynamic>;
  }

  Future<void> _runTask() async {
    Map<String, dynamic> cacheMap = _getEvaluateCacheMap();
    Map<String, dynamic>? cache = cacheMap.values.elementAtOrNull(0);
    if (cache == null) {
      return;
    }
    try {
      _running = true;
      EvaluateCache evaluateCache = EvaluateCache.fromJson(cache);
      _evaluate(
        cache: evaluateCache,
        onSuccess: () {
          _running = false;
          _runTask();
        },
      );
    } catch (e) {
      _running = false;
      _runTask();
    }
  }

  /** 评测 */
  Future<void> _evaluate({
    required EvaluateCache cache,
    required Function() onSuccess,
  }) async {
    try {
      NormalMessage message = cache.message;
      // 已评测未保存
      if (message.evaluation.isNotEmpty) {
        _saveEvaluation(
          message: message,
          onSuccess: (result) {
            // 初次上传
            if (result['id'] != null) {
              _upload(result['id'], [...message.audio]);
            }
            _removeEvaluateCache(cache);
            onSuccess();
          },
        );
        return;
      }
      _connectWebsocket((evaluation) {
        cache.message.evaluation = evaluation;
        _saveEvaluateCache(cache);
        _saveEvaluation(
          message: message,
          evaluation: evaluation,
          onSuccess: (result) {
            // 初次上传
            if (result['id'] != null) {
              _upload(result['id'], [...message.audio]);
            }
            _removeEvaluateCache(cache);
            onSuccess();
          },
        );
      });
      _sendData(message.text, [...message.audio]);
    } catch (e) {
      rethrow;
    }
  }

  void _connectWebsocket(Function(Map<String, dynamic>) onSuccess) {
    String date = HttpDate.format(DateTime.now());
    String authorization = XunfeiUtil.getEvaluateAuthorization(date);
    Uri uri = Uri.parse(
        'wss://ise-api.xfyun.cn:443/v2/open-ise?host=ise-api.xfyun.cn&date=$date&authorization=$authorization');
    try {
      _websocket = WebSocketChannel.connect(uri);
      _websocket!.stream.listen(
        (event) async {
          Map<String, dynamic> response = jsonDecode(event);
          if (response['code'] != 0) {
            await _disconnectWebsocket(WebSocketStatus.normalClosure, 'Fail');
            return;
          }
          Map<String, dynamic> result = response['data'];
          if (result['status'] == 2) {
            await _disconnectWebsocket(
                WebSocketStatus.normalClosure, 'Success');
            String xmlString = result['data'] ?? '';
            Map<String, dynamic> evaluation =
                XunfeiUtil.getEvaluateResult(xmlString);
            onSuccess(evaluation);
          }
        },
        onDone: () => _websocket = null,
        onError: _onWebSocketError,
        cancelOnError: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onWebSocketError(dynamic error) async {
    await _disconnectWebsocket(
        WebSocketStatus.internalServerError, 'Unknow Error');
  }

  void _sendData(String text, List<Uint8List> bufferList) async {
    // 发送首帧
    Map<String, dynamic> firstData =
        XunfeiUtil.createFrameDataForEvaluation(0, text: text);
    _websocket!.sink.add(jsonEncode(firstData));
    await Future.delayed(const Duration(milliseconds: 20));
    int total = bufferList.length;
    while (true) {
      if (bufferList.isEmpty) {
        break;
      }
      int frame = 1;
      int audioFrame = 2;
      if (bufferList.length == total) {
        audioFrame = 1;
      }
      if (bufferList.length == 1) {
        frame = 2;
        audioFrame = 4;
      }
      Uint8List buffer = bufferList.removeAt(0);
      Map<String, dynamic> data = XunfeiUtil.createFrameDataForEvaluation(
        frame,
        audioFrame: audioFrame,
        audio: buffer,
      );
      _websocket!.sink.add(jsonEncode(data));
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  Future<void> _disconnectWebsocket(int code, String reason) async {
    if (_websocket != null) {
      await _websocket!.sink.close(code, reason);
    }
  }

  /** 保存评测 */
  Map<String, dynamic> _getParams(
      NormalMessage message, Map<String, dynamic> evaluation) {
    return {
      'session_id': message.sessionId,
      'message_id': message.id,
      'message': message.text,
      'accuracy_score': evaluation['accuracy_score'],
      'fluency_score': evaluation['fluency_score'],
      'integrity_score': evaluation['integrity_score'],
      'standard_score': evaluation['standard_score'],
      'total_score': evaluation['total_score'],
      'score_detail': evaluation['score_detail'],
    };
  }

  void _saveEvaluation({
    required NormalMessage message,
    Map<String, dynamic>? evaluation,
    required Function(Map<String, dynamic>) onSuccess,
  }) {
    try {
      Map<String, dynamic> params =
          _getParams(message, evaluation ?? message.evaluation);
      DioUtils.instance.requestNetwork<ResultData>(
        Method.post,
        HttpApi.addScore,
        params: params,
        onSuccess: (result) {
          if (result != null && result.code == 200) {
            onSuccess((result.data ?? {}) as Map<String, dynamic>);
            return;
          }
          throw Exception();
        },
        onError: (code, msg) {
          throw Exception();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /** 上传缓存 */
  UploadCache _createUploadCache(int evaluationId, List<Uint8List> audio) {
    UploadCache cache = UploadCache();
    cache.evaluationId = evaluationId;
    cache.audio = audio;
    return cache;
  }

  void _saveUploadCache(UploadCache cache) {
    Map<String, dynamic> cacheMap = _getUploadCacheMap();
    cacheMap[cache.evaluationId.toString()] = cache.toJson();
    SpUtil.putObject(_uploadKey, cacheMap);
  }

  void _removeUploadCache(UploadCache cache) {
    Map<dynamic, dynamic> cacheMap = _getUploadCacheMap();
    cacheMap.remove(cache.evaluationId.toString());
    SpUtil.putObject(_uploadKey, cacheMap);
  }

  Map<String, dynamic> _getUploadCacheMap() {
    Map<dynamic, dynamic>? cacheMap = SpUtil.getObject(_key);
    if (cacheMap == null) {
      return {};
    }
    return cacheMap as Map<String, dynamic>;
  }

  void _getOssToken(Function(Map<String, dynamic>) onSuccess) {
    Map<dynamic, dynamic>? evaluateOss = SpUtil.getObject(_oss);
    // 未获取或者已过期
    if (evaluateOss == null ||
        DateTime.parse(evaluateOss['Expiration']).millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      DioUtils.instance.requestNetwork<ResultData>(
        Method.get,
        HttpApi.getOssSts,
        onSuccess: (result) {
          if (result == null || result.data == null) {
            return;
          }
          Map<String, dynamic> data = result.data as Map<String, dynamic>;
          SpUtil.putObject(_oss, data);
          onSuccess(data);
        },
        onError: (code, msg) {
          Log.d('upload audio:msg=$msg', tag: '上传语音');
        },
      );
      return;
    }
    onSuccess(evaluateOss as Map<String, dynamic>);
  }

  void _upload(int evaluationId, List<Uint8List> audio) {
    UploadCache cache = _createUploadCache(evaluationId, audio);
    _saveUploadCache(cache);
    _uploadAudio(cache);
  }

  void _uploadAudio(UploadCache cache) async {
    if (cache.url != '') {
      _saveUrl(cache);
    } else {
      _getOssToken((evaluateOss) async {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v1().replaceAll('-', '')}';
        String host = 'https://shenmo-statics.oss-cn-beijing.aliyuncs.com';
        String key = 'audio/$fileName.wav';

        // 获取签名
        Map<String, dynamic> policyParams = {
          'expiration': evaluateOss['Expiration'],
          'conditions': [
            ['content-length-range', 0, 1048576000]
          ],
        };
        String policy = base64Encode(utf8.encode(jsonEncode(policyParams)));
        Digest digest = Hmac(sha1, utf8.encode(evaluateOss['AccessKeySecret']))
            .convert(utf8.encode(policy));
        String signature = base64Encode(digest.bytes);
        Uint8List wav = await AudioConvertUtil.convertPcmToWav(cache.audio);
        FormData formData = FormData.fromMap({
          'key': key,
          'success_action_status': '200',
          'OSSAccessKeyId': evaluateOss['AccessKeyId'],
          'x-oss-security-token': evaluateOss['SecurityToken'],
          'policy': policy,
          'signature': signature,
          'Content-Type': 'audio/x-wave',
          // 'file': MultipartFile.fromBytes(toWav(buffer)),
          'file': MultipartFile.fromBytes(wav),
        });

        try {
          Response response = await Dio().post(
            host,
            data: formData,
          );
          if (response.statusCode == 200) {
            Log.d('upload audio success:url=${'$host/$key'}', tag: '上传音频');
            cache.url = '$key';
            _saveUploadCache(cache);
            _saveUrl(cache);
          }
        } catch (e) {
          Log.d('upload audio error:${e.toString()}', tag: '_uploadAudio');
        }
      });
    }
  }

  void _saveUrl(UploadCache cache) {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.addScoreData,
      params: {
        'id': cache.evaluationId,
        'speech_name': cache.url,
      },
      onSuccess: (result) {
        if (result != null && result.code == 200) {
          _removeUploadCache(cache);
        }
      },
      onError: (code, msg) {
        Log.d('保存语音失败:[code=$code][msg=$msg]', tag: '保存语音');
      },
    );
  }
}

class EvaluateCache {
  EvaluateCache();

  String id = '';
  String deviceId = '';
  bool evaluating = true;
  NormalMessage message = NormalMessage();

  factory EvaluateCache.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    EvaluateCache cache = EvaluateCache();
    if (json['id'] != null) {
      cache.id = json['id'];
    }
    if (json['device_id'] != null) {
      cache.deviceId = json['device_id'];
    }
    if (json['message'] != null) {
      cache.message = NormalMessage.fromJson(json['message']);
    }
    return cache;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'message': message.toJson(),
    };
  }
}

class UploadCache {
  UploadCache();

  int evaluationId = 0;
  String url = '';
  List<Uint8List> audio = [];

  factory UploadCache.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    UploadCache cache = UploadCache();
    if (json['evaluation_id'] != null) {
      cache.evaluationId = json['evaluation_id'];
    }
    if (json['url'] != null) {
      cache.url = json['url'];
    }
    if (json['audio'] != null) {
      List<dynamic> list = jsonDecode(json['message']);
      List<Uint8List> audio = list.map((item) => Uint8List.fromList(item.map((subItem) => subItem as int))).toList();
      cache.audio = audio;
    }
    return cache;
  }

  Map<String, dynamic> toJson() {
    return {
      'evaluation_id': evaluationId,
      'url': url,
      'audio': jsonEncode(audio),
    };
  }
}
