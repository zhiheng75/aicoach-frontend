// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spokid/conversation/presenter/conversation_page_presenter.dart';
import 'package:spokid/conversation/view/conversation_view.dart';
import 'package:spokid/mvp/base_page.dart';
import 'model/character_entity.dart';
import 'provider/conversation_provider.dart';
import 'widget/chat.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({
    Key? key,
    required this.character,
    required this.sessionId,
  }) : super(key: key);

  CharacterEntity character;
  String sessionId;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> with BasePageMixin<ConversationPage, ConversationPagePresenter> implements ConversationView {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
      ],
      child: Consumer<ConversationProvider>(
        builder: (_, provider, __) {
          if (provider.sessionId == '') {
            provider.sessionId = widget.sessionId;
          }
          final Size size = MediaQuery.of(context).size;
          return Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/huihua_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Chat(),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
            // body: Stack(
            //   children: [
            //     LoadAssetImage(
            //       'huihua_bg',
            //       width: size.width,
            //       height: size.height,
            //       fit: BoxFit.fill,
            //     ),
            //     Positioned(
            //       bottom: viewInsets.bottom + 16.0,
            //       child: const Chat(),
            //     ),
            //   ],
            // ),
          );
        },
      ),
    );
  }

  @override
  ConversationPagePresenter createPresenter() {
    return ConversationPagePresenter();
  }
}
