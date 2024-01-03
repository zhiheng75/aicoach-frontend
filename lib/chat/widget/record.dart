import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Record extends StatefulWidget {
  const Record({
    Key? key,
    required this.show,
    required this.offset,
  }) : super(key: key);

  final bool show;
  final ValueNotifier<Offset> offset;

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {

  final ScreenUtil _screenUtil = ScreenUtil();
  final GlobalKey _cancelButtonGlobalKey = GlobalKey();
  final GlobalKey _sendButtonGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return const SizedBox();
    }
    return Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 56.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/shengbo_green.png',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          const SizedBox(
            height: 80.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                key: _cancelButtonGlobalKey,
                width: 64.0,
                height: 64.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/quxiaofasong.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 151.0,
              ),
              Container(
                key: _sendButtonGlobalKey,
                width: 64.0,
                height: 64.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/fasong.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: _screenUtil.bottomBarHeight + 88.0,
          ),
        ],
      ),
    );
  }
}