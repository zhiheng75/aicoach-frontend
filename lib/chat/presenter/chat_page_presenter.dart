import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/chat_view.dart';

class ChatPagePresenter extends BasePagePresenter<ChatView> {}
