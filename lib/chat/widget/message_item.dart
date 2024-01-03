// ignore_for_file: no_leading_underscores_for_local_identifiers

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
  }) : super(key: key);

  final MessageEntity message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late HomeProvider _homeProvider;
  final ScreenUtil _screenUtil = ScreenUtil();

  void openTranslate() {
    _homeProvider.openTranslate(widget.message as NormalMessage);
  }

  void closeTranslate() {
    _homeProvider.closeTranslate(widget.message as NormalMessage);
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

    // // 话题消息
    // if (type == 'topic') {
    //   _message = _message as TopicMessage;
    //   double itemSize = (width - 16.0) / 3;
    //   return SizedBox(
    //     width: width,
    //     child: Wrap(
    //       spacing: 8.0,
    //       runSpacing: 8.0,
    //       children: _message.topicList.map((topic) {
    //         return GestureDetector(
    //           behavior: HitTestBehavior.opaque,
    //           onTap: () {
    //             widget.onSelectTopic(topic);
    //           },
    //           child: Stack(
    //             children: <Widget>[
    //               ClipRRect(
    //                 borderRadius: BorderRadius.circular(12.0),
    //                 child: LoadImage(
    //                   topic.cover,
    //                   width: itemSize,
    //                   height: itemSize,
    //                 ),
    //               ),
    //               Positioned(
    //                 bottom: 11.0,
    //                 child: Container(
    //                   width: itemSize,
    //                   alignment: Alignment.center,
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 12.0,
    //                   ),
    //                   child: Text(
    //                     topic.title,
    //                     style: const TextStyle(
    //                       fontSize: 14.0,
    //                       fontWeight: FontWeight.w400,
    //                       color: Colors.white,
    //                       height: 21.0 / 14.0,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   );
    // }

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
      onTap: openTranslate,
      child: const LoadAssetImage(
        'fanyi',
        width: 20.0,
        height: 20.0,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (_message.showTranslation)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black.withOpacity(0.8),
            ),
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
              left: 16.0,
              right: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _message.translateState == 1 ? '翻译中...' : (_message.translation == 3 ? '翻译失败' : _message.translation),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 15.0 / 12.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: closeTranslate,
                  child: const LoadAssetImage(
                    'fanyi_close',
                    width: 16.0,
                    height: 16.0,
                  ),
                ),
              ],
            ),
          ),
        Container(
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
        ),
      ],
    );

  }
}
