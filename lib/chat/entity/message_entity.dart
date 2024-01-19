import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import 'topic_entity.dart';

class MessageEntity {
  // 消息类型 normal-普通消息 introduction-角色简介消息 tip-提示消息 topic-话题消息 report-报告消息
  String type = '';

  MessageEntity();
}

class NormalMessage extends MessageEntity {
  String characterId = '';
  String sessionId = '';
  String question = '';
  String questionMessageId = '';
  String id = '';
  String text = '';
  List<Uint8List> audio = [];
  bool showTranslation = false;
  // 翻译状态 0-未翻译 1-翻译中 2-翻译成功 3-翻译失败
  int translateState = 0;
  String translation = '';
  String speaker = 'ai';
  Map<String, dynamic> evaluation = {};
  // 是否文本已全部返回
  bool isTextEnd = false;

  NormalMessage() {
    type = 'normal';
    id = const Uuid().v1().replaceAll('-', '').substring(0, 16);
  }

  factory NormalMessage.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    NormalMessage entity = NormalMessage();
    if (json['session_id'] != null) {
      entity.sessionId = json['session_id'];
    }
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['text'] != null) {
      entity.text = json['text'];
    }
    if (json['audio'] != null) {
      List<dynamic> audio = jsonDecode(json['audio']);
      entity.audio = audio.map((item) {
        Uint8List buffer;
        if (item is List) {
          List<int> list = item.map((e) => e as int).toList();
          buffer = Uint8List.fromList(list);
        } else {
          buffer = Uint8List(0);
        }
        return buffer;
      }).toList();
      // entity.audio = jsonDecode(json['audio']) as List<Uint8List>;
    }
    if (json['evaluation'] != null) {
      entity.evaluation = json['evaluation'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'id': id,
      'text': text,
      'audio': jsonEncode(audio),
      'evaluation': evaluation,
    };
  }
}

class IntroductionMessage extends MessageEntity {
  String name = '';
  String desc = '';

  IntroductionMessage() {
    type = 'introduction';
  }
}

class TipMessage extends MessageEntity {
  String tip = '';

  TipMessage() {
    type = 'tip';
  }
}

class TopicMessage extends MessageEntity {
  List<TopicEntity> topicList = [];

  TopicMessage() {
    type = 'topic';
  }
}

class BackgroundMessage extends MessageEntity {
  String background = '';

  BackgroundMessage() {
    type = 'background';
  }
}

class ReportMessage extends MessageEntity {
  double accuracyScore = 0.0;
  double fluencyScore = 0.0;
  double integrityScore = 0.0;
  double standardScore = 0.0;
  double totalScore = 0.0;
  double time = 0.0;
  int count = 0;
  String rank = '0%';

  ReportMessage() {
    type = 'report';
  }
}
