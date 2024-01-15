import 'package:Bubble/chat/entity/topic_entity.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import 'message_item.dart';

class MessageList extends StatefulWidget {

  const MessageList({
    Key? key,
    required this.controller,
    required this.onSelectTopic,
  }) : super(key: key);

  final ScrollController controller;
  final Function(TopicEntity) onSelectTopic;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  bool _needScroll = false;

  void scrollToEnd() {
    _needScroll = false;
    double maxScrollExtent = widget.controller.position.maxScrollExtent;
    if (maxScrollExtent > widget.controller.offset) {
      widget.controller.animateTo(maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  @override
  void initState() {
    super.initState();
    EventBus().on('SCROLL_MESSAGE_LIST', (_) => _needScroll = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPersistentFrameCallback((__) {
        if (!_needScroll) {
          return;
        }
        scrollToEnd();
      });
    });
  }

  @override
  void dispose() {
    EventBus().off('SCROLL_MESSAGE_LIST');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        return ListView.builder(
          controller: widget.controller,
          itemCount: provider.messageList.length,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(
              bottom: i < provider.messageList.length - 1 ? 16.0 : 0,
            ),
            child: MessageItem(
              message: provider.messageList.elementAt(i),
              onSelectTopic: widget.onSelectTopic,
            ),
          ),
          padding: const EdgeInsets.all(0),
        );
      },
    );
  }
}
