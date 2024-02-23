import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/btn_bg_widget.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:Bubble/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvitationCodePage extends StatefulWidget {
  const InvitationCodePage({super.key});

  @override
  State<InvitationCodePage> createState() => _InvitationCodePageState();
}

class _InvitationCodePageState extends State<InvitationCodePage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  void onBack() {
    _nodeText1.unfocus();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              _nodeText1.unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageUtils.getAssetImage(
                          "login_bg_img"), //splash_bg//login_bg_img
                      fit: BoxFit.fill)),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MyOnlyImgBar(
                    //     alignment: Alignment.centerLeft,
                    //     backgroundColor: Colours.transflate,
                    //     width: Dimens.w_dp32,
                    //     height: Dimens.h_dp32,
                    //     actionUrl: "round_close_img",
                    //     onActionPress: () {
                    //       NavigatorUtils.goBack(context);
                    //     }),
                    XTCupertinoNavigationBar(
                      backgroundColor: Color.fromRGBO(1, 1, 1, 0),
                      border: null,
                      padding: EdgeInsetsDirectional.zero,
                      leading: NavigationBackWidget(onBack: onBack),
                      middle: const Text(
                        "邀请码",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    // Gaps.vGap20,
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: Dimens.h_dp40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.h_dp40),
                        color: Colors.white70,
                      ),
                      child: Row(
                        children: [
                          Gaps.hGap16,
                          Expanded(
                            child: MyTextField(
                              key: const Key('phone'),
                              txtStyle: const TextStyle(
                                fontSize: 20,
                                color: Colours.color_001652,
                              ),
                              hintStyle: const TextStyle(
                                  fontSize: 20, color: Colours.color_001652),
                              focusNode: _nodeText1,
                              controller: _phoneController,
                              maxLength: 11,
                              // keyboardType: TextInputType.phone,
                              hintText: "请输入邀请码",
                              underLineColor: Colours.color_00,
                              countDownColor: Colours.color_001652,
                            ),
                          ),
                          Gaps.hGap16,
                        ],
                      ),
                    ),
                    const Text(
                      "被邀请用户可获得15分钟的加赠体验时长",
                      style: TextStyle(
                        fontSize: 15.0,
                        // fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        // height: 18.0 / 15.0,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      // height: Dimens.h_dp40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                      ),
                      child: Column(
                        children: [
                          const LoadAssetImage(
                            "tips_icon",
                            width: 40,
                            height: 40,
                          ),
                          Gaps.vGap12,
                          const Text(
                            "温馨提示",
                            style: TextStyle(
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                              // height: 18.0 / 15.0,
                            ),
                          ),
                          Gaps.vGap12,
                          const Text(
                            "1、下载APP后，1天内可输入邀请码，超过1天不可输入邀请码； \n2、一个用户账户，只能输入一次邀请码。已输入过邀请码的账户，换绑其他手机号，也无法再次输入其他邀请码； \n3、禁用非法手机号、非法软件进行邀请码输入，这种情况下不仅无法输入邀请码，还会被系统记录黑名单； \n4、如有疑问，可通过客服邮箱咨询和解决 客服邮箱：help@shenmo-ai.com",
                            style: TextStyle(
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                              // height: 18.0 / 15.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Gaps.vGap50,
                    ),
                    SizedBox(
                      width: 260,
                      child: BtnWidget(
                          "btn_bg_img",
                          "提交",
                          txtStyle: TextStyle(
                              color: Colours.color_001652,
                              fontSize: Dimens.font_sp18),
                          () {}),
                    ),
                    Gaps.vGap50,
                  ]),
            ),
          ),
        ));
  }
}
