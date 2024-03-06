// ignore_for_file: no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks

import 'dart:ui';

import 'package:Bubble/util/media_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../../res/colors.dart';
import '../../util/toast_utils.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';
import 'evaluation.dart';

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
  final MediaUtils _mediaUtils = MediaUtils();
  String _audioType = '';

  void openTranslate() {
    if (!(widget.message as NormalMessage).isTextEnd) {
      Toast.show(
        '回答中，请稍后再试',
        duration: 1000,
      );
      return;
    }
    _homeProvider.openTranslate(widget.message as NormalMessage);
  }

  void closeTranslate() {
    _homeProvider.closeTranslate(widget.message as NormalMessage);
  }

  void openEvaluation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => Evaluation(message: widget.message as NormalMessage),
    );
  }

  void openExample() {
    if (!(widget.message as NormalMessage).isTextEnd) {
      Toast.show(
        '回答中，请稍后再试',
        duration: 1000,
      );
      return;
    }
    _homeProvider.openExample(widget.message as NormalMessage);
  }

  void closeExample() {
    _homeProvider.closeExample(widget.message as NormalMessage);
  }

  void playAudio(String type) async {
    if (_audioType == type) {
      return;
    }
    _audioType = type;
    await _mediaUtils.stopPlay();
    if (type == 'user') {
      _mediaUtils.play(
        pcmBuffer: (widget.message as NormalMessage).audio,
        whenFinished: () => _audioType = '',
      );
    }
    if (type == 'example') {
      _mediaUtils.play(
        url: (widget.message as NormalMessage).exampleAudio,
        whenFinished: () => _audioType = '',
      );
    }
  }

  String formatScore(dynamic score) {
    score = score is String ? double.parse(score) : score as double;
    return score.toInt().toString();
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
    Color blackBgColor = const Color(0xFF060B19).withOpacity(0.88);

    // 角色简介消息
    if (type == 'introduction') {
      _message = _message as IntroductionMessage;
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4.0,
            sigmaY: 4.0,
          ),
          child: Container(
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
                if (_message.name != '')
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
          ),
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
            color: Colors.black.withOpacity(0.8),
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
                _homeProvider.sceneStreamController.add({'type': 'topic', 'data': topic.toJson()});
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
                    bottom: 0,
                    child: Container(
                      width: itemSize,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.11),
                            Colors.black.withOpacity(0.0),
                          ],
                          stops: const [0, 0.93, 1],
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
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

    // 背景图消息
    if (type == 'background') {
      _message = _message as BackgroundMessage;
      return Container(
        width: _screenUtil.screenWidth,
        alignment: Alignment.center,
        child: LoadImage(
          _message.background,
          width: _screenUtil.screenWidth * 0.5,
          fit: BoxFit.fitWidth,
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
      color: Colors.white.withOpacity(0.86),
      gradient: _message.speaker == 'ai' ? null : const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Colours.color_E8CCFE,
          Colours.color_ACCDFF,
        ],
      ),
    );

    // Widget ext = GestureDetector(
    //   behavior: HitTestBehavior.opaque,
    //   onTap: () {
    //     NormalMessage message = widget.message as NormalMessage;
    //     if (message.speaker != 'user') {
    //       if (message.showTranslation) {
    //         closeTranslate();
    //         return;
    //       }
    //       openTranslate();
    //       return;
    //     }
    //     openEvaluation();
    //   },
    //   child: _message.speaker == 'user' ? Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       const LoadAssetImage(
    //         'jiexi',
    //         width: 20.0,
    //         height: 20.0,
    //       ),
    //       Text(
    //         _message.evaluation['total_score'] != null ? formatScore(_message.evaluation['total_score']) : '',
    //         style: const TextStyle(
    //           fontSize: 13.0,
    //           fontWeight: FontWeight.w400,
    //           color: Colors.black,
    //           height: 24.0 / 13.0,
    //           letterSpacing: 0.05,
    //         ),
    //       ),
    //     ],
    //   ) : const LoadAssetImage(
    //     'fanyi',
    //     width: 20.0,
    //     height: 20.0,
    //   ),
    // );

    Widget createExtWidget(NormalMessage message) {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (message.speaker == 'user' && message.evaluation['total_score'] != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: openEvaluation,
                    child: Text(
                      '${formatScore(message.evaluation['total_score'])} 解析优化',
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 24.0 / 13.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.speaker == 'ai')
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (message.showTranslation) {
                        closeTranslate();
                        return;
                      }
                      openTranslate();
                    },
                    child: const LoadAssetImage(
                      'fanyi_hei',
                      width: 18,
                      height: 16,
                    ),
                  ),
                ),
              if (message.speaker == 'ai')
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (message.showExample) {
                      closeExample();
                      return;
                    }
                    openExample();
                  },
                  child: const LoadAssetImage(
                    'shili_zhi',
                    width: 20,
                    height: 19,
                  ),
                ),
              if (message.speaker == 'user')
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => playAudio('user'),
                    child: const LoadAssetImage(
                      'laba_lan',
                      width: 17.6,
                      height: 16,
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    }

    Widget createTranslationWidget(NormalMessage message) {
      if (!message.showTranslation) {
        return const SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Text(
          message.translateState == 1 ? '翻译中...' : (message.translation == 3 ? '翻译失败' : message.translation),
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_001652,
            height: 20.0 / 15.0,
            letterSpacing: 0.05,
          ),
        ),
      );
    }

    Widget createExample(NormalMessage message) {
      if (!message.showExample) {
        return const SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: message.exampleState != 2 ? Text(
          message.exampleState == 1 ? '获取示例中...' : '获取示例失败',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF890073),
            height: 20 / 15,
            letterSpacing: 0.05,
          ),
        ) : Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.8,
              style: BorderStyle.solid,
              color: const Color(0xFF3400A2),
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.exampleText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF890073),
                  height: 20 / 15,
                  letterSpacing: 0.05,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => playAudio('example'),
                    child: const LoadAssetImage(
                      'laba_lan',
                      width: 17.6,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_message.speaker == 'ai')
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: SizedBox(
              width: 48.0,
              height: 48.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48.0),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: LoadImage(
                    _message.imageUrl,
                    width: 48.0,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: Container(
            width: width,
            decoration: decoration,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _message.text,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_001652,
                    height: 20.0 / 15.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                createExtWidget(_message),
                createTranslationWidget(_message),
                createExample(_message),
              ],
            ),
          ),
        ),
        if (_message.speaker == 'user')
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48.0),
              child: LoadImage(
                _message.imageUrl,
                width: 48,
                height: 48,
              ),
            ),
          ),
      ],
    );

    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     ClipRect(
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(
    //           sigmaX: 4.0,
    //           sigmaY: 4.0
    //         ),
    //         child: Container(
    //           width: width,
    //           decoration: decoration,
    //           padding: const EdgeInsets.all(16.0),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Expanded(
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Text(
    //                       _message.text,
    //                       style: const TextStyle(
    //                         fontSize: 15.0,
    //                         fontWeight: FontWeight.w400,
    //                         color: Colours.color_001652,
    //                         height: 20.0 / 15.0,
    //                         letterSpacing: 0.05,
    //                       ),
    //                     ),
    //                     if (_message.showTranslation)
    //                       Text(
    //                         _message.translateState == 1 ? '翻译中...' : (_message.translation == 3 ? '翻译失败' : _message.translation),
    //                         style: const TextStyle(
    //                           fontSize: 15.0,
    //                           fontWeight: FontWeight.w400,
    //                           color: Colours.color_001652,
    //                           height: 20.0 / 15.0,
    //                           letterSpacing: 0.05,
    //                         ),
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //               // Expanded(
    //               //   child: Text(
    //               //     _message.text,
    //               //     style: const TextStyle(
    //               //       fontSize: 15.0,
    //               //       fontWeight: FontWeight.w400,
    //               //       color: Colours.color_001652,
    //               //       height: 20.0 / 15.0,
    //               //       letterSpacing: 0.05,
    //               //     ),
    //               //   ),
    //               // ),
    //               const SizedBox(
    //                 width: 10.0,
    //               ),
    //               ext,
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

  }
}
