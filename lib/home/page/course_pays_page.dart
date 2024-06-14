import 'dart:async';

import 'package:Bubble/home/entity/lesson_detail_bean.dart';
import 'package:Bubble/home/widget/teacher_show_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/presneter/purchase_page_presenter.dart';
import 'package:Bubble/person/view/purchase_view.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';

class CoursePaysPage extends StatefulWidget {
  final LessonDetailBean data;
  const CoursePaysPage({super.key, required this.data});

  @override
  State<CoursePaysPage> createState() => _CoursePaysPageState();
}

class _CoursePaysPageState extends State<CoursePaysPage>
    with
        BasePageMixin<CoursePaysPage, PurchasePagePresenter>,
        RouteAware,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<CoursePaysPage>
    implements PurchaseView {
  final ScreenUtil _screenUtil = ScreenUtil();
  late PurchasePagePresenter _purchasePagePresenter;

  String _pay = 'wxpay';

  String remainTimeStr = '00:00:00';
  late Timer _timer;
  late String? accessToken;
  Fluwx fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    //开始倒计时，这里传入的是秒数
    startCountDown(600);
    accessToken = SpUtil.getString(Constant.accessToken);

    fluwx.registerApi(
        appId: "wxfb033d09d2eecaf0",
        universalLink: "https://demo.shenmo-ai.net/ios/");

    EventUMStatistics.umengCommonPageCollectionModeAuto();
    EventUMStatistics.umengCommonOnPageStart("收银台页面停留时长");
  }

  //倒计时
  void startCountDown(int time) {
    var countTime = time;
    const repeatPeriod = Duration(seconds: 1);
    _timer = Timer.periodic(repeatPeriod, (timer) {
      if (countTime <= 0) {
        _timer.cancel();
        // timer = null;
        //待付款倒计时结束，可以在这里做相应的操作
        return;
      }
      countTime--;
      //外面传进来的单位是秒，所以需要根据总秒数，计算小时，分钟，秒
      int hour = (countTime ~/ 3600) % 24; //如果不止24小时的就不用%24
      int minute = countTime % 3600 ~/ 60;
      int second = countTime % 60;
      var str = '';
      if (hour > 0) {
        str = '$str$hour:';
      }
      if (minute / 10 < 1) {
        //当只有个位数时，给前面加“0”，实现效果：“:01”,":02"
        // ignore: prefer_interpolation_to_compose_strings
        str = str + '0' + minute.toString() + ":";
      } else {
        str = "$str$minute:";
      }
      if (second / 10 < 1) {
        str = '${str}0$second';
      } else {
        str = str + second.toString();
      }
      setState(() {
        remainTimeStr = str;
      });
    });
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

  // void showPayToast({required BuildContext context, required String message}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog.adaptive(
  //         title: Text(message),
  //         actions: [
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          "支付",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vGap10,
            const Text(
              "收银台",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_666666,
              ),
            ),
            Gaps.vGap4,
            Text(
              widget.data.data.price.toString(),
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Gaps.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "支付倒计时 ",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Text(
                  remainTimeStr,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_00BB40,
                  ),
                ),
              ],
            ),
            Gaps.vGap10,
            Container(
              width: _screenUtil.screenWidth,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colours.color_F8F8F8,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "商品名称",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                  Gaps.vGap8,
                  Text(
                    widget.data.data.levelName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_333333,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap30,
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
            Gaps.vGap30,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: payChildren,
            ),
            Expanded(child: Gaps.vGap30),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                EventUMStatistics.umengCommonMapEvent("收银台点击支付按钮的次数");
                pay();
              },
              child: Container(
                width: 250.0,
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
                  '立即支付',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_001652,
                  ),
                ),
              ),
            ),
            Gaps.vGap60,
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    EventUMStatistics.umengCommonOnPageEnd("收银台页面停留时长");

    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
  }

  // void alertDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("QQQQ"),
  //           content: Text("QQQQ"),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   //跳转小程序
  //                   Fluwx fluwx = Fluwx();
  //                   fluwx.registerApi(
  //                       appId: "wxfb033d09d2eecaf0",
  //                       universalLink: "https://demo.shenmo-ai.net/ios/");
  //                   fluwx.open(
  //                       target: MiniProgram(
  //                           username: "gh_dcd9c62ba779",
  //                           path:
  //                               "pages/mine/add-weChat/add-weChat?user_token=$accessToken",
  //                           miniProgramType: WXMiniProgramType.test));
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text("QQQQ")),
  //             TextButton(onPressed: () {}, child: Text("QQQQ")),
  //           ],
  //         );
  //       });
  // }

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TeacherShowView(
            () {
              //确定
              String accessToken = SpUtil.getString(Constant.accessToken) ?? "";
              String url =
                  "pages/mine/add-weChat/add-weChat?user_token=$accessToken";
              var encoded = Uri.encodeComponent(url);
              fluwx.open(
                  target: MiniProgram(
                      username: "gh_dcd9c62ba779",
                      path: encoded,
                      miniProgramType: WXMiniProgramType.release));
              EventUMStatistics.umengCommonMapEvent("添加辅导老师页面曝光次数");

              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  paySuccess() {
    // TODO: implement paySuccess
    // showPayToast(context: context, message: "支付成功\n前往微信添加\n本课程辅导老师");
    // Future.delayed(const Duration(seconds: 5), () {
    EventBus().emit(NotificationUtils.paySuccess);

    // 这里是你想要延迟执行的代码
    // });
    showImageDialog();
//     ConfirmUtils.showSingle(
//       context: context,
//       title: "支付成功\n前往微信添加\n本课程辅导老师",
//       onCancel: () {
// //         移动应用appid:wxfb033d09d2eecaf0
// // 小程序appid:wx2140a8026b8cdf74
// // 跳转路径：pages/mine/add-weChat/add-weChat?user_token=token
//         // alertDialoFg();
//         //跳转小程序
//         fluwx.open(
//             target: MiniProgram(
//                 username: "gh_dcd9c62ba779",
//                 path:
//                     "pages/mine/add-weChat/add-weChat?user_token=$accessToken",
//                 miniProgramType: WXMiniProgramType.test));
//         Navigator.of(context).pop();
//       },
//     );
  }

  @override
  PurchasePagePresenter createPresenter() {
    _purchasePagePresenter = PurchasePagePresenter();
    return _purchasePagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}
