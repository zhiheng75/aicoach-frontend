//课程支付
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoursePaymentPage extends StatefulWidget {
  const CoursePaymentPage({super.key});

  @override
  State<CoursePaymentPage> createState() => _CoursePaymentPageState();
}

class _CoursePaymentPageState extends State<CoursePaymentPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程支付",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Text("收银台"),
          Text("100元"),
          Text("支付倒计时"),
          Text("商品名"),
          Text("L1课程adad"),
          Text("支付方式"),
          Text("微信"),
          Text("支付宝"),
          Text("支付"),
        ],
      ))),
    );
  }
}
