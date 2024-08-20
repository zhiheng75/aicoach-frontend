import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedeemCodePage extends StatefulWidget {
  const RedeemCodePage({super.key});

  @override
  State<RedeemCodePage> createState() => _RedeemCodePageState();
}

class _RedeemCodePageState extends State<RedeemCodePage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < 10; i++) {
      list.add(Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 7.w),
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: Colours.color_F9F8FF,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("内容"),
            Text("兑换日期"),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "兑换中心",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        body: CustomPaint(
          painter: TopOriginPainter(),
          size: Size.infinite,
          child: Container(
            width: double.infinity,
            color: Colours.color_E8E4FF,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const LoadAssetImage(
                          'redeem_code_bg',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                        Gaps.vGap20
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 00,
                      child: Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        width: double.infinity,
                        height: Dimens.h_dp45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimens.h_dp40),
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: MyTextField(
                          key: const Key('phone'),
                          textAlign: TextAlign.center,
                          isDelete: false,
                          autoFocus: true,
                          textMessage: (message) {},
                          txtStyle: TextStyle(
                            fontSize: Dimens.font_sp14,
                            color: Colours.color_001652,
                          ),
                          hintStyle: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: Colours.color_001652),
                          focusNode: _nodeText1,
                          controller: _phoneController,
                          maxLength: 11,
                          keyboardType: TextInputType.phone,
                          hintText: "请输入兑换码",
                          underLineColor: Colours.color_00,
                          countDownColor: Colours.color_001652,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Gaps.vGap16,
                    Container(
                      width: double.infinity,
                      height: Dimens.h_dp45,
                      decoration: BoxDecoration(
                          // color: Colors.amber,
                          image: DecorationImage(
                              image:
                                  ImageUtils.getAssetImage("redeem_code_btn"),
                              fit: BoxFit.fitHeight)),
                      child: Center(
                        child: Text(
                          '立即兑换',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            // height: 3.5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w),
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, top: 5.h, bottom: 10.h),
                      decoration: BoxDecoration(
                        color: Colours.color_FFD67F,
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(
                        //   width: 1.0,
                        //   style: BorderStyle.solid,
                        //   color: Colours.color_001652,
                        // ),
                        // gradient: const LinearGradient(
                        //   begin: Alignment.topRight,
                        //   end: Alignment.bottomLeft,
                        //   colors: [
                        //     Colours.color_F8F3F5,
                        //     Colours.color_8256FF,
                        //     Colours.color_FF5CDB
                        //   ],
                        // ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoadAssetImage(
                            "tishi_icon",
                            width: 24.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("温情提示:",
                                  style: TextStyle(
                                    fontSize: 17.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    // height: 3.5,
                                  )),
                              Text("1,每个兑换码就嫩",
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                  )),
                              Text("1.每个兑换码就嫩",
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                    // height: 3.5,
                                  )),
                              Text("1.每个兑换码就嫩",
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                    // height: 3.5,
                                  )),
                              Text("1.每个兑换码就嫩",
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                    // height: 3.5,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                  padding: EdgeInsets.only(top: 10.h, left: 5.w, right: 5.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Gaps.hGap16,
                          LoadAssetImage(
                            "ticket_icon",
                            width: 24.w,
                          ),
                          Text("兑换记录",
                              style: TextStyle(
                                fontSize: 17.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                // height: 3.5,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildItems(),
                      ),
                      Gaps.vGap10
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Gaps.vGap35,
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class TopOriginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义新的坐标系原点
    canvas.translate(0.0, size.height);
    // 绘制操作从这里开始
    // ...
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
