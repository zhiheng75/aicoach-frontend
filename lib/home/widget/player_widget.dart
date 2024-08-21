import 'dart:async';

import 'package:Bubble/widgets/load_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// This code is also used in the example.md. Please keep it up to date.
class PlayerWidget extends StatefulWidget {
  final String playerUrl;

  const PlayerWidget({
    required this.playerUrl,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer player = AudioPlayer();

  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  // String get _durationText => _duration?.toString().split('.').first ?? '';

  // String get _positionText => _position?.toString().split('.').first ?? '';

  // AudioPlayer get player => widget.player;

  String _durationText = "00:00";
  String _positionText = "00:00";
  String playerUrlStr = "";

  String nameText = "";
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSourceUrl(widget.playerUrl);
      // await player.setSourceUrl(
      //     'https://statics.shenmo-ai.com/audio/20240304-131948-bf9c44b4.mp3');
      // await player.setSourceUrl(
      //     'https://statics.shenmo-ai.com/audio/1718930601400_4267a3802f6711ef95418f696044b8e0.wav');
      //
      // await player.resume();
      // await player.play(UrlSource('https://example.com/my-audio.wav'));
      // await player.play(UrlSource(
      //     'https://statics.shenmo-ai.com/audio/20240304-131948-bf9c44b4.mp3'));
    });

    playerUrlStr = widget.playerUrl;
    List<String> fruits = playerUrlStr.split('/'); // 使用逗号作为分隔符
    nameText = fruits.last;
    nameText = nameText.substring(0, nameText.indexOf('.'));
    nameText = Uri.decodeComponent(nameText);

    // imgUrl = playerUrlStr.substring(0, playerUrlStr.indexOf('.'));
    imgUrl = playerUrlStr.substring(0, playerUrlStr.length - 4);
    imgUrl = "$imgUrl.jpg";
    setState(() {});

    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
            //   int milliseconds = _duration!.inSeconds;
            //  countTimeStr(milliseconds);
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
            // int milliseconds = _position!.inSeconds;
            //  countTimeStr(milliseconds);
          }),
        );
    _initStreams();
  }

  String countTimeStr(int timeNum) {
    String countdownStr;
    if (timeNum > 60) {
      int minute = timeNum ~/ 60; //取整除法
      int second = timeNum % 60; //取余
      if (minute < 10) {
        if (second < 10) {
          countdownStr = '0$minute:0$second';
        } else {
          countdownStr = '0$minute:$second';
        }
      } else {
        if (second < 10) {
          countdownStr = '$minute:0$second';
        } else {
          countdownStr = '$minute:$second';
        }
      }
    } else {
      if (timeNum < 10) {
        countdownStr = '00:0$timeNum';
      } else {
        countdownStr = '00:$timeNum';
      }
    }
    return countdownStr;
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      // width: 290,
      // height: 190,
      // color: Colors.amber,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isPlaying ? _pause : _play,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: LoadImage(
                imgUrl,
                fit: BoxFit.fitWidth,
                // width: 290,
                // height: 190,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(
                  right: 10.w, left: 10.w, bottom: 15.w, top: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      !_isPlaying
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _isPlaying ? null : _play,
                              child: LoadAssetImage(
                                "audio_play",
                                width: 24.0.w,
                                height: 24.0.w,
                              ),
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _isPlaying ? _pause : null,
                              child: LoadAssetImage(
                                "audio_paused",
                                width: 24.0.w,
                                height: 24.0.w,
                              ),
                            ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white54,
                          thumbColor: Colors.white,
                          onChanged: (value) {
                            final duration = _duration;
                            if (duration == null) {
                              return;
                            }
                            final position = value * duration.inMilliseconds;
                            player
                                .seek(Duration(milliseconds: position.round()));
                          },
                          value: (_position != null &&
                                  _duration != null &&
                                  _position!.inMilliseconds > 0 &&
                                  _position!.inMilliseconds <
                                      _duration!.inMilliseconds)
                              ? _position!.inMilliseconds /
                                  _duration!.inMilliseconds
                              : 0.0,
                        ),
                      ),
                      Text(
                        _position != null
                            ? _positionText
                            : _duration != null
                                ? _durationText
                                : '0',
                        // _position != null
                        //     ? '$_positionText/$_durationText'
                        //     : _duration != null
                        //         ? _durationText
                        //         : '',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        nameText,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
        int milliseconds = _duration!.inSeconds;
        _durationText = countTimeStr(milliseconds);
      });
      // setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
        int milliseconds = _position!.inSeconds;
        _positionText = countTimeStr(milliseconds);
      });
      // setState(() => _duration = duration);
    });

    // _positionSubscription = player.onPositionChanged.listen(
    //   (p) => setState(() => _position = p),
    // );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
