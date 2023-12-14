import 'package:fluro/fluro.dart';
import '../home/entity/teach_list_entity.dart';
import '../routers/i_router.dart';
import 'connect.dart';
import 'conversation.dart';

class ConversationRouter implements IRouterProvider{

  static String connectPage = '/conversation/connect';
  static String conversationPage = '/conversation';

  @override
  void initRouter(FluroRouter router) {
    router.define(
      connectPage,
      handler: Handler(
          handlerFunc: (context, __) => ConnectPage(teacher: context!.settings!.arguments! as TeachListEntity)
      ),
    );
    router.define(
      conversationPage,
      handler: Handler(
          handlerFunc: (context, __) => const ConversationPage(),
      ),
    );
  }

}