// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/goods_list_bean.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/presneter/purchase_page_presenter.dart';
import 'package:Bubble/person/view/purchase_view.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../util/toast_utils.dart';
import '../widgets/load_data.dart';
import '../widgets/load_fail.dart';
import 'entity/exam_good_entity.dart';
import 'view/exam_purchas_view.dart';

class ExamPurchasePage extends StatefulWidget {
  const ExamPurchasePage({
    Key? key,
    this.onPurchased,
  }) : super(key: key);

  final Function()? onPurchased;

  @override
  State<ExamPurchasePage> createState() => _ExamPurchasePageState();
}

class _ExamPurchasePageState extends State<ExamPurchasePage>
    with
        BasePageMixin<ExamPurchasePage, PurchasePagePresenter>,
        AutomaticKeepAliveClientMixin<ExamPurchasePage>
    implements PurchaseView {
  late PurchasePagePresenter _purchasePagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<ExamGoodEntity> _goodsList = [];
  int _goodsId = 0;
  num _goodPrice = 0;
  String _pay = 'wxpay';
  bool _checked = false;

  void init() {
    // getGoodsList();
  }

  // void getGoodsList() {
  //   // todo 对接模考商品列表
  //   Future.delayed(const Duration(seconds: 3), () {
  //     ExamGoodEntity ten = ExamGoodEntity();
  //     ten.id = 1;
  //     ten.icon = 'huangguan';
  //     ten.name = '模考10次';
  //     ten.desc = '强化训练包';
  //     ten.price = 299;
  //     ExamGoodEntity five = ExamGoodEntity();
  //     five.id = 2;
  //     five.icon = 'xingxing';
  //     five.name = '模考5次';
  //     five.desc = '基础训练包';
  //     five.price = 199;
  //     ExamGoodEntity one = ExamGoodEntity();
  //     one.id = 3;
  //     one.icon = 'qizhi';
  //     one.name = '模考1次';
  //     one.desc = '单次训练包';
  //     one.price = 59;
  //     _goodsList = [ten, five, one];
  //     _pageState = 'success';
  //     setState(() {});
  //   });
  // }

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

  void payGoods() {
    if (_goodsId == 0) {
      Toast.show(
        '请选择练习包',
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

  // void initData() {
  //   _pageState = 'loading';
  //   setState(() {});
  //   CancelToken cancelToken = CancelToken();

  //   final Map<String, String> params = <String, String>{};
  //   params["type"] = "2";

  //   DioUtils.instance.requestNetwork<ResultData>(
  //     Method.get,
  //     HttpApi.goodsList,
  //     params: params,
  //     cancelToken: cancelToken,
  //     onSuccess: (result) {
  //       Log.e(result.toString());
  //     },
  //     onError: (code, msg) {},
  //   );
  // }

  // void initData() {
  // Future.delayed(const Duration(milliseconds: 20), () {
  //   _examPurchasePagePresenter.getGoodsList();
  // });
  // }

  void getGoodList() {
    final Map<String, String> params = <String, String>{};
    params["type"] = "2";

    _purchasePagePresenter.requestNetwork<ResultData>(Method.get,
        url: HttpApi.goodsList,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Log.e(result.toString());

      Map<String, dynamic> goodsListMap = json.decode(result.toString());
      GoodsListBean goodsListBean = GoodsListBean.fromJson(goodsListMap);

      Log.e(goodsListBean.msg);
      if (goodsListBean != null) {
        _goodsList = [];
        for (int i = 0; i < goodsListBean.data.length; i++) {
          ExamGoodEntity ten = ExamGoodEntity();
          ten.id = i + 1;
          if (i == 0) {
            ten.icon = 'huangguan';
          } else if (i == 1) {
            ten.icon = 'xingxing';
          } else {
            ten.icon = 'qizhi';
          }
          ten.name = goodsListBean.data[i].name!;
          ten.desc = goodsListBean.data[i].desc;
          ten.price = goodsListBean.data[i].originalPrice!.toInt();
          _goodsList.add(ten);
        }
        _pageState = 'success';
        setState(() {});
        // view.sendSuccess(goodsListBean);
      } else {
        // view.sendFail("");
      }
    }, onError: (code, msg) {
      // view.sendFail("");
    });

    // _purchasePagePresenter.requestNetwork<ResultData>(
    //   Method.get,
    //   url: HttpApi.goodList,
    //   isShow: false,
    //   isClose: false,
    //   onSuccess: (result) async {
    //     if (result == null || result.data == null) {
    //       _pageState = 'fail';
    //       setState(() {});
    //       return;
    //     }
    //     List<dynamic> data = result.data as List<dynamic>;
    //     List<GoodEntity> list =
    //         data.map((item) => GoodEntity.fromJson(item)).toList();
    //     if (Platform.isIOS) {
    //       await _purchasePagePresenter.getIosProduct(list);
    //     }
    //     _pageState = 'success';
    //     _goodList = list;
    //     setState(() {});
    //   },
    //   onError: (code, msg) {
    //     Log.d('getGoodList fail:[reason]$msg', tag: '获取会员商品列表');
    //     _pageState = 'fail';
    //     setState(() {});
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
    getGoodList();
    // init();
    // Future.delayed(const Duration(milliseconds: 20), () {
    // initData();
    // });
    // Future.delayed(const Duration(milliseconds: 10), () {
    // _examPurchasePagePresenter.getGoodsList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget goodsItem(ExamGoodEntity goods) {
      bool isSelected = _goodsId == goods.id;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  LoadAssetImage(
                    goods.icon,
                    width: 56.0,
                    height: 56.0,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                ],
              ),
              Text(
                '¥${goods.price}',
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
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

    List<Widget> goodsChildren = [];
    for (int i = 0; i < _goodsList.length; i++) {
      ExamGoodEntity goods = _goodsList.elementAt(i);
      goodsChildren.add(goodsItem(goods));
      if (i < _goodsList.length - 1) {
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
    ];

    late Widget content;

    if (_pageState == 'success') {
      content = Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: _screenUtil.statusBarHeight + 16.0,
            ),
            const Text(
              '模考练习包',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '1V1真实还原考试全流程',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
                Text(
                  '严格按照评分标准和评分体系进行评分',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: goodsChildren,
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: payChildren,
            ),
            const SizedBox(
              height: 26.0,
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
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(10),
                    child: LoadAssetImage(
                      _checked ? 'yigouxuan' : 'weigouxuan',
                      width: 15.0,
                      height: 15.0,
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 8.0,
                // ),
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
                            NavigatorUtils.goWebViewPage(context, " 续费规则",
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
    } else {
      content = Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        color: Colors.white,
        alignment: Alignment.center,
        child: _pageState == 'fail'
            ? LoadFail(
                reload: init,
              )
            : const LoadData(),
      );
    }

    return Stack(
      children: [
        content,
        Positioned(
          top: _screenUtil.statusBarHeight,
          right: 16.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const LoadAssetImage(
              'exam_purchase_close',
              width: 32.0,
              height: 32.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  PurchasePagePresenter createPresenter() {
    _purchasePagePresenter = PurchasePagePresenter();
    return _purchasePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  // @override
  // void sendSuccess(GoodsListBean msg) {
  //   // TODO: implement sendSuccess
  //   // _goodsList = [];
  //   // for (int i = 0; i < msg.data.length; i++) {
  //   //   ExamGoodEntity ten = ExamGoodEntity();
  //   //   ten.id = i + 1;
  //   //   if (i == 0) {
  //   //     ten.icon = 'huangguan';
  //   //   } else if (i == 1) {
  //   //     ten.icon = 'xingxing';
  //   //   } else {
  //   //     ten.icon = 'qizhi';
  //   //   }
  //   //   ten.name = msg.data[i].name!;
  //   //   ten.desc = msg.data[i].desc!;
  //   //   ten.price = msg.data[i].originalPrice!.toInt();
  //   //   _goodsList.add(ten);
  //   // }
  //   // _pageState = 'success';
  //   // setState(() {});
  // }

  @override
  paySuccess() {
    // TODO: implement paySuccess
    Navigator.of(context).pop();
    if (widget.onPurchased != null) {
      widget.onPurchased!();
    }
  }
}
