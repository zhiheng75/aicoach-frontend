// ignore_for_file: prefer_final_fields, unnecessary_getters_setters, slash_for_doc_comments, argument_type_not_assignable_to_error_handler, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path_provider/path_provider.dart';

import '../../net/http_api.dart';
import '../utils/xunfei_util.dart';

/** 讯飞评测 start */
List<Map<String, dynamic>> getTaskList(Message message) {
  List<Map<String, dynamic>> taskList = [];
  taskList.add(XunfeiUtil.createFrameDataForEvaluation(0, text: message.text));
  for (int i = 0; i < message.audio.length; i++) {
    int audioFrame = 2;
    if (i == 0) {
      audioFrame = 1;
    }
    Uint8List buffer = message.audio.elementAt(i);
    if (i < message.audio.length - 1) {
      taskList.add(XunfeiUtil.createFrameDataForEvaluation(1, audio: buffer, audioFrame: audioFrame));
    } else {
      audioFrame = 4;
      taskList.add(XunfeiUtil.createFrameDataForEvaluation(2, audio: buffer, audioFrame: audioFrame));
    }
  }
  return taskList;
}

void onData(dynamic event, Function(Map<String, dynamic>) callback) {
  Map<String, dynamic> response = jsonDecode(event);
  // 出错
  if (response['code'] != 0) {
    return;
  }
  Map<String, dynamic> result = response['data'];
  // 非最终结果
  if (result['status'] != 2) {
    return;
  }
  Map<String, dynamic>? evaluation = XunfeiUtil.getEvaluateResult(response);
  if (evaluation != null) {
    callback(evaluation);
  }
}

void evaluate(String sessionId, Message message) {
  List<Map<String, dynamic>> taskList = getTaskList(message);
  if (taskList.isEmpty) {
    return;
  }

  runTask(WebSocketChannel channel) {
    if (taskList.isEmpty) {
      return;
    }
    Map<String, dynamic> task = taskList.removeAt(0);
    channel.sink.add(jsonEncode(task));
    runTask(channel);
  }

  // 连接websocket
  String date = HttpDate.format(DateTime.now());
  String authorization = XunfeiUtil.getEvaluateAuthorization(date);
  Uri uri = Uri.parse('wss://ise-api.xfyun.cn:443/v2/open-ise?host=ise-api.xfyun.cn&date=$date&authorization=$authorization');
  try {
    WebSocketChannel channel = WebSocketChannel.connect(uri);
    channel.stream.listen(
      (event) {
        onData(event, (evaluation) async {
          List<int> speech = [];
          for (Uint8List item in message.audio) {
            speech.addAll(item.toList());
          }
          saveAsWav(speech);
          String deviceId = await Device.getDeviceId();
          DioUtils.instance.requestNetwork(
            Method.post,
            'add_score',
            params: {
              'session_id': sessionId,
              'device_id': deviceId,
              'message_id': message.id,
              'message': message.text,
              'speech': base64.encode(toWav(speech)),
              'accuracy_score': evaluation['accuracy_score'],
              'fluency_score': evaluation['fluency_score'],
              'integrity_score': evaluation['integrity_score'],
              'standard_score': evaluation['standard_score'],
              'total_score': evaluation['total_score'],
            },
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer IA==*u02jq0h6TdUgA6CJ2UB6aA==*rfIUDa60d92+DKqMZtkG+A==*URKndg3tPT/xab35fJArTg==',
              }
            ),
            onError: (code, msg) {
              if (kDebugMode) {
                print('保存评测结果失败：code=$code msg=$msg');
              }
            },
          );
          // saveAsWav(speech);
        });
      },
    );
    runTask(channel);
  } catch (e) {
    if (kDebugMode) {
      print('讯飞评测websocket连接失败：${e.toString()}');
    }
  }
}

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

void saveAsWav(List<int> data) async {
  Directory? dir = await getExternalStorageDirectory();
  if (dir == null) {
    return;
  }
  File txtdFile = File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.txt');
  Uint8List header = toWav(data);
  txtdFile.writeAsString(base64.encode(header));
}
/** 讯飞评测 end */

class ConversationProvider extends ChangeNotifier {

  String _sessionId = '';
  List<Message> _messageList = [];
  bool _showTranslation = false;
  // 是否超出体验期
  bool _hasFreeUsage = false;
  int _isVip = 0;
  // 剩余时间
  int _availableTime = 0;
  // 单次会话使用时间
  int _usageTime = 0;
  // 倒计时状态 -1-未开始 0-已结束 1-进行中
  int _cutdownState = -1;

  String get sessionId => _sessionId;
  set sessionId(String sessionId) => _sessionId = sessionId;
  List<Message> get messageList => _messageList;
  set messageList(List<Message> messageList) => _messageList = messageList;
  bool get showTranslation => _showTranslation;
  int get availableTime => _availableTime;
  bool get hasFreeUsage => _hasFreeUsage;
  int get isVip => _isVip;
  int get usageTime => _usageTime;
  int get cutdownState => _cutdownState;

  // 获取剩余体验时间
  Future<int> getAvailableTime() async {
    _availableTime = 0;
    String deviceId = await Device.getDeviceId();
    await DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.permission,
      queryParameters: {
        'device_id': deviceId,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          return;
        }
        Map<dynamic, dynamic> data = result.data! as Map<dynamic, dynamic>;
        _isVip = data['is_member'];
        int leftTime = data['left_time'] ?? 0;
        if (leftTime > 0) {
          _availableTime = leftTime;
        }
        int expDay = data['exp_day'] ?? 0;
        _hasFreeUsage = expDay > 0;
      },
    );
    return _availableTime;
  }

  void decreaseTime() {
    _availableTime -= 1;
    _usageTime += 1;
    notifyListeners();
  }

  void setCutdownState(int state) {
    _cutdownState = state;
    notifyListeners();
  }

  Message createMessage() {
    Message message = Message();
    _messageList.add(message);
    return _messageList.last;
  }

  void runEvaluate ([int? index]) {
    Message message = index != null ? _messageList.elementAt(index) : _messageList.last;
    evaluate(_sessionId, message);
  }

  void runTranslate([int? index]) async {
    Message message = index != null ? _messageList.elementAt(index) : _messageList.last;
    await message.translate();
    notifyListeners();
  }

  void updateMessageList() {
    notifyListeners();
  }

  void openTranslation() {
    _showTranslation = true;
    for (Message message in _messageList) {
      message.translate();
    }
    notifyListeners();
  }

  void closeTranslation() {
    _showTranslation = false;
    notifyListeners();
  }

  void clear() {
    _messageList = [];
    _showTranslation = false;
    _usageTime = 0;
    _cutdownState = -1;
  }

}

class Message {
  Message() {
    _id = const Uuid().v1().replaceAll('-', '').substring(0, 16);
    _translationState = 'loading';
  }

  String _id = '';
  String _speaker = '';
  String _text = '';
  bool _isTextEnd = false;
  String _translation = '';
  bool _isTranslate = false;
  // 状态 loading-翻译中 fail-翻译失败 success-翻译成功
  String _translationState = '';
  List<Uint8List> _audio = [];

  String get id => _id;
  String get speaker => _speaker;
  String get text => _text;
  bool get isTextEnd => _isTextEnd;
  String get translation => _translation;
  bool get isTranslate => _isTranslate;
  String get translationState => _translationState;
  List<Uint8List> get audio => _audio;

  set isTextEnd(bool isTextEnd) => _isTextEnd = isTextEnd;

  void setSpeaker(String speaker) {
    _speaker = speaker;
  }

  void appendText(String text) {
    _text += text;
  }

  void appendAudio(List<Uint8List> audio) {
    _audio.addAll(audio);
  }

  Future<void> translate() async {
    // 文本未收集完
    if (!_isTextEnd) {
      return;
    }
    // 已翻译
    if (_translationState == 'success') {
      return;
    }
    if (_isTranslate) {
      return;
    }
    _translationState = 'loading';
    _isTranslate = true;
    Map<String, dynamic> body = XunfeiUtil.createBodyForTranslation(_text);
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
                _translationState = 'success';
                _translation = transResult['dst'];
                return;
              }
              throw Exception('翻译失败');
            }
            throw Exception('翻译失败');
          }
          throw Exception('翻译失败');
        }
        throw Exception(result['message']);
      }
      throw Exception(response.statusMessage);
    } catch (e) {
      if (kDebugMode) {
        print('调用讯飞翻译失败，原因：${e.toString()}');
      }
      _translationState = 'fail';
    } finally {
      _isTranslate = false;
    }
  }
}
