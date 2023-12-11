import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/report/entity/message_entity.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConversationAnalysis extends StatefulWidget {
  const ConversationAnalysis({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  State<ConversationAnalysis> createState() => _ConversationAnalysisState();
}

class _ConversationAnalysisState extends State<ConversationAnalysis> {
  final List<MessageEntity> messageList = <MessageEntity>[];
  // 播放音频
  FlutterSoundPlayer? player;
  // 播放状态 0-未播放 1-播放中
  int playerState = 0;
  String currentMessageId = '';
  bool isUserSpeech = false;
  bool isLocked = false;
  List<String> speechList = [];

  void getMoreMessage() {
    DioUtils.instance
        .requestNetwork(Method.get, 'session_history', queryParameters: {
      'session_id': widget.sessionId,
    }, onSuccess: (_) {
      List<dynamic> list = _ as List<dynamic>;
      messageList.addAll(list.map((item) => MessageEntity.fromJson(item)));
      setState(() {});
    }, onError: (code, msg) {
      Toast.show(
        msg,
        duration: 1000,
      );
    });
  }

  void initPlayer() async {
    player = await FlutterSoundPlayer().openPlayer();
  }

  void getSpeechList(String messageId, int type) async {
    isLocked = true;
    setState(() {});
    if (playerState == 1) {
      await stopPlayer();
    }
    DioUtils.instance.requestNetwork(
      Method.get,
      HttpApi.speechList,
      queryParameters: {
        'message_id': messageId,
        'type': type,
      },
      onSuccess: (result) {
        if (currentMessageId != messageId) {
          return;
        }
        if (result == null) {
          isLocked = false;
          setState(() {});
          return;
        }
        result = result as Map<String, dynamic>;
        isLocked = false;
        List<dynamic> list = result['data'] ?? [];
        speechList = list.map((item) => item as String).toList();
        setState(() {});
        startPlayer();
      },
      onError: (code, msg) {
        Toast.show(
          msg,
          duration: 1000,
        );
        if (currentMessageId != messageId) {
          return;
        }
        isLocked = false;
        setState(() {});
      }
    );
  }

  Future<void> startPlayer() async {
    if (playerState == 1) {
      await stopPlayer();
    }
    if (player == null) {
      return;
    }
    playerState = 1;
    setState(() {});
    playSpeech();
  }

  void playSpeech() async {
    if (playerState == 0) {
      return;
    }
    if (speechList.isEmpty) {
      await stopPlayer();
      return;
    }
    String speech = speechList.removeAt(0);
    player!.startPlayer(
      fromURI: speech,
      whenFinished: () {
        playSpeech();
      },
    );
  }

  Future<void> stopPlayer() async {
    if (playerState == 0) {
      return;
    }
    if (player == null) {
      return;
    }
    await player!.stopPlayer();
    playerState = 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
    getMoreMessage();
  }

  @override
  void dispose() {
    if (player != null) {
      player!.closePlayer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    content(MessageEntity message, {bool isUser = false}) {
      String text = message.serverMessageUnicode;
      Color bgColor = Colours.hex2color('#925DFF');
      Color textColor = Colors.white;
      if (isUser) {
        text = message.clientMessageUnicode;
        bgColor = Colours.hex2color('#00E6D0');
        textColor = Colours.hex2color('#111B44');
      }

      Widget icon = const LoadAssetImage(
        'daibofangyuyin',
        width: 14.0,
        height: 24.0,
        fit: BoxFit.fill,
      );
      // 加载状态
      if (isLocked && currentMessageId == message.messageId && isUser == isUserSpeech) {
        icon = LoadingAnimationWidget.hexagonDots(
          color: Colors.white,
          size: 24.0,
        );
      }
      if (playerState == 1 && currentMessageId == message.messageId && isUser == isUserSpeech) {
        icon = const LoadAssetImage(
          'bofangyuyin',
          width: 14.0,
          height: 24.0,
          fit: BoxFit.fill,
        );
      }

      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: bgColor,
          ),
          padding: const EdgeInsets.only(
            top: 9.0,
            right: 10.0,
            bottom: 13.0,
            left: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                    height: 20.0 / 16.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (currentMessageId == message.messageId && isUserSpeech == isUser) {
                    // 请求中或者播放中
                    if (isLocked || playerState == 1) {
                      return;
                    }
                  }
                  currentMessageId = message.messageId;
                  isUserSpeech = isUser;
                  getSpeechList(message.messageId, isUser ? 1 : 2);
                },
                child: icon,
              ),
            ],
          ),
        ),
      );
    }

    aiMessage(MessageEntity message) {
      String? userHead;
      if (LoginManager.isLogin()) {
        Map<String, dynamic> userInfo =
            (SpUtil.getObject(Constant.userInfoKey) ?? {})
                as Map<String, dynamic>;
        userHead = userInfo['headimgurl'];
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          userHead != null
              ? ClipOval(
                  child: LoadImage(
                    userHead,
                    width: 51.0,
                    height: 51.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 51.0,
                  height: 51.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: Colors.blue,
                  ),
                ),
          const SizedBox(
            width: 10.0,
          ),
          content(message),
        ],
      );
    }

    userMessage(MessageEntity message) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          content(message, isUser: true),
          const SizedBox(
            width: 10.0,
          ),
          const ClipOval(
            child: LoadAssetImage(
              'test_banner_img',
              width: 51.0,
              height: 51.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    message(MessageEntity message) {
      return SizedBox(
        width: MediaQuery.of(context).size.width - 54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 19.0,
            ),
            userMessage(message),
            const SizedBox(
              height: 19.0,
            ),
            aiMessage(message),
          ],
        ),
      );
    }

    if (messageList.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width - 54,
        child: Column(
          children: <Widget>[
            Text(
              '暂无对话内容',
              style: TextStyle(
                fontSize: 15.0,
                color: Colours.hex2color('#546092'),
                letterSpacing: 16.0 / 15.0,
                height: 24.0 / 16.0,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: messageList.map((item) {
        return message(item);
      }).toList(),
    );
  }
}
