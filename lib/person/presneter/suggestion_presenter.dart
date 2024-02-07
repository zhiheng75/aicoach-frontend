import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
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

  Future pushSuggest(message, contact, images, Function(String) onSuccess) {
    // StringBuffer sb = StringBuffer();
    // for (int i = 0; i < allSendList.length; i++) {
    //   sb.write(allSendList[i].filename);
    //   if (i < allSendList.length - 1) {
    //     sb.write(",");
    //   }
    // }

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
          onSuccess("成功");
        } else {
          view.sendFail(data.msg);
          onSuccess("失败");
        }
      } else {
        view.sendFail("反馈失败");
        onSuccess("失败");
      }
    });
  }

  final String _oss = 'evaluate_oss';
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  String getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  void _getOssToken(Function(Map<String, dynamic>) onSuccess) {
    Map<dynamic, dynamic>? evaluateOss = SpUtil.getObject(_oss);
    // 未获取或者已过期
    if (evaluateOss == null ||
        DateTime.parse(evaluateOss['Expiration']).millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      DioUtils.instance.requestNetwork<ResultData>(
        Method.get,
        HttpApi.getOssSts,
        onSuccess: (result) {
          if (result == null || result.data == null) {
            return;
          }
          Map<String, dynamic> data = result.data as Map<String, dynamic>;
          SpUtil.putObject(_oss, data);
          onSuccess(data);
        },
        onError: (code, msg) {
          Log.d('upload audio:msg=$msg', tag: '上传图片');
        },
      );
      return;
    }
    onSuccess(evaluateOss as Map<String, dynamic>);
  }

  String host = 'https://shenmo-statics.oss-cn-beijing.aliyuncs.com';
  Future<String> upLoadImage(File imgFile, evaluateOss) async {
    // 获取签名
    Map<String, dynamic> policyParams = {
      'expiration': evaluateOss['Expiration'],
      'conditions': [
        ['content-length-range', 0, 1048576000]
      ],
    };
    String policy = base64Encode(utf8.encode(jsonEncode(policyParams)));
    Digest digest = Hmac(sha1, utf8.encode(evaluateOss['AccessKeySecret']))
        .convert(utf8.encode(policy));
    String signature = base64Encode(digest.bytes);
    // String fileName = getRandom(12);
    List<String> list = imgFile.path.split("/");
    String fileName = list.last;

    String key = 'feedback/$fileName';
    // String key = 'feedback${imgFile.path}';

    final MultipartFile multipartFile = await MultipartFile.fromFile(
      imgFile.path,
    );
    FormData formData = FormData.fromMap({
      'key': key,
      'success_action_status': '200',
      'OSSAccessKeyId': evaluateOss['AccessKeyId'],
      'x-oss-security-token': evaluateOss['SecurityToken'],
      'policy': policy,
      'signature': signature,
      // 'Content-Type': 'image/jpeg',
      'file': multipartFile,
    });

    String urlStr = "null";
    try {
      Response response = await Dio().post(
        host,
        data: formData,
      );
      if (response.statusCode == 200) {
        Log.d('upload img success:url=${'$host/$key'}', tag: '上传图片');
        // urlStr = '$host/$key';
        urlStr = key;

        // return urlStr;
      }
    } catch (e) {
      Log.d('upload png error:${e.toString()}', tag: '_png');
    }
    return urlStr;
  }

  void getOssToken(List<File> mlist, String message, String contact,
      Function(String) onSuccess) {
    _getOssToken((evaluateOss) async {
      String imagesStr = "";
      for (int i = 0; i < mlist.length; i++) {
        // Future<String> url = upLoadImage(mlist[i], evaluateOss);
        String url = await upLoadImage(mlist[i], evaluateOss);
        if (i == 0) {
          imagesStr = url;
        } else {
          imagesStr = "$imagesStr,$url";
        }
      }
      Log.e(imagesStr);
      pushSuggest(message, contact, imagesStr, onSuccess);
    });
  }
}
