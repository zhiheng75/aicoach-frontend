import 'package:Bubble/res/colors.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayBackItem extends StatefulWidget {
  final String title;
  final bool isPaly;
  const PlayBackItem({super.key, required this.title, required this.isPaly});

  @override
  State<PlayBackItem> createState() => _PlayBackItemState();
}

class _PlayBackItemState extends State<PlayBackItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "He's a nice cat.",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          widget.isPaly
              ? const LoadAssetImage(
                  "laba_lan",
                  width: 20.0,
                  height: 20.0,
                )
              : Container(),
        ],
      ),
    );
  }
}
