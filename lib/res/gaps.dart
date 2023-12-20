import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

/// 间隔
class Gaps {
  
  /// 水平间隔
  static  Widget hGap4 = SizedBox(width: Dimens.w_dp4);
  static  Widget hGap5 = SizedBox(width: Dimens.w_dp5);
  static  Widget hGap6 = SizedBox(width: Dimens.w_dp6);
  static  Widget hGap7 = SizedBox(width: Dimens.w_dp7);
  static  Widget hGap8 = SizedBox(width: Dimens.w_dp8);
  static  Widget hGap10 = SizedBox(width: Dimens.w_dp10);
  static  Widget hGap12 = SizedBox(width: Dimens.w_dp12);
  static  Widget hGap15 = SizedBox(width: Dimens.w_dp15);
  static  Widget hGap16 = SizedBox(width: Dimens.w_dp16);
  static  Widget hGap32 = SizedBox(width: Dimens.w_dp32);
  
  /// 垂直间隔
  static  Widget vGap2 = SizedBox(height: Dimens.h_dp2);
  static  Widget vGap3 = SizedBox(height: Dimens.h_dp3);
  static  Widget vGap4 = SizedBox(height: Dimens.h_dp4);
  static  Widget vGap5 = SizedBox(height: Dimens.h_dp5);
  static  Widget vGap7 = SizedBox(height: Dimens.h_dp7);
  static  Widget vGap8 = SizedBox(height: Dimens.h_dp8);
  static  Widget vGap10 = SizedBox(height: Dimens.h_dp10);
  static  Widget vGap11 = SizedBox(height: Dimens.h_dp11);
  static  Widget vGap12 = SizedBox(height: Dimens.h_dp12);
  static  Widget vGap13 = SizedBox(height: Dimens.h_dp13);
  static  Widget vGap15 = SizedBox(height: Dimens.h_dp15);
  static  Widget vGap16 = SizedBox(height: Dimens.h_dp16);
  static  Widget vGap18 = SizedBox(height: Dimens.h_dp18);
  static  Widget vGap20 = SizedBox(height: Dimens.h_dp20);
  static  Widget vGap24 = SizedBox(height: Dimens.h_dp24);
  static  Widget vGap26 = SizedBox(height: Dimens.h_dp26);
  static  Widget vGap30 = SizedBox(height: Dimens.h_dp30);
  static  Widget vGap32 = SizedBox(height: Dimens.h_dp32);
  static  Widget vGap33 = SizedBox(height: Dimens.h_dp33);
  static  Widget vGap40 = SizedBox(height: Dimens.h_dp40);
  static  Widget vGap50 = SizedBox(height: Dimens.h_dp50);
  static  Widget vGap60 = SizedBox(height: Dimens.h_dp60);
  static  Widget vGap80 = SizedBox(height: Dimens.h_dp80);
  static  Widget vGap85 = SizedBox(height: Dimens.h_dp85);
  static  Widget vGap100 = SizedBox(height: Dimens.h_dp100);
  static  Widget vGap168 = SizedBox(height: Dimens.h_dp168);

//  static Widget line = const SizedBox(
//    height: 0.6,
//    width: double.infinity,
//    child: const DecoratedBox(decoration: BoxDecoration(color: Colours.line)),
//  );

  static const Widget line = Divider();

  static const Widget vLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: VerticalDivider(),
  );
  
  static const Widget empty = SizedBox.shrink();

}
