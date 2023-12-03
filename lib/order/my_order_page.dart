import 'package:Bubble/order/persent/my_order_presenter.dart';
import 'package:Bubble/order/view/my_order_view.dart';
import 'package:Bubble/order/widget/my_order_item.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../res/dimens.dart';
import '../util/clip_board_tool.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/state_layout.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with
        BasePageMixin<MyOrderPage, MyOrderPresenter>,
        AutomaticKeepAliveClientMixin<MyOrderPage>
    implements MyOrderView {
  late MyOrderPresenter _myOrderPresenter;




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
                  stops: [
                0.0,
                0.2,
                1
              ])),
          child: Column(
            children: [
              const MyAppBar(
                centerTitle: "购买记录",
                backImgColor: Colors.white,
                backgroundColor: Colours.transflate,
              ),
              Expanded(
                  child: _myOrderPresenter.mList.isNotEmpty?

                  Container(
                    width: ScreenUtil.getScreenW(context),
                    padding:const EdgeInsets.only(left: Dimens.gap_dp28,right:Dimens.gap_dp28),
                    decoration:const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20)),
                        color: Colors.white
                    ),
                    child: ListView.builder(
                        shrinkWrap:true,
                        itemCount: 20,
                        itemBuilder: (context,index){
                          return MyOrderItem( (){
                            // ClipboardTool.getData().then((value) => {
                            //
                            // }).catchError((e){
                            //   Toast.show(e.toString());
                            // });
                            ClipboardTool.setDataToastMsg("detasd");

                          });

                        }),
                  ) :const StateLayout(
                    type: StateType.empty,
                    hintText: "   你还没有购买记录\n现在开始升级体验吧~",
                  ))
              ,
            ],
          ),
        )));
  }

  @override
  MyOrderPresenter createPresenter() {
    _myOrderPresenter = MyOrderPresenter();
    return _myOrderPresenter;
  }

  @override
  bool get wantKeepAlive => true;
}
