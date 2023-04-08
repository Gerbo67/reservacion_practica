import 'package:flutter/material.dart';

class Configure {
  Configure._();

  static final instance = Configure._();

  //Main colors
  static const PRIMARY = Colors.green;
  static const WHITE = Color(0xFFFFFFFF);
  static const PRIMARY_BLACK = Color(0xFF494949);
  static const SECONDARY_BLACK = Color(0xFF3C3C3C);

  //Accent colors
  static const YELLOW = Color(0xFFECC830);
  static const GREEN = Color(0xFF6FFF7D);
  static const PINK = Color(0xFFF48585);

  //Añadir ceros
  static String addLeadingZero(int number) {
    String numString = number.toString();
    if (numString.length == 1) {
      numString = '0$numString';
    }
    return numString;
  }
}
