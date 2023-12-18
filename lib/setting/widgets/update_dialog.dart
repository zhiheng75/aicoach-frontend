import 'dart:io';

import 'package:Bubble/widgets/load_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/util/theme_utils.dart';

import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../routers/fluro_navigator.dart';
import '../../util/image_utils.dart';
import '../../util/toast_utils.dart';
import '../../util/version_utils.dart';
import '../../widgets/my_button.dart';
import '../../util/other_utils.dart';
import '../entity/updata_info_entity.dart';


class UpdateDialog extends StatefulWidget {

  final UpdataInfoDataData data;
  const UpdateDialog(this.data,{super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {

  final CancelToken _cancelToken = CancelToken();
  bool _isDownload = false;
  double _value = 0;

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return WillPopScope(
      onWillPop: () async {
        /// 使用false禁止返回键返回，达到强制升级目的
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  image: DecorationImage(
                    image: ImageUtils.getAssetImage(
                      'update_bg2',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                child:Container(
                  padding:const EdgeInsets.only(top: 150,left: 50,right: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       Text('新版本更新', style: TextStyles.textSize16),
                      Gaps.vGap10,

                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          itemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                              return Text(widget.data.message);
                            }),
                      ),
                      Gaps.vGap10,
                      if (_isDownload)
                        LinearProgressIndicator(
                          backgroundColor: Colours.line,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          value: _value,
                        )
                      else
                        _buildButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ))),
    );
  }


  Widget _buildButton(BuildContext context) {
    if (widget.data.forceUpdate) {
      return GestureDetector(
        onTap: () async {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            NavigatorUtils.goBack(context);
            VersionUtils.jumpAppStore();
          } else {
            setState(() {
              _isDownload = true;
            });
            _download();
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageUtils.getAssetImage(
                  "purchase_btn_img",
                ),
                fit: BoxFit.fill),
          ),
          child: const Center(
            child: Text(
              "立即升级",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              NavigatorUtils.goBack(context);
            },
            child: Container(
              width: 140,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage(
                      "confirm_bg1",
                    ),
                    fit: BoxFit.fill),
              ),
              child: const Center(
                child: Text(
                  "取消",
                  style: const TextStyle(
                      fontSize: 13, color: Colours.color_3389FF),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                NavigatorUtils.goBack(context);
                VersionUtils.jumpAppStore();
              } else {
                setState(() {
                  _isDownload = true;
                });
                _download();
              }
            },
            child: Container(
              width: 140,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage(
                      "cancel_bg1",
                    ),
                    fit: BoxFit.fill),
              ),
              child: const Center(
                child: Text(
                  "立即升级",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  ///下载apk
  Future<void> _download() async {
    try {
      setInitDir(initStorageDir: true);
      await DirectoryUtil.getInstance();
      DirectoryUtil.createStorageDirSync(category: 'Download');
      final String path = DirectoryUtil.getStoragePath(fileName: 'deer', category: 'Download', format: 'apk').nullSafe;
      final File file = File(path);
      /// 链接可能会失效  'http://imtt.dd.qq.com/16891/apk/FF9625F40FD26F015F4CDED37B6B66AE.apk
      await Dio().download(widget.data.package,
        file.path,
        cancelToken: _cancelToken,
        onReceiveProgress: (int count, int total) {
          if (total != -1) {
            _value = count / total;
            setState(() {

            });
            if (count == total) {
              NavigatorUtils.goBack(context);
              VersionUtils.install(path);
            }
          }
        },
      );
    } catch (e) {
      Toast.show('下载失败!');
      debugPrint(e.toString());
      setState(() {
        _isDownload = false;
      });
    }
  }
}
