import 'dart:io';

import 'package:dio/dio.dart';

import '../../util/log_utils.dart';
import 'xunfei_util.dart';

class TranslateUtil {

  static Future<Map<String, dynamic>> translate(String english) async {
    Map<String, dynamic> operateResult = {};

    Map<String, dynamic> body = XunfeiUtil.createBodyForTranslation(english);
    String bodySignature = XunfeiUtil.getBodySignatureForTranslation(body);
    String date = HttpDate.format(DateTime.now());
    String authorization = XunfeiUtil.getTranslateAuthorization(date, bodySignature);

    try {
      Response response = await Dio().post(
        'https://itrans.xfyun.cn/v2/its',
        data: body,
        options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json,version=1.0',
              'Host': 'itrans.xfyun.cn',
              'Date': date,
              'Digest': 'SHA-256=$bodySignature',
              'Authorization': authorization,
            }
        ),
      );
      if (response.statusCode == 200) {
        dynamic result = response.data;
        if (result['code'] == 0) {
          Map<String, dynamic> data = (result['data'] ?? {}) as Map<String, dynamic>;
          if (data.containsKey('result')) {
            Map<String, dynamic> translation = (data['result'] ?? {}) as Map<String, dynamic>;
            if (translation.containsKey('trans_result')) {
              Map<String, dynamic> transResult = (translation['trans_result'] ?? {}) as Map<String, dynamic>;
              if (transResult['dst'] != null && transResult['dst'] != '') {
                operateResult['success'] = true;
                operateResult['data'] = transResult['dst'];
              } else {
                throw Exception('翻译失败:[error]dst为null或者空字符串');
              }
            } else {
              throw Exception('翻译失败:[error]trans_result字段不存在');
            }
          } else {
            throw Exception('翻译失败:[error]result字段不存在');
          }
        } else {
          throw Exception('翻译失败:[error]${result['message']}');
        }
      } else {
        throw Exception('翻译失败:[error]${response.statusMessage}');
      }
    } catch (e) {
      Log.d(e.toString(), tag: '翻译');
      operateResult['success'] = false;
    }
    return operateResult;
  }
}