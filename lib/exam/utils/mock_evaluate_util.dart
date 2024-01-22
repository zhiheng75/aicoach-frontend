// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:Bubble/chat/utils/xunfei_util.dart';
import 'package:Bubble/exam/entity/mock_message_entity.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../entity/result_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/device_utils.dart';
import '../../util/log_utils.dart';

class MockEvaluateUtil {
  MockEvaluateUtil();

  WebSocketChannel? _websocket;
  final String _oss = 'evaluate_oss';

  void evaluate(MockMessageEntity message,
      Function(Map<String, dynamic> params) onSuccess) {
    String pathName =
        '${getDate()}/${getRandom(12)}.${message.sessionId + message.messageId}';
    _uploadAudio(pathName, message.audio, (String audiopath) {
      message.speechfile = audiopath;
      _evaluate(
        message: message,
        onSuccess: onSuccess,
      );
    });
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /** 评测 */
  Future<void> _evaluate({
    required MockMessageEntity message,
    required Function(Map<String, dynamic> params) onSuccess,
  }) async {
    try {
      _connectWebsocket((evaluation) {
        _saveEvaluation(
          message: message,
          evaluation: evaluation,
          onSuccess: (Map<String, dynamic> params) {
            onSuccess(params);
          },
        );
      });
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

  Future<void> _disconnectWebsocket(int code, String reason) async {
    if (_websocket != null) {
      await _websocket!.sink.close(code, reason);
    }
  }

  /** 保存评测 */
  Map<String, dynamic> _getParams(
      MockMessageEntity message, Map<String, dynamic> evaluation) {
    return {
      'session_id': message.sessionId,
      'message_id': message.messageId,
      'message': message.text,
      'type': message.type,
      'speech_file': message.speechfile,
      'accuracy_score': evaluation['accuracy_score'],
      'fluency_score': evaluation['fluency_score'],
      'integrity_score': evaluation['integrity_score'],
      'standard_score': evaluation['standard_score'],
      'total_score': evaluation['total_score'],
    };
  }

  void _saveEvaluation({
    required MockMessageEntity message,
    required Map<String, dynamic> evaluation,
    required Function(Map<String, dynamic> params) onSuccess,
  }) {
    try {
      Map<String, dynamic> params = _getParams(message, evaluation);
      DioUtils.instance.requestNetwork<ResultData>(
        Method.post,
        HttpApi.addScore,
        params: params,
        onSuccess: (result) {
          if (result != null && result.code == 200) {
            onSuccess(params);
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
