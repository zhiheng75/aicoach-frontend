//认证学习
import 'package:Bubble/home/entity/base_config_entity.dart';
import 'package:Bubble/home/entity/lesson_detail_bean.dart';
import 'package:Bubble/home/page/course_pays_page.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/my_good_list_entity.dart';
import 'package:Bubble/person/entity/wx_pay_entity.dart';
import 'package:Bubble/person/presneter/purchase_page_presenter.dart';
import 'package:Bubble/person/view/purchase_view.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CertifiedLearningPage extends StatefulWidget {
  final LessonDetailBean data;

  const CertifiedLearningPage({super.key, required this.data});

  @override
  State<CertifiedLearningPage> createState() => _CertifiedLearningPageState();
}

class _CertifiedLearningPageState extends State<CertifiedLearningPage>
    with
        BasePageMixin<CertifiedLearningPage, PurchasePagePresenter>,
        RouteAware,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<CertifiedLearningPage>
    implements PurchaseView {
  late PurchasePagePresenter _purchasePagePresenter;

  String _pay = 'wxpay';

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

  void pay() {
    if (_pay == 'wxpay') {
      // payInt = 1;
      _purchasePagePresenter.wxChatPay(
          widget.data.data.goodsId, widget.data.data.price, true);
    }
    if (_pay == 'alipay') {
      _purchasePagePresenter.aliPay(
          widget.data.data.goodsId, widget.data.data.price, true);
    }
    if (_pay == 'applepay') {
      _purchasePagePresenter.applePay(widget.data.data.goodsId);
    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> payChildren = [
      payItem('wxpay'),
      const SizedBox(
        width: 16.0,
      ),
      payItem('alipay'),
    ];
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "获得证书",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LoadAssetImage(
              "zhengshu_img",
              width: 228,
            ),
            Gaps.vGap8,
            Text(
              widget.data.data.price.toString(),
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            const Text(
              "获得条件",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            const Text(
              "加入训练营完成学习任务，且总测试分数在60分以上",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            Row(
              children: [
                Gaps.hGap16,
                const Text(
                  "支付方式",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_666666,
                  ),
                ),
              ],
            ),
            Gaps.vGap8,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: payChildren,
            ),
            Gaps.vGap8,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                pay();
              },
              child: Center(
                child: Container(
                  width: 250.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
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
            ),
          ],
        ),
      ))),
    );
  }

  @override
  PurchasePagePresenter createPresenter() {
    _purchasePagePresenter = PurchasePagePresenter();
    return _purchasePagePresenter;
  }

  @override
  paySuccess() {
    // TODO: implement paySuccess
    // throw UnimplementedError();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  void getBaseConfig(BaseConfigDataData data) {
    // TODO: implement getBaseConfig
  }

  @override
  void getWXPayMsg(WxPayDataData bean) {
    // TODO: implement getWXPayMsg
  }

  @override
  void goodListData(List<MyGoodListEntity> bean) {
    // TODO: implement goodListData
  }
}
