import 'package:flutter/material.dart';

// ------------------- Stainless Steel Grayscale Theme -------------------

final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF666666), // medium gray
  scaffoldBackgroundColor: const Color(0xFFF1F1F1), // light gray
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF333333), // dark gray
    foregroundColor: Color(0xFFF9F9F9), // soft white
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF333333)),
    bodyMedium: TextStyle(color: Color(0xFF333333)),
    titleLarge: TextStyle(
      color: Color(0xFF333333),
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF444444), // button dark gray
      foregroundColor: const Color(0xFFF9F9F9), // button text soft white
      shape: const StadiumBorder(),
      fixedSize: const Size(150, 48), // <-- fixedSize applied to preserve StadiumBorder
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF9F9F9), // soft white input background
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF666666), width: 2.0), // focused border medium gray
      borderRadius: BorderRadius.circular(48.0), // preserved border radius
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF333333), width: 2.0), // default border dark gray
      borderRadius: BorderRadius.circular(48.0), // preserved border radius
    ),
    labelStyle: const TextStyle(color: Color(0xFF333333)),
  ),
);
