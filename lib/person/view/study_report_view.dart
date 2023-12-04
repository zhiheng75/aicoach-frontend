
import 'package:Bubble/mvp/mvps.dart';

import '../entity/study_list_entity.dart';

abstract class StudyReportView implements IMvpView{
void studyListInfo(List<StudyListDataData> list);

}