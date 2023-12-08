import 'package:fluro/fluro.dart';

import '../routers/i_router.dart';
import 'change_role_page.dart';

class ChangeRoleRouter implements IRouterProvider{

  static String changeRole = '/changeRole';


  
  @override
  void initRouter(FluroRouter router) {
    router.define(changeRole, handler: Handler(handlerFunc: (_, __) => const ChangeRolePage()));


  }
  
}
