import 'package:flutter/material.dart';

/* Class: StarRating 等级评分
*/
class StarRating extends StatefulWidget {
  final double rating; // 当前评分、必传参数
  final double maxRating; // 最高评分、默认为10
  final Widget unselectedImage; // 未选中的星星图片
  final Widget selectedImage; // 选中的星星的图片
  final int count; // 星星个数
  final double size; // 星星大小
  final Color unselectedColor; // 星星未选中颜色
  final Color selectedColor; // 星星选中颜色
  final bool isShowLeftText; // 左边是否显示标题
  final Widget leftTextWidget; // 自定义定制左边文字Widget
  final String leftText; // 左边文字
  final double leftTextRightMargin; // 左边标题跟星星的间距

  StarRating({
    super.key,
    required this.rating, // 3. https://blog.csdn.net/u011272795/article/details/109486729
    this.maxRating = 5,
    this.size = 25,
    this.unselectedColor = const Color(0xffbbbbbb),
    this.selectedColor = const Color(0xffe0aa46),
    Widget?
        unselectedImage, // https://zhuoyuan.blog.csdn.net/article/details/118671585
    Widget? selectedImage,
    Widget? leftTextWidget,
    this.count = 5,
    this.isShowLeftText = false,
    this.leftTextRightMargin = 10,
    this.leftText = '物流服务',
  })  : assert(rating <= maxRating),
        unselectedImage = unselectedImage ??
            Icon(Icons.star, size: size, color: unselectedColor),
        selectedImage =
            selectedImage ?? Icon(Icons.star, size: size, color: selectedColor),
        leftTextWidget =
            leftTextWidget ?? Text(leftText, style: TextStyle(fontSize: 16));

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min, // 如果不设置就会不居中...
        children: [
          widget.isShowLeftText ? widget.leftTextWidget : Container(),
          widget.isShowLeftText
              ? SizedBox(width: widget.leftTextRightMargin)
              : SizedBox(width: 0),
          oneLineStarRating(),
        ],
      ),
    );
  }

  /* 一行只有星星评级【为选中星星 + 选中星星】
  */
  Widget oneLineStarRating() {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: getUnselectedStarRatingImage(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: getSelectedStarRatingImage(),
        ),
      ],
    );
  }

  // 获取未选中的星级评定
  List<Widget> getUnselectedStarRatingImage() {
    return List.generate(widget.count, (index) => widget.unselectedImage);
  }

  // 获取选中的星级评定
  List<Widget> getSelectedStarRatingImage() {
    // 计算每一个星星分
    double oneStarRatingValue = widget.maxRating / widget.count;

    // 计算用户评价的分数显示几颗星, 取整数高亮
    int entireCount = (widget.rating / oneStarRatingValue).floor();

    // 计算剩下未选中星星分
    double leftStarRatingValue =
        widget.rating - entireCount * oneStarRatingValue;

    // 计算剩余未选中星星分数的比率
    double leftStarRatingRatio = leftStarRatingValue / oneStarRatingValue;

    // 获取评分Star前面整数部分
    List<Widget> selectedImages = [];
    for (int i = 0; i < entireCount; i++) {
      selectedImages.add(widget.selectedImage);
    }

    // 3.计算: 如果leftStarValue==0.0, 还是会创建一个星星、造成不居中对齐
    if (leftStarRatingRatio != 0.0) {
      Widget leftStar = ClipRect(
        clipper: MyRectClipper(width: leftStarRatingRatio * widget.size),
        child: widget.selectedImage,
      );
      selectedImages.add(leftStar);
    }

    return selectedImages;
  }
}

/*  ClipRect + CustomClipper
  可以使用ClipRect定制CustomClipper进行裁剪
  定义CustomClipper裁剪规则：
*/
class MyRectClipper extends CustomClipper<Rect> {
  final double width;

  MyRectClipper({this.width = 0.0});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}
