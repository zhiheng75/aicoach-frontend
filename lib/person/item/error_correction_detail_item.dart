import 'package:Bubble/course/entity/lesson_report_detail_bean.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/person/entity/mistake_details_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCorrectionDetailItem extends StatefulWidget {
  final Datum data;
  const ErrorCorrectionDetailItem({super.key, required this.data});

  @override
  State<ErrorCorrectionDetailItem> createState() =>
      _ErrorCorrectionDetailItemState();
}

class _ErrorCorrectionDetailItemState extends State<ErrorCorrectionDetailItem> {
  late String headimgurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> user = LoginManager.getUserInfo();
    String headImg = '';
    if (validateInput(user['headimgurl'])) {
      headImg = user['headimgurl'];
    }
    headimgurl = headImg;
    setState(() {});
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28.0),
                child: headimgurl != ''
                    ? LoadImage(
                        headimgurl,
                        width: 25.0,
                        height: 25.0,
                      )
                    : const LoadAssetImage(
                        'head_icon',
                        width: 25.0,
                        height: 25.0,
                      ),
              ),
              Gaps.hGap6,
              SizedBox(
                width: 70,
                height: 25,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 3,
                      child: Container(
                        width: 60,
                        height: 15,
                        color: Colours.color_FFE99C,
                      ),
                    ),
                    const Text(
                      "我的回答",
                      style: TextStyle(
                        // backgroundColor: Colors.yellow,
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // const Text(
              //   "我的回答",
              //   style: TextStyle(
              //     backgroundColor: Colors.yellow,
              //     fontSize: 17.0,
              //     color: Colors.black,
              //   ),
              // ),
              // Gaps.hGap10,
              Text(
                widget.data.userScore.toString(),
                style: const TextStyle(
                  // backgroundColor: Colors.yellow,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,

                  color: Colours.color_E00094,
                ),
              ),
              Gaps.hGap2,
              const Text(
                "分",
                style: TextStyle(
                  // backgroundColor: Colors.yellow,
                  fontSize: 12.0,
                  color: Colours.color_666666,
                  height: 2,
                ),
              ),
            ],
          ),
          Gaps.vGap8,
          Container(
            margin: const EdgeInsets.only(right: 16),
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.data.userSentence,
                    style: const TextStyle(
                        fontSize: 14.0, color: Colors.black, height: 1.5),
                  ),
                ),
                Gaps.hGap16,
                GestureDetector(
                  onTap: () {
                    MediaUtils().play(
                      url: widget.data.userAudio,
                      useAvatar: true,
                      whenFinished: () {},
                    );
                  },
                  child: const LoadAssetImage(
                    'jiucuo_laba_icon',
                    width: 24,
                    height: 24,
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

class ErrorCorrectionOneDetailItem extends StatefulWidget {
  final Datum data;

  const ErrorCorrectionOneDetailItem({super.key, required this.data});

  @override
  State<ErrorCorrectionOneDetailItem> createState() =>
      _ErrorCorrectionOneDetailItemState();
}

class _ErrorCorrectionOneDetailItemState
    extends State<ErrorCorrectionOneDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 25,
            // color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 3,
                  child: Container(
                    width: 78,
                    height: 15,
                    color: Colours.color_FFE99C,
                  ),
                ),
                const Text(
                  "试试这么说",
                  style: TextStyle(
                    // backgroundColor: Colors.yellow,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,

                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // const Text(
          //   "试试这么说",
          //   style: TextStyle(
          //     backgroundColor: Colors.yellow,
          //     fontSize: 17.0,
          //     color: Colors.black,
          //   ),
          // ),
          Gaps.vGap8,
          Container(
            // margin: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 16),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.data.suggestionSentence ?? "",
                    style: const TextStyle(
                        fontSize: 14.0, color: Colors.black, height: 1.5),
                  ),
                ),
                Gaps.hGap16,
                GestureDetector(
                  onTap: () {
                    MediaUtils().play(
                      url: widget.data.suggestionAudio,
                      useAvatar: true,
                      whenFinished: () {},
                    );
                  },
                  child: const LoadAssetImage(
                    'jiucuo_laba_icon',
                    width: 24,
                    height: 24,
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

class ErrorCorrectionDetailTwoItem extends StatefulWidget {
  final ExcellentExpression excellentExpression;
  const ErrorCorrectionDetailTwoItem({
    super.key,
    required this.excellentExpression,
  });

  @override
  State<ErrorCorrectionDetailTwoItem> createState() =>
      _ErrorCorrectionDetailTwoItemState();
}

class _ErrorCorrectionDetailTwoItemState
    extends State<ErrorCorrectionDetailTwoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.only(top: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colours.color_F9F8FF,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 10.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.excellentExpression.sentence,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            Gaps.hGap16,
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.excellentExpression.score.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "分",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Gaps.vGap8,
                GestureDetector(
                  onTap: () {
                    MediaUtils().stopPlay();
                    MediaUtils().play(
                      url: widget.excellentExpression.audio,
                      useAvatar: true,
                      whenFinished: () {},
                    );
                  },
                  child: const LoadAssetImage(
                    'jiucuo_laba_icon',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorCorrectionThreeDetailItem extends StatefulWidget {
  final Datum data;

  const ErrorCorrectionThreeDetailItem({super.key, required this.data});

  @override
  State<ErrorCorrectionThreeDetailItem> createState() =>
      _ErrorCorrectionThreeDetailItemState();
}

class _ErrorCorrectionThreeDetailItemState
    extends State<ErrorCorrectionThreeDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 55,
                height: 25,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 3,
                      child: Container(
                        width: 42,
                        height: 15,
                        color: Colours.color_FFE99C,
                      ),
                    ),
                    const Text(
                      "已更正",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const LoadAssetImage(
                'correct_icon',
                width: 14.0,
                height: 14.0,
              ),
              Gaps.hGap8,
              Text(
                widget.data.userPracticeScore.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colours.color_00B53D,
                ),
              ),
              Gaps.hGap2,
              const Text(
                "分",
                style: TextStyle(
                  // backgroundColor: Colors.yellow,
                  fontSize: 12.0,
                  color: Colors.black,
                  height: 2,
                ),
              ),
            ],
          ),
          Gaps.vGap8,
          Container(
            margin: const EdgeInsets.only(right: 16),

            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.data.userPracticeSentence ?? "",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Gaps.hGap16,
                GestureDetector(
                  onTap: () {
                    MediaUtils().play(
                      url: widget.data.userPracticeAudio,
                      useAvatar: true,
                      whenFinished: () {},
                    );
                  },
                  child: const LoadAssetImage(
                    'jiucuo_laba_icon',
                    width: 24,
                    height: 24,
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

class ErrorCorrectionNotDetailItem extends StatefulWidget {
  const ErrorCorrectionNotDetailItem({super.key});

  @override
  State<ErrorCorrectionNotDetailItem> createState() =>
      _ErrorCorrectionNotDetailItemState();
}

class _ErrorCorrectionNotDetailItemState
    extends State<ErrorCorrectionNotDetailItem> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            height: 25,
            // color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 3,
                  child: Container(
                    width: 45,
                    height: 15,
                    color: Colours.color_FFE99C,
                  ),
                ),
                const Text(
                  "未更正",
                  style: TextStyle(
                    // backgroundColor: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          Container(
            width: _screenUtil.screenWidth - 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: const Text(
              "你还未更正读音喔~",
              style: TextStyle(
                fontSize: 14.0,
                color: Colours.color_999999,
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
