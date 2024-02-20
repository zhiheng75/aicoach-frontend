// ignore_for_file: prefer_final_fields
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../entity/result_entity.dart';
import '../mvp/base_page.dart';
import '../net/dio_utils.dart';
import '../net/http_api.dart';
import '../res/colors.dart';
import '../util/log_utils.dart';
import '../widgets/load_fail.dart';
import '../widgets/load_image.dart';
import '../widgets/navbar.dart';
import 'entity/order_entity.dart';
import 'presneter/order_page_presenter.dart';
import 'view/order_view.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with
        BasePageMixin<OrderPage, OrderPagePresenter>,
        AutomaticKeepAliveClientMixin<OrderPage>
    implements OrderView {
  late OrderPagePresenter _orderPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  int _loadFailed = 0;
  int _page = 1;
  int _loading = 0;
  List<OrderEntity> _orderList = [];
  late String phone = "";

  void init() {
    getMore();
  }

  void getMore() {
    if (_loading == 1) {
      return;
    }
    _loadFailed = 0;
    _loading = 1;
    setState(() {});
    _orderPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.orderRecords,
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _loading = 0;
          setState(() {});
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<OrderEntity> list =
            data.map((item) => OrderEntity.fromJson(item)).toList();
        Log.e(list.toString());
        _orderList.addAll(list);
        _loading = 0;
        setState(() {});
      },
      onError: (code, msg) {
        Log.d('getMore failed:[reason]$msg', tag: '获取订单列表');
        if (_page == 1) {
          _loadFailed = 1;
        }
        _loading = 0;
        setState(() {});
      },
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

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> user = LoginManager.getUserInfo();
    if (validateInput(user['phone'])) {
      phone = user['phone'];
    }

    Future.delayed(Duration.zero, init);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget orderItem(OrderEntity order) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFF8F8F8),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    order.name,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 18.0 / 17.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  Text(
                    '订单号：${order.no}\n交易金额：${order.amount}元\n交易时间：${order.payTime}\n支付方式：${order.payType}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.0 / 14.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 24.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '¥${order.price}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0047FF),
                    height: 18.7 / 16.0,
                    letterSpacing: 0.05,
                  ),
                ),
                order.type == 1
                    ? Text(
                        '/${order.unit}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 18.7 / 16.0,
                          letterSpacing: 0.05,
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      );
    }

    Widget list = const SizedBox();

    if (_loading == 0) {
      list = _orderList.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: _screenUtil.bottomBarHeight,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _orderList.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(
                    bottom: i == _orderList.length - 1 ? 0 : 16.0,
                  ),
                  child: orderItem(_orderList.elementAt(i)),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 250.0,
                ),

                // const SizedBox(
                //   height: 24.0,
                // ),

                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LoadAssetImage(
                      'no_data',
                      width: 63.0,
                      height: 63.0,
                    ),
                    Text(
                      '您还没有购买记录',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_999999,
                        height: 20.0 / 15.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                    Text(
                      '现在开始升级体验吧！',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_999999,
                        height: 20.0 / 15.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ],
                ),
                phone == "17001234567"
                    ? Container()
                    : const Expanded(child: Gaps.empty),

                // phone == "17001234567"
                //     ? Container()
                //     :
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        NavigatorUtils.push(context, PersonalRouter.purchase),
                    child: Container(
                      width: 200,
                      height: Dimens.h_dp40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage("btn_bg_img"),
                              fit: BoxFit.fill)),
                      child: Center(
                        child: Text(
                          "升级会员",
                          style: TextStyle(
                              color: Colours.color_001652,
                              fontSize: Dimens.font_sp18),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 50.0,
                ),
              ],
            );
    }

    if (_loadFailed == 1) {
      list = Center(
        child: LoadFail(
          reload: init,
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60.0,
            ),
            const Navbar(
              title: '购买记录',
            ),
            Expanded(
              child: list,
            ),
          ],
        ),
      ),
    );
  }

  @override
  OrderPagePresenter createPresenter() {
    _orderPagePresenter = OrderPagePresenter();
    return _orderPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}
