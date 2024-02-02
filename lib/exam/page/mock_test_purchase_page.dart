import 'package:Bubble/exam/entity/goods_list_bean.dart';
import 'package:Bubble/exam/presenter/exam_purchase_page_presenter.dart';
import 'package:Bubble/exam/view/exam_purchas_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockTestPurchasePage extends StatefulWidget {
  final Function()? onPurchased;

  const MockTestPurchasePage({
    super.key,
    this.onPurchased,
  });

  @override
  State<MockTestPurchasePage> createState() => _MockTestPurchasePageState();
}

class _MockTestPurchasePageState extends State<MockTestPurchasePage>
    with
        BasePageMixin<MockTestPurchasePage, ExamPurchasePagePresenter>,
        AutomaticKeepAliveClientMixin<MockTestPurchasePage>
    implements ExamPurchaseView {
  late ExamPurchasePagePresenter _examPurchasePagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  // List<ExamGoodEntity> _goodsList = [];
  int _goodsId = 0;
  String _pay = 'wxpay';
  bool _checked = false;

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
    // TODO: implement initState
    super.initState();
    _examPurchasePagePresenter.getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const XTCupertinoNavigationBar(
              backgroundColor: Color(0xFFFFFFFF),
              border: null,
              padding: EdgeInsetsDirectional.zero,
              leading: NavigationBackWidget(),
              middle: Text(
                "KET考试模拟现场",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Gaps.vGap10,
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
            Gaps.vGap16,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                payItem('wxpay'),
                Gaps.vGap16,
                payItem('alipay'),
              ],
            ),
            Gaps.vGap26,
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
      ),
    );
  }

  @override
  ExamPurchasePagePresenter createPresenter() {
    _examPurchasePagePresenter = ExamPurchasePagePresenter();
    return _examPurchasePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(GoodsListBean msg) {
    // TODO: implement sendSuccess
  }
}
