import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/theme_provider.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return AlertDialog(
      title: const Text("Choose your theme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: currentTheme == AppTheme.stainlessSteel
                  ? null // disable if current
                  : () {
                ref.read(themeProvider.notifier).state = AppTheme.stainlessSteel;
                Navigator.of(context).pop();
              },
              child: const Text("Stainless Steel"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: currentTheme == AppTheme.sunnySideUp
                  ? null
                  : () {
                ref.read(themeProvider.notifier).state = AppTheme.sunnySideUp;
                Navigator.of(context).pop();
              },
              child: const Text("Sunny Side Up"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: currentTheme == AppTheme.defaultTheme
                  ? null
                  : () {
                ref.read(themeProvider.notifier).state = AppTheme.defaultTheme;
                Navigator.of(context).pop();
              },
              child: const Text("Default"),
            ),
          ),
        ],
      ),
    );
  }
}
