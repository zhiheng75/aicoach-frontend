import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/report/presenter/my_report_presenter.dart';
import 'package:Bubble/report/view/my_report_view.dart';
import 'package:Bubble/report/widget/conversation_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:Bubble/report/widget/radar_map.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/widgets/my_app_bar.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';

import '../person/entity/study_list_entity.dart';
import '../res/colors.dart';
import '../res/gaps.dart';
import '../util/image_utils.dart';
import '../util/time_utils.dart';
import '../widgets/load_image.dart';

class MyReportPage extends StatefulWidget {

  final StudyListDataData  entity;

  const MyReportPage(this.entity,{Key? key}) : super(key: key);

  @override
  State<MyReportPage> createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage>
    with
        BasePageMixin<MyReportPage, MyReportPresenter>,
        AutomaticKeepAliveClientMixin<MyReportPage>
    implements MyReportView {
  late MyReportPresenter _myReportPresenter;

  @override
  void initState() {
    super.initState();
    _myReportPresenter.getReport(widget.entity.sessionId);
  }

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
            Colours.color_00FFB4,
            Colours.color_0E90FF,
            Colours.color_DA2FFF,
          ],
        )),
        child: Column(
          children: [
            const MyAppBar(
              backImgColor: Colors.white,
              centerTitle: "口语学习日报",
              backgroundColor: Colours.transflate,
            ),
            Expanded(
                child: MyScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ImageUtils.getAssetImage(
                          "report_white_board_img",
                        ),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: [
                      talkAmount(
                          "---", TimeUtils.formatDateYMDTime(1630399935000)),
                      Gaps.vGap50,
                      CircularPercentIndicator(
                        radius: 95.0,
                        lineWidth: 5.0,
                        percent: 0.7,
                        center:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "76",
                              style: TextStyle(
                                  fontSize: 60, color: Colours.color_00DBAF,fontWeight: FontWeight.bold),
                            ),

                            RichText(
                                text: TextSpan(
                                    text: '超过',
                                    style:  TextStyle(
                                        color: Colours.color_00DBAF, fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "--%",
                                          style: const TextStyle(
                                              color: Colours.color_925DFF,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: "该年龄段用户",
                                          style:
                                          TextStyle(color: Colours.color_00DBAF, fontSize: 15)),
                                    ])),


                            // Text("超过94%该年龄段用户"),
                            Gaps.vGap8,
                            const Text("满分为100分",style: TextStyle(fontSize: 10,color: Colours.color_BABFD6),),


                          ],
                        ),
                        progressColor: Colours.color_00DBAF,
                      ),
                      RadarMap(_myReportPresenter.list),
                    ],
                  ),
                ),
                Gaps.vGap32,
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Center(
                        child: LoadAssetImage(
                          "divder_img",
                          width: 200,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "对话内容解析",
                        style: TextStyle(
                            fontSize: Dimens.font_sp15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 30),
                  margin: const EdgeInsets.symmetric(
                    vertical: 25.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: Colors.white,
                  ),
                  // child:Text("sad"),
                  child: const ConversationAnalysis(
                    sessionId: '567710cca1474b53bda63b0d2c5eb44d',
                  ),
                )
              ],
            ))
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

  List<RadarBean> xx() {
    List<RadarBean> list = [];
    var a = RadarBean(70, "发音\n精准度");
    var b = RadarBean(99, "语法");
    var c = RadarBean(55, "用词\n标准度");
    var d = RadarBean(60, "完整度");
    // var e = RadarBean(80, "流畅度");
    list.add(a);
    list.add(b);
    list.add(c);
    list.add(d);
    // list.add(e);
    return list;
  }

  Widget talkAmount( amount, String time) {
    return Row(
      children: [
        const LoadAssetImage(
          "talk_amount_img",
          width: 18,
          height: 18,
        ),
        Gaps.hGap6,
        Expanded(
            flex: 2,
            child: RichText(
                text: TextSpan(
                    text: '本次对话',
                    style: const TextStyle(
                        color: Colours.color_111B44, fontSize: 13),
                    children: <TextSpan>[
                  TextSpan(
                      text: "$amount",
                      style: const TextStyle(
                          color: Colours.color_00DFB3,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text: "个",
                      style:
                          TextStyle(color: Colours.color_111B44, fontSize: 13)),
                ]))),
        const LoadAssetImage(
          "talk_time_img",
          width: 18,
          height: 18,
        ),
        Gaps.hGap6,
        Expanded(
            child: Text(time,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colours.color_111B44,
                  fontSize: 13,
                ))),
      ],
    );
  }

  @override
  MyReportPresenter createPresenter() {
    _myReportPresenter = MyReportPresenter();
    return _myReportPresenter;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void getScore(List<RadarBean> list) {
    setState(() {});
  }
}
