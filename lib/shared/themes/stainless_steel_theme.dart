import 'package:flutter/material.dart';

// ------------------- Stainless Steel Theme -------------------

final ThemeData stainlessSteelTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF61788C), // slateBlue
  scaffoldBackgroundColor: const Color(0xFFD5E5F2), // softGray
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3C4C59), // darkCharcoal
    foregroundColor: Color(0xFFFAFAF9), // softWhite
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF3C4C59)),
    bodyMedium: TextStyle(color: Color(0xFF3C4C59)),
    titleLarge: TextStyle(
      color: Color(0xFF3C4C59),
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF27507), // deepOrange
      foregroundColor: const Color(0xFFFAFAF9), // softWhite
      shape: const StadiumBorder(),
      minimumSize: const Size(150, 48),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFAFAF9), // softWhite
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF61788C), width: 2.0),
      borderRadius: BorderRadius.circular(48.0),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF3C4C59), width: 2.0),
      borderRadius: BorderRadius.circular(48.0),
    ),
    labelStyle: const TextStyle(color: Color(0xFF3C4C59)),
  ),
);