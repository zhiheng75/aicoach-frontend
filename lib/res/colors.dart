// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../setting/provider/theme_provider.dart';

/// 暗黑模式判断
extension ThemeExtension on BuildContext {
  bool get jhIsDark => Provider.of<ThemeProvider>(this).isDark(this);
}

class Colours {
  /// 设置动态颜色
  static Color dynamicColor(BuildContext context, Color lightColor,
      [Color? darkColor]) {
    var isDark = context.jhIsDark;
    return isDark ? darkColor ?? lightColor : lightColor;
  }

  static const Color kThemeColor = Color(0xFFFFFFff);
  // 黑色文字
  static const Color kBlackTextColor = Color(0xFF333333); // (51, 51, 51)
  static const Color kBlackTextDarkColor = Color(0xFFC6C6C6); // (198, 198, 198)
  // 分割线
  static const Color kLineColor = Color(0xFFE6E6E6); // (230, 230, 230)
  static const Color kLineDarkColor = Color(0xFF232323); // (35, 35, 35)

  // picker、bottomSheet颜色
  static const Color kPickerBgColor = Colors.white;
  static const Color kPickerBgDarkColor = Color(0xFF1E1E1E); // (30, 30, 30)
  static const Color kPickerTitleColor = Color(0xFF787878); // (120, 120, 120)
  static const Color kPickerTitleDarkColor =
      Color(0xFF878787); // (135, 135, 135)
  static const Color kPickerTextColor = kBlackTextColor;
  static const Color kPickerTextDarkColor = kBlackTextDarkColor;
  static const Color kPickerRedTextDarkColor =
      Color(0xFFE64242); // (230, 66, 66)
  static const Color kPickerHeaderColor = kPickerBgColor;
  static const Color kPickerHeaderDarkColor = kPickerBgDarkColor;
  static const Color kPickerHeaderLineColor = kLineColor;
  static const Color kPickerHeaderLineDarkColor = kLineDarkColor;
  static const Color kPickerBtnColor = kBlackTextColor;
  static const Color kPickerBtnDarkColor = kBlackTextDarkColor;

  static const Color app_main = Color(0xFF4688FA);
  static const Color dark_app_main = Color(0xFF3F7AE0);

  static const Color bg_color = Color(0xfff1f1f1);
  static const Color dark_bg_color = Color(0xFF18191A);

  static const Color material_bg = Color(0xFFFFFFFF);
  static const Color dark_material_bg = Color(0xFF303233);

  static const Color text = Color(0xFF333333);
  static const Color dark_text = Color(0xFFB8B8B8);

  static const Color text_gray = Color(0xFF999999);
  static const Color dark_text_gray = Color(0xFF666666);

  static const Color text_gray_c = Color(0xFFcccccc);
  static const Color dark_button_text = Color(0xFFF2F2F2);

  static const Color bg_gray = Color(0xFFF6F6F6);
  static const Color dark_bg_gray = Color(0xFF1F1F1F);

  static const Color line = Color(0xFFEEEEEE);
  static const Color dark_line = Color(0xFF3A3C3D);

  static const Color red = Color(0xFFFF4759);
  static const Color dark_red = Color(0xFFE03E4E);

  static const Color text_disabled = Color(0xFFD4E2FA);
  static const Color dark_text_disabled = Color(0xFFCEDBF2);

  static const Color button_disabled = Color(0xFF96BBFA);
  static const Color dark_button_disabled = Color(0xFF83A5E0);

  static const Color unselected_item_color = Color(0xffbfbfbf);
  static const Color dark_unselected_item_color = Color(0xFF4D4D4D);

  static const Color bg_gray_ = Color(0xFFFAFAFA);
  static const Color dark_bg_gray_ = Color(0xFF242526);

  static const Color gradient_blue = Color(0xFF5793FA);
  static const Color shadow_blue = Color(0x805793FA);
  static const Color orange = Color(0xFFFF8547);
  static const Color color_c979ff = Color(0xFFC979FF);
  static const Color color_925DFF = Color(0xFF925DFF);
  static const Color color_546092 = Color(0xFF546092);
  static const Color color_4ED7FF = Color(0xFF4ED7FF);

  static const Color color_00FFB4 = Color(0xb300FFB4);
  static const Color color_0E90FF = Color(0xb30E90FF);
  static const Color color_DA2FFF = Color(0xb3DA2FFF);
  static const Color transflate = Color(0x00000000);
  static const Color black = Color(0xff000000);
  static const Color color_00DBAF = Color(0xff00DBAF);

  static const Color color_0EF4D1 = Color(0xff0EF4D1);
  static const Color color_53C5FF = Color(0xff53C5FF);
  static const Color color_E0AEFF = Color(0xffE0AEFF);

  static const Color color_700EF4D1 = Color(0x660EF4D1);
  static const Color color_7053C5FF = Color(0x6653C5FF);
  static const Color color_70E0AEFF = Color(0x66E0AEFF);

  static const Color color_300EF4D1 = Color(0x4D0EF4D1);
  static const Color color_3053C5FF = Color(0x4D53C5FF);
  static const Color color_30E0AEFF = Color(0x4DE0AEFF);

  static const Color color_111B44 = Color(0xff111B44);

  static const Color color_5B8BD2 = Color(0xff5B8BD2);
  static const Color color_00E6D0 = Color(0xff00E6D0);

  static const Color color_30white = Color(0x4Dffffff);
  static const Color color_70white = Color(0x66ffffff);
  static const Color color_00DFB3 = Color(0xFF00DFB3);
  static const Color color_006CFF = Color(0xFF006CFF);
  static const Color color_D74DFF = Color(0xFFD74DFF);
  static const Color color_3389FF = Color(0xFF3389FF);
  static const Color color_04D0D7 = Color(0xFF04D0D7);
  static const Color color_06C4DA = Color(0xFF06C4DA);
  static const Color color_00F3BD = Color(0xFF00F3BD);
  static const Color color_00BAFF = Color(0xFF00BAFF);
  static const Color color_AD4DFF = Color(0xFFAD4DFF);
  static const Color color_ADC5E8 = Color(0xFFADC5E8);
  static const Color color_BABFD6 = Color(0xFFBABFD6);
  static const Color color_B7BFD9 = Color(0xFFB7BFD9);
  static const Color color_2F468A = Color(0xFF2F468A);
  static const Color color_3A74E6 = Color(0xFF3A74E6);
  static const Color color_00B4DA = Color(0x8000B4DA);
  static const Color color_0047FF = Color(0xff0047FF);

  static Color hex2color(String hex) {
    if (hex.length != 7) {
      return const Color(0xFFFF0000);
    }
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  ///  新版UI
  static const Color color_999999 = Color(0xFF999999);
  static const Color color_001652 = Color(0xFF001652);
  static const Color color_9AC3FF = Color(0xFF9AC3FF);
  static const Color color_FF71E0 = Color(0xFFFF71E0);
  static const Color color_E8CCFE = Color(0xFFE8CCFE);
  static const Color color_ACCDFF = Color(0xFFACCDFF);

  static const Color color_9BA9BE = Color.fromRGBO(155, 169, 190, 1);
  static const Color color_00 = Color.fromRGBO(1, 1, 1, 0);
  static const Color color_F8F8F8 = Color.fromRGBO(248, 248, 248, 1);
  static const Color color_666666 = Color.fromRGBO(102, 102, 102, 1);
  static const Color color_333333 = Color.fromRGBO(51, 51, 51, 1);
  static const Color color_CDEDF4 = Color.fromRGBO(205, 237, 244, 1);
  static const Color color_51D8FF = Color.fromRGBO(81, 216, 255, 1);
  static const Color color_FF71CF = Color.fromRGBO(255, 113, 207, 1);
  static const Color color_8E30FF = Color.fromRGBO(142, 48, 255, 1);
  static const Color color_C1EBF7 = Color.fromRGBO(193, 235, 247, 1);
  static const Color color_DDF3D2 = Color.fromRGBO(221, 245, 210, 1);
  static const Color color_51D6FF = Color.fromRGBO(71, 216, 255, 1);

  static const Color color_FFF5BF = Color.fromRGBO(255, 245, 191, 1);
  static const Color color_examination = Color.fromRGBO(71, 0, 250, 1);
  static const Color color_F4F4F4 = Color.fromRGBO(244, 244, 244, 1);

  // static const Color color_C1EBF7 = Color.fromRGBO(71, 216, 255, 1);
  // static const Color color_8E30FF = Color.fromRGBO(71, 216, 255, 1);
}
