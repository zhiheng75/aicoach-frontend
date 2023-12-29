import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import 'message_item.dart';

class MessageList extends StatelessWidget {

  const MessageList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        return ListView.builder(
          itemCount: provider.messageList.length,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(
              bottom: i < provider.messageList.length - 1 ? 16.0 : 0,
            ),
            child: MessageItem(
              message: provider.messageList.elementAt(i),
            ),
          ),
          padding: const EdgeInsets.all(0),
        );
      },
    );
  }
}
