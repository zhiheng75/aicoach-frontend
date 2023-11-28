// ignore_for_file: prefer_final_fields, unnecessary_getters_setters

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xml2json/xml2json.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/xunfei_util.dart';

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
  // 获取评测结果（base64解密->xml转json->json转map）
  String xmlString = utf8.decode(base64.decode(result['data']));
  Xml2Json xml2json = Xml2Json();
  xml2json.parse(xmlString);
  String json = xml2json.toOpenRally();
  Map<String, dynamic> evaluation = jsonDecode(json);

  if (evaluation['xml_result'] != null) {
    Map<String, dynamic> xmlResult = evaluation['xml_result'];
    if (xmlResult['read_sentence'] != null) {
      Map<String, dynamic> readSentence = xmlResult['read_sentence'];
      if (readSentence['rec_paper'] != null) {
        Map<String, dynamic> recPaper = readSentence['rec_paper'];
        if (recPaper['read_chapter'] != null) {
          callback(recPaper['read_chapter']);
        }
      }
    }
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
        onData(event, (evaluation) {
          List<int> speech = [];
          for (Uint8List item in message.audio) {
            speech.addAll(item.toList());
          }
          DioUtils.instance.requestNetwork(
            Method.post,
            '/add_score',
            params: {
              'session_id': sessionId,
              'message': message.text,
              'speech': base64.encode(Uint8List.fromList(speech)),
              'accuracy_score': evaluation['accuracy_score'],
              'fluency_score': evaluation['fluency_score'],
              'integrity_score': evaluation['integrity_score'],
              'standard_score': evaluation['standard_score'],
              'total_score': evaluation['total_score'],
            },
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer vQ==*WxyykOe/tzuaTsTi4d7LQA==*T5VxynRnfFEDcmPGpKfRnA==*mj5r1YELnX7dZLbubNdLXA==',
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

void saveAsWav(List<int> data) async {
  Directory? dir = await getExternalStorageDirectory();
  if (dir == null) {
    return;
  }
  if (kDebugMode) {
    print('dir:${dir.path}');
  }
  File txtdFile = File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.txt');
  File recordedFile = File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.wav');

  var channels = 1;

  int sampleRate = 16000;

  int byteRate = ((16 * sampleRate * channels) / 8).round();

  var size = data.length;

  var fileSize = size + 36;

  Uint8List header = Uint8List.fromList([
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
  recordedFile.writeAsBytesSync(header, flush: true);
  txtdFile.writeAsString(base64.encode(data));
}

class ConversationProvider extends ChangeNotifier {

  String _sessionId = '';
  List<Message> _messageList = [];

  String get sessionId => _sessionId;
  set sessionId(String sessionId) => _sessionId = sessionId;
  List<Message> get messageList => _messageList;
  set messageList(List<Message> messageList) => _messageList = messageList;

  void appendMessage(Message message) {
    // 评测
    if (message.speaker == 'user') {
      evaluate(_sessionId, message);
    }
    _messageList.add(message);
    notifyListeners();
  }

  void clear() {
    _sessionId = '';
    _messageList = [];
  }

}

class Message {
  Message();

  String _speaker = '';
  String _text = '';
  String _translation = '';
  List<Uint8List> _audio = [];

  String get speaker => _speaker;
  String get text => _text;
  String get translation => _translation;
  List<Uint8List> get audio => _audio;

  set speaker(String speaker) => _speaker = speaker;

  void appendText(String text) {
    _text += text;
  }

  void appendAudio(List<Uint8List> audio) {
    _audio.addAll(audio);
  }

  void translate() {}
}
