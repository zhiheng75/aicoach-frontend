
import '../../mvp/mvps.dart';
import 'package:Bubble/person/entity/mistake_records_bean.dart';

abstract class ErrorCorrectionPageView implements IMvpView {
  void sendSuccess(MistakeRecordsBean msg);
  void sendFail(String msg);
}
