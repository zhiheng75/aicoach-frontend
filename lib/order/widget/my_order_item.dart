import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../../util/image_utils.dart';
import '../../widgets/round_picture_widget.dart';

class MyOrderItem extends StatefulWidget {

  final Function _press;


  const MyOrderItem(this._press,{Key? key, }) : super(key: key);

  @override
  State<MyOrderItem> createState() => _MyOrderItemState();
}

class _MyOrderItemState extends State<MyOrderItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget._press();
      },
      child: Container(
        margin:const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(
              color: Colours.color_5B8BD2,
              width: 0.4
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 22),
              height: 100,
              width: 133,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage(
                      "order_record_img",
                    ),
                    fit: BoxFit.fill)
              ),
              // child: Center(
                child: Column(
                  children: [
                    Text("连续包年",style: TextStyle(fontSize: Dimens.font_sp22,color: Colors.white),),
                    Text("¥ 365元/年",style: TextStyle(fontSize: Dimens.font_sp13,color: Colors.white),)
                  ],
                ),
              // ),
            ),




            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 17,top: 10,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                "订 单 号：123 ",
                                style: TextStyles.text12_11B44,
                              )),
                          LoadAssetImage("copy_img",width: 9,height: 10,)
                          
                        ],
                      ),
                      Gaps.vGap5,
                      Text(
                        "交易金额：123",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Text(
                        "交易时间：",
                        style: TextStyles.text12_546092,
                      ),
                      Gaps.vGap5,
                      Row(
                        children: [
                          Text(
                            "支付方式：  ",
                            style: TextStyles.text12_546092,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            Gaps.hGap10,
          ],
        ),
      ),
    );
  }
}
