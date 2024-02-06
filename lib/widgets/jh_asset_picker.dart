///  jh_asset_picker.dart
///
///  Created by iotjin on 2022/09/10.
///  description: 基于微信UI的图片/视频选择器(支持拍照及录制视频) 封装wechat_assets_picker、wechat_camera_picker

import 'package:Bubble/main.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../res/colors.dart';
import '../res/gaps.dart';
import '../setting/provider/theme_provider.dart';
import '../util/EventBus.dart';
import '../util/device_utils.dart';
import '../util/jh_permission_utils.dart';
import 'jh_bottom_sheet.dart';

// 最大数量
const int _maxAssets = 4;
// 录制视频最长时长, 默认为 15 秒，可以使用 `null` 来设置无限制的视频录制
const Duration _maximumRecordingDuration = Duration(seconds: 15);
// 一行显示几个
const int _lineCount = 4;
// 每个GridView item间距(GridView四周与内部item间距在此统一设置)
const double _itemSpace = 7.0;
// 右上角删除按钮大小
const double _deleteBtnWH = 17.0;
// 默认添加图片
const String _addBtnIcon = 'assets/images/selectPhoto_add.png';
// 默认删除按钮图片
const String _deleteBtnIcon = 'assets/images/selectPhoto_close.png';
// 默认背景色
const Color _bgColor = Colors.transparent;

enum AssetType {
  image,
  video,
  imageAndVideo,
}

class JhAssetPicker extends StatefulWidget {
  const JhAssetPicker({
    Key? key,
    this.assetType = AssetType.image,
    this.maxAssets = _maxAssets,
    this.lineCount = _lineCount,
    this.itemSpace = _itemSpace,
    this.maximumRecordingDuration = _maximumRecordingDuration,
    this.bgColor = _bgColor,
    this.callBack,
    this.deleteCallBack,
  }) : super(key: key);

  final AssetType assetType; // 资源类型
  final int maxAssets; // 最大数量
  final int lineCount; // 一行显示几个
  final double itemSpace; // 每个GridView item间距(GridView四周与内部item间距在此统一设置)
  final Duration?
      maximumRecordingDuration; // 录制视频最长时长, 默认为 15 秒，可以使用 `null` 来设置无限制的视频录制
  final Color bgColor; // 背景色
  final Function(List<AssetEntity> assetEntityList)? callBack; // 选择回调

  final Function(int index)? deleteCallBack; // 删除回调

  @override
  State<JhAssetPicker> createState() => _JhAssetPickerState();
}

class _JhAssetPickerState extends State<JhAssetPicker> {
  List<AssetEntity> _selectedAssets = [];
  final Color _themeColor = Colours.color_0E90FF;

  int maxAmount = 0;
  @override
  void initState() {
    super.initState();
    maxAmount = widget.maxAssets;
    bus.on("refreshSelectImg", (arg) {
      _selectedAssets.clear();
      _selectedAssets.addAll(arg);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    // final provider = Provider.of<ThemeProvider>(context);
    // _themeColor = Colours.dynamicColor(
    // context, provider.getThemeColor(), Colours.color_0EF4D1);

    var allCount = _selectedAssets.length + 1;

    return Container(
      color: widget.bgColor,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // 可以直接指定每行（列）显示多少个Item
          crossAxisCount: widget.lineCount, // 一行的Widget数量
          crossAxisSpacing: widget.itemSpace, // 水平间距
          mainAxisSpacing: widget.itemSpace, // 垂直间距
          childAspectRatio: 1.0, // 子Widget宽高比例
        ),
        // GridView内边距
        padding: EdgeInsets.all(widget.itemSpace),
        // itemCount: _selectedAssets.length == widget.maxAssets ? _selectedAssets.length : allCount,
        itemCount:
            _selectedAssets.length == 4 ? _selectedAssets.length : allCount,
        itemBuilder: (context, index) {
          if (_selectedAssets.length < 5) {
            if (index == allCount - 1) {
              return _addBtnWidget();
            } else {
              return _itemWidget(index);
            }
          }

          // if (_selectedAssets.length == widget.maxAssets) {
          //   return _itemWidget(index);
          // }
          // if (index == allCount - 1) {
          //   return _addBtnWidget();
          // } else {
          //   return _itemWidget(index);
          // }
        },
      ),
    );
  }

  // 添加按钮
  Widget _addBtnWidget() {
    return GestureDetector(
      // child: const Image(image: AssetImage(_addBtnIcon)),
      child: Container(
        // color: Colors.black,
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(13),
        //     border: Border.all(color: Colours.color_5B8BD2, width: 0.5)),
        child: const LoadAssetImage(
          "camera_img",
          width: 50,
          height: 50,
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const LoadAssetImage(
        //       "camera_img",
        //       width: 28,
        //       height: 23,
        //     ),
        //     // Gaps.vGap8,
        //     // Text(
        //     //   "上传",
        //     //   style: TextStyle(
        //     //       fontSize: Dimens.font_sp10, color: Colours.color_546092),
        //     // )
        //   ],
        // ),
      ),
      onTap: () => _showBottomSheet(),
    );
  }

  // 图片和删除按钮
  Widget _itemWidget(index) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _loadAsset(_selectedAssets[index]),
            ),
            GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: const Image(
                    image: AssetImage(_deleteBtnIcon),
                    width: _deleteBtnWH,
                    height: _deleteBtnWH,
                  ),
                ),
                onTap: () => {
                      _deleteAsset(index),
                    })
          ],
        ),
      ),
      onTap: () => _clickAsset(index),
    );
  }

  Widget _loadAsset(AssetEntity asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image(image: AssetEntityImageProvider(asset), fit: BoxFit.cover),
    );
  }

  void _deleteAsset(index) {
    setState(() {
      // _selectedAssets.removeAt(index);
      // widget.callBack?.call(_selectedAssets);
      // 选择回调
      widget.deleteCallBack?.call(index);
    });
  }

  // 全屏查看
  void _clickAsset(index) {
    AssetPickerViewer.pushToViewer(
      context,
      currentIndex: index,
      previewAssets: _selectedAssets,
      themeData: AssetPicker.themeData(_themeColor),
    );
  }

  // 点击添加按钮
  void _showBottomSheet() {
    JhBottomSheet.showText(context, dataArr: ['拍摄', '相册'], title: '请选择',
        clickCallback: (index, str) async {
      if (index == 1) {
        _openCamera(context);
      }
      if (index == 2) {
        _openAlbum(context);
      }
    });
  }

  // 相册选择
  Future<void> _openAlbum(context) async {
    // if (Device.isAndroid) {
    //   if (!Device.isMobile) {
    //     return;
    //   }
    //   //相册权限
    //   bool isGrantedPhotos = await JhPermissionUtils.photos();
    //   if (isGrantedPhotos) {
    //     return;
    //   }

    //   RequestType requestType = RequestType.image;
    //   if (widget.assetType == AssetType.video) {
    //     requestType = RequestType.video;
    //   }
    //   if (widget.assetType == AssetType.imageAndVideo) {
    //     requestType = RequestType.common;
    //   }
    // }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: widget.maxAssets,
        selectedAssets: _selectedAssets,
        requestType: RequestType.image,
        themeColor: _themeColor,
        // textDelegate: const EnglishAssetPickerTextDelegate(),
      ),
    );

    // final List<AssetEntity>? result = await AssetPicker.pickAssets(
    //   context,
    // pickerConfig: AssetPickerConfig(
    //   maxAssets: widget.maxAssets,
    //   requestType: requestType,
    //   // selectedAssets: _selectedAssets,
    //   themeColor: _themeColor,
    //   // textDelegate: const EnglishAssetPickerTextDelegate(),
    // ),
    // );
    if (result != null) {
      setState(() {
        _selectedAssets = result;
      });
      // 相册选择回调
      widget.callBack?.call(result);
    }
  }

  // 拍照或录像
  Future<void> _openCamera(context) async {
    // if (Device.isAndroid) {
    //   if (!Device.isMobile) {
    //     return;
    //   }
    //   //相机权限
    //   bool isGrantedCamera = await JhPermissionUtils.camera();
    //   if (!isGrantedCamera) {
    //     return;
    //   }

    //   if (widget.assetType != AssetType.image) {
    //     // 麦克风权限
    //     bool isGrantedMicrophone = await JhPermissionUtils.microphone();
    //     if (!isGrantedMicrophone) {
    //       return;
    //     }
    //   }

    //   // 相册权限
    //   bool isGrantedPhotos = await JhPermissionUtils.photos();
    //   if (!isGrantedPhotos) {
    //     return;
    //   }
    // }

    final AssetEntity? result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(),
    );
    // final AssetEntity? result = await CameraPicker.pickFromCamera(
    //   context,
    // );
    if (result != null) {
      setState(() {
        // _selectedAssets.clear();
        _selectedAssets.add(result);
        // 相机回调
        widget.callBack?.call(_selectedAssets);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('refreshSelectImg');
  }
}
