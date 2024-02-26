import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/invitation_code_bean.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/invitation_code_view.dart';

class InvitationCodePresenter extends BasePagePresenter<InvitationCodeView> {
  Future getInviteCode(String code) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['code'] = code;
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.inviteCode,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> permissionBeanMap = json.decode(result.toString());
      InvitationCodeBean permissionBean =
          InvitationCodeBean.fromJson(permissionBeanMap);
      if (permissionBean.code == 200) {
        view.sendSuccess(permissionBean.msg);
      } else {
        view.sendFail(permissionBean.msg);
      }
    });
  }
}
