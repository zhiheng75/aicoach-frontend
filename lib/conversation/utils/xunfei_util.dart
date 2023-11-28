/// 对接讯飞API工具类

// ignore_for_file: non_constant_identifier_names, slash_for_doc_comments

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// 语音识别
String RECOGNIZATION_APP_ID = '8d275e28';
String RECOGNIZATION_API_SECRET = 'MTNkOWJiZmFlMGMxOTM0NmZhMDliMGMw';
String RECOGNIZATION_API_KEY = 'a6d70098ffbc7b7857454f5cf412f0b3';

// 语音评测
String EVALUATION_APP_ID = '8d275e28';
String EVALUATION_API_SECRET = 'MTNkOWJiZmFlMGMxOTM0NmZhMDliMGMw';
String EVALUATION_API_KEY = 'a6d70098ffbc7b7857454f5cf412f0b3';

class XunfeiUtil {

  // 获取鉴权参数
  static String getRecognizeAuthorization(String date) {  // 鉴权请参考：https://www.xfyun.cn/doc/asr/voicedictation/API.html
    String stringNeedSigned = 'host: iat-api.xfyun.cn\ndate: $date\nGET /v2/iat HTTP/1.1';
    Digest digest = Hmac(sha256, utf8.encode(RECOGNIZATION_API_SECRET)).convert(utf8.encode(stringNeedSigned));
    String signature = base64.encode(digest.bytes);
    String stringNeedAuthed = 'api_key="$RECOGNIZATION_API_KEY", algorithm="hmac-sha256", headers="host date request-line", signature="$signature"';
    return base64.encode(stringNeedAuthed.codeUnits);
  }
  static String getEvaluateAuthorization(String date) {  // 鉴权请参考：https://www.xfyun.cn/doc/Ise/IseAPI.html
    String stringNeedSigned = 'host: ise-api.xfyun.cn\ndate: $date\nGET /v2/open-ise HTTP/1.1';
    Digest digest = Hmac(sha256, utf8.encode(RECOGNIZATION_API_SECRET)).convert(utf8.encode(stringNeedSigned));
    String signature = base64.encode(digest.bytes);
    String stringNeedAuthed = 'api_key="$RECOGNIZATION_API_KEY", algorithm="hmac-sha256", headers="host date request-line", signature="$signature"';
    return base64.encode(stringNeedAuthed.codeUnits);
  }

  /**
   * 创建帧数据
   * @param frame 0-首帧 1-中间帧 2-末帧
   * @param audio 语音数据
   * @param text 语音评测文本
   */
  static Map<String, dynamic> createFrameDataForRecognization(int frame, {Uint8List? audio}) {
    Map<String, dynamic> frameData = {};

    if (frame == 0) {
      frameData['common'] = {
        'app_id': RECOGNIZATION_APP_ID,
      };
      frameData['business'] = {
        'language': 'en_us',
        'domain': 'iat',
        'vinfo': 1,
      };
    }
    frameData['data'] = {
      'status': frame,
      'format': 'audio/L16;rate=16000',
      'encoding': 'raw',
      'audio': base64.encode(audio ?? Uint8List(0)),
    };

    return frameData;
  }
  static Map<String, dynamic> createFrameDataForEvaluation(int frame, {Uint8List? audio, String? text,  int audioFrame = 1}) {
    Map<String, dynamic> frameData = {};

    if (frame == 0) {
      frameData['common'] = {
        'app_id': EVALUATION_APP_ID,
      };
      frameData['business'] = {
        'sub': 'ise',
        'ent': 'en_vip',
        'category': 'read_sentence',
        'cmd': 'ssb',
        'text': '[content]$text',
        'ttp_skip': true,
        'extra_ability': 'multi_dimension',
        'aue': 'raw',
        'auf': 'audio/L16;rate=16000',
        'ise_unite': '1',
      };
    } else {
      frameData['business'] = {
        'cmd': 'auw',
        'aus': audioFrame,
      };
    }
    frameData['data'] = {
      'status': frame,
      'data': base64.encode(audio ?? Uint8List(0)),
    };

    return frameData;
  }

  // 格式化结果
  static Map<String, dynamic> getRecognizeResult(Map<String, dynamic> response) {
    Map<String, dynamic> result = {
      'code': response['code'],
    };
    if (response['code'] == 0) {
      Map<String, dynamic> data = response['data'];
      String text = '';
      Map<String, dynamic> recognizeResult = data['result'];
      // 获取语音帧
      Map<String, dynamic>? vad = recognizeResult['vad'];
      if (vad != null && vad.containsKey('ws')) {
        List<dynamic> vad_ws = vad['ws'] as List<dynamic>;
        if (vad_ws.isNotEmpty) {
          Map<String, dynamic> first = vad_ws.elementAt(0);
          Map<String, dynamic> last = vad_ws.elementAt(vad_ws.length - 1);
          result['bg'] = first['bg'] as int;
          result['ed'] = last['ed'] as int;
        }
      }
      // 获取识别文字
      List<dynamic> ws = recognizeResult['ws'] as List<dynamic>;
      if (ws.isNotEmpty) {
        for (var wsItem in ws) {
          List<dynamic> cw = wsItem['cw'] as List<dynamic>;
          if (cw.isNotEmpty) {
            for (var cwItem in cw) {
              text += (cwItem['w'] ?? '');
            }
          }
        }
      }
      result['status'] = data['status'];
      result['text'] = text;
    }
    return result;
  }
  static Map<String, dynamic> getEvaluateResult(Map<String, dynamic> response) {
    Map<String, dynamic> result = {};
    return result;
  }

}