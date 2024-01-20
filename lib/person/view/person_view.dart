import 'package:Bubble/person/entity/permission_bean.dart';

import '../../mvp/mvps.dart';

abstract class PersonView implements IMvpView {
  void sendSuccess(PermissionBean permissionBean);
  void sendFail(String msg);
}
