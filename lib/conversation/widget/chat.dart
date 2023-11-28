import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/conversation/widget/chat_input.dart';
import 'package:Bubble/conversation/widget/create_scene.dart';
import 'package:Bubble/conversation/widget/message_list.dart';
import 'package:Bubble/conversation/widget/scene.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/load_image.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatInputController inputController = ChatInputController();
  
  void createScene() {
    showBottomSheet(
      context: context,
      clipBehavior: Clip.none,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CreateScene(
          onComplete: showScene,
        );
      }
    );
  }

  void showScene() {
    showBottomSheet(
        context: context,
        clipBehavior: Clip.none,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return const Scene();
        }
    );
  }

  void openOrCloseTranslation(bool showTranslation) {
    ConversationProvider provider = Provider.of<ConversationProvider>(context, listen: false);
    if (showTranslation) {
      provider.closeTranslation();
    } else {
      provider.openTranslation();
    }
  }

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
    final Size size = MediaQuery.of(context).size;
    bool showTranslation = Provider.of<ConversationProvider>(context).showTranslation;

    iconButton({
      required String icon,
      double? width,
      double? height,
      BoxFit? fit,
      required Function() onPress,
    }) {
      return GestureDetector(
        onTap: onPress,
        child: LoadAssetImage(
          icon,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    final Widget boxHeader = Padding(
      padding: const EdgeInsets.only(
        top: 13.0,
        right: 13.0,
        left: 13.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              iconButton(
                icon: 'fanyi',
                width: 20.0,
                height: 20.0,
                onPress: () {
                  openOrCloseTranslation(showTranslation);
                },
              ),
              // const SizedBox(
              //   width: 23.0,
              // ),
              // iconButton(
              //   icon: 'tishi',
              //   width: 16.0,
              //   height: 20.0,
              //   onPress: () {},
              // ),
            ],
          ),
          // iconButton(
          //   icon: 'changjing',
          //   width: 21.0,
          //   height: 19.0,
          //   onPress: createScene,
          // ),
        ],
      ),
    );

    final Widget boxFooter = Padding(
      padding: const EdgeInsets.only(
        right: 13.0,
        bottom: 16.0,
        left: 13.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              height: 42.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/shurukuang_bg.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              alignment: Alignment.center,
              child: ChatInput(
                controller: inputController,
              ),
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Consumer<ConversationProvider>(
            builder: (_, provider, __) {
              return iconButton(
                icon: 'guaduan',
                width: 48.0,
                height: 48.0,
                onPress: () async {
                  await inputController.endConversation();
                  provider.clear();
                  Future.delayed(Duration.zero, () {
                    NavigatorUtils.goBack(context);
                  });
                },
              );
            },
          ),
        ],
      ),
    );

    return Container(
      width: size.width - 28.0,
      height: 343,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.0),
        image: const DecorationImage(
          image: AssetImage('assets/images/liaotian_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: Column(
        children: <Widget>[
          boxHeader,
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: 20.0,
                left: 20.0,
              ),
              child: MessageList(),
            ),
          ),
          boxFooter,
        ],
      ),
    );
  }
}