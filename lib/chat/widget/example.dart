// ignore_for_file: prefer_final_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../entity/result_entity.dart';
import '../../home/provider/home_provider.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../res/colors.dart';
import '../../util/log_utils.dart';
import '../../util/media_utils.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';

class Example extends StatefulWidget {
  const Example({
    Key? key,
    required this.message,
  }) : super(key: key);

  final NormalMessage message;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  final MediaUtils _mediaUtils = MediaUtils();
  // 状态 loading-加载中 fail-失败 success-成功
  CancelToken _cancelToken = CancelToken();
  String _pageState = 'loading';
  String _text = '';
  String _speechUrl = '';

  void init() {
    _pageState = 'loading';
    setState(() {});
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.suggestAnswer,
      params: {
        'question': widget.message.text,
        // 'session_id': _homeProvider.sessionId,
        // 'message_id': widget.message.id,
        'character_id': _homeProvider.character.characterId,
      },
      cancelToken: _cancelToken,
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _pageState = 'success';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        _text = data['text'];
        _speechUrl = data['speech_url'];
        _pageState = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        Log.d('get example fail:msg=$msg', tag: '获取示例');
        _pageState = 'fail';
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void playAudio() {
    _mediaUtils.play(
      url: _speechUrl,
    );
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
  }

  @override
  Widget build(BuildContext context) {
    Widget example;
    if (_pageState != 'success') {
      example = Container(
        alignment: Alignment.center,
        child: _pageState == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    } else {
      example = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _text,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFF5BF),
              height: 18.0 / 14.0,
              letterSpacing: 0.05,
            ),
          ),
          // const SizedBox(
          //   height: 16.0,
          // ),
          // Text(
          //   textZh,
          //   style: const TextStyle(
          //     fontSize: 14.0,
          //     fontWeight: FontWeight.w400,
          //     color: Colors.white,
          //     height: 18.0 / 14.0,
          //     letterSpacing: 0.05,
          //   ),
          // ),
          const SizedBox(
            height: 16.0,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: playAudio,
            child: const LoadAssetImage(
              'laba',
              width: 17.6,
              height: 16.0,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (_pageState == 'loading') {
              _cancelToken.cancel();
            }
            await _mediaUtils.stopPlay();
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          child: Container(
            width: _screenUtil.screenWidth,
            height: _screenUtil.screenHeight,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: _screenUtil.screenWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: const Color(0xFF000101).withOpacity(0.9),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '示例',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_999999,
                    height: 18.0 / 12.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                example,
                SizedBox(
                  height: _screenUtil.bottomBarHeight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
