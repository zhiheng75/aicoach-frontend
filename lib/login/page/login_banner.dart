import 'dart:async';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

///自定义须知，手势滑动时，取消定时，手势抬起，重新定时
class LoginBanner extends StatefulWidget {
  final List<String>? imageList; //图片地址
  final List<String>? topImageList; //图片地址

  final double? height; //图片高度
  final double? margin; //距离左上右下边的距离
  final Color? indicatorSelectColor; //指示器选中的颜色
  final Color? indicatorUnSelectColor; //指示器未选中的颜色
  final double? indicatorWidth; //指示器宽
  final double? indicatorHeight; //指示器高
  final double? indicatorUnWidth; //指示器未选中宽
  final double? indicatorUnHeight; //指示器未选中高
  final double? indicatorMargin; //指示器边距
  final IndicatorType? indicatorType; //指示器类型
  final double? indicatorRadius; //指示器圆角度数
  final Color? indicatorBottomColor; //指示器在Banner下的背景，默认是透明
  final double? indicatorBottomHeight; //指示器在Banner下的高度
  final double? indicatorBottomMarginLeft; //指示器在Banner下的 距离左边
  final double? indicatorBottomMarginRight; //指示器在Banner下的 距离右边
  final MainAxisAlignment indicatorBottomMainAxisAlignment; //指示器在Banner下的位置
  final int? delay; //多少时间轮播一次
  final bool? autoPlay; //是否自动轮播
  final bool? showIndicators; //是否展示指示器
  final Function(int)? bannerClick; //点击事件
  final double? viewportFraction; //banner缩进

  const LoginBanner({
    super.key,
    required this.imageList,
    required this.topImageList,
    this.height = 800, //默认高度150
    this.margin,
    this.indicatorSelectColor = Colours.color_00000019,
    this.indicatorUnSelectColor = Colours.color_00000019,
    this.indicatorWidth = 10, //指示器宽
    this.indicatorHeight = 10, //指示器高
    this.indicatorMargin = 5, //指示器边距
    this.indicatorType = IndicatorType.circle,
    this.indicatorRadius = 0, //指示器圆角度数
    this.indicatorUnWidth,
    this.indicatorUnHeight,
    this.indicatorBottomColor = Colors.transparent,
    this.indicatorBottomHeight = 30,
    this.indicatorBottomMarginLeft = 0,
    this.indicatorBottomMarginRight = 0,
    this.indicatorBottomMainAxisAlignment = MainAxisAlignment.center,
    this.delay = 5, //默认是5秒轮询一次
    this.autoPlay = true, //默认是自动轮播
    this.showIndicators = true, //默认展示指示器
    this.bannerClick,
    this.viewportFraction = 1, //banner缩进
  });

  @override
  State<StatefulWidget> createState() => _CarouselState();
}

class _CarouselState extends State<LoginBanner> with WidgetsBindingObserver {
  late PageController _controller;
  int _currentPage = 0;
  int _pagePosition = 0;
  double opacity = 1.0;

  // 定时器实例
  Timer? _timer;

  //计时器的运行状态
  bool _isRunning = false;

  //是否触发了点击
  bool _isClick = true;

  /*
  * 开启定时
  * */
  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: widget.delay!), (timer) {
        _controller.animateToPage(_pagePosition + 1,
            duration: const Duration(microseconds: 10),
            curve: Curves.easeInOut);
      });
    }
  }

  /*
  * 暂停定时
  * */
  void _pauseTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel(); //取消计时器
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
        viewportFraction: widget.viewportFraction!, keepPage: false);

    // 添加监听
    WidgetsBinding.instance.addObserver(this);
    if (widget.autoPlay!) {
      _startTimer();
    }
  }

  /*
  * 感知生命周期变化
  * */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _startTimer(); //页面可见，开启定时
    } else if (state == AppLifecycleState.paused) {
      _pauseTimer(); //页面不可见，关闭定时
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /*
  * 页面滑动监听
  * */
  void _onPageChanged(int index) {
    // Log.e("msg============$index");
    var position = index % widget.imageList!.length;
    if (position == 0) {
      EventUMStatistics.umengCommonMapEvent("view_login_carousel_1");
    } else if (position == 1) {
      EventUMStatistics.umengCommonMapEvent("view_login_carousel_2");
    } else if (position == 2) {
      EventUMStatistics.umengCommonMapEvent("view_login_carousel_3");
    } else if (position == 3) {
      EventUMStatistics.umengCommonMapEvent("view_login_carousel_4");
    }
    setState(() {
      _currentPage = position;
      _pagePosition = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bannerImage = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        ///滑动开始
        if (notification is ScrollStartNotification) {
          Log.e("滑动开始");
          _pauseTimer();
          _isClick = true;
          setState(() {
            opacity = 0.5;
          });
        }

        ///滑动中
        if (notification.depth == 0 &&
            notification is ScrollUpdateNotification) {
          Log.e("滑动中");
          setState(() {
            Future.delayed(const Duration(milliseconds: 800), () {
              opacity = 1.0;
            });
          });
        }

        ///滑动结束
        if (notification.depth == 0 && notification is ScrollEndNotification) {
          Log.e("滑动结束");
          _startTimer();
          setState(() {
            opacity = 1.0;
          });
        }
        return false;
      },
      child: SizedBox(
        height: widget.height,
        child: Listener(
            onPointerDown: (event) {
              //手指按下，定时取消
              _pauseTimer();
              _isClick = true;
            },
            onPointerMove: (event) {
              _isClick = false;
              // Log.e('Pointer down at: ${event.position}');
              // print('Pointer down at: ${event.position}');
            },
            onPointerUp: (event) {
              //手指抬起，定时开启
              _startTimer();
              //作为点击事件
              if (_isClick && widget.bannerClick != null) {
                widget.bannerClick!(_currentPage);
              }
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: opacity,
              child: PageView.builder(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    var position = index % widget.imageList!.length;
                    String imageUrl = widget.imageList![position];
                    return Lottie.asset(imageUrl, repeat: false);
                  }),
            )),
      ),
    );
    return Stack(
      children: [bannerImage, getBannerIndicators(), getBannerTopImage()],
    );
  }

  Widget getBannerTopImage() {
    return Positioned(
      top: 60.h,
      left: 0,
      right: 0,
      child: LoadAssetImage(
        widget.topImageList![_currentPage],
      ),
    );
  }

  /*
  * 获取指示器
  * */
  Widget getBannerIndicators() {
    return Positioned(
      bottom: 200.h,
      left: 0,
      right: 0,
      child: _buildIndicators(MainAxisAlignment.center),
    );
  }

  /*
  * 获取指示器,底部
  * */
  Widget getBannerBottomIndicators() {
    return Container(
      height: widget.indicatorBottomHeight,
      color: widget.indicatorBottomColor,
      margin: EdgeInsets.only(
          left: widget.indicatorBottomMarginLeft!,
          right: widget.indicatorBottomMarginRight!),
      child: _buildIndicators(widget.indicatorBottomMainAxisAlignment),
    );
  }

  /*
  * 指示器
  * */
  Widget _buildIndicators(mainAxisAlignment) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(widget.imageList!.length, (index) {
        return Container(
          width: _currentPage == index
              ? widget.indicatorWidth
              : widget.indicatorUnWidth ?? widget.indicatorWidth,
          height: _currentPage == index
              ? widget.indicatorHeight
              : widget.indicatorUnHeight ?? widget.indicatorHeight,
          margin: EdgeInsets.symmetric(horizontal: widget.indicatorMargin!),
          decoration: BoxDecoration(
            shape: widget.indicatorType == IndicatorType.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: widget.indicatorType == IndicatorType.rectangle
                ? BorderRadius.all(Radius.circular(widget.indicatorRadius!))
                : null,
            color: _currentPage == index
                ? widget.indicatorSelectColor
                : widget.indicatorUnSelectColor,
          ),
        );
      }),
    );
  }
}

///指示器类型
enum IndicatorType { circle, rectangle, text }
