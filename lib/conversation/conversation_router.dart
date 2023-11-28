import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'connect.dart';
import 'conversation.dart';
import 'model/character_entity.dart';

class ConversationRouter implements IRouterProvider{

  static String connectPage = '/conversation/connect';
  static String conversationPage = '/conversation';

  @override
  void initRouter(FluroRouter router) {
    router.define(
      connectPage,
      handler: Handler(
          handlerFunc: (context, __) => ConnectPage(character: context!.settings!.arguments! as CharacterEntity)
      ),
    );
    router.define(
      conversationPage,
      handler: Handler(
          handlerFunc: (context, __) {
            Map<String, dynamic> arguments = context!.settings!.arguments! as Map<String, dynamic>;
            return ConversationPage(
              character: arguments['character'] as CharacterEntity,
              sessionId: arguments['sessionId'],
            );
          }
      ),
    );
  }

}