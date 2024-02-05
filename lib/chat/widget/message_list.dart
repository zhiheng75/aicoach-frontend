import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../entity/topic_entity.dart';
import 'message_item.dart';

class MessageList extends StatefulWidget {

  const MessageList({
    Key? key,
    required this.controller,
    required this.onSelectTopic,
  }) : super(key: key);

  final MessageListController controller;
  final Function(TopicEntity) onSelectTopic;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        return ListView.builder(
          controller: widget.controller.scrollController,
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

class MessageListController {
  MessageListController();

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  void scrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent > _scrollController.offset) {
      _scrollController.animateTo(maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
  }
}
