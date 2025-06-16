import 'package:diploma_prj/shared/themes/default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/stainless_steel_theme.dart';
import '../themes/sunny_side_up_theme.dart';

enum AppTheme {
  sunnySideUp,
  stainlessSteel,
  defaultTheme,
}

// First, import your previously defined themes
// Assume you already have stainlessSteelTheme and sunnySideUpTheme defined as you wrote above

// Provider for current selected theme
final themeProvider = StateProvider<AppTheme>((ref) => AppTheme.stainlessSteel);

// Provider that returns the active ThemeData based on AppTheme enum
final appThemeDataProvider = Provider<ThemeData>((ref) {
  final theme = ref.watch(themeProvider);
  switch (theme) {
    case AppTheme.stainlessSteel:
      return stainlessSteelTheme;
    case AppTheme.sunnySideUp:
      return sunnySideUpTheme;
    case AppTheme.defaultTheme:
      return defaultTheme;
  }
});
