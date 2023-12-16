
import 'package:flutter/material.dart';

import '../res/colors.dart';
import '../res/gaps.dart';
import '../routers/fluro_navigator.dart';
import '../util/image_utils.dart';

class CommonDialog extends StatefulWidget {

  final VoidCallback confirmPress;
  final VoidCallback cancelPress;
  final String confirmStr;
  final String cancelStr;
  final String contentStr;

  const CommonDialog(  {Key? key, required this.confirmPress,required this.cancelPress, this.confirmStr="确定", this.cancelStr="再想一想", required this.contentStr}) : super(key: key);

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child:
          Stack(
            children: [
              Container(
                padding:const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
                width: 330,
                height: 170,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white
                ),
              ),
              Container(
                padding:const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
                width: 330,
                height: 170,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colours.color_300EF4D1,
                          Colours.color_3053C5FF,
                          Colours.color_30E0AEFF,
                        ],
                        stops: [0,0.5,1]
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gaps.vGap30,

                    Text(widget.contentStr ?? "", style:const TextStyle(fontSize: 17, color: Colours.color_111B44,),),
                    Gaps.vGap24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            NavigatorUtils.goBack(context);
                            widget.cancelPress();
                          },
                          child: Container(
                            width: 125,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ImageUtils.getAssetImage(
                                    "confirm_bg1",),
                                  fit: BoxFit.fill
                              ),
                            ),

                            child: Center(
                              child:Text(widget.cancelStr, style:const TextStyle(fontSize: 13,color: Colours.color_3389FF),) ,
                            ) ,
                          ),
                        ),
                        Gaps.hGap15,
                        GestureDetector(
                          onTap: () async {
                            NavigatorUtils.goBack(context);
                            widget.confirmPress();
                          },
                          child: Container(
                            width: 125,
                            height:40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ImageUtils.getAssetImage(
                                    "cancel_bg1",),
                                  fit: BoxFit.fill
                              ),
                            ),
                            child: Center(
                              child: Text(widget.confirmStr,style: const TextStyle(fontSize: 13,color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
          ,
        )
    );;
  }
}
