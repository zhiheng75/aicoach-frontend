// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/advise_entity.dart';

class Advise extends StatefulWidget {
  const Advise({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<Advise> createState() => _AdviseState();
}

class _AdviseState extends State<Advise> {

  // 状态 loading-加载中 fail-失败 success-成功
  final ScreenUtil _screenUtil = ScreenUtil();
  String _state = 'loading';
  List<AdviseEntity> _adviseList = [];

  void init() {
    _state = 'loading';
    setState(() {});
    getAdviseList();
  }

  void getAdviseList() {
    Future.delayed(const Duration(seconds: 1), () {
      AdviseEntity good = AdviseEntity();
      good.score = 90;
      good.aiText = 'Really? Awesome， Awesome，Behind me are the Alps，Now I\'m going skiing，shall we go？';
      good.userText = 'Really? Awesome， Awesome，Behind me are the Alps，Now I\'m going skiing，shall we go？';
      AdviseEntity bad = AdviseEntity();
      bad.score = 60;
      bad.aiText = 'Really? Awesome， Awesome，Behind me are the Alps，Now I\'m going skiing，shall we go？';
      bad.userText = 'Really? Awesome， Awesome，Behind me are the Alps，Now I\'m going skiing，shall we go？';
      _state = 'success';
      _adviseList.add(good);
      _adviseList.add(bad);
      setState(() {});
    });
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
          bottom: _screenUtil.bottomBarHeight,
        ),
        child: _state == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    }

    Widget adviseItem(AdviseEntity advise) {

      Widget content = Row(
        children: [
          Expanded(
            child: Text(
              advise.userText,
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
                      text: '${advise.score}',
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

      if (advise.score < 80) {
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

        content = Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    advise.aiText,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 16.0 / 14.0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11.0,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: const LoadAssetImage(
                    'laba_lan',
                    width: 17.6,
                    height: 16.0,
                  ),
                ),
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
                  onPress: () {},
                ),
                button(
                  '试一下这样说',
                  onPress: () {},
                )
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

    return Column(
      children: _adviseList.map((advise) => adviseItem(advise)).toList(),
    );
  }
}