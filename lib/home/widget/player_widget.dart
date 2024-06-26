import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// This code is also used in the example.md. Please keep it up to date.
class PlayerWidget extends StatefulWidget {
  // final AudioPlayer player;

  const PlayerWidget({
    // required this.player,
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
      await player.setSourceUrl(
          'https://statics.shenmo-ai.com/audio/20240304-131948-bf9c44b4.mp3');
      // await player.resume();
      // await player.play(UrlSource('https://example.com/my-audio.wav'));
      // await player.play(UrlSource(
      //     'https://statics.shenmo-ai.com/audio/20240304-131948-bf9c44b4.mp3'));
    });

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
    final color = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            !_isPlaying
                ? IconButton(
                    key: const Key('play_button'),
                    onPressed: _isPlaying ? null : _play,
                    iconSize: 48.0,
                    icon: const Icon(Icons.play_arrow),
                    color: color,
                  )
                : IconButton(
                    key: const Key('pause_button'),
                    onPressed: _isPlaying ? _pause : null,
                    iconSize: 48.0,
                    icon: const Icon(Icons.pause),
                    color: color,
                  ),
            Slider(
              onChanged: (value) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = value * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
            ),
            Text(
              _position != null
                  ? '$_positionText/$_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        Text("happy birds sing a song"),
      ],
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
