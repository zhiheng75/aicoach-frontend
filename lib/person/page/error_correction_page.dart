import 'package:Bubble/person/item/error_correction_item.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorCorrectionPage extends StatefulWidget {
  const ErrorCorrectionPage({super.key});

  @override
  State<ErrorCorrectionPage> createState() => _ErrorCorrectionPageState();
}

class _ErrorCorrectionPageState extends State<ErrorCorrectionPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "纠错列表",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "lEVEL1",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_007Aff,
                    ),
                  ),
                  Text(
                    "lEVEL2",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "lEVEL3",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Unit2 朋友见面",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtils.push(
                        context,
                        PersonalRouter.errorCorrectionDetailPage,
                      );
                    },
                    child: const ErrorCorrectionItem(),
                  );
                },
                itemCount: 10,
              ),
            )
          ],
        ),
        //         CustomScrollView(
        //   slivers: [
        // SliverList.builder(
        //   itemBuilder: (ctx, index) {
        //     return GestureDetector(
        //       onTap: () {},
        //       child: const ErrorCorrectionItem(),
        //     );
        //   },
        //   itemCount: 10,
        // )
        //   ],
        // )
      )),
    );
  }
}
