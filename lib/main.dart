import 'package:diploma_prj/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/routing/router_configuration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Show loading screen while checking auth state
    if (authState.isLoading) {
      return const MaterialApp(
        home: LoadingScreen(),
      );
    }


    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'App',
      theme: ThemeData(
        primaryColor: const Color(0xFFF27507),
      ),
    );
  }
}




