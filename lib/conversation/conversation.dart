// ignore_for_file: must_be_immutable

import 'package:Bubble/conversation/widget/avatar.dart';
import 'package:Bubble/conversation/widget/cutdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Bubble/conversation/presenter/conversation_page_presenter.dart';
import 'package:Bubble/conversation/view/conversation_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import '../home/entity/teach_list_entity.dart';
import 'provider/conversation_provider.dart';
import 'widget/chat.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({
    Key? key,
    required this.teacher,
    required this.sessionId,
  }) : super(key: key);

  TeachListEntity teacher;
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
          final EdgeInsets padding = MediaQuery.of(context).padding;
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
              child: Stack(
                children: <Widget>[
                  Avatar(
                    avatarId: 'Haru',
                    width: size.width,
                    height: size.height,
                  ),
                  Positioned(
                    top: padding.top + 19.0,
                    left: 0,
                    child: Cutdown(),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Chat(),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
