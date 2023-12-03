import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../res/colors.dart';
import 'dart:ui' as ui;

///五维雷达图
/// 设置雷达图的半径，根据分5等分来计算
/// 绘制一个正五边形，一个顶点在y轴上，半径为r，顺势正依次是（0，r）（r*c18，r*s18）
/// （r*c54，-r*s54）（-r*c54，-r*s54）(-r*c18,r*s18)
///
class RadarBean {
  double score;
  String name;

  RadarBean(this.score, this.name);
}

/// 右边的文字不需要移动   有的文字要移动一半居中  左边的文字需要左移动整个距离
///type 0 1 2
///
enum MoveType { noMove, halfMove, allMove }
enum MoveType2 { oneMove, twoMove, threeMove,fourMove,fiveMove }

class RadarMap extends StatefulWidget {
  ///半径
  double r;

  // static final double defaultR = setWidth(80.0);

  ///正五边形个数 目前只支持五边形
  int n = 5;

  ///文字和图像的间距
  double padding;

  static const double defaultPadding = 20;

  ///最下面两个的间距
  double bottomPadding = 20;
  static const double defaultBottomPadding = 20;
  static const double strokeWidth_0_5 = 0.5;
  static const double strokeWidth_1 = 1;
  static const double strokeWidth_2 = 2;

  Paint zeroToPointPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colours.color_546092
    ..strokeWidth = strokeWidth_0_5;

  Paint pentagonPaint  = Paint()
  ..color = Colours.color_546092
  ..strokeWidth = strokeWidth_1
  ..style = PaintingStyle.stroke;


    // ..color = Colors.lightBlue[300]!.withAlpha(100)
    // ..shader = ui.Gradient.linear(
    //   Alignment.topCenter,
    //   endOffset,
    //   [
    //     Colours.color_00FFB4,
    //     Colours.color_0E90FF,
    //     Colours.color_DA2FFF,
    //   ],
    // )
    // ..strokeWidth = strokeWidth_2
    // ..style = PaintingStyle.fill;

  ///当前的分数 ///对应的文案
  List<RadarBean> scoreList;
  List<Offset> points =[];

  RadarMap(this.scoreList,
      {this.r = 100.0,
        this.padding = defaultPadding,
        this.bottomPadding = defaultBottomPadding,
        /*this.zeroToPointPaint,
        this.pentagonPaint,
        this.contentPaint*/}) {
    // assert(scoreList.length == 5);
    assert(scoreList.length == 4);

    ///原点到5个定点的连线
    // zeroToPointPaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..color = Colors.black12
    //   ..strokeWidth = strokeWidth_0_5;

    ///5层五边形画笔
    // pentagonPaint = Paint()
    //   ..color = Colors.black12
    //   ..strokeWidth = strokeWidth_1
    //   ..style = PaintingStyle.fill;

    // ///覆盖内容颜色
    // contentPaint = Paint()
    //   ..color = Colors.lightBlue[300]!.withAlpha(100)
    //   ..strokeWidth = strokeWidth_2
    //   ..style = PaintingStyle.fill;


    points = [
      Offset(0, -r),
      Offset(r , 0),
      Offset(0, r ),
      Offset(-r , 0),
      // Offset(-r * cos(angleToRadian(18)), r * -sin(angleToRadian(18))),
    ];
  }

  @override
  State<StatefulWidget> createState() {
    return RadarMapState();
  }
}

class RadarMapState extends State<RadarMap>
    with SingleTickerProviderStateMixin {
  ValueNotifier<List<Offset>> values = ValueNotifier([]);
  late AnimationController ctrl;
  late Animation animation;
  Paint contentPaint = Paint();

  @override
  void initState() {

    super.initState();

    // Size size = MediaQuery.of(context).size;
    Gradient gradient = const LinearGradient(
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        colors: [
          Colours.color_00FFB4,
          Colours.color_0E90FF,
          Colours.color_DA2FFF,
        ],
    );


    Shader shader = gradient.createShader(Rect.fromCircle(center:const Offset(0,0), radius: 90));

    contentPaint.style = PaintingStyle.fill;
    contentPaint.shader = shader;


    ctrl = AnimationController(vsync: this, duration:const Duration(seconds: 1))
      ..addListener(() {
        values.value = converPoint(widget.points, widget.scoreList, animation.value);
      });
    animation = CurvedAnimation(parent: ctrl,curve: Curves.bounceOut);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      ctrl.forward(from: 0);
    });
  }

  List<Offset> converPoint(
      List<Offset> points, List<RadarBean> score, double scale) {
    List<Offset> list = [];
    for (int i = 0; i < points.length; i++) {
      list.add(points[i]
          .scale(score[i].score * scale / 100, score[i].score * scale / 100));
    }
    return list;
  }



  @override
  Widget build(BuildContext context) {


    return Container(
      child: CustomPaint(
        size:const Size.fromRadius(200),
        painter: RadarmapPainter(widget.scoreList, ctrl, values,
            r: widget.r,
            n: widget.n,
            padding: widget.padding,
            bottomPadding: widget.bottomPadding,
            zeroToPointPaint: widget.zeroToPointPaint,
            pentagonPaint: widget.pentagonPaint,
            contentPaint: contentPaint),
      ),
    );
  }
}

class RadarmapPainter extends CustomPainter {
  double r;
  int n;
  double padding;
  double bottomPadding;
  Paint zeroToPointPaint;
  Paint pentagonPaint;
  Paint contentPaint;
  List<RadarBean> score;
  AnimationController ctrl;
  ValueNotifier<List<Offset>> values;

  RadarmapPainter(this.score, this.ctrl, this.values,
      {required this.r,
        required this.n,
        required this.padding,
        required this.bottomPadding,
        required this.zeroToPointPaint,
        required this.pentagonPaint,
        required this.contentPaint})
      : super(repaint: values);

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> points = [
      // Offset(0, -r),
      // Offset(r * cos(angleToRadian(18)), -r * sin(angleToRadian(18))),
      // Offset(r * cos(angleToRadian(54)), r * sin(angleToRadian(54))),
      // Offset(-r * cos(angleToRadian(54)), r * sin(angleToRadian(54))),
      // Offset(-r * cos(angleToRadian(18)), r * -sin(angleToRadian(18))),
      Offset(0, -r),
      Offset(r , 0),
      Offset(0, r ),
      Offset(-r , 0),
    ];

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawPoints(
        PointMode.points,
        [Offset(0, 0)],
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2);

    ///画n个五边形
    for (int i = 0; i < n; i++) {
      List<Offset> points = [
        // Offset(0, -r * (i + 1) / n),
        // Offset(r * (i + 1) / n * cos(angleToRadian(18)),
        //     -r * (i + 1) / n * sin(angleToRadian(18))),
        // Offset(r * (i + 1) / n * cos(angleToRadian(54)),
        //     r * (i + 1) / n * sin(angleToRadian(54))),
        // Offset(-r * (i + 1) / n * cos(angleToRadian(54)),
        //     r * (i + 1) / n * sin(angleToRadian(54))),
        // Offset(-r * (i + 1) / n * cos(angleToRadian(18)),
        //     r * (i + 1) / n * -sin(angleToRadian(18))),
        Offset(0, -r* (i + 1) / n),
        Offset(r* (i + 1) / n , 0),
        Offset(0, r* (i + 1) / n ),
        Offset(-r* (i + 1) / n , 0),
      ];
      drawPentagon(points, canvas, pentagonPaint);
    }

    ///连接最外层的五个定点
    drawZeroToPoint(points, canvas);

    ///修改成对应的分数，绘制覆盖内容
    drawPentagon(values.value, canvas, contentPaint);

    ///根据位置绘制文字
    // drawTextByPosition(points, canvas);
    drawTextByPosition2(points, canvas);
    canvas.restore();
  }



  ///根据位置来绘制文字
  void drawTextByPosition(List<Offset> points, Canvas canvas) {


    for (int i = 0; i < points.length; i++) {
      MoveType type = MoveType.noMove;
      switch (i) {
        case 0:
          type = MoveType.halfMove;
          points[i] -= Offset(0, padding * 2);
          break;
        case 1:
          type = MoveType.noMove;
          points[i] += Offset(padding, -padding);
          break;
        case 2:
          type = MoveType.halfMove;
          points[i] += Offset(bottomPadding, padding);
          break;
        case 3:
          type = MoveType.halfMove;
          points[i] += Offset(-bottomPadding, padding);
          break;
        case 4:
          type = MoveType.allMove;
          points[i] -= Offset(padding, padding);
          break;
        default:
      }


      drawText(canvas, points[i], score[i].name,
          TextStyle(fontSize: 10, color: Colors.black54,background: Paint()..color=Colors.brown), type);
    }
  }

  void drawTextByPosition2(List<Offset> points, Canvas canvas) {


    for (int i = 0; i < points.length; i++) {
      MoveType2 type = MoveType2.oneMove;
      switch (i) {
        case 0:
          type = MoveType2.oneMove;
          points[i] -= Offset(0, padding * 2);
          break;
        case 1:
          type = MoveType2.twoMove;
          points[i] += Offset(padding, -padding);
          break;
        case 2:
          type = MoveType2.threeMove;
          points[i] += Offset(bottomPadding, padding);
          break;
        case 3:
          type = MoveType2.fourMove;
          points[i] += Offset(-bottomPadding, padding);
          break;
        case 4:
          type = MoveType2.fiveMove;
          points[i] -= Offset(padding, padding);
          break;
        default:
      }


      drawText2(canvas, points[i], score[i].name,
         const TextStyle(fontSize: 8, color: Colors.white), type);
    }
  }


  final Paint _paintCircle = Paint()
    ..color = Colours.color_925DFF
    ..style= PaintingStyle.fill;

  /// 右边的文字不需要移动   有的文字要移动一半居中  左边的文字需要左移动整个距离
  void drawText(Canvas canvas, Offset offset, String text, TextStyle style,
      MoveType type) {
    var textPainter = TextPainter(
        text: TextSpan(text: text, style: style,),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);
    textPainter.layout();
    Size size = textPainter.size;
    Offset offsetResult;
    switch (type) {
      case MoveType.halfMove:
        offsetResult = Offset(offset.dx - size.width / 2, offset.dy);
        break;
      case MoveType.allMove:
        offsetResult = Offset(offset.dx - size.width, offset.dy);
        break;
      default:
        offsetResult = offset;
    }

    canvas.drawCircle(Offset(offset.dx,offset.dy), 25, _paintCircle);

    textPainter.paint(canvas, offsetResult);
  }


  void drawText2(Canvas canvas, Offset offset, String text, TextStyle style,
      MoveType2 type) {
    var textPainter = TextPainter(
        text: TextSpan(text: text, style: style,),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);
    textPainter.layout();
    Size size = textPainter.size;
    Offset offsetResult;
    Offset offsetResultCircle;
    switch (type) {
      case MoveType2.oneMove:
        // offsetResult = Offset(offset.dx - size.width / 2, offset.dy);
        offsetResult = Offset(offset.dx - size.width / 2, offset.dy+2);
        break;
      case MoveType2.twoMove:
        // offsetResult = Offset(offset.dx - size.width/2+5, offset.dy+5);
        offsetResult = Offset(offset.dx - size.width/2+5, offset.dy+12);

        break;
      case MoveType2.threeMove:
        // offsetResult = Offset(offset.dx - size.width / 2-5, offset.dy-10);
        offsetResult = Offset(offset.dx - size.width / 2-20, offset.dy-8);
        break;
      case MoveType2.fourMove:
        // offsetResult = Offset(offset.dx - size.width+15, offset.dy-5);
        offsetResult = Offset(offset.dx - size.width+6, offset.dy-26);
        break;
      case MoveType2.fiveMove:
        offsetResult = Offset(offset.dx - size.width / 2-5, offset.dy+5);
        break;
      default:
        offsetResult = offset;
    }

    switch (type) {
      case MoveType2.oneMove:
        offsetResultCircle = Offset(offset.dx , offset.dy+15);
        break;
      case MoveType2.twoMove:
        // offsetResultCircle = Offset(offset.dx+5, offset.dy+10);
        offsetResultCircle = Offset(offset.dx+5, offset.dy+18);
        break;
      case MoveType2.threeMove:
        // offsetResultCircle = Offset(offset.dx-5 , offset.dy);
        offsetResultCircle = Offset(offset.dx-20 , offset.dy+5);
        break;
      case MoveType2.fourMove:
        // offsetResultCircle = Offset(offset.dx+5, offset.dy);
        offsetResultCircle = Offset(offset.dx-5, offset.dy-20);
        break;
      case MoveType2.fiveMove:
        offsetResultCircle = Offset(offset.dx-5, offset.dy+10);
        break;
      default:
        offsetResultCircle = offset;
    }


    canvas.drawCircle(offsetResultCircle, 18, _paintCircle);

    textPainter.paint(canvas, offsetResult);
  }


  void drawZeroToPoint(List<Offset> points, Canvas canvas) {
    points.forEach((element) {
      canvas.drawLine(
        Offset.zero,
        element,
        zeroToPointPaint,
      );
    });
  }

  ///画五边形
  void drawPentagon(List<Offset> points, Canvas canvas, Paint paint) {
    if(points.length == 0){
      return;
    }
    Path path = Path();

    path.moveTo(0, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

///转换角度  18/180.0 *pi

}

double angleToRadian(double angle) {
  return angle / 180.0 * pi;
}