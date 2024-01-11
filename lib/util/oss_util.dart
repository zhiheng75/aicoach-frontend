import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// import '../constants/constants.dart';
import 'package:intl/date_symbol_data_local.dart'; //intl包下的

String ossAccessKeyId = '替换成自己的accessKeyId';

String ossAccessKeySecret = '替换成自己的accessKeySecret';
// oss设置的bucket的名字
String bucketName = '替换成自己的bucket';
String ossEndPoint = '替换成自己的endPoint'; //oss-cn-shanghai.aliyuncs.com
String ossSecurityToken = '替换成自己的securityToken';
String host = "$bucketName.$ossEndPoint";
String url = 'https://$host';

class OssUtil {
  OssUtil._internal();

  factory OssUtil() => _instance;

  static late final OssUtil _instance = OssUtil._internal();
  Future<String> ossUploadImage(Uint8List imageData, String pathName,
      {required String fileType, String? directory = "community"}) async {
    String date = getGMTDateString();
    String contentType = 'image/$fileType';
    //签名相关
    //请求头
    SplayTreeMap<String, String> treeMap = SplayTreeMap();
    treeMap["Content-Type".toLowerCase()] = contentType.trim();
    treeMap["Content-MD5".toLowerCase()] = "";
    treeMap["Date".toLowerCase()] = date.trim();
    treeMap["x-oss-security-token".toLowerCase()] = ossSecurityToken.trim();
    String headString = "PUT\n";
    treeMap.forEach((key, value) {
      if (key.startsWith("x-oss-")) {
        headString += key;
        headString += ':';
        headString += value;
      } else {
        headString += value;
      }
      headString += '\n';
    });

    String contentString = "/$bucketName/$pathName";
    String contentToSign = headString + contentString;

    List<int> key = utf8.encode(ossAccessKeySecret);
    List<int> data = utf8.encode(contentToSign);
    var signaturePre = Hmac(sha1, key).convert(data).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    String signatureA = "OSS " + ossAccessKeyId + ":" + signature;

    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["Authorization"] = signatureA;
      options.headers["Host"] = host;
      options.headers["x-oss-security-token"] = ossSecurityToken;
      options.contentType = contentType;
      options.headers["date"] = date; //必须要设置日期 不设置日期报错 403
      handler.next(options);
    }));
    try {
      // 发送请求
      var resultUrl = url + "/$pathName";
      //必须转成这个类型才可以
      Stream<List<int>> stream = Stream.value(imageData);
      var rep = await dio.put(resultUrl, data: stream);
      // 成功后返回文件访问路径
      return "UPLOAD_IMAGE_BASE_URL" + "$pathName";
    } catch (e) {
      return '';
    }
  }

  String getRandom(int num) {
    String alphabet = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    String left = "";
    for (var i = 0; i < num; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

//这个时间必须调用初始化，并且的时间要减去8小时，要不然会报错，服务器时间和请求时间相差太大，因为是GMT时间，所以当前时间我们是东八区的时间，所以相差8小时。
  String getGMTDateString() {
    initializeDateFormatting();
    var date = DateTime.now();
    date = date.subtract(const Duration(hours: 8)); //当前时间减去8个小时
    // date = date.add(const Duration(hours: 8));//当前时间加上8个小时
    return DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en').format(date);
  }
}
