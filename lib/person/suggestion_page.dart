import 'dart:io';

import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/presneter/suggestion_presenter.dart';
import 'package:Bubble/person/view/suggestion_view.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/string_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/btn_bg_widget.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../util/EventBus.dart';
import '../widgets/jh_asset_picker.dart';
import '../widgets/my_app_bar.dart';
import 'entity/send_img_result_entity.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage>
    with
        BasePageMixin<SuggestionPage, SuggestionPresenter>,
        AutomaticKeepAliveClientMixin<SuggestionPage>
    implements SuggestionView {
  late SuggestionPresenter _presenter;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  List<TextInputFormatter>? _inputFormatters;
  late int _maxLength;
  int selectImgAmount = 0;

  List<File> mlist = [];

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _contactController.text = '';
    _maxLength = 500;
    _inputFormatters = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              _nodeText1.unfocus();
              _nodeText2.unfocus();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              // decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topRight,
              //         end: Alignment.bottomLeft,
              //         colors: [
              //       Colours.color_00E6D0,
              //       Colours.color_006CFF,
              //       Colours.color_D74DFF,
              //     ],
              //         stops: [
              //       0.0,
              //       0.2,
              //       1
              //     ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const XTCupertinoNavigationBar(
                    backgroundColor: Color(0xFFFFFFFF),
                    border: null,
                    padding: EdgeInsetsDirectional.zero,
                    leading: NavigationBackWidget(),
                    middle: Text(
                      "意见反馈",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // const MyAppBar(
                  //   centerTitle: "意见反馈",
                  //   centerTitleColor: Colors.black,
                  //   backImgColor: Colors.black,
                  //   backgroundColor: Colours.black,
                  // ),
                  Expanded(
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      padding: const EdgeInsets.only(
                          left: Dimens.gap_dp16,
                          right: Dimens.gap_dp16,
                          top: 10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white),
                      child: MyScrollView(
                        children: [
                          Text(
                            "遇到的问题和建议请写这里吧：",
                            style: TextStyle(
                              color: Colours.color_111B44,
                              fontSize: Dimens.font_sp16,
                            ),
                          ),
                          Gaps.vGap16,
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                                color: Colours.color_F8F8F8),
                            child: Semantics(
                              multiline: true,
                              // maxValueLength: _maxLength,
                              child: TextField(
                                cursorColor: Colours.color_333333,
                                style: const TextStyle(
                                    color: Colours.color_546092, fontSize: 13),
                                // maxLength: _maxLength,
                                maxLines: 5,
                                autofocus: false,
                                focusNode: _nodeText1,
                                controller: _controller,
                                inputFormatters: _inputFormatters,
                                decoration: const InputDecoration(
                                  hintText: "在这里输入您的具体问题和建议",
                                  hintStyle:
                                      TextStyle(color: Colours.color_B7BFD9),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Gaps.vGap24,
                          const Row(
                            children: [
                              Text(
                                "可以上传图片说明选",
                                style: TextStyle(
                                    fontSize: 15, color: Colours.color_111B44),
                              ),
                              Text(
                                "（最多可上传4张）",
                                style: TextStyle(
                                    fontSize: 15, color: Colours.color_666666),
                              ),
                            ],
                          ),
                          Gaps.vGap16,
                          Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: JhAssetPicker(
                              assetType: AssetType.image,
                              maxAssets: 4 - _presenter.refreshAssets.length,
                              bgColor: Colors.white,
                              callBack: (assetEntityList) async {
                                selectImgAmount = assetEntityList.length;

                                if (assetEntityList.isNotEmpty) {
                                  mlist = [];

                                  for (int i = 0;
                                      i < assetEntityList.length;
                                      i++) {
                                    var asset = assetEntityList[i];
                                    var f = await asset.file;
                                    if (f != null) {
                                      mlist.add(f);
                                    }
                                  }
                                  Log.e("============");
                                  // Log.e(mlist as String);
                                  // Log.e(selectImgAmount as String);

                                  Log.e("============");

                                  // _presenter.uploadImg(mlist,assetEntityList);
                                  // _presenter.getOssToken(mlist, assetEntityList);
                                  // var asset = assetEntityList[0];
                                  // print(await asset.file);
                                  // print(await asset.originFile);
                                  // var asd = await asset.file;
                                  // if(asd!=null){
                                  //   _presenter.uploadImg(asd);
                                  // }
                                }
                              },
                              deleteCallBack: (index) async {
                                _presenter.selectedAssets.removeAt(index);
                                _presenter.refreshAssets.removeAt(index);
                                bus.emit('refreshSelectImg',
                                    _presenter.refreshAssets);
                                setState(() {});
                              },
                            ),
                          ),
                          Gaps.vGap20,
                          Text(
                            "请输入联系您的方式：",
                            style: TextStyle(
                              color: Colours.color_111B44,
                              fontSize: Dimens.font_sp16,
                            ),
                          ),
                          Gaps.vGap16,
                          Container(
                            width: ScreenUtil().screenWidth,
                            padding: const EdgeInsets.only(
                              left: 13,
                            ),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Colours.color_F8F8F8),
                            child: TextField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                  color: Colours.color_546092,
                                  fontSize: Dimens.font_sp13),
                              maxLines: 1,
                              controller: _contactController,
                              focusNode: _nodeText2,
                              inputFormatters: _inputFormatters,
                              decoration: const InputDecoration(
                                hintText: "可输入电话/邮箱",
                                hintStyle:
                                    TextStyle(color: Colours.color_B7BFD9),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          // const Expanded(child: Gaps.empty),
                          Gaps.vGap85,
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "客服邮箱：help@shenmo-ai.com ",
                              style: TextStyle(
                                  fontSize: Dimens.font_sp10,
                                  color: Colours.color_999999),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "任何问题或举报，都可发送到邮箱，我们会尽快处理",
                              style: TextStyle(
                                  fontSize: Dimens.font_sp10,
                                  color: Colours.color_999999),
                            ),
                          ),
                          Gaps.vGap30,
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: BtnWidget("btn_bg_img", "提交",
                                  txtStyle: TextStyle(
                                      color: Colours.color_001652,
                                      fontSize: Dimens.font_sp18), () {
                                if (!StringUtils.isChinaEmailLegal(
                                        _contactController.text) &&
                                    !StringUtils.isChinaPhoneLegal(
                                        _contactController.text)) {
                                  Toast.show("请输入正确联系方式");
                                  return;
                                }

                                if (_controller.text.isNotEmpty &&
                                    _contactController.text.isNotEmpty) {
                                  _presenter.getOssToken(
                                      mlist,
                                      _controller.text,
                                      _contactController.text,
                                      (String audiopath) {});
                                  ;
                                  // _presenter.pushSuggest(
                                  //     _controller.text, _contactController.text);
                                  //    _presenter.getOssToken();
                                } else {
                                  if (_controller.text.isEmpty) {
                                    Toast.show("请输入问题和意见");
                                  } else if (_contactController.text.isEmpty) {
                                    Toast.show("请输入联系方式");
                                  }
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  ///读取本地图片路径
  Future _selectImage() async {
    final ImagePicker _picker = ImagePicker();

    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // LogUtils.i(image.path);
      // String filePath = image.path ?? "";
      // UploadPicModel uploadPicModel = UploadPicModel();
      // uploadPicModel.id = picsGet.length == 0 ? 0 : picsGet.length;
      // uploadPicModel.uri = filePath;
      // picsGet.add(uploadPicModel);
      // // String _picBase64 = await EncodeUtil.image2Base64(uploadPicModel.uri);
      // // saveData("send_announce_pic_${uploadPicModel.id}", _picBase64);
      // saveData("send_announce_pic_${uploadPicModel.id}", uploadPicModel.uri!);
      // saveData("send_announce_pic_size", picsGet.length.toString());
      // publishBtnStatus();
      // if (mounted) {
      //   setState(() {});
      // }
    }
  }

  @override
  SuggestionPresenter createPresenter() {
    _presenter = SuggestionPresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    Toast.show(msg);
  }

  @override
  void sendSuccess() {
    Toast.show("反馈成功");
    NavigatorUtils.goBack(context);
  }

  @override
  void sendImgFail() {
    _presenter.sendImgSuccess = true;
    setState(() {});
  }

  @override
  void sendImgSuccess(List<SendImgResultDataData> mList) {
    _presenter.sendImgSuccess = false;

    for (int i = 0; i < mList.length; i++) {
      _presenter.suggestImgStr = "${mList[i].filename},";
    }
    _presenter.refreshAssets.clear();
    if (_presenter.selectedAssets.length > 4) {
      for (int i = _presenter.selectedAssets.length - 1;
          i > _presenter.selectedAssets.length - 5;
          i--) {
        _presenter.refreshAssets.add(_presenter.selectedAssets[i]);
      }
    } else {
      _presenter.refreshAssets.addAll(_presenter.selectedAssets);
    }
    bus.emit('refreshSelectImg', _presenter.refreshAssets);
    if (_presenter.refreshAssets.length < 4) {
      setState(() {});
    }
  }
}
