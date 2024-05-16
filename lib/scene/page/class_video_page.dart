import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
// import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:native_video_player/native_video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String introFileStr;
  final Function()? onScrollEnd;
  final bool isplay;

  const VideoPlayerView({
    Key? key,
    required this.introFileStr,
    required this.isplay,
    this.onScrollEnd,
  }) : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  NativeVideoPlayerController? _controller;

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.introFileStr != widget.introFileStr) {
      _loadVideoSource();
    }
    if (widget.isplay) {
      _controller?.play();
      _controller?.setVolume(1);
    }
  }

  Future<void> _initController(controller) async {
    _controller = controller;

    _controller?. //
        onPlaybackStatusChanged
        .addListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .addListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .addListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .addListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .addListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .addListener(_onPlaybackEnded);

    await _loadVideoSource();
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await _createVideoSource();
    await _controller?.loadVideoSource(videoSource);
  }

  Future<VideoSource> _createVideoSource() async {
    return await VideoSource.init(
      path: widget.introFileStr,
      type: VideoSourceType.network,
    );
  }

  @override
  void dispose() {
    _controller?. //
        onPlaybackStatusChanged
        .removeListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .removeListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .removeListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .removeListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .removeListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .removeListener(_onPlaybackEnded);
    _controller = null;
    super.dispose();
  }

  void _onPlaybackReady() {
    setState(() {});
    if (isAutoplayEnabled) {
      _controller?.play();
    }
  }

  void _onPlaybackStatusChanged() {
    setState(() {});
  }

  void _onPlaybackPositionChanged() {
    Log.e(_controller?.playbackInfo?.position.toString() ?? "0");
    Log.e(_controller?.videoInfo?.duration.toString() ?? "0");

    if (_controller?.playbackInfo?.position ==
        _controller?.videoInfo?.duration) {
      if (widget.onScrollEnd != null) {
        widget.onScrollEnd!();
      }
      //播放完成重置状态
    }

    setState(() {});
  }

  void _onPlaybackSpeedChanged() {
    setState(() {});
  }

  void _onPlaybackVolumeChanged() {
    setState(() {});
  }

  void _onPlaybackEnded() {
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NativeVideoPlayerView(
            onViewReady: _initController,
          ),
        ),
        // Slider(
        //   min: 0,
        //   max: (_controller?.videoInfo?.duration ?? 0).toDouble(),
        //   value: (_controller?.playbackInfo?.position ?? 0).toDouble(),
        //   onChanged: (value) => _controller?.seekTo(value.toInt()),
        // ),
        // const SizedBox(height: 4),
        // Row(
        //   children: [
        //     Text(
        //       formatDuration(
        //         Duration(seconds: _controller?.playbackInfo?.position ?? 0),
        //       ),
        //     ),
        //     const Spacer(),
        //     Text(
        //       formatDuration(
        //         Duration(seconds: _controller?.videoInfo?.duration ?? 0),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.play_arrow),
        //       onPressed: () {
        // _controller?.setVolume(1);
        // _controller?.play();
        //       },
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.pause),
        //       onPressed: () => _controller?.pause(),
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.stop),
        //       onPressed: () => _controller?.stop(),
        //     ),
        //     const SizedBox(width: 8),
        //     IconButton(
        //       icon: const Icon(Icons.fast_rewind),
        //       onPressed: () => _controller?.seekBackward(5),
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.fast_forward),
        //       onPressed: () => _controller?.seekForward(5),
        //     ),
        //     const Spacer(),
        //     _buildPlaybackStatusView(),
        //   ],
        // ),
        // Row(
        //   children: [
        //     Text(
        //         "Volume: ${_controller?.playbackInfo?.volume.toStringAsFixed(2)}"),
        //     Expanded(
        //       child: Slider(
        //         value: _controller?.playbackInfo?.volume ?? 0,
        //         onChanged: (value) => _controller?.setVolume(value),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   children: [
        //     Text(
        //         "Speed: ${_controller?.playbackInfo?.speed.toStringAsFixed(2)}"),
        //     Expanded(
        //       child: Slider(
        //         value: _controller?.playbackInfo?.speed ?? 1,
        //         onChanged: (value) => _controller?.setPlaybackSpeed(value),
        //         min: 0.25,
        //         max: 2,
        //         divisions: (2 - 0.25) ~/ 0.25,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildPlaybackStatusView() {
    const size = 16.0;
    final color = Colors.black.withOpacity(0.3);
    switch (_controller?.playbackInfo?.status) {
      case PlaybackStatus.playing:
        return Icon(Icons.play_arrow, size: size, color: color);
      case PlaybackStatus.paused:
        return Icon(Icons.pause, size: size, color: color);
      case PlaybackStatus.stopped:
        return Icon(Icons.stop, size: size, color: color);
      default:
        return Container();
    }
  }
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
