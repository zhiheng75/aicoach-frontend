import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/setting/widgets/update_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/setting/presenter/setting_presenter.dart';
import 'package:Bubble/setting/view/setting_view.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dialog/common_dialog.dart';
import '../login/entity/login_info_entity.dart';
import '../loginManager/login_manager.dart';
import '../method/fluter_native.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../util/image_utils.dart';
import '../widgets/my_app_bar.dart';
import 'entity/updata_info_entity.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with
        BasePageMixin<SettingPage, SettingPresenter>,
        AutomaticKeepAliveClientMixin<SettingPage>
    implements SettingView {

  late SettingPresenter _settingPresenter;
  bool mHasNewVersion = false;

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(

          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colours.color_00E6D0,
                  Colours.color_006CFF,
                  Colours.color_D74DFF,
                ],
                stops: [0.0,0.2,1]
              )
          ),
          child: Column(
            children: [
              const MyAppBar(
                centerTitle: "设置",
                backImgColor: Colors.white,
                backgroundColor: Colours.transflate,
              ),
              Expanded(
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    padding:const EdgeInsets.only(top: Dimens.gap_dp23,left: Dimens.gap_dp28,right:Dimens.gap_dp28,bottom: Dimens.gap_dp40),
                    decoration:const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20)),
                        color: Colors.white
                    ),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child:   Text(
                              "账户绑定",
                              style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  color: Colours.color_111B44),
                            )),
                        Gaps.vGap20,
                        const Divider(
                          height: Dimens.gap_dp1,
                          color: Colours.color_5B8BD2,
                        ),
                        Gaps.vGap20,
                        GestureDetector(
                          onTap: (){
                            NavigatorUtils.pushResult(context, LoginRouter.changeBindPhonePage,
                                arguments: _settingPresenter.userInfo, (result) {
                                  setState(() {});
                                });
                          },
                          child:  phoneBindState(0,"手机号",_settingPresenter.hasBindPhone),
                        ),

                        Gaps.vGap20,
                        const Divider(
                          height: Dimens.gap_dp1,
                          color: Colours.color_5B8BD2,
                        ),
                        Gaps.vGap20,

                        GestureDetector(
                          onTap: (){
                            if(_settingPresenter.hasBindWX) {
                              _showAboutWXDialog();

                            }else{
                              // _settingPresenter.bindWx();
                              FlutterToNative.jumpToWechatLogin().then((value) => {
                                // _wechatCode = value,
                                // Log.e("===========>$_wechatCode"),

                                _settingPresenter.getWxInfo(value)
                              });
                            }
                          },
                          child: bindState(1,"微信",_settingPresenter.hasBindWX),
                        ),
                        Gaps.vGap20,
                        const Divider(
                          height: Dimens.gap_dp1,
                          color: Colours.color_5B8BD2,
                        ),
                        Gaps.vGap20,
                        // bindState(2,"QQ",false),
                        // Gaps.vGap20,
                        // const Divider(
                        //   height: Dimens.gap_dp1,
                        //   color: Colours.color_5B8BD2,
                        // ),
                        // Gaps.vGap20,
                        GestureDetector(
                          onTap: (){
                            _settingPresenter.getUpdate(true);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                 Text(
                                  "版本升级检测",
                                  style: TextStyle(
                                      fontSize: Dimens.font_sp16,
                                      color: Colours.color_111B44),
                                ),
                                Gaps.hGap6,
                                Visibility(
                                  visible: mHasNewVersion,
                                  child:const LoadAssetImage("had_new_version_img",width: 33,height: 13,),),
                                const Expanded(child: Gaps.empty),
                                Text("${_settingPresenter.appVersion}版本",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_546092),),
                                Gaps.hGap6,
                                const LoadAssetImage(
                                  "to_next_img",
                                  width: 5,
                                  height: 9,
                                )
                              ],
                            ),
                          ),
                        ),
                        Gaps.vGap20,
                        const Expanded(child: Gaps.empty),

                        GestureDetector(
                          onTap: (){
                            LoginManager.toLoginOut();
                            NavigatorUtils.push(context, HomeRouter.homePage);
                          },
                          child: Container(
                            width: 400,
                            height: 46,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ImageUtils.getAssetImage(
                                    "login_out_bg_img",),
                                  fit: BoxFit.fill
                              ),
                            ),
                            child:  Center(
                              child: Text("退出登录", style: TextStyle(
                                  fontSize: Dimens.font_sp17,
                                  color: Colours.color_3389FF),),
                            ),
                          ),
                        ),
                        Gaps.vGap20,
                         Text("京ICP备2023024660号-1",style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.color_546092),)
                      ],
                    ) ,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }



  Widget phoneBindState(int type,String name,bool hasBind){
    return Row(
      children: [
        imageWidget(type),
        Gaps.hGap7,
        Text(name,style:const TextStyle(fontSize: 15,color: Colours.color_111B44),),
        const Expanded(child: Gaps.empty),
        Text(
          hasBind ? "去换绑" : "去绑定",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_546092),
        ),
        Gaps.hGap6,
        Visibility(
          visible: !hasBind,
          child: const LoadAssetImage(
            "to_next_img",
            width: 5,
            height: 9,
          ),
        )
      ],
    );
  }

  ///1（微信）2（qq）
  Widget bindState(int type,String name,bool hasBind){
    return Row(
      children: [
        imageWidget(type),
        Gaps.hGap7,
        Text(name,style:const TextStyle(fontSize: 15,color: Colours.color_111B44),),
        const Expanded(child: Gaps.empty),
        Text(
          hasBind ? "已绑定" : "去绑定",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_546092),
        ),
        Gaps.hGap6,
        Visibility(
            visible: !hasBind,
            child: GestureDetector(
              onTap: () {
                Toast.show("去绑定");
              },
              child: const LoadAssetImage(
                "to_next_img",
                width: 5,
                height: 9,
              ),
            ))
      ],
    );
  }

  Widget imageWidget(int type){
    switch(type){
      case 0:
       return const  LoadAssetImage("bind_phone_img",width: 20,height: 20,);
      case 1:
        return const LoadAssetImage("bind_wechat_img",width: 20,height: 20,);
      case 2:
        return const LoadAssetImage("bind_qq_img",width: 20,height: 20,);
      default:
        return Gaps.empty;
    }
  }


  @override
  void getUserInfo(LoginInfoDataData data) {
    setState(() {

    });
  }

  @override
  SettingPresenter createPresenter() {
    _settingPresenter = SettingPresenter();
    return _settingPresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {

    Toast.show(msg);
  }

  @override
  void sendSuccess(String s) {
    Toast.show(s);
    setState(() {

    });
  }

  @override
  void wechatFail(String msg) {
    Toast.show(msg);
  }

  @override
  void wechatSuccess() {

  }

  void _showAboutWXDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CommonDialog(
              contentStr: "要解除与微信的绑定吗？",
              confirmPress: () {
                _settingPresenter.unbindWx();
              },
              cancelPress: () {},
            ));
  }

  @override
  void getAppInfo(UpdataInfoDataData data) {
    _showUpdateDialog(data);
  }


  void _showUpdateDialog(UpdataInfoDataData data) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) =>  UpdateDialog(data)
    );
  }

  @override
  void viewLocalAppName(String appName) {
    setState(() {

    });
  }

  @override
  void hasNewVersion(hasNew) {
    mHasNewVersion = hasNew;
    if(hasNew){
      setState(() {

      });
    }
  }
}
