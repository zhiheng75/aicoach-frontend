import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class StringUtils {
  static bool isChinaTwoPhoneLegal(String str) {
    ///判断是手机号并且不为空  但是不toast
    if (str != null && str.isNotEmpty) {
      int isElev = str.length;
      if (isElev == 11) {
        ///是手机号
        if (RegExp('^\\d{11}\$').hasMatch(str)) {
          str = str.substring(0, 1);
          if (str == "1") {
            return true;
          } else {
            return false;
          }
        }
        return RegExp('^\\d{11}\$').hasMatch(str);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static bool isChinaPhoneLegal(String str) {
    ///判断是手机号并且不为空  但是不toast
    if (str != null && str.isNotEmpty) {
      int isElev = str.length;
      if (isElev == 11) {
        ///是手机号
        return true; //RegExp('^\\d{11}\$').hasMatch(str);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///邮箱格式判断
  static bool isChinaEmailLegal(String input) {
    /// 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  ///8位数字+字母
  static bool isPassLegal(String str) {
    int isElev = str.length;
    if (str != null && str.isNotEmpty) {
      if (isElev >= 8 && isElev <= 16) {
        return true;
      } else {
//        showToastMessage("密码不符合规范");
        return false;
      }
    } else {
      return false;
    }
  }

  static bool isPassLegaltwo(String str) {
    RegExp reg =
        new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,16}$");
    return reg.hasMatch(str);
  }

  ///去除富文本标签
  static String removeTag(String htmlString) {
    if (htmlString == null || htmlString.isEmpty) {
      return '';
    }
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString.replaceAll('&nbsp;', '').replaceAll('/\s/ig', '');
  }

  ///去掉小数点后的0
  static String getDoubleRemoveZero(double d) {
    String str = "0";
    if (d.toString().split(".")[1] == "0") {
      str = d.toString().split(".")[0];
    } else {
      str = d.toStringAsFixed(1);
    }

    return str;
  }
}
