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
  static const Color color_0000 = Color.fromRGBO(0, 0, 0, 0);

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
  static const Color color_FF00A8 = Color.fromRGBO(255, 0, 168, 1);
  static const Color color_893A6E = Color.fromRGBO(137, 58, 110, 1);
  static const Color color_FFD076 = Color.fromRGBO(255, 208, 118, 1);
  static const Color color_D845A6 = Color.fromRGBO(216, 69, 166, 1);
  static const Color color_00BB40 = Color.fromRGBO(0, 187, 64, 1);
  static const Color color_007AFF = Color.fromRGBO(0, 122, 255, 1);
  static const Color color_EBCCFE = Color.fromRGBO(232, 204, 254, 1);
  static const Color color_F3E4FF = Color.fromRGBO(243, 228, 255, 1);
  static const Color color_F8CCFE = Color.fromRGBO(232, 204, 254, 0.9);
  static const Color color_ACCDFE = Color.fromRGBO(172, 205, 255, 0.9);
  static const Color color_FFF3D8 = Color.fromRGBO(255, 243, 219, 1);
  static const Color color_6D388F = Color.fromRGBO(109, 56, 143, 1);
  static const Color color_2C0047 = Color.fromRGBO(44, 0, 71, 1);

  static const Color color_906DA9 = Color.fromRGBO(144, 109, 169, 1);
  static const Color color_3770C6 = Color.fromRGBO(55, 112, 198, 1);

  static const Color color_FAF3FF = Color.fromRGBO(250, 243, 255, 1);
  static const Color color_EFF9FF = Color.fromRGBO(239, 249, 255, 1);
  static const Color color_E8F9DF = Color.fromRGBO(232, 249, 223, 1);

  static const Color color_F9F8FF = Color.fromRGBO(249, 248, 255, 1);

  static const Color color_EEF9E8 = Color.fromRGBO(238, 249, 232, 1);

  static const Color color_108F4C = Color.fromRGBO(16, 191, 76, 1);

  static const Color color_292A2E = Color.fromRGBO(41, 42, 46, 1);

  static const Color color_C8F5B1 = Color.fromRGBO(200, 245, 177, 1);

  static const Color color_007Aff = Color.fromRGBO(0, 122, 255, 1);

  static const Color color_E00094 = Color.fromRGBO(224, 0, 148, 1);

  static const Color color_FF4343 = Color.fromRGBO(255, 67, 67, 1);
  static const Color color_FFFFFF = Color.fromRGBO(255, 255, 255, 0.64);

  static const Color color_B2E3FF = Color.fromRGBO(178, 227, 255, 1);
  static const Color color_FFA7EC = Color.fromRGBO(255, 167, 236, 1);

  static const Color color_E3FBFA = Color.fromRGBO(227, 251, 250, 1);

  static const Color color_9F7EFF = Color.fromRGBO(159, 126, 255, 1);
  static const Color color_BDA6FF = Color.fromRGBO(189, 166, 255, 1);

  static const Color color_7AAFFF = Color.fromRGBO(122, 175, 255, 1);

  static const Color color_00CFD1 = Color.fromRGBO(0, 207, 209, 1);
  static const Color color_6EF0F1 = Color.fromRGBO(110, 240, 241, 1);

  static const Color color_8256FF = Color.fromRGBO(130, 86, 255, 1);
  static const Color color_FF5CDB = Color.fromRGBO(255, 92, 219, 1);

  static const Color color_ECCCFF = Color.fromRGBO(236, 204, 255, 1);

  static const Color color_ECCCFF5 = Color.fromRGBO(236, 204, 255, 0.5);
  static const Color color_F3E4FF5 = Color.fromRGBO(243, 228, 255, 0.5);

  static const Color color_00B53D = Color.fromRGBO(0, 181, 61, 1);

  static const Color color_C1E8F7 = Color.fromRGBO(193, 235, 247, 1);
  static const Color color_191919 = Color.fromRGBO(25, 25, 25, 1);

  static const Color color_542DEC = Color.fromRGBO(84, 45, 236, 1);

  static const Color color_FAF7FF = Color.fromRGBO(250, 247, 255, 1);
  static const Color color_F3EEFE = Color.fromRGBO(243, 238, 254, 1);

  static const Color color_BA995A = Color.fromRGBO(186, 153, 90, 1);

  static const Color color_FFFFFF60 = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color color_8F8D8D = Color.fromRGBO(143, 141, 141, 1);

  static const Color color_EFE9FF = Color.fromRGBO(239, 233, 255, 1);
  static const Color color_8003FD = Color.fromRGBO(128, 3, 253, 1);

  static const Color color_FFE99C = Color.fromRGBO(255, 233, 156, 1);

  static const Color color_FFFFFF9 = Color.fromRGBO(255, 255, 255, 0.9);

  static const Color color_875EFF = Color.fromRGBO(135, 94, 255, 1);

  static const Color color_FFFFFF5 = Color.fromRGBO(255, 255, 255, 0.5);

  static const Color color_FAF8FF = Color.fromRGBO(250, 248, 255, 1);
  static const Color color_FFEB81 = Color.fromRGBO(255, 235, 129, 1);

  static const Color color_D9D9D9 = Color.fromRGBO(217, 217, 217, 1);
  static const Color color_7C7C7C = Color.fromRGBO(124, 124, 124, 1);

  static const Color color_737373 = Color.fromRGBO(115, 115, 115, 1);
  static const Color color_7373733 = Color.fromRGBO(115, 115, 115, 0.3);
  static const Color color_949393 = Color.fromRGBO(148, 147, 147, 1);

  static const Color color_F2F3F5 = Color.fromRGBO(242, 243, 245, 1);

  static const Color color_00000019 = Color.fromRGBO(0, 0, 0, 0.19);

  static const Color color_94FFF9 = Color.fromRGBO(148, 255, 249, 0.91);
  static const Color color_7F5FFF = Color.fromRGBO(127, 95, 255, 0.91);
  static const Color color_A55FFF = Color.fromRGBO(165, 95, 255, 0.91);

  static const Color color_DCF2FE = Color.fromRGBO(220, 242, 254, 1);
  static const Color color_E0D5FF = Color.fromRGBO(224, 213, 255, 1);
}
