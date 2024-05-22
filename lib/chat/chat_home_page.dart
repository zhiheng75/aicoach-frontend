import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/chat/presenter/chat_page_presenter.dart';
import 'package:Bubble/chat/view/chat_view.dart';
import 'package:Bubble/chat/widget/chat_home_item.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/scene/widget/select_scene.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with
        BasePageMixin<ChatHomePage, ChatPagePresenter>,
        AutomaticKeepAliveClientMixin<ChatHomePage>
    implements ChatView {
  late ChatPagePresenter _chatPagePresenter;

  List<Datum> characterList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      getCharacterList();
    });
  }

  void getCharacterList() {
    _chatPagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.characterList,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Map<String, dynamic> characterListMap = json.decode(result.toString());
      CharacterListBean goodsListBean =
          CharacterListBean.fromJson(characterListMap);
      Log.e(goodsListBean.msg);
      if (goodsListBean.code == 200) {
        characterList.addAll(goodsListBean.data);
        setState(() {});
      } else {}
    }, onError: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: SafeArea(
          child: ListView.builder(
            itemCount: characterList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: ChatHomeItem(datum: characterList[index]),
                onTap: () {
                  // if (index == 0) {
                  NavigatorUtils.push(
                    context,
                    "${HomeRouter.homePage}?index=$index",
                  );
                  // } else {
                  //   showModalBottomSheet(
                  //     context: context,
                  //     backgroundColor: Colors.transparent,
                  //     barrierColor: Colors.transparent,
                  //     isScrollControlled: true,
                  //     isDismissible: false,
                  //     enableDrag: false,
                  //     builder: (_) => const SelectScene(),
                  //   );
                  // }
                },
              );
            },
          ),
        )));
  }

  @override
  ChatPagePresenter createPresenter() {
    _chatPagePresenter = ChatPagePresenter();
    return _chatPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}
