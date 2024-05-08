import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/basec_onfig_bean.dart';
import 'package:Bubble/person/entity/invitation_code_bean.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/invitation_code_view.dart';

class InvitationCodePresenter extends BasePagePresenter<InvitationCodeView> {
  @override
  void afterInit() {
    // TODO: implement afterInit
    super.afterInit();
    getbaseConfig();
  }

  Future getbaseConfig() async {
    String titleStr = "";
    String contentStr = "";

    final Map<String, dynamic> params = <String, dynamic>{};
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.baseConfig,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> ebasecOnfigBeanMap = json.decode(result.toString());
      BasecOnfigBean basecOnfigBean =
          BasecOnfigBean.fromJson(ebasecOnfigBeanMap);
      if (basecOnfigBean != null || basecOnfigBean.data.length != 0) {
        for (int i = 0; i < basecOnfigBean.data.length; i++) {
          Datum datum = basecOnfigBean.data[i];

          if (datum.key == "invite_content") {
            contentStr = datum.value;
          }
          if (datum.key == "invite_title") {
            titleStr = datum.value;
          }
        }
        view.sendSuccessMsg(titleStr, contentStr);
      } else {}
    });
  }

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
