import 'package:flutter/material.dart';

import 'dimens.dart';

/// 间隔
class Gaps {
  
  /// 水平间隔
  static const Widget hGap4 = SizedBox(width: Dimens.gap_dp4);
  static const Widget hGap5 = SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap6 = SizedBox(width: Dimens.gap_dp6);
  static const Widget hGap7 = SizedBox(width: Dimens.gap_dp7);
  static const Widget hGap8 = SizedBox(width: Dimens.gap_dp8);
  static const Widget hGap10 = SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap12 = SizedBox(width: Dimens.gap_dp12);
  static const Widget hGap15 = SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap32 = SizedBox(width: Dimens.gap_dp32);
  
  /// 垂直间隔
  static const Widget vGap4 = SizedBox(height: Dimens.gap_dp4);
  static const Widget vGap5 = SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap8 = SizedBox(height: Dimens.gap_dp8);
  static const Widget vGap10 = SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap12 = SizedBox(height: Dimens.gap_dp12);
  static const Widget vGap13 = SizedBox(height: Dimens.gap_dp13);
  static const Widget vGap15 = SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap16 = SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap20 = SizedBox(height: Dimens.gap_dp20);
  static const Widget vGap24 = SizedBox(height: Dimens.gap_dp24);
  static const Widget vGap30 = SizedBox(height: Dimens.gap_dp30);
  static const Widget vGap32 = SizedBox(height: Dimens.gap_dp32);
  static const Widget vGap40 = SizedBox(height: Dimens.gap_dp40);
  static const Widget vGap50 = SizedBox(height: Dimens.gap_dp50);
  static const Widget vGap60 = SizedBox(height: Dimens.gap_dp60);
  static const Widget vGap100 = SizedBox(height: Dimens.gap_dp100);

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
