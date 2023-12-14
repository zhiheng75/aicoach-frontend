
import 'package:intl/intl.dart';

class TimeUtils {
  static String formatDateTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }


  static String formatDateYMDTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        "${getParsedTime(min.toString())} : ${getParsedTime(sec.toString())}";

    return parsedTime;
  }

  static String formatedMinute(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return time;
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;
    if(sec>0){
      min = min+1;
    }

    String parsedTime =
        getParsedTime(min.toString());

    return parsedTime;
  }
}