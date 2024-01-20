import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/permission_bean.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/log_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/person_view.dart';

class PersonPagePresenter extends BasePagePresenter<PersonView> {
  // 获取使用时间、体验天数
  // Future<void> getUsageTime() async {
  //   String deviceId = await Device.getDeviceId();
  //   await DioUtils.instance.requestNetwork<ResultData>(
  //       Method.get, HttpApi.permission,
  //       queryParameters: {
  //         'device_id': deviceId,
  //       }, onSuccess: (result) {
  // Log.e("这里=============================");

  // Log.e(result.toString());
  // Log.e("=============================");

  //     if (result == null) {
  //       return;
  //     }
  //     if (result.data == null) {
  //       return;
  //     }
  //     Map<String, dynamic> data = result.data! as Map<String, dynamic>;
  //     if (data.containsKey('left_time')) {
  //       _usageTime = data['left_time'];
  //     }
  //     if (data.containsKey('is_member')) {
  //       _vipState = data['is_member'];
  //     }
  //     if (data.containsKey('exp_day')) {
  //       _expDay = data['exp_day'];
  //     }
  //     if (data.containsKey('membership_expiry_date')) {
  //       _expireDate = data['membership_expiry_date'] ?? '';
  //     }
  //   });

  @override
  void afterInit() {
    super.afterInit();
    getUsageTime();
  }

  Future getUsageTime() async {
    String deviceId = await Device.getDeviceId();
    final Map<String, dynamic> params = <String, dynamic>{};
    params['device_id'] = deviceId;
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.permission,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Log.e("这里=============================");
      Log.e(result.toString());
      Log.e("=============================");

      Map<String, dynamic> permissionBeanMap = json.decode(result.toString());
      PermissionBean permissionBean =
          PermissionBean.fromJson(permissionBeanMap);
      if (permissionBean.data != null) {
        view.sendSuccess(permissionBean);
      } else {
        view.sendFail("响应异常");
      }
      // if (data != null) {
      //   if (data.code == 200) {
      //     view.sendSuccess("发送成功");
      //   } else {
      //     view.sendFail(data.msg);
      //   }
      // } else {
      //   view.sendFail("响应异常");
      // }
    });
  }
}
