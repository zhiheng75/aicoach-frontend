import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spokid/util/theme_utils.dart';

import '../res/dimens.dart';
import '../res/gaps.dart';
import 'load_image.dart';

class StateLayout extends StatelessWidget {

  const StateLayout({
    super.key,
    required this.type,
    this.hintText
  });

  final StateType type;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (type == StateType.loading)
          const CupertinoActivityIndicator(radius: 16.0)
        else
          if (type != StateType.empty)
            Opacity(
              opacity: context.isDark ? 0.5 : 1,
              child: LoadAssetImage(
                'state/${type.img}',
                width: 120,
              ),
            ),
        const SizedBox(width: double.infinity, height: Dimens.gap_dp16,),
        Text(
          hintText ?? type.hintText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimens.font_sp14),
        ),
        Gaps.vGap50,
      ],
    );
  }
}

enum StateType {

  /// 无网络
  network,
  /// 消息
  message,
  /// 无账号(用户没登录)
  account,
  /// 加载中
  loading,
  /// 空
  empty
}

extension StateTypeExtension on StateType {
  String get img => <String>[

    'net_error_img', 'empty_msg_img',
    'zwzh', '', '']
  [index];

  String get hintText => <String>[

    '无网络连接', '暂无消息',
    '马上注册账号吧', '', ''
  ][index];
}

