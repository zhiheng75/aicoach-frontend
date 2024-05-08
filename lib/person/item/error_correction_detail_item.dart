import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorCorrectionDetailItem extends StatefulWidget {
  const ErrorCorrectionDetailItem({super.key});

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
      margin: const EdgeInsets.only(top: 10),
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
                        'default_head_img',
                        width: 25.0,
                        height: 25.0,
                      ),
              ),
              Gaps.hGap10,
              const Text(
                "我的回答",
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
              Gaps.hGap10,
              const Text(
                "14",
                style: TextStyle(
                  // backgroundColor: Colors.yellow,
                  fontSize: 15.0,
                  color: Colours.color_E00094,
                ),
              ),
              const Text(
                "分",
                style: TextStyle(
                  // backgroundColor: Colors.yellow,
                  fontSize: 13.0,
                  color: Colours.color_666666,
                ),
              ),
            ],
          ),
          Gaps.vGap8,
          Container(
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Gaps.hGap16,
                const LoadAssetImage(
                  'laba_lan',
                  width: 17.6,
                  height: 16.0,
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
  const ErrorCorrectionOneDetailItem({super.key});

  @override
  State<ErrorCorrectionOneDetailItem> createState() =>
      _ErrorCorrectionOneDetailItemState();
}

class _ErrorCorrectionOneDetailItemState
    extends State<ErrorCorrectionOneDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "试试这么说",
            style: TextStyle(
              backgroundColor: Colors.yellow,
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
          Gaps.vGap8,
          Container(
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Gaps.hGap16,
                const LoadAssetImage(
                  'laba_lan',
                  width: 17.6,
                  height: 16.0,
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
  const ErrorCorrectionDetailTwoItem({super.key});

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
            const Expanded(
              child: Text(
                "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            Gaps.hGap16,
            Column(
              children: [
                const Text(
                  "14+",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Gaps.vGap8,
                const LoadAssetImage(
                  'laba_lan',
                  width: 17.6,
                  height: 16.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
