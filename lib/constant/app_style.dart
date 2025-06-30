import 'package:flutter/rendering.dart';
import 'package:the_reading_room_app/constant/app_color.dart';

class AppStyle {
  static TextStyle fontMoreSugarRegular({double? fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'MoreSugar',
      color: color ?? AppColor.black,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? 16,
    );
  }

  static TextStyle fontMoreSugarThin({double? fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'MoreSugar',
      color: color ?? AppColor.black,
      fontWeight: FontWeight.w200,
      fontSize: fontSize ?? 16,
    );
  }

  static TextStyle fontMoreSugarExtra({double? fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'MoreSugar',
      color: color ?? AppColor.black,
      fontWeight: FontWeight.w600, // assuming "Extra" means SemiBold or similar
      fontSize: fontSize ?? 16,
    );
  }
}
