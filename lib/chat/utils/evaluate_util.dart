// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
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
  bool _running = false;

  void evaluate(NormalMessage message, Function() onSuccess) {
    String cacheId = '${message.sessionId}${message.id}';
    Map<String, dynamic> cacheMap = _getCacheMap();
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
        _saveCache(cache);
      }
      return;
    }
    _createCache(message).then((cache) {
      _saveCache(cache);
      try {
        _evaluate(
          cache: cache,
          onSuccess: onSuccess,
        );
      } catch (e) {
        cache.evaluating = false;
        _saveCache(cache);
      }
    });
  }

  /** 缓存 */
  Future<EvaluateCache> _createCache(NormalMessage message) async {
    EvaluateCache cache = EvaluateCache();
    cache.id = '${message.sessionId}${message.id}';
    cache.deviceId = await Device.getDeviceId();
    cache.message = message;
    return cache;
  }

  void _saveCache(EvaluateCache cache) {
    Map<String, dynamic> cacheMap = _getCacheMap();
    cacheMap[cache.id] = cache.toJson();
    SpUtil.putObject(_key, cacheMap);
  }

  void _removeCache(EvaluateCache cache) {
    Map<String, dynamic> cacheMap = _getCacheMap();
    cacheMap.remove(cache.id);
    SpUtil.putObject(_key, cacheMap);
  }

  Map<String, dynamic> _getCacheMap() {
    Map<dynamic, dynamic>? cacheMap = SpUtil.getObject(_key);
    if (cacheMap == null) {
      return {};
    }
    return cacheMap as Map<String, dynamic>;
  }

  Future<void> _runTask() async {
    Map<String, dynamic> cacheMap = _getCacheMap();
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
          onSuccess: () {
            _removeCache(cache);
            onSuccess();
          },
        );
        return;
      }
      _connectWebsocket((evaluation) {
        cache.message.evaluation = evaluation;
        _saveCache(cache);
        _saveEvaluation(
          message: message,
          evaluation: evaluation,
          onSuccess: () {
            _removeCache(cache);
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
    };
  }

  void _saveEvaluation({
    required NormalMessage message,
    Map<String, dynamic>? evaluation,
    required Function() onSuccess,
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
            onSuccess();
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

  void _uploadAudio(String filename, List<Uint8List> audio,
      Function(String) onSuccess) async {
    _getOssToken((evaluateOss) async {
      String host = 'https://shenmo-statics.oss-cn-beijing.aliyuncs.com';
      String key = 'audio/$filename';

      // 获取签名
      Map<String, dynamic> policyParams = {
        'expiration': evaluateOss['Expiration'],
        'conditions': [
          ['content-length-range', 0, 1048576000]
        ],
      };
      // String policy = base64Encode(utf8.encode('{\"expiration\": \"${}\",\"conditions\": [[\"content-length-range\", 0, 104857600]]}'));
      String policy = base64Encode(utf8.encode(jsonEncode(policyParams)));
      Digest digest = Hmac(sha1, utf8.encode(evaluateOss['AccessKeySecret']))
          .convert(utf8.encode(policy));
      String signature = base64Encode(digest.bytes);

      List<int> buffer = [];
      for (Uint8List item in audio) {
        buffer.addAll(item);
      }
      FormData formData = FormData.fromMap({
        'key': key,
        'success_action_status': '200',
        'OSSAccessKeyId': evaluateOss['AccessKeyId'],
        'x-oss-security-token': evaluateOss['SecurityToken'],
        'policy': policy,
        'signature': signature,
        'Content-Type': 'audio/x-wave',
        'file': MultipartFile.fromBytes(toWav(buffer)),
      });

      try {
        Response response = await Dio().post(
          host,
          data: formData,
        );
        if (response.statusCode == 200) {
          Log.d('upload audio success:url=${'$host/$key'}', tag: '上传音频');
          onSuccess('$host/$key');
        }
      } catch (e) {
        Log.d('upload audio error:${e.toString()}', tag: '_uploadAudio');
      }
    });
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
