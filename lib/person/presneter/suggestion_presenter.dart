import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../entity/oss_token_entity.dart';
import '../entity/send_img_result_entity.dart';
import '../view/suggestion_view.dart';

class SuggestionPresenter extends BasePagePresenter<SuggestionView> {
  bool sendImgSuccess = false;

  String suggestImgStr = "";

  List<SendImgResultDataData> allSendList = []; //需要发送的集合
  List<SendImgResultDataData> allImgList = []; //所以上传过的集合

  List<AssetEntity> selectedAssets = []; //选的照片（本地）

  List<AssetEntity> refreshAssets = [];

  String url = "";

  Future pushSuggest(message, contact, images) {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < allSendList.length; i++) {
      sb.write(allSendList[i].filename);
      if (i < allSendList.length - 1) {
        sb.write(",");
      }
    }

    Map<String, dynamic> map = {};
    map["message"] = message;
    map["images"] = images; //图片地址
    map["contact"] = contact;

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.suggestion, isShow: true, params: map, onSuccess: (data) {
      if (data != null) {
        if (data.code == 200) {
          Toast.show("反馈成功");
          view.sendSuccess();
        } else {
          view.sendFail(data.msg);
        }
      } else {
        view.sendFail("反馈失败");
      }
    });
  }

  Future getOssToken(List<File> mlist, String message, String contact) {
    return requestNetwork<OssTokenData>(Method.get,
        url: HttpApi.getOssSts, isShow: true, onSuccess: (data) {
      if (data != null) {
        if (data.code == 200 && data.data != null) {
          //   Toast.show("反馈成功");
          //   view.sendSuccess();
          // }else{
          //   view.sendFail(data.msg);
          // uploadImg(files,sendList,data.data.accessKeyId,
          // data.data.accessKeySecret,data.data.expiration);
          List allImageList = []; //需要发送的集合

          for (int i = 0; i < mlist.length; i++) {
            UploadOss.SecurityToken = data.data.securityToken;
            UploadOss.ossAccessKeyId = data.data.accessKeyId;
            UploadOss.ossAccessKeySecret = data.data.accessKeySecret;

            Future<String> xxx = UploadOss.upload(
                file: mlist[i],
                fileType: "/feedback/filename",
                onSendProgress: () {});
            Log.e("=============");
            Log.e(xxx as String);
            Log.e("=============");
            allImageList.add(UploadOss.upload(
                file: mlist[i],
                fileType: "/feedback/filename",
                onSendProgress: () {}));
          }

          pushSuggest(message, contact, allImageList.toString());
        }
      } else {
        // view.sendFail("反馈失败");
      }
    });
  }

  // void ads(){
  //   String encodePolicy = base64Encode(utf8.encode(policy));
  //   String signature = getSignature(encodePolicy);
  //   String fileName = basename(imgFile.path);
  //   fileName='flutter/$fileName';
  //   var formData = FormData.fromMap(
  //       {
  //         'key':fileName,
  //         "success_action_status":200,
  //         'OSSAccessKeyId':encodePolicy,
  //         "policy":encodePolicy,
  //         "Signature":signature,
  //         "Content-Type":"image/jpeg",
  //         'file':await MultipartFile.fromFile(image.path),
  //       }
  //   );
  //
  // }

  String getSignature(accessKeySecret, String encodePolicy) {
    var key = utf8.encode(accessKeySecret);
    var bytes = utf8.encode(encodePolicy);
    var hmacSha1 = Hmac(sha1, key);
    Digest sha1Result = hmacSha1.convert(bytes);
    String signature = base64Encode(sha1Result.bytes);
    return signature;
  }

  /// 上传图片实现
  Future<String> uploadImg(List<File> images, List<AssetEntity> sendList,
      OSSAccessKeyId, accessKeySecret, policy) async {
    String encodePolicy = base64Encode(utf8.encode(policy));
    String signature = getSignature(accessKeySecret, encodePolicy);

    String imgPath = '';
    try {
      List<MultipartFile> mList = [];

      for (int i = 0; i < images.length; i++) {
        final String path = images[i].path;
        final String name = path.substring(path.lastIndexOf('/') + 1);
        MultipartFile mf = await MultipartFile.fromFile(path, filename: name);
        mList.add(mf);
      }
      final FormData formData = FormData.fromMap(<String, dynamic>{
        "success_action_status": 200,
        'OSSAccessKeyId': OSSAccessKeyId,
        "policy": encodePolicy,
        "Signature": signature,
        'files': mList
      });

      await requestNetwork<SendImgResultData>(Method.post,
          url: HttpApi.upload, params: formData, onSuccess: (data) {
        if (data != null && data.code == 200) {
          // imgPath = data ?? '';
          Toast.show("上传成功");

          allImgList.addAll(data.data);
          allSendList.clear();

          selectedAssets.addAll(sendList);

          if (allImgList.length > 4) {
            for (int i = allImgList.length - 1;
                i > allImgList.length - 5;
                i--) {
              allSendList.add(allImgList[i]);
            }
          } else {
            allSendList.addAll(allImgList);
          }

          view.sendImgSuccess(data.data);
        }
      });
    } catch (e) {
      view.showToast('图片上传失败！');
      view.sendImgFail();
    }
    return imgPath;
  }
}

class UploadOss {
  static String ossAccessKeyId = '';
  static String SecurityToken = '';
  static String ossAccessKeySecret = '';

  // oss设置的bucket的名字
  static String bucket = 'beijing';
  // 发送请求的url,根据你自己设置的是哪个城市的
  static String url = "https://shenmo-statics.oss-cn-beijing.aliyuncs.com";

  // 过期时间
  static String expiration = '2025-01-01T12:00:00.000Z';

  /**
   * @params file 要上传的文件对象
   * @params rootDir 阿里云oss设置的根目录文件夹名字
   * @param fileType 文件类型例如jpg,mp4等
   * @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
   * @param onSendProgress 上传的进度事件
   */

  static Future<String> upload(
      {required File file,
      String rootDir = '/feedback/filename',
      required String fileType,
      Function? callback,
      required Function onSendProgress}) async {
    String policyText =
        '{"expiration": "$expiration","conditions": [{"bucket": "$bucket" },["content-length-range", 0, 1048576000]]}';

    // 获取签名
    String signature = getSignature(policyText);

    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;

    //创建dio对象
    Dio dio = new Dio(options);
    // 生成oss的路径和文件名我这里目前设置的是moment/20201229/test.mp4
    String pathName =
        '$rootDir/${getDate()}/${getRandom(12)}.${fileType == null ? getFileType(file.path) : fileType}';

    // 请求参数的form对象
    FormData data = FormData.fromMap({
      'key': pathName,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'OSSAccessKeyId': ossAccessKeyId,
      'x-oss-security-token': SecurityToken,
      'policy': getSplicyBase64(policyText),
      'signature': signature,
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(file.path),
    });

    Response response;
    CancelToken uploadCancelToken = CancelToken();
    callback ?? callback!(uploadCancelToken);

    try {
      // 发送请求
      response = await dio.post(url, data: data, cancelToken: uploadCancelToken,
          onSendProgress: (int count, int data) {
        onSendProgress(count, data);
      });
      // 成功后返回文件访问路径
      return '$url/$pathName';
    } catch (e) {
      // throw(e.message);
      return "失败";
    }
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String? getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath?.substring(
        filePath!.lastIndexOf("/") + 1, filePath?.length);
  }

  /**
   * 获取文件类型
   */
  static String getFileType(String path) {
    print(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  // 获取plice的base64
  static getSplicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    return policy_base64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policy_base64);
    //进行utf8 编码
    List<int> key = utf8.encode(ossAccessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signature_pre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signature_pre);
    return signature;
  }
}
