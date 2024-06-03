import 'package:Bubble/res/gaps.dart';
import 'package:flutter/material.dart';

class HomeMapItem extends StatefulWidget {
  const HomeMapItem({super.key});

  @override
  State<HomeMapItem> createState() => _HomeMapItemState();
}

class _HomeMapItemState extends State<HomeMapItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 5),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/home_book_img.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          Gaps.hGap10,
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("聊聊兴趣爱好"),
                Text("分享一本你最爱的书"),
              ],
            ),
          ),
          Container(
            width: 70,
          ),
        ],
      ),
    );
  }
}
