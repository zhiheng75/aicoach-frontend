import 'dart:async';

import 'package:Bubble/conversation/provider/conversation_provider.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cutdown extends StatefulWidget {
  const Cutdown({Key? key}) : super(key: key);

  @override
  State<Cutdown> createState() => _CutdownState();
}

class _CutdownState extends State<Cutdown> {
  int state = -1;
  Timer? timer;

  String formatTime(int availableTime) {
    int minute = (availableTime / 60).floor();
    int second = availableTime % 60;
    return '${minute > 9 ? minute : '0$minute'}:${second > 9 ? second : '0$second'}';
  }

  void startCutdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ConversationProvider provider = Provider.of<ConversationProvider>(context, listen: false);
      if (provider.availableTime == 0) {
        provider.setCutdownState(0);
        return;
      }
      provider.decreaseTime();
    });
  }

  void stopCutdown() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    stopCutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationProvider>(
      builder: (_, provider, __) {
        if (state == -1 && provider.cutdownState == 1) {
          startCutdown();
        }
        if (state == 1 && provider.cutdownState == 0) {
          stopCutdown();
        }
        state = provider.cutdownState;

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            right: 17.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const LoadAssetImage(
                'timer_img',
                width: 16.0,
                height: 16.0,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                formatTime(provider.availableTime),
                style: const TextStyle(
                  fontSize: 16.0,
                  // color: Colors.white,
                  height: 19.0 / 16.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
