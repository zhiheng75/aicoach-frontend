import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/res/colors.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationProvider>(
      builder: (_, provider, __) {
        Future.delayed(Duration.zero, () {
          controller.animateTo(
            controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
        List<Message> messageList = provider.messageList;
        return ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(0),
          itemCount: messageList.length,
          itemBuilder: (_, i) {
            Message message = messageList.elementAt(i);
            return Padding(
              padding: EdgeInsets.only(
                top: i == 0 ? 27.0 : 0,
                bottom: 18.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colours.hex2color(message.speaker != 'user' ? '#00FFDE' : '#7469DE'),
                    ),
                  ),
                  const SizedBox(
                    width: 11.0,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message.text,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colours.hex2color('#111B44'),
                              height: 1,
                            ),
                          ),
                          if (provider.showTranslation)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Text(
                                message.isTranslate ? '翻译中...' : (message.translation != '' ? message.translation : '翻译失败，请重新翻译'),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colours.hex2color('#111B44'),
                                ),
                              ),
                            ),
                        ],
                      )
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
