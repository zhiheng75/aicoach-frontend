// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtils {

  // 临时文件夹
  static Future<String> getTemporaryFolderPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  // 文档文件夹
  static Future<String> getDocumentFolderPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}