// ignore_for_file: prefer_final_fields

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../net/http_api.dart';
import '../../res/colors.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/advise_entity.dart';

class Advise extends StatefulWidget {
  const Advise({
    Key? key,
    required this.sessionId,
    this.type,
  }) : super(key: key);

  final String sessionId;
  final String? type;

  @override
  State<Advise> createState() => _AdviseState();
}

class _AdviseState extends State<Advise> {
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _state = 'loading';
  final CancelToken _cancelToken = CancelToken();
  List<AdviseEntity> _adviseList = [];
  AdviseEntity? _adviseEntityInPlay;

  void init() {
    _state = 'loading';
    setState(() {});
    getAdviseList();
  }

  void getAdviseList() {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      widget.type == 'exam' ? HttpApi.examScoreSuggestion : HttpApi.scoreSuggestion,
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
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        if (data['sentence_list'] != null && data['sentence_list'] is List) {
          List<AdviseEntity> adviseList = [];
          for(dynamic item in data['sentence_list']) {
            AdviseEntity advise = AdviseEntity.fromJson(item);
            advise.type = data['type'] ?? 2;
            adviseList.add(advise);
          }
          _adviseList = adviseList;
        }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state != 'success') {
      return Padding(
        padding: EdgeInsets.only(
          bottom: _screenUtil.bottomBarHeight + 16.0,
        ),
        child: _state == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    }

    Widget adviseItem(AdviseEntity advise) {
      Widget button(String label, {Function()? onPress}) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (onPress != null) {
              onPress();
            }
          },
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 20.0 / 15.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                const LoadAssetImage(
                  'laba_lan',
                  width: 17.6,
                  height: 16.0,
                ),
              ],
            ),
          ),
        );
      }

      Widget content = const SizedBox();

      if (advise.type == 1) {
        content = Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    advise.sentence,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 16.0 / 14.0,
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 11.0,
                // ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {},
                //   child: const LoadAssetImage(
                //     'laba_lan',
                //     width: 17.6,
                //     height: 16.0,
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                button(
                  '你的回答',
                  onPress: () async {
                    // 点击其他的
                    if (_adviseEntityInPlay != null && advise != _adviseEntityInPlay) {
                      await _adviseEntityInPlay!.stopAll();
                    }
                    advise.playUserVoice();
                    _adviseEntityInPlay ??= advise;
                  },
                ),
                button(
                  '试一下这样说',
                  onPress: () async {
                    // 点击其他的
                    if (_adviseEntityInPlay != null && advise != _adviseEntityInPlay) {
                      await _adviseEntityInPlay!.stopAll();
                    }
                    advise.playStandardVoice();
                    _adviseEntityInPlay ??= advise;
                  },
                )
              ],
            ),
          ],
        );
      }

      if (advise.type == 2) {
        content = Row(
          children: [
            Expanded(
              child: Text(
                advise.userSentence,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 16.0 / 14.0,
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '${advise.score.toInt()}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 24.0 / 14.0,
                            letterSpacing: 0.05,
                          )
                      ),
                      const TextSpan(
                          text: '分',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 24.0 / 10.0,
                            letterSpacing: 0.05,
                          )
                      ),
                    ],
                  ),
                ),
                const LoadAssetImage(
                  'dianzan',
                  width: 18.0,
                  height: 18.0,
                ),
              ],
            ),
          ],
        );
      }

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
        child: content,
      );
    }

    if (_adviseList.isEmpty) {
      return Column(
        children: <Widget>[
          Text(
            '暂无地道表达',
            style: TextStyle(
              fontSize: 15.0,
              color: Colours.hex2color('#546092'),
              letterSpacing: 16.0 / 15.0,
              height: 24.0 / 16.0,
            ),
          ),
          SizedBox(
            height: _screenUtil.bottomBarHeight + 16.0,
          ),
        ],
      );
    }

    return Column(
      children: _adviseList.map((advise) => adviseItem(advise)).toList(),
    );
  }
}