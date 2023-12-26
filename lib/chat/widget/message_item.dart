import 'package:Bubble/chat/entity/character_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../../res/colors.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    Key? key,
    required this.message,
    required this.onSelectTopic,
  }) : super(key: key);

  final MessageEntity message;
  final Function(CharacterTopic) onSelectTopic;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late HomeProvider _homeProvider;
  final ScreenUtil _screenUtil = ScreenUtil();

  void translate() {
    _homeProvider.translate(widget.message as NormalMessage);
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageEntity _message = widget.message;
    String type = _message.type;

    double width = _screenUtil.screenWidth - 32.0;
    Color blackBgColor = const Color(0xFF060B19).withOpacity(0.78);

    // 角色简介消息
    if (type == 'introduction') {
      _message = _message as IntroductionMessage;
      return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: blackBgColor,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _message.name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 22.0 / 16.0,
              ),
            ),
            Text(
              _message.desc,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFFC0FFFF),
                height: 22.0 / 14.0,
              ),
            ),
          ],
        ),
      );
    }

    // 提示消息
    if (type == 'tip') {
      _message = _message as TipMessage;
      return Container(
        width: width,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: blackBgColor,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          child: Text(
            _message.tip,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 16.4 / 14.0,
            ),
          ),
        ),
      );
    }

    // 话题消息
    if (type == 'topic') {
      _message = _message as TopicMessage;
      double itemSize = (width - 16.0) / 3;
      return SizedBox(
        width: width,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _message.topicList.map((topic) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                widget.onSelectTopic(topic);
              },
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: LoadImage(
                      topic.cover,
                      width: itemSize,
                      height: itemSize,
                    ),
                  ),
                  Positioned(
                    bottom: 11.0,
                    child: Container(
                      width: itemSize,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 21.0 / 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    // 报告消息
    if (type == 'report') {
      _message = _message as ReportMessage;
      return Container();
    }

    // 普通消息
    _message = _message as NormalMessage;
    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20.0),
        topRight: const Radius.circular(20.0),
        bottomLeft: Radius.circular(_message.speaker == 'ai' ? 0 : 20.0),
        bottomRight: Radius.circular(_message.speaker == 'ai' ? 20.0 : 0),
      ),
      color: Colors.white,
      gradient: _message.speaker == 'ai' ? null : const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Colours.color_E8CCFE,
          Colours.color_ACCDFF,
        ],
      ),
    );

    Widget ext = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: translate,
      child: const LoadAssetImage(
        'fanyi',
        width: 13.0,
        height: 11.6,
      ),
    );

    return Container(
      width: width,
      decoration: decoration,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              _message.text,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_001652,
                height: 20.0 / 15.0,
                letterSpacing: 0.05,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ext,
        ],
      ),
    );

  }
}
