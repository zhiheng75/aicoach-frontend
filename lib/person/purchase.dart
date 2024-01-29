// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/entity/basec_onfig_bean.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../entity/result_entity.dart';
import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../res/colors.dart';
import '../util/log_utils.dart';
import '../util/toast_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import '../widgets/load_image.dart';
import 'entity/good_entity.dart';
import 'presneter/purchase_page_presenter.dart';
import 'view/purchase_view.dart';
import 'widget/illustration.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage>
    with
        BasePageMixin<PurchasePage, PurchasePagePresenter>,
        AutomaticKeepAliveClientMixin<PurchasePage>
    implements PurchaseView {
  late PurchasePagePresenter _purchasePagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<GoodEntity> _goodList = [];
  int _goodsId = 0;
  num _goodPrice = 0;
  String _pay = 'wxpay';
  bool _checked = false;

  late String title = "";
  late String contentTit = "";

  void init() {
    _pageState = 'loading';

    setState(() {});
    getBaseConfig();
  }

  void getBaseConfig() {
    _purchasePagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.baseConfig, isShow: false, onSuccess: (result) {
      Log.e(result.toString());
      Map<String, dynamic> ebasecOnfigBeanMap = json.decode(result.toString());
      BasecOnfigBean basecOnfigBean =
          BasecOnfigBean.fromJson(ebasecOnfigBeanMap);
      if (basecOnfigBean != null || basecOnfigBean.data.length != 0) {
        for (int i = 0; i < basecOnfigBean.data.length; i++) {
          Datum datum = basecOnfigBean.data[i];
          if (datum.key == "rechargeTitle") {
            title = datum.value;
          }
          if (datum.key == "rechargeSlogan") {
            contentTit = datum.value;
          }
        }

        getGoodList();
      } else {
        _pageState = 'fail';
        setState(() {});
        return;
      }
    });
  }

  void getGoodList() {
    _purchasePagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.goodList,
      isShow: false,
      isClose: false,
      onSuccess: (result) async {
        if (result == null || result.data == null) {
          _pageState = 'fail';
          setState(() {});
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<GoodEntity> list =
            data.map((item) => GoodEntity.fromJson(item)).toList();
        if (Platform.isIOS) {
          await _purchasePagePresenter.getIosProduct(list);
        }
        _pageState = 'success';
        _goodList = list;
        setState(() {});
      },
      onError: (code, msg) {
        Log.d('getGoodList fail:[reason]$msg', tag: '获取会员商品列表');
        _pageState = 'fail';
        setState(() {});
      },
    );
  }

  void openIllustration() {
    Map<String, dynamic> user = LoginManager.getUserInfo();

    // String userPhone = user['phone'].toString();

    String phone = '';
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }

    if (phone == "17001234567") {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (_) => const IPhoneIllustration(),
      );

      return;
    }
    // Log.e(user.toString());
    // String userId = user['id'].toString();

    // if (userId == "2") {
    //   return;
    // }
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => const Illustration(),
    );
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  void payGoods() {
    if (_goodsId == 0) {
      Toast.show(
        '请选择会员',
        duration: 1000,
      );
      return;
    }
    if (!_checked) {
      Toast.show(
        '请勾选协议',
        duration: 1000,
      );
      return;
    }
    pay();
  }

  void pay() {
    if (_pay == 'wxpay') {
      _purchasePagePresenter.wxChatPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'alipay') {
      _purchasePagePresenter.aliPay(_goodsId, _goodPrice, true);
    }
    if (_pay == 'applepay') {
      _purchasePagePresenter.applePay(_goodsId);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget navbar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const LoadAssetImage(
              'navbar_back',
              width: 18.2,
              height: 22.0,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 18.0 / 20.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: 220,
                  child: Text(
                    contentTit,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.0 / 14.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: openIllustration,
            child: const LoadAssetImage(
              'wenhao',
              width: 24,
              height: 24.0,
            ),
          ),
        ],
      );
    }

    Widget goodsItem(GoodEntity goods) {
      bool isSelected = _goodsId == goods.id;
      Map<String, dynamic> user = LoginManager.getUserInfo();
      // String userPhone = user['phone'].toString();

      String userPhone = '';
      if (validateInput(user['phone'])) {
        userPhone = user['phone'].toString();
      }

      BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xFFF5F5F5),
      );
      if (isSelected) {
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colours.color_E8CCFE,
              Colours.color_ACCDFF,
            ],
          ),
        );
      }
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _goodsId = goods.id;
          _goodPrice = goods.price;
          setState(() {});
        },
        child: Container(
          width: _screenUtil.screenWidth - 32.0,
          decoration: decoration,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  LoadAssetImage(
                    userPhone == "17001234567" ? "jiangpai" : 'vip',
                    width: 56.0,
                    height: 56.0,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          goods.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          goods.desc,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 16.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '原价：¥${goods.originalPrice}/${goods.unit}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.75 / 16.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '尝鲜价：',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.75 / 16.0,
                          ),
                        ),
                        TextSpan(
                          text: '¥${goods.price}/${goods.unit}',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                            height: 25.75 / 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget payItem(String pay) {
      bool isSelected = _pay == pay;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _pay = pay;
          setState(() {});
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xFFECECEC),
                )
              : null,
          padding: EdgeInsets.all(isSelected ? 12.0 : 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: LoadAssetImage(
              'exam_$pay',
              width: 40.0,
              height: 40.0,
            ),
          ),
        ),
      );
    }

    Widget content;

    if (_pageState != 'success') {
      content = Expanded(
        child: Center(
          child: _pageState == 'fail'
              ? LoadFail(
                  reload: init,
                )
              : const LoadData(),
        ),
      );
    } else {
      List<Widget> goodsChildren = [];
      for (int i = 0; i < _goodList.length; i++) {
        GoodEntity goods = _goodList.elementAt(i);
        goodsChildren.add(goodsItem(goods));
        if (i < _goodList.length - 1) {
          goodsChildren.add(const SizedBox(
            height: 16.0,
          ));
        }
      }
      List<Widget> payChildren = [
        payItem('wxpay'),
        const SizedBox(
          width: 16.0,
        ),
        payItem('alipay'),
        const SizedBox(
          width: 16.0,
        ),
        // payItem('applepay'),
      ];

      content = SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: goodsChildren,
            ),
            const SizedBox(
              height: 34.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: payChildren,
            ),
            const SizedBox(
              height: 32.0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: payGoods,
              child: Container(
                width: 295.0,
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colours.color_001652,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colours.color_9AC3FF,
                      Colours.color_FF71E0,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '立即购买',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_001652,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _checked = !_checked;
                    setState(() {});
                  },
                  child: LoadAssetImage(
                    _checked ? 'yigouxuan' : 'weigouxuan',
                    width: 10.0,
                    height: 10.0,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '我已阅读并同意',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      TextSpan(
                        text: '会员协议',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0047FF),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigatorUtils.goWebViewPage(context, "会员协议",
                                "http://www.shenmo-ai.com/tos/");
                          },
                      ),
                      const TextSpan(
                        text: '和',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      TextSpan(
                        text: '续费规则',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0047FF),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigatorUtils.goWebViewPage(context, "续费规则",
                                "http://www.shenmo-ai.com/agreements");
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _screenUtil.bottomBarHeight + 16.0,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: _screenUtil.statusBarHeight,
            ),
            navbar(),
            const SizedBox(
              height: 16.0,
            ),
            content,
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  PurchasePagePresenter createPresenter() {
    _purchasePagePresenter = PurchasePagePresenter();
    return _purchasePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  paySuccess() {
    // 刷新使用时间
    Provider.of<HomeProvider>(context, listen: false).getUsageTime();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }
}
