// ------------------- Sunny Side Up Theme -------------------

import 'package:flutter/material.dart';

final ThemeData sunnySideUpTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFFF4CC), // lightYellow
  scaffoldBackgroundColor: const Color(0xFFFAFAF9), // softWhite
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF2A20C), // orange
    foregroundColor: Color(0xFF2B2B2B), // deepBlack
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2B2B2B)),
    bodyMedium: TextStyle(color: Color(0xFF2B2B2B)),
    titleLarge: TextStyle(
      color: Color(0xFF2B2B2B),
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
    fillColor: const Color(0xFFFFF4CC), // lightYellow
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF27507), width: 2.0),
      borderRadius: BorderRadius.circular(48.0),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF27507), width: 2.0),
      borderRadius: BorderRadius.circular(48.0),
    ),
    labelStyle: const TextStyle(color: Color(0xFF2B2B2B)),
  ),
);