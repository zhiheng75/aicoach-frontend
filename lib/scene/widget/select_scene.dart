// ignore_for_file: prefer_final_fields

import 'package:Bubble/util/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../entity/result_entity.dart';
import '../../home/provider/home_provider.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../res/colors.dart';
import '../../util/confirm_utils.dart';
import '../../util/log_utils.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/category_entity.dart';
import '../entity/scene_entity.dart';

class SelectScene extends StatefulWidget {
  const SelectScene({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectScene> createState() => _SelectSceneState();
}

class _SelectSceneState extends State<SelectScene> {

  late HomeProvider _homeProvider;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  List<CategoryEntity> _categoryList = [];
  ValueNotifier<int> _currentIndex = ValueNotifier(0);
  Offset? _initialPosition;
  double _offset = 0;
  // 状态 loading-加载中 fail-失败 success-成功
  String _sceneState = 'loading';
  List<SceneEntity> _sceneList = [];
  final ScrollController _scrollController = ScrollController();

  void init() {
    _pageState = 'loading';
    setState(() {});
    getCategoryList();
  }

  void getCategoryList() {
    _pageState = 'loading';
    setState(() {});
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.topicOrScene,
      queryParameters: {
        'character_id': _homeProvider.character.characterId,
        'type': 2,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _pageState = 'fail';
          setState(() {});
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<CategoryEntity> list = data.map((item) => CategoryEntity.fromJson(item)).toList();
        _pageState = 'success';
        _categoryList = list;
        setState(() {});

        if (_categoryList.isNotEmpty) {
          changeCategory(0);
        }
      },
      onError: (code, msg) {
        Log.d('getCategoryList fail:[reason]$msg', tag: '获取场景分类');
        _pageState = 'fail';
        setState(() {});
      }
    );
  }

  void changeCategory(int index) {
    _currentIndex.value = index;
    getSceneListByCategory();
  }

  void getSceneListByCategory() {
    _sceneState = 'loading';
    setState(() {});
    CategoryEntity category = _categoryList.elementAt(_currentIndex.value);
    _sceneList = category.sceneList;
    _sceneState = 'success';
    setState(() {});
    Future.delayed(Duration.zero, () {
      _scrollController.jumpTo(0);
    });
  }

  void selectScene(SceneEntity scene) {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
    if (homeProvider.scene?.id == scene.id) {
      return;
    }
    Navigator.of(context).pop();
    ConfirmUtils.show(
      context: context,
      title: '你要切换场景吗？',
      onConfirm: () {
        EventBus().emit('SELECT_SCENE', scene);
      },
      child: const Text(
        '场景切换会结束当前对话',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
          height: 18.0 / 15.0,
        ),
      ),
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

    if (_pageState != 'success') {
      return Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: _screenUtil.screenWidth,
              height: _screenUtil.screenHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: const Color(0xFF111111).withOpacity(0.95),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              alignment: Alignment.center,
              child: _pageState == 'fail' ? LoadFail(
                reload: init,
              ) : const LoadData(),
            ),
          ],
        ),
      );
    }

    // 各个组件的高度
    double titleHeight = _screenUtil.statusBarHeight +  80.0;
    double categoryHeight = 30.0;

    Widget categoryItem(int index, int currentIndex) {
      CategoryEntity category = _categoryList.elementAt(index);
      bool isSelected = index == currentIndex;

      TextStyle style = TextStyle(
        fontSize: 16.0,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        color: isSelected ? Colors.white : Colours.color_999999,
        height: 18.0 / 16.0,
        letterSpacing: 0.05,
      );

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          changeCategory(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              category.name,
              style: style,
            ),
            if (isSelected)
              Container(
                width: 32.0,
                height: 3.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colours.color_9AC3FF,
                      Colours.color_FF71E0,
                    ],
                  ),
                ),
                margin: const EdgeInsets.only(
                  top: 8.0,
                ),
              ),
          ],
        ),
      );
    }

    Widget category = SizedBox(
      width: _screenUtil.screenWidth - 32.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (_, index, __) {
            List<Widget> children = [];
            for (int i = 0; i < _categoryList.length; i++) {
              children.add(categoryItem(i, index));
              if (i < _categoryList.length - 1) {
                children.add(const SizedBox(width: 24.0,));
              }
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          },
        ),
      ),
    );

    Widget sceneItem(SceneEntity scene, double size) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => selectScene(scene),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: LoadImage(
                scene.cover,
                width: size,
                height: size,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.11),
                      Colors.black.withOpacity(0.0),
                    ],
                    stops: const [0, 0.93, 1],
                  ),
                ),
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Text(
                  scene.name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 16.4 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget scene = Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: const LoadData(),
    );

    if (_sceneState == 'fail') {
      scene = Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: LoadFail(
          reload: init,
        ),
      );
    }

    if (_sceneState == 'success') {
      // 数据结构转换
      List<List<SceneEntity>> rows = [];
      List<SceneEntity> row = [];
      for (int i = 0; i < _sceneList.length; i++) {
        row.add(_sceneList.elementAt(i));
        if (row.length == 2) {
          rows.add(row);
          row = [];
        }
      }

      if (row.isNotEmpty) {
        rows.add(row);
      }

      double width = _screenUtil.screenWidth;
      double height = _screenUtil.screenHeight - titleHeight - categoryHeight - 12 - _screenUtil.bottomBarHeight;
      scene = GestureDetector(
        onHorizontalDragStart: (details) {
          _initialPosition = details.globalPosition;
          _offset = 0;
        },
        onHorizontalDragUpdate: (details) {
          Offset position = details.globalPosition;
          if (position.dy - _initialPosition!.dy < 5.0) {
            _offset = position.dx - _initialPosition!.dx;
          }
        },
        onHorizontalDragEnd: (_) {
          if (_offset.abs() > 50) {
            int index = _offset < 0 ? _currentIndex.value + 1 : _currentIndex.value - 1;
            if (index < 0 || index == _categoryList.length) {
              return;
            }
            changeCategory(index);
          }
        },
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(0.0),
            itemCount: rows.length,
            itemBuilder: (_, i) {
              List<SceneEntity> row = rows.elementAt(i);
              List<Widget> children = [];
              for (int i = 0; i < row.length; i++) {
                SceneEntity scene = row.elementAt(i);
                children.add(sceneItem(scene, (width - 40.0) * 0.5));
                if (i < row.length - 1) {
                  children.add(const SizedBox(
                    width: 8.0,
                  ));
                }
              }
              return Container(
                margin: EdgeInsets.only(
                  bottom: i == rows.length - 1 ? 0 : 8.0,
                ),
                child: Row(
                  children: children,
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: _screenUtil.screenWidth,
            height: _screenUtil.screenHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color(0xFF111111).withOpacity(0.95),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: _screenUtil.statusBarHeight + 24.0,
                    bottom: 24.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        '场景',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 18.0 / 17.0,
                          letterSpacing: 0.05,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).pop(),
                        child: const LoadAssetImage(
                          'guanbi_yuan_bai',
                          width: 32.0,
                          height: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: category,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                scene,
                SizedBox(
                  height: _screenUtil.bottomBarHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}