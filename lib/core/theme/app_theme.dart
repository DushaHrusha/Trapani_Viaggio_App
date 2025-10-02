import 'package:flutter/material.dart';

import '../constants/base_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: BaseColors.background,
      fontFamily: 'San Francisco Pro Display',
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'San Francisco Pro Display'),
        bodyMedium: TextStyle(fontFamily: 'San Francisco Pro Display'),
        bodySmall: TextStyle(fontFamily: 'San Francisco Pro Display'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: BaseColors.background,
      fontFamily: 'San Francisco Pro Display',
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'San Francisco Pro Display'),
        bodyMedium: TextStyle(fontFamily: 'San Francisco Pro Display'),
        bodySmall: TextStyle(fontFamily: 'San Francisco Pro Display'),
      ),
    );
  }
}
