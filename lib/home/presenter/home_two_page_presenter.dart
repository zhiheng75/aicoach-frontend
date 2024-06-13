import 'dart:convert';
import 'dart:ffi';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';
import 'package:Bubble/home/entity/bind_teacher_status_bean.dart';
import 'package:Bubble/home/view/home_two_page_view.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class HomeTwoPagePresenter extends BasePagePresenter<HomeTwoPageView> {
  @override
  void afterInit() {
    // TODO: implement afterInit
    super.afterInit();
    getBannerList();
    // getCharacterList();
  }

  Future getCharacterList() {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.characterHome,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Map<String, dynamic> characterListMap = json.decode(result.toString());
      CharacterListBean goodsListBean =
          CharacterListBean.fromJson(characterListMap);

      if (goodsListBean.code == 200) {
        view.sendCharacterListSuccess(goodsListBean);
      } else {
        view.sendFail(goodsListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("响应异常");
    });
  }

  Future getBannerList() {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.bannerList,
        isShow: false,
        isClose: false, onSuccess: (result) {
      Map<String, dynamic> bannerListBeanMap = json.decode(result.toString());
      BannerListBean bannerListBean =
          BannerListBean.fromJson(bannerListBeanMap);

      if (bannerListBean.code == 200) {
        view.sendBannerListSuccess(bannerListBean);
      } else {
        view.sendFail(bannerListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("响应异常");
    });
  }

  Future getBindTeacherStatus() {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.bindTeacherStatus, isShow: false, onSuccess: (result) {
      Map<String, dynamic> bindTeacherStatusMap =
          json.decode(result.toString());
      BindTeacherStatusBean bindTeacherStatusBean =
          BindTeacherStatusBean.fromJson(bindTeacherStatusMap);

      if (bindTeacherStatusBean.code == 200) {
        view.sendBindTeacherStatusSuccess(bindTeacherStatusBean.data.count);
      } else {
        // view.sendFail(bannerListBean.msg);
      }
    }, onError: (code, msg) {
      // view.sendFail("响应异常");
    });
  }
}
