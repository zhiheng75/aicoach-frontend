import 'package:Bubble/order/order_router.dart';
import 'package:Bubble/person/person_router.dart';
import 'package:Bubble/person/presneter/person_center_presenter.dart';
import 'package:Bubble/person/view/person_center_view.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/setting/setting_router.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../login/entity/login_info_entity.dart';
import '../login/entity/my_user_info_entity.dart';
import '../login/entity/user_info_entity.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../res/styles.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/load_image.dart';

class PersonalCenterPage extends StatefulWidget {
  const PersonalCenterPage({Key? key}) : super(key: key);

  @override
  State<PersonalCenterPage> createState() => _PersonalCenterPageState();
}

class _PersonalCenterPageState extends State<PersonalCenterPage>
    with
        BasePageMixin<PersonalCenterPage, PersonalCenterPresenter>,
        AutomaticKeepAliveClientMixin<PersonalCenterPage>
    implements PersonCenterView {

  String _headerImg = "";
  String _userName = "";
  late PersonalCenterPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child:Scaffold(
            body:Stack(
              children: [
                const LoadAssetImage("personal_center_bg"),
                Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                NavigatorUtils.goBack(context);
                              },
                              padding: const EdgeInsets.all(12.0),
                              icon: Image.asset(
                                "assets/images/ic_back_black.png",
                                color: Colors.white,
                              ),
                            ),
                            const Expanded(child: Gaps.empty),
                            IconButton(
                              onPressed: () {
                                NavigatorUtils.push(context, SettingRouter.settingPage);
                              },
                              padding: const EdgeInsets.all(12.0),
                              icon: Image.asset(
                                "assets/images/setting_img.png",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      Container(
                        margin:const EdgeInsets.only(left: 18,right: 18,top: 15),
                        child: headerItem(),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: ScreenUtil.getScreenW(context),
                  height: ScreenUtil.getScreenH(context),
                  margin: const EdgeInsets.only(top: 220),
                  padding: const EdgeInsets.only(top: Dimens.gap_dp23,
                    left: Dimens.gap_dp28,
                    right: Dimens.gap_dp28,),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colours.color_0EF4D1,
                            Colours.color_53C5FF,
                            Colours.color_E0AEFF,
                          ],
                          stops: [0.0,0.2,1]
                      ),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white
                  ),
                  child: MyScrollView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30,bottom: 17),
                          padding: const EdgeInsets.all(24),
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        child: Row(
                          children: [
                            Expanded(child:studyItem("学习时长","29","min") ),
                            Expanded(child: studyItem("完成对话","3000","个")),
                            Expanded(child:Column(
                              children: [
                                const Text("学习排行", style: TextStyles.text12_546092,),
                                Gaps.vGap4,
                                RichText(text:
                                TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(text: "优胜",style:  TextStyle(fontSize: 10,color: Colours.color_546092)),
                                      TextSpan(text: "96%",style: const TextStyle(fontSize: 17,color: Colours.color_00DBAF)),
                                    ]
                                ))
                              ],
                            ) ),

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          NavigatorUtils.push(context, PersonalRouter.personalPurchase);
                        },
                        child: const LoadAssetImage("vip_img",fit: BoxFit.cover,),
                      ),

                      GestureDetector(
                        onTap: (){
                          NavigatorUtils.push(context, PersonalRouter.personalStudyReport);
                        },
                        child: personItem(0,"学习报告"),
                      ),
                      Gaps.vGap30,
                      GestureDetector(
                        onTap: (){
                          NavigatorUtils.push(context, MyOrderRouter.myOrder);
                        },
                        child: personItem(1,"购买记录"),
                      ),
                      Gaps.vGap30,
                      GestureDetector(
                        onTap: (){
                          NavigatorUtils.push(context, PersonalRouter.personalSuggestion);
                        },
                        child: personItem(2,"意见反馈"),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }



  Widget headerItem(){
    return  Row(
      children: [
        Center(
          child: ClipOval(
            child: LoadImage(
              _headerImg,
              height: 74,
              width: 74,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Gaps.hGap16,
        Expanded(
            child:Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Toast.show("编辑");
                  },
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      Text(_userName,style: TextStyle(fontSize: 17,color: Colors.white),),
                      Gaps.hGap4,
                      const LoadAssetImage("edit_img",width: 14,height: 14,)
                    ],
                  ),
                ),
                RichText(text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "你的周学习活跃指数为",style: TextStyle(fontSize: Dimens.font_sp11,color: Colors.white)),
                      TextSpan(text: "95%",style: TextStyle(fontSize: Dimens.font_sp11,color: Colours.color_00DFB3)),
                      TextSpan(text: ",前边还有",style: TextStyle(fontSize: Dimens.font_sp11,color: Colors.white)),
                      TextSpan(text: "49213",style: TextStyle(fontSize: Dimens.font_sp11,color: Colours.color_00DFB3)),
                      TextSpan(text: "位保持每天学习，加油赶超~",style: TextStyle(fontSize: Dimens.font_sp11,color: Colors.white)),
                    ]
                ))

              ],
            )
        )

      ],
    );
  }

  Widget studyItem(String title,String content1,String content2){
    return Column(
      children: [
        Text(title, style: TextStyles.text12_546092,),
        Gaps.vGap4,
        RichText(text:
        TextSpan(
            children: <TextSpan>[
              TextSpan(text: content1,style: const TextStyle(fontSize: 17,color: Colours.color_00DBAF)),
              TextSpan(text: content2,style: const TextStyle(fontSize: 10,color: Colours.color_546092)),
            ]
        ))
      ],
    );
  }


  Widget personItem(int type,String name){
    return Row(
      children: [
        imageWidget(type),
        Gaps.hGap7,
        Text(name,style:const TextStyle(fontSize: 15,color: Colours.color_111B44),),
        const Expanded(child: Gaps.empty),
        Gaps.hGap6,
        const LoadAssetImage(
          "to_next_img",
          width: 5,
          height: 9,
        ),
      ],
    );
  }

  Widget imageWidget(int type){
    switch(type){
      case 0:
        return const  LoadAssetImage("study_report_img",width: 20,height: 20,);
      case 1:
        return const LoadAssetImage("purchase_record_img",width: 20,height: 20,);
      case 2:
        return const LoadAssetImage("issue_img",width: 20,height: 20,);
      default:
        return Gaps.empty;
    }
  }

  @override
  PersonalCenterPresenter createPresenter() {
    _presenter = PersonalCenterPresenter();
    return _presenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void getUserInfo(LoginInfoDataData data) {
    _headerImg = data.headimgurl;
    _userName = data.nickname;
    setState(() {

    });
  }
}
