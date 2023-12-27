import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'toast_utils.dart';



class MediaUtils {

  MediaUtils();

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;

  Future<FlutterSoundRecorder?> getRecorder() async {
    // 权限判断
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        Toast.show(
          "麦克风权限未授权！",
          duration: 1000,
        );
        return null;
      }
    }
    _recorder ??= await FlutterSoundRecorder().openRecorder();
    return _recorder;
  }

  Future<FlutterSoundPlayer?> getPlayer() async {
    _player ??= await FlutterSoundPlayer().openPlayer();
    return _player;
  }

  void play(String audioPath, { Function? whenFinished }) async {
    await getPlayer();
    if (_player == null) {
      return;
    }
    _player!.startPlayer(
      fromURI: audioPath,
      whenFinished: () {
        if (whenFinished != null) {
          whenFinished();
        }
      },
    );
  }

}