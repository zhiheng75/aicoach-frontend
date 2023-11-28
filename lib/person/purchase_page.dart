import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';

import '../method/fluter_native.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../routers/fluro_navigator.dart';
import '../util/image_utils.dart';
import '../widgets/load_image.dart';
import '../widgets/my_app_bar.dart';

///购买
class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {

  bool itemOne = true;
  bool itemTwo = false;
  bool itemThree = false;

  bool wxPay = true;
  bool aliPay = false;

  bool agreeAgreement = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            const LoadAssetImage("purchase_bg_img"),
            Positioned(
              top: 35,
              child: IconButton(
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
                padding: const EdgeInsets.all(12.0),
                icon: Image.asset(
                  "assets/images/ic_back_black.png",
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: ScreenUtil.getScreenW(context),
              margin: const EdgeInsets.only(top: 220),
              padding: const EdgeInsets.only(top: Dimens.gap_dp23,
                  left: Dimens.gap_dp28,
                  right: Dimens.gap_dp28,),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white
              ),
              child:MyScrollView(
                children: [
                  GestureDetector(
                    onTap: (){
                      itemOne = true;
                      itemTwo = false;
                      itemThree = false;
                      setState(() {

                      });
                    },
                    child: purchaseItem(0,itemOne),
                  ),
                  Gaps.vGap20,
                  GestureDetector(
                    onTap: (){
                      itemOne = false;
                      itemTwo = true;
                      itemThree = false;
                      setState(() {

                      });
                    },
                    child: purchaseItem(1,itemTwo),
                  ),
                  Gaps.vGap20,
                  GestureDetector(
                    onTap: (){
                      itemOne = false;
                      itemTwo = false;
                      itemThree = true;
                      setState(() {

                      });
                    },
                    child: purchaseItem(2,itemThree),
                  ),

                  Gaps.vGap30,
                  GestureDetector(
                    onTap: (){
                      wxPay = true;
                      aliPay = false;
                      setState(() {

                      });
                    },
                    child: purchaseType(0,wxPay),
                  ),
                  Gaps.vGap30,
                  GestureDetector(
                    onTap: (){
                      wxPay = false;
                      aliPay = true;
                      setState(() {
                      });
                    },
                    child: purchaseType(1,aliPay),
                  ),

                  Gaps.vGap32,
                  GestureDetector(
                    onTap: (){
                      FlutterToNative.jumpToWechatPay();
                    },
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage("purchase_btn_img"),
                              fit: BoxFit.fill
                          )
                      ),
                      child:const Center(
                        child: Text("立即开通",style: TextStyle(color: Colors.white,fontSize: 16),),
                      ),
                    ),
                  ),
                  Gaps.vGap16,
                  GestureDetector(
                    onTap: (){
                      agreeAgreement=!agreeAgreement;
                      setState(() {

                      });
                    },
                    child: agreement(agreeAgreement),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///0包年，1包月，2年度会员
  Widget purchaseItem(int type,bool isSelect){
  return Stack(
      children: [
        Container(
          padding:const EdgeInsets.only(left: 26,right: 26,top: 10,bottom: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageUtils.getAssetImage(
                  isSelect==true ?"purchase_select_img":"purchase_unselect_img",),
                fit: BoxFit.fill
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.vGap15,
              purchaseItemTxt(type),
              Gaps.vGap13,
              const Text("24小时随时可学习，不限场景。",style: TextStyle(fontSize: Dimens.font_sp13,color:Colours.color_546092),),
            ],
          ),
        ),
        Visibility(
            visible: type == 0,
            child: const LoadAssetImage(
              "preferenti_img", width: 83, height: 20,))
        ,
      ],
    );
  }

  Widget purchaseItemTxt(int type){
    switch(type){
      case 0:
        return  Row(
          children: [
           const Text("连续包年",style: TextStyle(fontSize: 16,color: Colours.color_111B44,fontWeight: FontWeight.bold),),
            Expanded(
                child: Container(
                  margin:const EdgeInsets.only(left:5,right: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: ImageUtils.getAssetImage("auto_purchase_bg"),
                    fit: BoxFit.cover
              )),
              child: const Center(
                child: Text(
                  "自动续费，可随时取消",
                  style: TextStyle(
                      fontSize: Dimens.font_sp10, color: Colors.white),
                ),
              ),
            )),
            const Text("¥ 365元/年",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      case 1:
        return const Row(
          children: [
            Text("连续包月",style: TextStyle(fontSize: 16,color: Colours.color_111B44,fontWeight: FontWeight.bold),),
            Expanded(child: Gaps.empty),
             Text("¥ 48元/月",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      case 2:
        return const Row(
          children: [
            Text("年度会员",style: TextStyle(fontSize: 16,color: Colours.color_111B44,fontWeight: FontWeight.bold),),
            Expanded(child: Gaps.empty),
             Text("¥ 638元/年",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      default :
        return  Gaps.empty;
    }
  }

  ///支付方式
  Widget purchaseType(int type,bool isCheck){
    switch(type){
      case 0:
        return Row(
          children: [
            const LoadAssetImage("wechat_pay_img",width: 27,height: 27,),
            Gaps.hGap8,
            const Text("微信支付",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_111B44),),
            const Expanded(child: Gaps.empty),
            LoadAssetImage(isCheck==true?"select_img":"unselect_img",width: 17,height: 17,),
          ],
        );
      case 1:
        return Row(
          children: [
            const LoadAssetImage("alipay_img",width: 27,height: 27,),
            Gaps.hGap8,
            const Text("支付宝支付",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_111B44),),
            const Expanded(child: Gaps.empty),
            LoadAssetImage(isCheck==true?"select_img":"unselect_img",width: 17,height: 17,),
          ],
        );
      default:
        return Gaps.empty;
    }
  }

  Widget agreement(bool agree){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadAssetImage(agree==true ?"select_img":"unselect_img",width: 13,height: 13,),
        Gaps.hGap4,
        const Text("我已阅读并同意", style: TextStyle(fontSize: 10, color: Colours.color_546092,),),
        GestureDetector(
          onTap: () {
            NavigatorUtils.goWebViewPage(context, "会员协议",
                "http://www.shenmo-ai.com/tos/");
          },
          child: const Text(" 会员协议 ", style: TextStyle(
              color: Colours.color_546092,
              fontSize: 10, decoration: TextDecoration.underline)),
        ),
        const Text("和", style: TextStyle(fontSize: 10, color: Colours.color_546092,),),
        GestureDetector(
          onTap: () {
            NavigatorUtils.goWebViewPage(
                context, " 续费规则", "http://www.shenmo-ai.com/agreements");
          },
          child: const Text(" 续费规则 ", style: TextStyle(
            color: Colours.color_546092,
              fontSize: 10, decoration: TextDecoration.underline),),
        ),
      ],
    );
  }

}
