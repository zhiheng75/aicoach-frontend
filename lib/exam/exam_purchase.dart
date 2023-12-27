// ignore_for_file: prefer_final_fields

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
import 'presenter/exam_purchase_page_presenter.dart';
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

class _ExamPurchasePageState extends State<ExamPurchasePage> with BasePageMixin<ExamPurchasePage, ExamPurchasePagePresenter>, AutomaticKeepAliveClientMixin<ExamPurchasePage> implements ExamPurchaseView {

  late ExamPurchasePagePresenter _examPurchasePagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<ExamGoodEntity> _goodsList = [];
  int _goodsId = 0;
  String _pay = 'wxpay';
  bool _checked = false;

  void init() {
    getGoodsList();
  }

  void getGoodsList() {
    // todo 对接模考商品列表
    Future.delayed(const Duration(seconds: 3), () {
      ExamGoodEntity ten = ExamGoodEntity();
      ten.id = 1;
      ten.icon = 'huangguan';
      ten.name = '模考10次';
      ten.desc = '强化训练包';
      ten.price = 299;
      ExamGoodEntity five = ExamGoodEntity();
      five.id = 2;
      five.icon = 'xingxing';
      five.name = '模考5次';
      five.desc = '基础训练包';
      five.price = 199;
      ExamGoodEntity one = ExamGoodEntity();
      one.id = 3;
      one.icon = 'qizhi';
      one.name = '模考1次';
      one.desc = '单次训练包';
      one.price = 59;
      _goodsList = [ten, five, one];
      _pageState = 'success';
      setState(() {});
    });
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
    Navigator.of(context).pop();
    if (widget.onPurchased != null) {
      widget.onPurchased!();
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
    
    Widget goodsItem(ExamGoodEntity goods) {
      bool isSelected = _goodsId == goods.id;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _goodsId = goods.id;
          setState(() {});
        },
        child: Container(
          width: _screenUtil.screenWidth - 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: isSelected ? const Color(0xFFF5F5F5) : const Color(0xFFF5F5F5),
          ),
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
        child: LoadAssetImage(
          'exam_$pay',
          width: 40.0,
          height: 40.0,
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
                  child: LoadAssetImage(
                    _checked ? 'weigouxuan' : 'weigouxuan',
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
                        recognizer: TapGestureRecognizer()..onTap = () {},
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
                        recognizer: TapGestureRecognizer()..onTap = () {},
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
        child: _pageState == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
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
  ExamPurchasePagePresenter createPresenter() {
    _examPurchasePagePresenter = ExamPurchasePagePresenter();
    return _examPurchasePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}