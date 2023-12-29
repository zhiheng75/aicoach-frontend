// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../entity/result_entity.dart';
import '../../home/provider/home_provider.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../res/colors.dart';
import '../../util/log_utils.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/topic_entity.dart';

class Topic extends StatefulWidget {
  const Topic({
    Key? key,
    required this.onSelect
  }) : super(key: key);

  final Function(TopicEntity) onSelect;

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  late HomeProvider _homeProvider;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<TopicEntity> _topicList = [];

  void init() {
    getTopicList();
  }

  void getTopicList() {
    _pageState = 'loading';
    setState(() {});
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.topicOrScene,
      queryParameters: {
        'character_id': _homeProvider.character.characterId,
        'type': 1,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _pageState = 'fail';
          setState(() {});
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<TopicEntity> list = data.map((item) => TopicEntity.fromJson(item)).toList();
        _pageState = 'success';
        _topicList = list;
        setState(() {});
      },
      onError: (code, msg) {
        Log.d('getTopicList fail:[reason]$msg', tag: '获取话题');
        _pageState = 'fail';
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget list;
    if (_pageState != 'success') {
      list = Container(
        alignment: Alignment.center,
        child: _pageState == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    } else {
      double width = _screenUtil.screenWidth - 32.0;
      double itemSize = (width - 16.0) / 3;
      list = _topicList.isNotEmpty ? SizedBox(
        width: width,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _topicList.map((topic) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                widget.onSelect(topic);
              },
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: LoadImage(
                      topic.cover,
                      width: itemSize,
                      height: itemSize,
                    ),
                  ),
                  Positioned(
                    bottom: 11.0,
                    child: Container(
                      width: itemSize,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 21.0 / 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ) : Container(
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadAssetImage(
              'no_data',
              width: 63.0,
              height: 63.0,
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              '该角色没有话题',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_999999,
                height: 20.0 / 15.0,
                letterSpacing: 0.05,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
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
            height: 328.0,
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
                  '话题',
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
                Expanded(
                  child: list,
                ),
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