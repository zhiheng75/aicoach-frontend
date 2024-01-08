import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/chat/entity/message_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'xunfei_util.dart';

class EvaluateUtil {

  EvaluateUtil();

  WebSocketChannel? _websocket;
  Map<String, dynamic> _result = {};
  final String _key = 'evaluate_task';
  final String _oss = 'evaluate_oss';

  void evaluate(NormalMessage message, {required Function(Map<String, dynamic>) onSuccess}) async {
    String taskId = const Uuid().v1();
    String deviceId = await Device.getDeviceId();
    _addEvaluateTask(taskId, deviceId, message);
    String text = message.text;
    List<Uint8List> bufferList = [...message.audio];
    _evaluate(text, bufferList, (evaluation) {
      onSuccess(evaluation);
      Map<String, dynamic> params = _getParams(message, evaluation);
      params['device_id'] = deviceId;
      _uploadEvaluation(taskId, message.audio, params);
    });
  }

  void delCachedTask() {
    Map<dynamic, dynamic> cachedTask = SpUtil.getObject(_key) ?? {};
    List<String> keys = cachedTask.keys.map((key) => key as String).toList();
    if (keys.isEmpty) {
      return;
    }
    for (String key in keys) {
      Map<String, dynamic> task = cachedTask[key] as Map<String, dynamic>;
      NormalMessage message = NormalMessage.fromJson(task['message']);
      evaluate(
        message,
        onSuccess: (evaluation) {
          Map<String, dynamic> params = _getParams(message, evaluation);
          params['device_id'] = task['deviceId'];
          _uploadEvaluation(key, message.audio, params);
        },
      );
    }
  }

  Future<void> _evaluate(String text, List<Uint8List> bufferList, Function(Map<String, dynamic>) onSuccess) async {
    try {
      _connectWebsocket((result) {
        onSuccess(result);
      });
      if (_websocket != null) {
        Map<String, dynamic> params = XunfeiUtil.createFrameDataForEvaluation(0, text: text);
        _websocket!.sink.add(jsonEncode(params));
      }
      // 发送语音帧
      int total = bufferList.length;
      while(bufferList.isNotEmpty) {
        if (_websocket == null) {
          break;
        }
        Uint8List buffer = bufferList.removeAt(0);
        int frame = 1;
        int audioFrame = 2;
        if (bufferList.length == total - 1) {
          audioFrame = 1;
        }
        if (bufferList.isEmpty) {
          frame = 2;
          audioFrame = 4;
        }
        Map<String, dynamic> data = XunfeiUtil.createFrameDataForEvaluation(
          frame,
          audioFrame: audioFrame,
          audio: buffer,
        );
        _websocket!.sink.add(jsonEncode(data));
      }
    } catch(e) {
      Log.d('connect xunfei evaluation error:[error]${e.toString()}', tag: '连接讯飞语音评测');
    }
  }

  void _addEvaluateTask(String taskId, String deviceId, NormalMessage message) {
    Map<String, dynamic> task = {
      'message': message.toJson(),
      'deviceId': deviceId,
    };
    Map<dynamic, dynamic> cachedTask = SpUtil.getObject(_key) ?? {};
    cachedTask[taskId] = task;
    SpUtil.putObject(_key, cachedTask);
  }

  void _removeEvaluateTask(String taskId) {
    Map<dynamic, dynamic> cachedTask = SpUtil.getObject(_key) ?? {};
    if (cachedTask.containsKey(taskId)) {
      cachedTask.remove(taskId);
    }
    SpUtil.putObject(_key, cachedTask);
  }

  Map<String, dynamic> _getParams(NormalMessage message, Map<String, dynamic> evaluation) {
    return {
      'session_id': message.sessionId,
      'message_id': message.id,
      'message': message.text,
      'speech': '',
      'accuracy_score': evaluation['accuracy_score'],
      'fluency_score': evaluation['fluency_score'],
      'integrity_score': evaluation['integrity_score'],
      'standard_score': evaluation['standard_score'],
      'total_score': evaluation['total_score'],
    };
  }

  void _uploadEvaluation(String taskId, List<Uint8List> audio, Map<String, dynamic> params) {
    String filename = params['session_id'] + '_' + params['message_id'] + '.wav';
    _uploadAudio(filename, audio, (url) {
      params['speech_file'] = url;
      DioUtils.instance.requestNetwork<ResultData>(
        Method.post,
        HttpApi.addScore,
        onSuccess: (result) {
          if (result != null && result.code == 200) {
            Log.d('upload score success', tag: '上传评分');
            _removeEvaluateTask(taskId);
          }
        },
        onError: (code, msg) {
          Log.d('upload score:msg=$msg', tag: '上传评分');
        },
      );
    });
  }

  void _uploadAudio(String filename, List<Uint8List> audio, Function(String) onSuccess) async {
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
      Digest digest = Hmac(sha1, utf8.encode(evaluateOss['AccessKeySecret'])).convert(utf8.encode(policy));
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
        'file': MultipartFile.fromBytes(_toWav(buffer)),
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

  Uint8List _toWav(List<int> data) {
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
    if (evaluateOss == null || DateTime.parse(evaluateOss['Expiration']).millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
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

  void _connectWebsocket(Function(Map<String, dynamic>) onSuccess) {
    String date = HttpDate.format(DateTime.now());
    String authorization = XunfeiUtil.getEvaluateAuthorization(date);
    Uri uri = Uri.parse('wss://ise-api.xfyun.cn:443/v2/open-ise?host=ise-api.xfyun.cn&date=$date&authorization=$authorization');
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
          // 非最终结果
          if (result['status'] != 2) {
            return;
          }
          Map<String, dynamic>? evaluation = XunfeiUtil.getEvaluateResult(response);
          if (evaluation != null) {
            _result = evaluation;
          }
          await _disconnectWebsocket(WebSocketStatus.normalClosure, 'Success');
        },
        onDone: () {
          int? code = _websocket!.closeCode;
          String? reason = _websocket!.closeReason;
          if (code == WebSocketStatus.normalClosure) {
            onSuccess(_result);
          } else {
            Log.d('xunfei evaluation error:[error]$reason', tag: '讯飞语音评测异常');
          }
          _websocket = null;
        },
        onError: (e) {
          Log.d('xunfei evaluation error:[error]${e.toString()}', tag: '讯飞语音评测异常');
        },
        cancelOnError: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _disconnectWebsocket(int code, String reason) async {
    if (_websocket != null) {
      await _websocket!.sink.close(code, reason);
    }
  }

}