// ignore_for_file: prefer_final_fields, unnecessary_getters_setters, slash_for_doc_comments
import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';

import '../../chat/entity/character_entity.dart';
import '../../chat/entity/message_entity.dart';
import '../../chat/entity/topic_entity.dart';
import '../../chat/utils/translate_util.dart';
import '../../entity/result_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../scene/entity/scene_entity.dart';
import '../../util/device_utils.dart';

class HomeProvider extends ChangeNotifier {
  /** 对话 */
  // 使用时间
  int _usageTime = 0;
  // 体验天数
  int _expDay = 0;
  // 当前用户会员状态 0-未开通 1-已开通 2-已过期
  int _vipState = 0;
  // 会员过期时间
  String _expireDate = '';
  // 角色
  CharacterEntity _character = CharacterEntity();
  // 话题
  TopicEntity? _topic;
  // 场景
  SceneEntity? _scene;
  // 对话类型 normal-自由对话 topic-话题对话 scene-场景对话
  String _sessionType = '';
  String _sessionId = '';
  List<MessageEntity> _messageList = [];
  // 对话背景
  String? _chatBackground;

  /** 模考 */
  // 使用次数
  int _usageCount = 0;

  /// get
  int get usageTime => _usageTime;
  int get expDay => _expDay;
  int get vipState => _vipState;
  String get expireDate => _expireDate;
  CharacterEntity get character => _character;
  SceneEntity? get scene => _scene;
  TopicEntity? get topic => _topic;
  String get sessionId => _sessionId;
  String get sessionType => _sessionType;
  String? get chatBackground => _chatBackground;
  List<MessageEntity> get messageList => _messageList;
  int get usageCount => _usageCount;

  /// set
  set character(CharacterEntity character) {
    _character = character;
    _chatBackground = character.imageUrl;
    _sessionType = 'normal';
    notifyListeners();
  }

  set topic(TopicEntity? topic) {
    _topic = topic;
    _sessionType = 'topic';
    notifyListeners();
  }

  set scene(SceneEntity? scene) {
    _scene = scene;
    _sessionType = 'scene';
    notifyListeners();
  }

  set sessionId(String sessionId) {
    _sessionId = sessionId;
    if (sessionId == '') {
      _sessionType = 'normal';
    }
  }

  // 获取使用时间、体验天数
  Future<void> getUsageTime() async {
    String deviceId = await Device.getDeviceId();
    await DioUtils.instance.requestNetwork<ResultData>(
        Method.get, HttpApi.permission,
        queryParameters: {
          'device_id': deviceId,
        }, onSuccess: (result) {
      Log.e("这里=============================");

      Log.e(result.toString());
      Log.e("=============================");

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
      if (data.containsKey('membership_expiry_date')) {
        _expireDate = data['membership_expiry_date'] ?? '';
      }
    });
  }

  void resetChatParams() {
    _sessionId = '';
    _topic = null;
    _scene = null;
    _messageList = [];
    notifyListeners();
  }

  // 创建普通消息
  NormalMessage createNormalMessage([bool isUser = false]) {
    NormalMessage normalMessage = NormalMessage();
    if (isUser) {
      normalMessage.characterId = _character.characterId;
      normalMessage.sessionId = _sessionId;
      // 获取上一个AI说的话
      List<MessageEntity> messageList = [..._messageList];
      while (true) {
        if (messageList.isEmpty) {
          break;
        }
        MessageEntity message = messageList.removeLast();
        if (message.type == 'normal') {
          if ((message as NormalMessage).speaker == 'ai') {
            normalMessage.question = message.text;
            normalMessage.questionMessageId = message.id;
            break;
          }
        }
      }
    }
    return normalMessage;
  }

  // 渲染普通消息到列表
  void addNormalMessage(NormalMessage normalMessage, [bool update = true]) {
    _messageList.add(normalMessage);
    if (update == true) {
      notifyListeners();
    }
  }

  // 更新普通消息项
  void updateNormalMessage(NormalMessage normalMessage) {
    int index = 0;
    while (index < _messageList.length) {
      MessageEntity message = _messageList.elementAt(index);
      if (message is NormalMessage && message.id == normalMessage.id) {
        break;
      }
      index++;
    }
    if (index < _messageList.length) {
      _messageList[index] = normalMessage;
      notifyListeners();
    }
  }

  // 渲染简介消息到列表
  void addIntroductionMessage([bool update = true]) {
    IntroductionMessage introductionMessage = IntroductionMessage();
    if (_sessionType == 'normal') {
      introductionMessage.name = _character.name;
      introductionMessage.desc = _character.slogan;
    }
    if (_sessionType == 'topic') {
      introductionMessage.desc = _topic!.desc;
    }
    if (_sessionType == 'scene') {
      introductionMessage.name = '${_scene!.name} ${_scene!.enName}';
      introductionMessage.desc = _scene!.desc;
    }
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
  void addTopicMessage(List<TopicEntity> topicList, [bool update = true]) {
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
  void openTranslate(NormalMessage normalMessage) {
    if (normalMessage.showTranslation) {
      return;
    }

    normalMessage.showTranslation = true;

    if (normalMessage.translateState == 1 ||
        normalMessage.translateState == 2) {
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

  void closeTranslate(NormalMessage normalMessage) {
    normalMessage.showTranslation = false;
    notifyListeners();
  }

  // 增加模考次数
  void increaseUsageCount(int count) {
    _usageCount += count;
  }

  // 减少模考次数
  void decreaseUsageCount(int count) {
    _usageCount -= count;
  }

  void notify() {
    notifyListeners();
  }
}
