
import 'dart:io';

import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/presneter/suggestion_presenter.dart';
import 'package:Bubble/person/view/suggestion_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../res/colors.dart';
import '../res/dimens.dart';
import '../util/EventBus.dart';
import '../widgets/jh_asset_picker.dart';
import '../widgets/my_app_bar.dart';
import 'entity/send_img_result_entity.dart';

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
  List<TextInputFormatter>? _inputFormatters;
  late int _maxLength;

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
          body: Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Colours.color_00E6D0,
                  Colours.color_006CFF,
                  Colours.color_D74DFF,
                ],
                    stops: [
                  0.0,
                  0.2,
                  1
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const MyAppBar(
                  centerTitle: "意见反馈",
                  backImgColor: Colors.white,
                  backgroundColor: Colours.transflate,
                ),
                Expanded(
                  child: Container(
                    width: ScreenUtil.getScreenW(context),
                    padding: const EdgeInsets.only(
                        top: Dimens.gap_dp23,
                        left: Dimens.gap_dp28,
                        right: Dimens.gap_dp28,
                        bottom: Dimens.gap_dp40),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white),
                    child:
                    MyScrollView(
                      children: [
                        const Text(
                          "遇到的问题和建议写这里吧",
                          style: TextStyle(
                              color: Colours.color_111B44,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Gaps.vGap20,
                        Container(
                          padding: const EdgeInsets.all(13),
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(13)),
                              color: Color(0x4D5B8BD2)),
                          child: Semantics(
                            multiline: true,
                            maxValueLength: _maxLength,
                            child: TextField(
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                  color: Colours.color_546092, fontSize: 13),
                              maxLength: _maxLength,
                              maxLines: 10,
                              autofocus: false,
                              controller: _controller,
                              inputFormatters: _inputFormatters,
                              decoration: const InputDecoration(
                                hintText:
                                "和智能语音老师用英语交流真是非常不错的体验！希望开发出更好用的英语学习APP。",
                                hintStyle:
                                TextStyle(color: Colours.color_B7BFD9),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        Gaps.vGap33,
                        const Text("可上传图片说明（选填）",style: TextStyle(fontSize: 15,color: Colours.color_111B44),),
                        Gaps.vGap16,
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: JhAssetPicker(
                            assetType: AssetType.image,
                            maxAssets: 4-_presenter.imgAmount,
                            bgColor: Colors.white,
                            callBack: (assetEntityList) async {
                              // print('assetEntityList-------------');
                              // print(assetEntityList);
                              _presenter.selectedAssets.addAll(assetEntityList);
                              if (assetEntityList.isNotEmpty) {
                                List<File> mlist = [];
                                for(int i = 0;i<assetEntityList.length;i++){
                                  var asset = assetEntityList[i];
                                  var f = await asset.file;
                                  if(f!=null){
                                    mlist.add(f);
                                  }
                                }
                                _presenter.uploadImg(mlist);
                                // var asset = assetEntityList[0];
                                // print(await asset.file);
                                // print(await asset.originFile);
                                // var asd = await asset.file;
                                // if(asd!=null){
                                //   _presenter.uploadImg(asd);
                                // }

                              }
                              // print('assetEntityList-------------');

                            },
                          ),
                        ),

                        Gaps.vGap20,
                        const Text(
                          "方便联系您的方式",
                          style: TextStyle(
                              color: Colours.color_111B44,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Gaps.vGap16,
                        Container(
                          width: ScreenUtil.getScreenW(context),
                          padding: const EdgeInsets.only(
                            left: 13,
                          ),
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(13)),
                              color: Color(0x4D5B8BD2)),
                          child: TextField(
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                color: Colours.color_546092, fontSize: 13),
                            maxLines: 1,
                            controller: _contactController,
                            inputFormatters: _inputFormatters,
                            decoration: const InputDecoration(
                              hintText: "可输入电话或邮箱",
                              hintStyle: TextStyle(color: Colours.color_B7BFD9),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // const Expanded(child: Gaps.empty),
                        Gaps.vGap32,
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "客服邮箱：help@shenmo-ai.com ",
                            style: TextStyle(
                                fontSize: 10, color: Colours.color_546092),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "任何问题或举报，都可发送到邮箱，我们会尽快处理",
                            style: TextStyle(
                                fontSize: 10, color: Colours.color_546092),
                          ),
                        ),
                        Gaps.vGap20,
                        GestureDetector(
                          onTap: () {
                            _presenter.pushSuggest(_controller.text,_contactController.text);

                            // Toast.show(msg)
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colours.color_DA2FFF,
                                    Colours.color_0E90FF,
                                    Colours.color_00FFB4,
                                  ],
                                )),
                            // child: Center(
                            child: const Text(
                              "提交",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                    ,
                  ),
                )
              ],
            ),
          ),
        ));
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
    setState(() {

    });
  }



  @override
  void sendImgSuccess(List<SendImgResultDataData> mList) {
    _presenter.sendImgSuccess = false;

    for(int i = 0;i<mList.length;i++){
      _presenter.suggestImgStr = "${mList[i].filename},";
    }
    _presenter.refreshAssets.clear();
    if(_presenter.selectedAssets.length>4){
      for(int i = _presenter.selectedAssets.length-1;i>_presenter.selectedAssets.length-5;i--){
        _presenter.refreshAssets.add(_presenter.selectedAssets[i]);
      }
    } else {
      _presenter.refreshAssets.addAll(_presenter.selectedAssets);
    }
    bus.emit('refreshSelectImg',_presenter.refreshAssets);
  }
}
