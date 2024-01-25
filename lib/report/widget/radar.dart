// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';

class Radar extends StatefulWidget {
  Radar({
    Key? key,
    required this.r,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.scoreStyle,
    required this.labelStyle,
    this.source = 'report',
  }) : super(key: key);

  final double r;
  final RadarItem top;
  final RadarItem bottom;
  final RadarItem left;
  final RadarItem right;
  final TextStyle scoreStyle;
  final TextStyle labelStyle;
  String? source;

  @override
  State<Radar> createState() => _RadarState();
}

class _RadarState extends State<Radar> {

  double toDouble(num value) {
    if (value is double) {
      return value;
    }
    return double.parse(value.toString());
  }

  @override
  Widget build(BuildContext context) {

    Widget legend(RadarItem radarItem, {double? top, double? right, double? bottom, double? left}) {
      return Positioned(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              radarItem.score.toStringAsFixed(0),
              style: widget.scoreStyle,
            ),
            Text(
              radarItem.label,
              style: widget.labelStyle,
            ),
          ],
        ),
      );
    }

    // 实际值
    List<Offset> pointList = [];
    pointList.add(Offset(toDouble(0 - widget.left.score), 0));
    pointList.add(Offset(0, toDouble(widget.top.score)));
    pointList.add(Offset(toDouble(widget.right.score), 0));
    pointList.add(Offset(0, toDouble(0 - widget.bottom.score)));

    double legendHeight = 0;
    if (widget.scoreStyle.fontSize != null && widget.scoreStyle.height != null) {
      legendHeight += widget.scoreStyle.fontSize! * widget.scoreStyle.height!;
    }
    if (widget.labelStyle.fontSize != null && widget.labelStyle.height != null) {
      legendHeight += widget.labelStyle.fontSize! * widget.labelStyle.height!;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CustomPaint(
          painter: RadarWrap(widget.r, pointList, widget.source ?? 'report'),
        ),
        legend(
          widget.right,
          bottom: widget.source == 'report' ? 0 : 0,
          left: widget.r,
        ),
        legend(
          widget.top,
          top: widget.source == 'report' ? -widget.r - legendHeight : -widget.r - legendHeight * 0.5,
          left: widget.r * 0.25,
        ),
        legend(
          widget.left,
          bottom: 0,
          right: widget.source == 'report' ? widget.r * 1.25 : widget.r,
        ),
        legend(
          widget.bottom,
          top: widget.source == 'report' ? widget.r : widget.r - legendHeight * 0.5,
          left: widget.r * 0.25,
        ),
      ],
    );
  }
}

class RadarWrap extends CustomPainter {

  RadarWrap(this.radius, this.points, this.source);

  double radius;
  List<Offset> points;
  String source;

  void drawWrap(List<Offset> points, Canvas canvas) {
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1.0;
    paint.style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 3; i >= 0; i--) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void drawVertex(List<Offset> points, Canvas canvas) {
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    for (var point in points) {
      canvas.drawCircle(point, radius / 16, paint);
    }
  }

  void drawLine(List<Offset> points, Canvas canvas) {
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1.0;
    paint.style = PaintingStyle.stroke;
    for (var point in points) {
      canvas.drawLine(Offset.zero, point, paint);
    }
  }

  void drawContent(List<Offset> points, Canvas canvas) {
    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 1.0;

    double rate = radius / 100.0;

    Path path = Path();
    path.moveTo(points[0].dx * rate, points[0].dy * rate);
    for (int i = 3; i >= 0; i--) {
      path.lineTo(points[i].dx * rate, points[i].dy * rate);
    }
    path.close();

    paint.shader = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFFFF71CF),
        Color(0xFF9AC3FF),
      ],
      stops: [0, 0.75],
    ).createShader(path.getBounds());

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0.0, 0.0);

    drawContent(points, canvas);

    for (int i = 1; i <= 4; i++) {
      List<Offset> wrapPoints = [];
      double r = i * radius * 0.25;
      wrapPoints.add(Offset(r, 0));
      wrapPoints.add(Offset(0, r));
      wrapPoints.add(Offset(-r, 0));
      wrapPoints.add(Offset(0, -r));
      drawWrap(wrapPoints, canvas);
      if (i == 4) {
        drawLine(wrapPoints, canvas);
        if (source == 'report') {
          drawVertex(wrapPoints, canvas);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

class RadarItem {

  RadarItem(this.label, this.score, [Color? color]) {
    if (color != null) {
      this.color = color;
    }
  }

  late String label;
  late num score;
  Color color = Colors.black;

}
