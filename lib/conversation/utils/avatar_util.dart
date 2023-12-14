import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Bubble/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

class AvatarUtil {

  Future<String> loadModelSetting(String id) async {
    String key = '${Constant.avatarParams}-$id';
    String? value = SpUtil.getString(key, defValue: null);
    if (value != null) {
      return value;
    }
    String targetPath = '${await getDirPath()}/$id/model3.json';
    File file = File(targetPath);
    if (file.existsSync()) {
      return getBase64ByFile(file);
    }
    try {
      await downloadAssetFile(id);
      file = File(targetPath);
      String base64Str = getBase64ByFile(file);
      SpUtil.putString(key, base64Str);
      return base64Str;
    } catch(e) {
      return '';
    }
  }

  Future<AvatarAsset> loadModel(String id, Map<String, dynamic> params) async {
    String key = '${Constant.avatarModel}-$id';
    Map<dynamic, dynamic>? value = SpUtil.getObject(key);
    if (value != null) {
      return AvatarAsset.fromJson(value as Map<String, dynamic>);
    }

    AvatarAsset avatarAsset = AvatarAsset();
    String dirPath = '${await getDirPath()}/$id';

    String? moc;
    // moc
    if (checkString(params['moc'])) {
      moc = getBase64ByFile(File('$dirPath/${params['moc']}'));
    }
    // exp
    List<String> exp = [];
    if (checkString(params['exp'])) {
      List<String> expList = (params['exp'] as String).split(',');
      for (String expPath in expList) {
        exp.add(getBase64ByFile(File('$dirPath/$expPath')));
      }
    }
    // physic
    String? physic;
    if (checkString(params['physic'])) {
      physic = getBase64ByFile(File('$dirPath/${params['physic']}'));
    }
    // pose
    String? pose;
    if (checkString(params['pose'])) {
      pose = getBase64ByFile(File('$dirPath/${params['pose']}'));
    }
    // user
    String? user;
    if (checkString(params['user'])) {
      user = getBase64ByFile(File('$dirPath/${params['user']}'));
    }
    // motion
    List<String> motion = [];
    if (checkString(params['motion'])) {
      List<String> motionList = (params['motion'] as String).split(',');
      for (String motionPath in motionList) {
        motion.add(getBase64ByFile(File('$dirPath/$motionPath')));
      }
    }
    // texture
    List<String> texture = [];
    if (checkString(params['texture'])) {
      List<String> textureList = (params['texture'] as String).split(',');
      for (String texturePath in textureList) {
        texture.add(getBase64ByFile(File('$dirPath/$texturePath')));
      }
    }

    avatarAsset.moc = moc ?? '';
    avatarAsset.exp = exp;
    avatarAsset.physic = physic ?? '';
    avatarAsset.pose = pose ?? '';
    avatarAsset.user = user ?? '';
    avatarAsset.motion = motion;
    avatarAsset.texture = texture;

    // 缓存storage
    SpUtil.putObject(key, avatarAsset.toJson());
    
    return avatarAsset;
  }

  Future<String> getDirPath() async {
    late Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory() ?? await getApplicationSupportDirectory();
    }
    if (Platform.isIOS) {
      directory = await getLibraryDirectory();
    }
    return '${directory.path}/avatar';
  }

  Future<void> downloadAssetFile(String id) async {
    try {
      String fileName = '$id.zip';
      String url = 'https://avatech-avatar-dev1.nyc3.cdn.digitaloceanspaces.com/public-download/sdk/$fileName';
      String savePath = '${await getDirPath()}/$fileName';
      await Dio().download(url, savePath);
      await decompressZip(id);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> decompressZip(String id) async {
    String dirPath = await getDirPath();
    // 解压到指定文件夹
    String zipPath = '$dirPath/$id.zip';
    InputFileStream inputFileStream = InputFileStream(zipPath);
    Archive archive = ZipDecoder().decodeBuffer(inputFileStream);
    for (ArchiveFile file in archive.files) {
      if (file.isFile) {
        String fileName = file.name;
        // 排除以__MACOSX开头、以.DS_Store结尾的文件
        RegExp regExp = RegExp(r'^__MACOSX|.DS_Store$');
        if (regExp.hasMatch(fileName)) {
          continue;
        }
        // 拆分path，用id替换顶层文件夹
        List<String> splitList = fileName.split('/');
        splitList[0] = id;
        // 处理后缀为model3.json的文件
        if (RegExp(r'model3.json$').hasMatch(splitList.last)) {
          splitList[splitList.length - 1] = 'model3.json';
        }

        String targetFilePath = '$dirPath/${splitList.join('/')}';
        OutputFileStream outputFileStream = OutputFileStream(targetFilePath);
        file.writeContent(outputFileStream);
        await outputFileStream.close();
      }
    }
    inputFileStream.closeSync();
    // 删除zip
    File(zipPath).delete();
  }

  String getBase64ByFile(File file) {
    if (!file.existsSync()) {
      return '';
    }
    Uint8List buffer = file.readAsBytesSync();
    return base64.encode(buffer);
  }

  bool checkString(String? string) {
    return string != null && string != '';
  }

}

class AvatarAsset {
  late String moc;
  late List<String> exp;
  late String physic;
  late String pose;
  late String user;
  late List<String> motion;
  late List<String> texture;

  AvatarAsset();

  factory AvatarAsset.fromJson(Map<String, dynamic> json) {
    AvatarAsset avatarAsset = AvatarAsset();
    avatarAsset.moc = json['moc'] ?? '';
    List<String> exp = [];
    if (json['exp'] != null && json['exp'] != '') {
      exp = (json['exp'] as String).split(',');
    }
    avatarAsset.exp = exp;
    avatarAsset.physic = json['physic'] ?? '';
    avatarAsset.pose = json['pose'] ?? '';
    avatarAsset.user = json['user'] ?? '';
    List<String> motion = [];
    if (json['motion'] != null && json['motion'] != '') {
      motion = (json['motion'] as String).split(',');
    }
    avatarAsset.motion = motion;
    List<String> texture = [];
    if (json['texture'] != null && json['texture'] != '') {
      texture = (json['texture'] as String).split(',');
    }
    avatarAsset.texture = texture;
    return avatarAsset;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['moc'] = moc;
    json['exp'] = exp.join(',');
    json['physic'] = physic;
    json['pose'] = pose;
    json['user'] = user;
    json['motion'] = motion.join(',');
    json['texture'] = texture.join(',');
    return json;
  }
}