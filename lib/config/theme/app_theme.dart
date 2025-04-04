import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color(0xFFB7410E), 
    fontFamily: 'Poppins',
    brightness: Brightness.dark
  );
}
