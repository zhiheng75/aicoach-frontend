// ignore_for_file: prefer_final_fields, unnecessary_getters_setters
import 'package:flutter/material.dart';

import '../../chat/entity/character_entity.dart';
import '../../chat/entity/message_entity.dart';
import '../../chat/utils/translate_util.dart';
import '../../entity/result_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/device_utils.dart';

class HomeProvider extends ChangeNotifier {

  // 使用时间
  int _usageTime = 0;
  // 体验天数
  int _expDay = 0;
  // 当前用户会员状态 0-未开通 1-已开通 2-已过期
  int _vipState = 0;
  // 角色
  late CharacterEntity _character;
  // 话题
  CharacterTopic? _topic;
  // 对话相关
  String _sessionId = '';
  List<MessageEntity> _messageList = [];

  /// get
  int get usageTime => _usageTime;
  int get expDay => _expDay;
  int get vipState => _vipState;
  String get sessionId => _sessionId;
  CharacterTopic? get topic => _topic;
  List<MessageEntity> get messageList => _messageList;

  /// set
  set character(CharacterEntity character) => _character = character;
  set topic(CharacterTopic? topic) => _topic = topic;
  set sessionId(String sessionId) => _sessionId = sessionId;

  // 获取使用时间、体验天数
  Future<void> getUsageTime() async {
    String deviceId = await Device.getDeviceId();
    await DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.permission,
      queryParameters: {
        'device_id': deviceId,
      },
      onSuccess: (result) {
        if (result == null) {
          return;
        }
        if (result.data == null) {
          return;
        }
        Map<String, dynamic> data = result.data! as Map<String, dynamic>;
        if (data.containsKey('left_time')) {
          _usageTime = data['left_time'];
        }
        if (data.containsKey('is_member')) {
          _vipState = data['is_member'];
        }
        if (data.containsKey('exp_day')) {
          _expDay = data['exp_day'];
        }
      }
    );
  }

  void clearMessageList() {
    _messageList = [];
    notifyListeners();
  }

  // 创建普通消息
  MessageEntity createNormalMessage() {
    NormalMessage normalMessage = NormalMessage();
    return normalMessage;
  }

  // 渲染普通消息到列表
  void addNormalMessage(NormalMessage normalMessage, [bool update = true]) {
    _messageList.add(normalMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 渲染角色简介消息到列表
  void addIntroductionMessage([bool update = true]) {
    IntroductionMessage introductionMessage = IntroductionMessage();
    introductionMessage.name = _character.name;
    introductionMessage.desc = '这是角色简介';
    _messageList.add(introductionMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 渲染提示消息到列表
  void addTipMessage(String tip, [bool update = true]) {
    TipMessage tipMessage = TipMessage();
    tipMessage.tip = tip;
    _messageList.add(tipMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 渲染话题消息到列表
  void addTopicMessage(List<CharacterTopic> topicList, [bool update = true]) {
    TopicMessage topicMessage = TopicMessage();
    topicMessage.topicList = topicList;
    _messageList.add(topicMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 渲染报告消息到列表
  void addReportMessage(dynamic report, [bool update = true]) {
    report = report as Map<String, dynamic>;
    ReportMessage reportMessage = ReportMessage();
    reportMessage.accuracyScore = report['accuracy_score'];
    reportMessage.fluencyScore = report['fluency_score'];
    reportMessage.integrityScore = report['integrity_score'];
    reportMessage.standardScore = report['standard_score'];
    reportMessage.totalScore = report['total_score'];
    reportMessage.time = report['session_time'];
    reportMessage.count = report['session_count'];
    reportMessage.rank = report['rank'];
    _messageList.add(reportMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 翻译
  void translate(NormalMessage normalMessage) {
    normalMessage.showTranslation = !normalMessage.showTranslation;
    // 关闭翻译
    if (!normalMessage.showTranslation) {
      notifyListeners();
      return;
    }
    // 翻译成功
    if (normalMessage.translateState == 2) {
      notifyListeners();
      return;
    }

    TranslateUtil.translate(normalMessage.text).then((result) {
      if (result['success']) {
        normalMessage.translateState = 2;
        normalMessage.translation = result['data'];
      } else {
        normalMessage.translateState = 3;
      }
      notifyListeners();
    });

    normalMessage.translateState = 1;
    notifyListeners();
  }

}