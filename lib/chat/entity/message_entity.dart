import 'package:uuid/uuid.dart';

import 'topic_entity.dart';

class MessageEntity {

  // 消息类型 normal-普通消息 introduction-角色简介消息 tip-提示消息 topic-话题消息 report-报告消息
  String type = '';

  MessageEntity();

}

class NormalMessage extends MessageEntity {

  String id = '';
  String text = '';
  String audio = '';
  bool showTranslation = false;
  // 翻译状态 0-未翻译 1-翻译中 2-翻译成功 3-翻译失败
  int translateState = 0;
  String translation = '';
  String speaker = 'ai';

  NormalMessage() {
    type = 'normal';
    id = const Uuid().v1().replaceAll('-', '').substring(0, 16);
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

