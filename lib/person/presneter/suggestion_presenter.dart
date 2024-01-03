
import 'dart:convert';
import 'dart:io';

import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../entity/oss_token_entity.dart';
import '../entity/send_img_result_entity.dart';
import '../view/suggestion_view.dart';

class SuggestionPresenter extends BasePagePresenter<SuggestionView>{


  bool sendImgSuccess = false;



  String suggestImgStr = "";

  List<SendImgResultDataData> allSendList = [];//需要发送的集合
  List<SendImgResultDataData> allImgList = [];//所以上传过的集合


  List<AssetEntity> selectedAssets = [];//选的照片（本地）

  List<AssetEntity> refreshAssets = [];

  String url = "";

  Future pushSuggest(suggest1,contact){

    StringBuffer sb = StringBuffer();
    for(int i = 0;i<allSendList.length;i++){
      sb.write(allSendList[i].filename);
      if(i<allSendList.length-1){
        sb.write(",");
      }
    }

    Map<String,dynamic> map = {};
    map["message"] = suggest1;
    map["images"] = sb.toString();//图片地址
    map["contact"] = contact;

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.suggestion, isShow: true,
        params: map,
        onSuccess: (data) {
          if (data != null ) {
            if(data.code == 200){
              Toast.show("反馈成功");
              view.sendSuccess();
            }else{
              view.sendFail(data.msg);
            }
          }else {
            view.sendFail("反馈失败");
          }
        });
  }


  Future getOssToken(List<File> files,List<AssetEntity> sendList){
    return requestNetwork<OssTokenData>(Method.get,
        url: HttpApi.getOssSts, isShow: true,
        onSuccess: (data) {
          if (data != null ) {
            if(data.code == 200&&data.data!=null){
            //   Toast.show("反馈成功");
            //   view.sendSuccess();
            // }else{
            //   view.sendFail(data.msg);
              uploadImg(files,sendList,data.data.accessKeyId,
                  data.data.accessKeySecret,data.data.expiration);
            }
          }else {
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

  String getSignature(accessKeySecret,String encodePolicy){
    var key = utf8.encode(accessKeySecret);
    var bytes = utf8.encode(encodePolicy);
    var hmacSha1 =  Hmac(sha1,key);
    Digest sha1Result = hmacSha1.convert(bytes);
    String signature = base64Encode(sha1Result.bytes);
    return signature;
  }

  /// 上传图片实现
  Future<String> uploadImg(
      List<File> images,List<AssetEntity> sendList,OSSAccessKeyId,accessKeySecret,
      policy) async {
    String encodePolicy = base64Encode(utf8.encode(policy));
    String signature = getSignature(accessKeySecret,encodePolicy);

    String imgPath = '';
    try{
      List<MultipartFile> mList = [];


      for(int i = 0;i<images.length;i++){
        final String path = images[i].path;
        final String name = path.substring(path.lastIndexOf('/') + 1);
        MultipartFile mf = await MultipartFile.fromFile(path, filename: name);
        mList.add(mf);
      }
      final FormData formData = FormData.fromMap(<String, dynamic>{
        "success_action_status":200,
        'OSSAccessKeyId':OSSAccessKeyId,
        "policy":encodePolicy,
        "Signature":signature,
        'files':mList
      });

      await requestNetwork<SendImgResultData>(Method.post,
          url: HttpApi.upload,
          params: formData,
          onSuccess: (data) {
        if (data != null && data.code == 200) {
          // imgPath = data ?? '';
          Toast.show("上传成功");

          allImgList.addAll(data.data);
          allSendList.clear();

          selectedAssets.addAll(sendList);

          if(allImgList.length>4){
            for(int i = allImgList.length-1;i>allImgList.length-5;i--){
              allSendList.add(allImgList[i]);
            }
          } else {
            allSendList.addAll(allImgList);
          }

          view.sendImgSuccess(data.data);
        }
      });
    } catch(e) {
      view.showToast('图片上传失败！');
      view.sendImgFail();
    }
    return imgPath;
  }
}