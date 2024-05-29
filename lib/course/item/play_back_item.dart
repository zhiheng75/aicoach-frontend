import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/util/media_utils.dart';
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
      margin: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          widget.isPaly
              ? GestureDetector(
                  onTap: () {
                    DioUtils.instance.requestNetwork<ResultData>(
                        Method.post, HttpApi.generateAudio,
                        params: {
                          'text': widget.title,
                        }, onSuccess: (result) {
                      if (result?.code == 200) {
                        Map<String, dynamic> data =
                            result?.data as Map<String, dynamic>;
                        MediaUtils().stopPlay();
                        MediaUtils().play(
                          url: data['speech_url'],
                          useAvatar: true,
                          whenFinished: () {},
                        );
                      }
                    }, onError: (code, msg) {});
                  },
                  child: const LoadAssetImage(
                    "laba_lan",
                    width: 20.0,
                    height: 20.0,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
