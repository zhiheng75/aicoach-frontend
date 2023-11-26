import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:spokid/report/widget/radar_map.dart';
import 'package:spokid/widgets/my_app_bar.dart';
import 'package:spokid/widgets/my_scroll_view.dart';

import '../res/colors.dart';
import '../res/gaps.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/load_image.dart';

class MyReportPage extends StatefulWidget {
  const MyReportPage({Key? key}) : super(key: key);

  @override
  State<MyReportPage> createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // appBar: MyAppBar(),
        body:
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.color_00FFB4,
                    Colours.color_0E90FF,
                    Colours.color_DA2FFF,
                  ],
                )
              ),
              child: Column(
                children: [
                         const MyAppBar(
                            title: "口语学习日报",
                           backgroundColor: Colours.transflate,
                          ),
                  Expanded(
                      child:
                      MyScrollView(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        padding: EdgeInsets.only(left: 16,right: 16,top: 60),
                        children:[
                          one(),
                          CircularPercentIndicator(
                            radius: 90.0,
                            lineWidth: 5.0,
                            percent: 0.7,
                            center:const  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "176",
                                  style: TextStyle(fontSize: 50,color: Colours.color_00DBAF),
                                ),
                                Text("超过94%该年龄段用户"),
                                Text("满分为200分"),
                              ],
                            ),
                            progressColor: Colours.color_00DBAF,
                          ),
                          RadarMap(xx()),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadAssetImage("select_img",width: 20,height: 20,),
                              Text("对话内容解析",style: TextStyle(fontSize: 10,color: Colors.white),),
                              LoadAssetImage("select_img",width: 20,height: 20,),
                            ],
                          )
                          
                        ],
                      )
                  )

                ],
              ),
            )
        // Column(
        //   children:[
        //     one(),
        //     RadarMap(xx()),
        //
        //
        //   ],
        // )
        // MyScrollView(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   padding: EdgeInsets.only(left: 16,right: 16,top: 60),
        //   children:[
        //     one(),
        //     CircularPercentIndicator(
        //       radius: 90.0,
        //       lineWidth: 5.0,
        //       percent: 0.7,
        //       center: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(
        //             "176",
        //             style: TextStyle(fontSize: 50,color: Colours.color_00DBAF),
        //           ),
        //           Text("超过94%该年龄段用户"),
        //           Text("满分为200分"),
        //         ],
        //       ),
        //       progressColor: Colours.color_00DBAF,
        //     ),
        //     RadarMap(xx()),
        //
        //
        //   ],
        // )

        // Stack(
        //   children: [
        //      LoadAssetImage(
        //       "test_banner_img",
        //       height: ScreenUtil.getScreenH(context),
        //       fit: BoxFit.cover,
        //     ),
        //      Column(
        //       children: [
        //        const MyAppBar(
        //           title: "口语学习日报",
        //          backgroundColor: Colours.transflate,
        //         ),
        //
        //         MyScrollView(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           padding: EdgeInsets.only(left: 16,right: 16,top: 60),
        //           children:[
        //             one(),
        //             CircularPercentIndicator(
        //               radius: 90.0,
        //               lineWidth: 5.0,
        //               percent: 0.7,
        //               center: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Text(
        //                     "176",
        //                     style: TextStyle(fontSize: 50,color: Colours.color_00DBAF),
        //                   ),
        //                   Text("超过94%该年龄段用户"),
        //                   Text("满分为200分"),
        //                 ],
        //               ),
        //               progressColor: Colours.color_00DBAF,
        //             ),
        //             RadarMap(xx()),
        //
        //
        //           ],
        //         )
        //       ],
        //     )
        //
        //   ],
        // ),
      ),
    );
  }

  List<RadarBean> xx(){
    List<RadarBean> list =[];
     var a = RadarBean(70, "发音\n精准度");
     var b = RadarBean(99, "语法");
     var c = RadarBean(55, "用词\n标准度");
     var d = RadarBean(60, "完整度");
     var e = RadarBean(80, "流畅度");
     list.add(a);
     list.add(b);
     list.add(c);
     list.add(d);
     list.add(e);
     return list;
  }

  Widget one(){
    return Row(
      children: [
        LoadAssetImage("select_img",width: 20,height: 20,),
        Text("本次对话30"),
        Expanded(child: Gaps.empty),
        LoadAssetImage("select_img",width: 20,height: 20,),
        Text("2023-09-09"),
      ],
    );
  }
}

