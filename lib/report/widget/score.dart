import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../net/http_api.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';

class Score extends StatefulWidget {
  const Score({
    Key? key,
    required this.sessionId,
    this.type,
  }) : super(key: key);

  final String sessionId;
  final String? type;

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  // 状态 loading-加载中 fail-失败 success-成功
  final ScreenUtil _screenUtil = ScreenUtil();
  String _state = 'loading';
  Map<String, dynamic> _data = {};
  final CancelToken _cancelToken = CancelToken();

  void init() {
    _state = 'loading';
    setState(() {});
    getScore();
  }

  void getScore() {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      widget.type == 'exam' ? HttpApi.examScoreAllRound : HttpApi.scoreAllRound,
      cancelToken: _cancelToken,
      queryParameters: {
        'session_id': widget.sessionId,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _state = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        _data = result.data as Map<String, dynamic>;
        _state = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _state = 'fail';
        if (mounted) {
          setState(() {});
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    if (_state == 'loading') {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state != 'success') {
      return Padding(
        padding: EdgeInsets.only(
          bottom: _screenUtil.bottomBarHeight,
        ),
        child: _state == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    }

    Widget evaluationItem({
      required String icon,
      required String label,
      required num score,
      required String rank,
    }) {
      return Container(
        width: _screenUtil.screenWidth - 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFF8F8F8),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Row(
          children: <Widget>[
            LoadAssetImage(
              icon,
              width: 51.0,
              height: 51.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '$label得分${score.toInt()}，超过$rank的同学',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.0 / 15.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        evaluationItem(
          icon: 'fayin',
          label: '发音',
          score: _data['standard_score'] ?? 0,
          rank: _data['standard_rank'] ?? '0%',
        ),
        evaluationItem(
          icon: 'yufa',
          label: '语法与用词',
          score: _data['accuracy_score'] ?? 0,
          rank: _data['accuracy_rank'] ?? '0%',
        ),
        evaluationItem(
          icon: 'liuchangdu',
          label: '流畅度',
          score: _data['fluency_score'] ?? 0,
          rank: _data['fluency_rank'] ?? '0%',
        ),
        evaluationItem(
          icon: 'wanzhengdu',
          label: '完整度',
          score: _data['integrity_score'] ?? 0,
          rank: _data['integrity_rank'] ?? '0%',
        ),
      ],
    );
  }
}