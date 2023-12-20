
import 'package:Bubble/home/entity/base_config_entity.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/person/entity/wx_pay_entity.dart';
import 'package:Bubble/person/presneter/purchase_presenter.dart';
import 'package:Bubble/person/presneter/purchase_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../routers/fluro_navigator.dart';
import '../util/image_utils.dart';
import '../widgets/load_image.dart';
import 'entity/my_good_list_entity.dart';

///购买
class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> with BasePageMixin<PurchasePage,PurchasePresenter>,
    AutomaticKeepAliveClientMixin<PurchasePage> implements PurchaseView {

  bool itemOne = true;
  bool itemTwo = false;
  bool itemThree = false;

  bool wxPay = true;
  bool aliPay = false;

  bool agreeAgreement = false;
  late PurchasePresenter _purchasePresenter;
  int selectIndex = 0;
  String category="";





  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            const LoadAssetImage("purchase_bg_img"),
            Positioned(
              top: 35,
              left: 15,
              child:
              IconButton(
                onPressed: () async {
                  NavigatorUtils.goBack(context);
                },
                icon: Image.asset(
                  'assets/images/ic_back_white.png',
                  width: 10,
                  height: 16,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              height: 60,
              margin: const EdgeInsets.only(top: 140,left: 120,right: 50),
              child: RichText(
                  text: TextSpan(
                      children: <TextSpan>[
                         TextSpan(text: category,style:  TextStyle(fontSize: Dimens.font_sp13,color: Colors.white)),
                         // TextSpan(text: "\n每天低至1块钱",style: const TextStyle(fontSize: 13,color: Colours.color_00DBAF)),
                      ]
                  )),
            )
            ,

            Container(
              width: ScreenUtil().screenWidth,
              margin: const EdgeInsets.only(top: 220),
              padding: const EdgeInsets.only(left: Dimens.gap_dp28,
                  right: Dimens.gap_dp28,),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white
              ),
              child: _purchasePresenter.goodList.isNotEmpty
                  ? MyScrollView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _purchasePresenter.goodList.length,
                            physics:const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  selectIndex = index;
                                  for(int i = 0;i<_purchasePresenter.goodList.length;i++){
                                    _purchasePresenter.goodList[i].isSelect = false;
                                  }
                                  _purchasePresenter.goodList[index].isSelect = true;
                                  setState(() {

                                  });
                                },
                                child: purchaseItem(_purchasePresenter.goodList[index]),
                              )
                                ;
                            }),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {
                            wxPay = true;
                            aliPay = false;
                            setState(() {});
                          },
                          child: purchaseType(0, wxPay),
                        ),
                        Gaps.vGap30,
                        GestureDetector(
                          onTap: () {
                            wxPay = false;
                            aliPay = true;
                            setState(() {});
                          },
                          child: purchaseType(1, aliPay),
                        ),
                SizedBox(height: 40.h),
                        GestureDetector(
                          onTap: () {
                            if(agreeAgreement){

                              if(Device.isAndroid){
                                if(wxPay){
                                  _purchasePresenter.wxChatPay(_purchasePresenter.goodList[selectIndex].id,
                                      _purchasePresenter.goodList[selectIndex].price,true);
                                }else{
                                  _purchasePresenter.aliPay(_purchasePresenter.goodList[selectIndex].id,
                                      _purchasePresenter.goodList[selectIndex].price,true);
                                }
                              }else {

                              }

                            }else{
                              Toast.show("请同意会员协议和续费规则");
                            }
                          },
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.getAssetImage(
                                        "purchase_btn_img"),
                                    fit: BoxFit.fill)),
                            child: const Center(
                              child: Text(
                                "立即开通",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Gaps.vGap16,
                        GestureDetector(
                          onTap: () {
                            agreeAgreement = !agreeAgreement;
                            setState(() {});
                          },
                          child: agreement(agreeAgreement),
                        ),
                        Gaps.vGap40,
                      ],
                    )
                  : Container(
                color: Colors.white,
                height: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  ///0包年，1包月，2年度会员
  Widget purchaseItem(MyGoodListEntity bean){
  return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding:const EdgeInsets.only(left: 22,right: 22,top: 10,bottom: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageUtils.getAssetImage(
                  bean.isSelect==true ?"purchase_select_img":"purchase_unselect_img",),
                fit: BoxFit.fill
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.vGap15,
              purchaseItemTxt2(bean),
              Gaps.vGap13,
              Text(bean.desc,style: TextStyle(fontSize: Dimens.font_sp13,color:Colours.color_546092),),
            ],
          ),
        ),
        Visibility(
            visible: bean.recommend,
            child: const LoadAssetImage(
              "preferenti_img", width: 83, height: 20,))
        ,
      ],
    );
  }

  Widget purchaseItemTxt2(MyGoodListEntity bean){
    return Row(
      children: [
         Text(
          bean.name,
          style: const TextStyle(
              fontSize: 16,
              color: Colours.color_111B44,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: bean.recommend==true? Row(
                    children: [
                         Container(
                          constraints:BoxConstraints(maxWidth: 125.w) ,
                          alignment: Alignment.center,
                          margin:  EdgeInsets.only(left: Dimens.w_dp5, right: Dimens.w_dp5),
                          padding:  EdgeInsets.only(
                              left: Dimens.w_dp7, right:Dimens.w_dp7, top:Dimens.h_dp3, bottom: Dimens.h_dp3),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.gap_dp3)),
                              color: Colours.color_00B4DA),
                          child: Text(
                            "自动续费，可随时取消",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: Dimens.font_sp10,
                                color: Colors.white),
                          ),
                        ),
                    ],
                  )
            :Gaps.empty),
         Text(
          "¥ ${viewPrice(bean.price)}元/${bean.unit}",
          style:  TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
      ],
    );
  }


  String viewPrice(double price){
    if(price == price.toInt()){
      return price.toInt().toString();
    }else{
      return price.toString();
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
            Expanded(child: Text("微信支付",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_111B44),)),
            LoadAssetImage(isCheck==true?"select_img":"unselect_img",width: 17,height: 17,),
          ],
        );
      case 1:
        return Row(
          children: [
            const LoadAssetImage("alipay_img",width: 27,height: 27,),
            Gaps.hGap8,
             Expanded(child:  Text("支付宝支付",style: TextStyle(fontSize: Dimens.font_sp13,color: Colours.color_111B44),)),
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

  @override
  PurchasePresenter createPresenter() {
    _purchasePresenter = PurchasePresenter();
    return _purchasePresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void goodListData(List<MyGoodListEntity> bean) {

    setState(() {

    });
  }


  // int ERR_OK = 0;
  //        int ERR_COMM = -1;
  //        int ERR_USER_CANCEL = -2;
  //        int ERR_SENT_FAILED = -3;
  //        int ERR_AUTH_DENIED = -4;
  //        int ERR_UNSUPPORT = -5;
  //        int ERR_BAN = -6;

  @override
  void getWXPayMsg(WxPayDataData bean) {


  }

  @override
  void paySuccess() {
    NavigatorUtils.push(context, HomeRouter.homePage,clearStack: true);
  }

  @override
  void getBaseConfig(BaseConfigDataData data) {
    if(data.key=="rechargeSlogan"){
      category = data.value;
      setState(() {

      });
    }
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
                  child:  Center(
                    child: Text(
                      "自动续费，可随时取消",
                      style: TextStyle(
                          fontSize: Dimens.font_sp10, color: Colors.white),
                    ),
                  ),
                )),
            Text("¥ 365元/年",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      case 1:
        return  Row(
          children: [
            const Text("连续包月",style: TextStyle(fontSize: 16,color: Colours.color_111B44,fontWeight: FontWeight.bold),),
            const  Expanded(child: Gaps.empty),
            Text("¥ 48元/月",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      case 2:
        return  Row(
          children: [
            const Text("年度会员",style: TextStyle(fontSize: 16,color: Colours.color_111B44,fontWeight: FontWeight.bold),),
            const Expanded(child: Gaps.empty),
            Text("¥ 638元/年",style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.color_925DFF,fontWeight: FontWeight.bold),),
          ],
        );
      default :
        return  Gaps.empty;
    }
  }
}
