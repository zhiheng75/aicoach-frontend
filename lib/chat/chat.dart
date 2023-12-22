import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'presenter/chat_page_presenter.dart';
import 'view/chat_view.dart';
import 'widget/bottom_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatState();
}

class _ChatState extends State<ChatPage> with BasePageMixin<ChatPage, ChatPagePresenter>, AutomaticKeepAliveClientMixin<ChatPage> implements ChatView {
  late ChatPagePresenter _chatPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String pageState = 'loading';

  void initPage() {
    pageState = 'loading';
    setState(() {});
    Future.delayed(Duration.zero, () {
      Future.delayed(const Duration(seconds: 3), () {
        pageState = 'fail';
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageState == 'loading') {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const LoadData(),
      );
    }

    if (pageState == 'fail') {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: LoadFail(
          reload: initPage,
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: _screenUtil.bottomBarHeight + 16.0,
          child: const BottomBar(),
        ),
      ],
    );
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}