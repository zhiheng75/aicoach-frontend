import 'package:flutter/material.dart';

class BarChart extends StatefulWidget {
  final List<String?> xData;
  final List<double> peopleData;
  final List<Color> colorData;
  const BarChart(this.xData, this.peopleData, this.colorData, {Key? key})
      : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 200,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: GestureDetector(
        onTapUp: (TapUpDetails detail) {},
        child: CustomPaint(
            painter:
                BarPainter(widget.xData, widget.peopleData, widget.colorData)),
      ),
    );
  }
}

const double _kScaleHeight = 10; // 刻度高

class BarPainter extends CustomPainter {
  final ValueNotifier<Offset>? offset;

  ///文字画笔
  final TextPainter _textPainter =
      TextPainter(textDirection: TextDirection.ltr, maxLines: 2);

  ///x轴上数据
  final List<String?> xData;

  ///人数数据
  final List<double> peopleData;

  ///颜色数据
  final List<Color> colorData;

  final Animation<double>? repaint;

  ///x,y轴路径
  Path axisPath = Path();

  ///x,y轴画笔
  Paint axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Color(0xFFEEF0F5);

  ///网格线画笔
  Paint gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Color(0xFFEEF0F5)
    ..strokeWidth = 0.5;

  ///柱状图画笔
  Paint unknowPaint = Paint()
    ..color = Color(0xFFF16748).withOpacity(0.8)
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  double xStep = 0; // x 间隔
  double yStep = 0; // y 间隔

  double maxData = 100; // 数据最大值

  BarPainter(
    this.xData,
    this.peopleData,
    this.colorData, {
    this.repaint,
    this.offset,
  }) : super(repaint: repaint) {
    if (peopleData != null && peopleData.length > 0) {
      maxData = maxData;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (xData.length != 0) {
      xStep = (size.width - _kScaleHeight) / xData.length;
    }
    yStep = (size.height - _kScaleHeight) / 2 / 2;
    canvas.translate(0, size.height);
    canvas.translate(_kScaleHeight, -_kScaleHeight);
    axisPath.moveTo(0, 0);
    axisPath.relativeLineTo(size.width - _kScaleHeight, 0);
    axisPath.moveTo(0, 0);
    axisPath.relativeLineTo(0, -size.height);

    axisPath.moveTo(size.width - _kScaleHeight, 0);
    axisPath.relativeLineTo(0, -size.height);
    // canvas.drawPath(axisPath, axisPaint);

    drawXText(canvas, size);
    drawYText(canvas, size);

    drawBarChart(canvas, size);
  }

  ///绘制x轴文字
  void drawXText(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(xStep, 0);
    double fontSize = 12;
    for (int i = 0; i < xData.length; i++) {
      if (xData[i]!.length > 11) {
        fontSize = 11;
      }
    }

    for (int i = 0; i < xData.length; i++) {
      _drawAxisText(canvas, xData[i],
          fontSize: fontSize,
          alignment: Alignment.center,
          offset: Offset(-xStep / 2, 14),
          showBackgroud: false);

      canvas.translate(xStep, 0);
    }
    canvas.restore();
  }

  ///绘制y轴文字
  void drawYText(Canvas canvas, Size size) {
    canvas.save();
    double numStep = maxData / 2 / 2;
    for (int i = 0; i <= 4; i++) {
      // if (i == 0) {
      //   // _drawAxisText(canvas, '0', offset: Offset(-5, 2));
      //   canvas.translate(0, -yStep);
      //   continue;
      // }

      canvas.drawLine(
          Offset(0, 0), Offset(size.width - _kScaleHeight, 0), gridPaint);
      // canvas.drawLine(Offset(0, 0), Offset(0, 0), gridPaint);

      String str = '${(numStep * i).toStringAsFixed(0)}';
      _drawAxisText(canvas, str, offset: Offset(-5, 2));
      // _drawAxisText(canvas, "45", offset: Offset(-5, 2));

      canvas.translate(0, -yStep);
    }
    canvas.restore();
  }

  ///绘制柱状图
  void drawBarChart(Canvas canvas, Size size) {
    double barWidth = 34;
    canvas.save();

    ///向右移动一个x间隔距离，准备绘制
    canvas.translate(xStep, 0);
    canvas.translate(xStep / 2 - barWidth / 2, 0);
    for (int i = 0; i < peopleData.length; i++) {
      double y = -(peopleData[i] / maxData * (size.height - _kScaleHeight));
      unknowPaint.color = colorData[i];
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, barWidth, y).translate(-xStep, 0),
            // topLeft: Radius.circular(6),
            // topRight: Radius.circular(6),
            // bottomLeft: Radius.circular(12),
            // bottomRight: Radius.circular(12)
          ),
          unknowPaint);
      String str = (peopleData[i]).toStringAsFixed(0);
      _drawAxisText(canvas, str,
          offset: Offset(-xStep + barWidth - 10, y - 15),
          color: Color(0xFF656A72));

      canvas.translate(xStep, 0);
    }
    canvas.restore();
  }

  ///绘制坐标轴的文字
  void _drawAxisText(Canvas canvas, String? str,
      {Color color = const Color(0xFF90949D),
      double fontSize = 12,
      bool x = false,
      Alignment alignment = Alignment.centerRight,
      Offset offset = Offset.zero,
      bool showBackgroud = false}) {
    TextSpan text = TextSpan(
        text: str,
        style: TextStyle(
          fontSize: fontSize, //isX ? str.length > 10 ? 11 : 12 :12,
          color: showBackgroud ? Color(0xFF3D7BFF) : color,
        ));

    _textPainter.text = text;
    _textPainter.layout(); // 进行布局

    Size size = _textPainter.size;

    print(size);

    Offset offsetPos = Offset(-size.width / 2, -size.height / 2)
        .translate(-size.width / 2 * alignment.x + offset.dx, 0.0 + offset.dy);
    print(offsetPos);

    _textPainter.paint(canvas, offsetPos);
  }

  @override
  bool shouldRepaint(covariant BarPainter oldDelegate) =>
      oldDelegate.peopleData != peopleData;
}
