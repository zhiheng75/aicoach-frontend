import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Illustration extends StatelessWidget {
  const Illustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    Widget session(String content, {Widget? child}) {
      Color color = const Color(0xFF3C4074);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            margin: const EdgeInsets.only(
              top: 7.0,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                content,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: color,
                  height: 18.0 / 14.0,
                  letterSpacing: 0.05,
                ),
              ),
              if (child != null) child,
            ],
          )),
        ],
      );
    }

    Widget sessionChild(String content) {
      return Container(
        margin: const EdgeInsets.only(
          top: 16.0,
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF333333),
            height: 18.0 / 13.0,
            letterSpacing: 0.05,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: screenUtil.screenWidth,
            height: screenUtil.screenHeight,
            color: Colors.black.withOpacity(0.6),
          ),
          Positioned(
              bottom: screenUtil.bottomBarHeight + 16.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        right: 16.0,
                      ),
                      child: LoadAssetImage(
                        'exam_purchase_close',
                        width: 32.0,
                        height: 32.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    width: screenUtil.screenWidth - 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white.withOpacity(0.92),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 32.0,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        const LoadAssetImage(
                          'dunpai',
                          width: 56.0,
                          height: 56.0,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        const Text(
                          '权益说明',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                            height: 14.0 / 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        session('会员权益包有2个计算维度，分别是时效和学习时长。'),
                        const SizedBox(
                          height: 16.0,
                        ),
                        session(
                            '权益包内的学习时长月包，每个月畅学900分钟；年包可在一年内畅学10800分钟，不进行月度管控。'),
                        const SizedBox(
                          height: 16.0,
                        ),
                        session(
                          '累加购买的权益说明',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              sessionChild(
                                  '（1）每次购买的会员权益包单独计时效和学习时长，个人中心显示剩余学习时长及有效包的截止时间。'),
                              sessionChild(
                                  '举例说明，年包在购买后1个月内使用完了学习时长，这时年包权益已兑现，年包权益清零。此时购买1个月包，则月包自购买日开始计时，1个月后到期，1个月内享有15小时学习权益。个人中心显示剩余学习时长为月包的剩余学习时长，有效时长为月包的截止时间。'),
                              sessionChild(
                                  '（2）年包在没用完学习时长的情况下，购买了月包，则两个包的学习时长同时有效，优先使用先到期的学习时长。'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class IPhoneIllustration extends StatelessWidget {
  const IPhoneIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    Widget session(String content, {Widget? child}) {
      Color color = const Color(0xFF3C4074);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            margin: const EdgeInsets.only(
              top: 7.0,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                content,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: color,
                  height: 18.0 / 14.0,
                  letterSpacing: 0.05,
                ),
              ),
              if (child != null) child,
            ],
          )),
        ],
      );
    }

    Widget sessionChild(String content) {
      return Container(
        margin: const EdgeInsets.only(
          top: 16.0,
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF333333),
            height: 18.0 / 13.0,
            letterSpacing: 0.05,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: screenUtil.screenWidth,
            height: screenUtil.screenHeight,
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: LoadAssetImage(
                      'exam_purchase_close',
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: screenUtil.screenWidth - 32.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.92),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 32.0,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      const LoadAssetImage(
                        'dunpai',
                        width: 56.0,
                        height: 56.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        '购买奖牌说明',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                          height: 14.0 / 20.0,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 16.0,
                      // ),
                      // session('会员权益包有2个计算维度，分别是时效和学习时长。'),
                      // const SizedBox(
                      //   height: 16.0,
                      // ),
                      // session('权益包内的学习时长月包，每个月畅学900分钟；年包可在一年内畅学10800分钟，不进行月度管控。'),
                      const SizedBox(
                        height: 16.0,
                      ),
                      session(
                        '年度奖牌',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            sessionChild('「展示年度奖牌图片」'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      session(
                        '年度奖牌权益：',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            sessionChild('1）全年畅学，多角色、多话题、多场景任意可选；'),
                            sessionChild('2）年度奖牌线下邮寄到家。'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      session(
                        '月度奖牌',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            sessionChild('「展示月度奖牌图片」'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      session(
                        '月度奖牌权益：',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            sessionChild('1）全月畅学，多角色、多话题、多场景任意可选；'),
                            sessionChild('2）月度奖牌线下邮寄到家。'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
