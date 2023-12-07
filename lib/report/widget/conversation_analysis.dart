import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/report/entity/message_entity.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

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

  void getMoreMessage() {
    DioUtils.instance.requestNetwork(
      Method.get,
      'session_history',
      queryParameters: {
        'session_id': widget.sessionId,
      },
      onSuccess: (_) {
        List<dynamic> list = _ as List<dynamic>;
        messageList.addAll(list.map((item) => MessageEntity.fromJson(item)));
        setState(() {});
      },
      onError: (code, msg) {
        Toast.show(
          msg,
          duration: 1000,
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    getMoreMessage();
  }

  @override
  void dispose() {
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
                onTap: () {},
                child: const LoadAssetImage(
                  'daibofangyuyin',
                  width: 7.0,
                  height: 12.0,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      );
    }
    aiMessage(MessageEntity message) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
          Container(
            width: 51.0,
            height: 51.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.0),
              color: Colors.blue,
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
