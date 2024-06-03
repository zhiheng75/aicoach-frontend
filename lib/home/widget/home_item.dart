import 'package:Bubble/home/page/entity/banner_list_bean.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class HomeMapItem extends StatefulWidget {
  final SceneList data;
  const HomeMapItem({super.key, required this.data});

  @override
  State<HomeMapItem> createState() => _HomeMapItemState();
}

class _HomeMapItemState extends State<HomeMapItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: LoadImage(
            widget.data.imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: [
            Gaps.vGap10,
            Row(
              children: [
                Gaps.hGap10,
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "聊聊兴趣爱好",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "分享一本你最爱的书",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70,
                ),
              ],
            ),
          ],
        ),
      ],
    );

    //  Container(
    //   padding: const EdgeInsets.only(top: 10, left: 5),
    //   decoration: const BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage(
    //         'assets/images/home_book_img.png',
    //       ),
    //       fit: BoxFit.fill,
    //     ),
    //   ),
    // child: Row(
    //   children: [
    //     Gaps.hGap10,
    //     const Expanded(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text("聊聊兴趣爱好"),
    //           Text("分享一本你最爱的书"),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       width: 70,
    //     ),
    //   ],
    // ),
    // );
  }
}
