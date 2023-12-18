import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class TextStyles {
  
  static  TextStyle textSize12 = TextStyle(
    fontSize: Dimens.font_sp12,
  );
  static  TextStyle textSize16 = TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static  TextStyle textBold14 = TextStyle(
    fontSize: Dimens.font_sp14,
    fontWeight: FontWeight.bold
  );
  static  TextStyle textBold16 = TextStyle(
    fontSize: Dimens.font_sp16,
    fontWeight: FontWeight.bold
  );
  static  TextStyle textBold18 = TextStyle(
    fontSize: Dimens.font_sp18,
    fontWeight: FontWeight.bold
  );
  static  TextStyle textBold24 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold
  );
  static  TextStyle textBold26 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold
  );
 
  static  TextStyle textGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );
  static  TextStyle textDarkGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.dark_text_gray,
  );

  static  TextStyle textWhite14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
  );
  
  static  TextStyle text = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text,
    textBaseline: TextBaseline.alphabetic
  );
  static  TextStyle textDark = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.dark_text,
    textBaseline: TextBaseline.alphabetic
  );

  static  TextStyle textGray12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
    fontWeight: FontWeight.normal
  );
  static  TextStyle textDarkGray12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.dark_text_gray,
    fontWeight: FontWeight.normal
  );
  
  static  TextStyle textHint14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.dark_unselected_item_color
  );

  static  TextStyle text12_11B44 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.color_111B44
  );

  static  TextStyle text12_546092 = TextStyle(
      fontSize: Dimens.font_sp12,
      color: Colours.color_546092
  );


  static  TextStyle text18_white = TextStyle(
      fontSize: Dimens.font_sp18,
      color: Colors.white
  );

  static  TextStyle text20_white = TextStyle(
      fontSize: Dimens.font_sp20,
      color: Colors.white
  );
}
