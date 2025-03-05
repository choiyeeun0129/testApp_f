import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /**
   * primary
   * greyscale
   * alert
   */

  /// primary colors
  static const Color primary100 = Color(0xffA9BAFF);
  static const Color primaryLight1 = Color(0xffD4E2FF);
  static const Color primaryLight2 = Color(0xffECFDFF);
  static const Color primaryLight3 = Color(0xffEFFFFF);

  /// greyscale colors - first set
  static const Color grey0 = Color(0xffFFFFFF);
  static const Color grey25 = Color(0xffFFF2FB);
  static const Color grey50 = Color(0xffE7EBF2);
  static const Color grey100 = Color(0xffB3BED0);
  static const Color grey200 = Color(0xff898989);
  static const Color grey300 = Color(0xff696D70);
  static const Color grey400 = Color(0xff30333E);

  /// main scale colors - second set
  static const Color mainScale1 = Color(0xff5A7EFF);
  static const Color mainScale2 = Color(0xff54B5FF);
  static const Color mainScale3 = Color(0xffAEDCFF);
  static const Color mainScale4 = Color(0xff90A862);
  static const Color mainScale5 = Color(0xff818181);

  /// alert/success colors
  static const Color success = Color(0xff498eff);
  static const Color successLight1 = Color(0xffcfe0fd);
  static const Color successLight2 = Color(0xffe7effc);

  /// alert/error colors
  static const Color error = Color(0xffFA5800);
  static const Color errorLight1 = Color(0xffFBD0BC);
  static const Color errorLight2 = Color(0xffF7E9E3);

  /// primary swatch
  static const Color primary = Color(0xff498AFF);
  static MaterialColor primarySwatch = MaterialColor(primary.value, {
    50: primary.withOpacity(.1),
    100: primary.withOpacity(.2),
    200: primary.withOpacity(.3),
    300: primary.withOpacity(.4),
    400: primary.withOpacity(.5),
    500: primary.withOpacity(.6),
    600: primary.withOpacity(.7),
    700: primary.withOpacity(.8),
    800: primary.withOpacity(.9),
    900: primary.withOpacity(1),
  });

  /// basic colors (keeping from original code)
  static const Color mainText = Color(0xffffffff);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color transparent = Color(0x00000000);
  static const Color correct = Color(0xff536FFF);
  static const Color correctLight = Color(0xffE7EBFF);

  /// etc
  static const Color tabInactive = Color(0xffCCCCCC);

  static const Color backgroundColor = Color(0xffffffff);
  static const Color basicColor = Color(0xffF7F8FA);
}