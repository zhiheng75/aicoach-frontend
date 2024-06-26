// ignore_for_file: no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks

import 'dart:typed_data';
import 'dart:ui';

import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/photo_view_simple_screen.dart';
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
  double valueau = 10.0;
  late String coverUrl = '';
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
    NormalMessage normalMessage = widget.message as NormalMessage;
    await _mediaUtils.stopPlay();
    if (type == 'ai') {
      // url方式
      if (normalMessage.audioUrl != null) {
        _mediaUtils.play(
          url: normalMessage.audioUrl,
          whenFinished: () => _audioType = '',
        );
      } else {
        // 未返回完音频
        if (!normalMessage.isTextEnd) {
          Toast.show("请稍后再试", duration: 1000);
          return;
        }
        ListPlayer listPlayer = _mediaUtils.createListPlay(() {
          _audioType = '';
        }, false);
        for (Uint8List buffer in normalMessage.audio) {
          listPlayer.play(buffer);
        }
        listPlayer.setReturnEnd();
      }
    }
    if (type == 'user') {
      _mediaUtils.play(
        pcmBuffer: normalMessage.audio,
        whenFinished: () => _audioType = '',
      );
    }
    if (type == 'example') {
      _mediaUtils.play(
        url: normalMessage.exampleAudio,
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
      return _message.desc == ""
          ? Container()
          : ClipRect(
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
                _homeProvider.sceneStreamController
                    .add({'type': 'topic', 'data': topic.toJson()});
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
      color: Colors.white.withOpacity(0.85),
      gradient: _message.speaker == 'ai'
          ? null
          : const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colours.color_E8CCFE,
                Colours.color_ACCDFF,
              ],
            ),
    );

    Widget createExtWidget(NormalMessage message) {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (message.speaker == 'user' &&
                    message.evaluation['total_score'] != null)
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
                      closeExample();
                      if (message.showTranslation) {
                        closeTranslate();
                        return;
                      }
                      openTranslate();
                      EventBus().emit(NotificationUtils.messageEnd);
                    },
                    child: const LoadAssetImage(
                      'fanyi_hei',
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
              if (message.speaker == 'ai')
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    closeTranslate();
                    if (message.showExample) {
                      closeExample();
                      return;
                    }
                    openExample();
                    EventBus().emit(NotificationUtils.messageEnd);
                  },
                  child: const LoadAssetImage(
                    'shili_zhi',
                    width: 18,
                    height: 18,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => playAudio(message.speaker),
                  child: LoadAssetImage(
                    message.speaker == 'user' ? 'laba_hei' : 'laba_hei',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    String titTwoMessage(String message) {
      String one = message;
      RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
      if (one.contains("<image>") && one.contains("<word>")) {
        for (int i = 0; i < 2; i++) {
          RegExpMatch? match = pattern.firstMatch(one);
          late String coverUrl = "";

          if (match != null) {
            String? tag = match.group(1); // 获取标签名
            String? content = match.group(2); // 获取内容
            // Log.e('===============Tag: $tag, Content: $content');
            coverUrl = content!;
            if (tag == "image") {
              //去出来图片content
            }
            if (tag == "word") {
              //取出来文字content
            }
            String reStr = "<$tag>$coverUrl</$tag>";
            String replacedString = one.replaceAll(reStr, "");
            one = replacedString;
          }
          // Log.e("================" + one);
        }
        one = one.replaceAll("{[finish]}", "");
        return one;
      } else if (one.contains("<image>")) {
        RegExpMatch? match = pattern.firstMatch(one);
        late String coverUrl = "";

        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          coverUrl = content!;
        }
        String reStr = "<image>$coverUrl</image>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
        one = one.replaceAll("{[finish]}", "");

        return one;
      } else if (one.contains("<word>")) {
        RegExpMatch? match = pattern.firstMatch(one);
        late String coverUrl = "";
        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          coverUrl = content!;
        }
        String reStr = "<word>$coverUrl</word>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
        one = one.replaceAll("{[finish]}", "");
        return one;
        // Log.e("================" + one);
      }
      message = message.replaceAll("{[finish]}", "");
      // if (message.text.contains("<image>")) {
      //   RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
      //   RegExpMatch? match = pattern.firstMatch(message.text);
      //   late String coverUrl = "";
      //   if (match != null) {
      //     String? tag = match.group(1); // 获取标签名
      //     String? content = match.group(2); // 获取内容
      //     // Log.e('===============Tag: $tag, Content: $content');
      //     coverUrl = content!;
      //   }
      //   String one = "<image>$coverUrl</image>";
      //   String replacedString = message.text.replaceAll(one, "");

      //   return replacedString;
      // }

      return message;
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
          message.translateState == 1
              ? '翻译中...'
              : (message.translation == 3
                  ? '翻译失败'
                  : titTwoMessage(message.translation)),
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 2,
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
        child: message.exampleState != 2
            ? Text(
                message.exampleState == 1 ? '获取示例中...' : '获取示例失败',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 20 / 15,
                  letterSpacing: 0.05,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 0.8,
                  //   style: BorderStyle.solid,
                  //   color: const Color(0xFF3400A2),
                  // ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.exampleText,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
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
                            'laba_hei',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      );
    }

    Widget createImgExample(NormalMessage message) {
      if (message.text.contains("<image>") && message.text.contains("<word>")) {
        RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');

        String one = message.text;
        Log.e("111111111111" + one);

        late String coverUrl = "";
        // for (int i = 0; i < 2; i++) {
        RegExpMatch? match = pattern.firstMatch(one);

        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          if (tag == "image") {
            //去出来图片content
            coverUrl = content!;
          }
          if (tag == "word") {
            //取出来文字content
          }
          String reStr = "<$tag>$content</$tag>";
          String replacedString = one.replaceAll(reStr, "");
          one = replacedString;
        }

        RegExpMatch? match1 = pattern.firstMatch(one);
        if (match1 != null) {
          String? tag = match1.group(1); // 获取标签名
          String? content = match1.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          if (tag == "image") {
            //去出来图片content
            coverUrl = content!;
          }
          if (tag == "word") {
            //取出来文字content
          }
          // String reStr = "<$tag>$content</$tag>";
          // String replacedString = one.replaceAll(reStr, "");
          // one = replacedString;
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              isScrollControlled: true,
              isDismissible: false,
              builder: (_) => PhotoViewSimpleScreen(
                imageProvider: NetworkImage(coverUrl),
              ),
            );
          },
          child: LoadImage(
            coverUrl,
          ),
        );
      } else if (message.text.contains("<image>")) {
        RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
        String one = message.text;
        Log.e("111111111111" + one);
        RegExpMatch? match = pattern.firstMatch(one);
        late String coverUrl = "";

        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          coverUrl = content!;
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              isScrollControlled: true,
              isDismissible: false,
              builder: (_) => PhotoViewSimpleScreen(
                imageProvider: NetworkImage(coverUrl),
              ),
            );
          },
          child: LoadImage(
            coverUrl,
            // width: 48.0,
          ),
        );
      } else {
        return Container();
      }
    }

    String titMessage(NormalMessage message) {
      String one = message.text;
      RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
      if (one.contains("<image>") && one.contains("<word>")) {
        for (int i = 0; i < 2; i++) {
          RegExpMatch? match = pattern.firstMatch(one);
          late String coverUrl = "";

          if (match != null) {
            String? tag = match.group(1); // 获取标签名
            String? content = match.group(2); // 获取内容
            // Log.e('===============Tag: $tag, Content: $content');
            coverUrl = content!;
            if (tag == "image") {
              //去出来图片content
            }
            if (tag == "word") {
              //取出来文字content
            }
            String reStr = "<$tag>$coverUrl</$tag>";
            String replacedString = one.replaceAll(reStr, "");
            one = replacedString;
          }
          // Log.e("================" + one);
        }
        one = one.replaceAll("{[finish]}", "");
        return one;
      } else if (one.contains("<image>")) {
        RegExpMatch? match = pattern.firstMatch(one);
        late String coverUrl = "";

        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          coverUrl = content!;
        }
        String reStr = "<image>$coverUrl</image>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
        one = one.replaceAll("{[finish]}", "");

        return one;
      } else if (one.contains("<word>")) {
        RegExpMatch? match = pattern.firstMatch(one);
        late String coverUrl = "";
        if (match != null) {
          String? tag = match.group(1); // 获取标签名
          String? content = match.group(2); // 获取内容
          // Log.e('===============Tag: $tag, Content: $content');
          coverUrl = content!;
        }
        String reStr = "<word>$coverUrl</word>";
        String replacedString = one.replaceAll(reStr, "");
        one = replacedString;
        one = one.replaceAll("{[finish]}", "");
        return one;
        // Log.e("================" + one);
      }
      message.text = message.text.replaceAll("{[finish]}", "");
      // if (message.text.contains("<image>")) {
      //   RegExp pattern = RegExp(r'<([^>]*)>([^<]*)</\1>');
      //   RegExpMatch? match = pattern.firstMatch(message.text);
      //   late String coverUrl = "";
      //   if (match != null) {
      //     String? tag = match.group(1); // 获取标签名
      //     String? content = match.group(2); // 获取内容
      //     // Log.e('===============Tag: $tag, Content: $content');
      //     coverUrl = content!;
      //   }
      //   String one = "<image>$coverUrl</image>";
      //   String replacedString = message.text.replaceAll(one, "");

      //   return replacedString;
      // }

      return message.text;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_message.speaker == 'ai')
          _homeProvider.ishread == ""
              ? Padding(
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
                  ))
              : SizedBox(width: 0, height: 0),
        _homeProvider.ishread == ""
            ? const SizedBox(width: 0, height: 0)
            : SizedBox(width: _message.speaker == 'user' ? 40 : 0, height: 0),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
              bottomLeft: Radius.circular(_message.speaker == 'ai' ? 0 : 20.0),
              bottomRight: Radius.circular(_message.speaker == 'ai' ? 20.0 : 0),
            ),
            child: Container(
              width: width,
              // color: Colors.amber,
              decoration: decoration,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titMessage(_message),
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_001652,
                      height: 20.0 / 15.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  createImgExample(_message),
                  Container(
                      color: Colors.amber,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              LoadAssetImage(
                                'class_vip_icon',
                                width: 32.0,
                                height: 32.0,
                              ),
                              Slider(
                                min: 0,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.white,
                                // secondaryActiveColor: Colors.red,
                                thumbColor: Colors.white,
                                max: 30.0,
                                value: valueau,
                                onChanged: (value) {
                                  valueau = value;
                                  setState(() {});
                                },
                              ),
                              Text(
                                "0:15",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "歌名",
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  // Text("data"),
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
        ),
        _homeProvider.ishread == ""
            ? const SizedBox(width: 0, height: 0)
            : SizedBox(width: _message.speaker == 'ai' ? 40 : 0, height: 0),
        if (_message.speaker == 'user')
          _homeProvider.ishread == ""
              ? Padding(
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
                )
              : SizedBox(width: 0, height: 0),
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
