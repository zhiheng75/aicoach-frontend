
import 'package:Bubble/mvp/mvps.dart';

import '../widget/radar_map.dart';

abstract class MyReportView implements IMvpView{
  void getScore(List<RadarBean> list);
}