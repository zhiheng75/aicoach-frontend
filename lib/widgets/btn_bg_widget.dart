import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/image_utils.dart';

class BtnWidget extends StatelessWidget {

  final String btnImg;
  final String btnTxt;
  final TextStyle? txtStyle;
  final VoidCallback press;


 const BtnWidget(this.btnImg,this.btnTxt,this.press,{Key? key,this.txtStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        press();
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration:  BoxDecoration(
            image:DecorationImage(
                image: ImageUtils.getAssetImage(
                    btnImg),
                fit: BoxFit.fill)
        ),
        // child: Center(
        child:  Text(
          btnTxt,
          style:txtStyle ?? TextStyle(fontSize: 16.sp,color: Colors.white),
        ),
      ),
    )

      ;
  }
}
