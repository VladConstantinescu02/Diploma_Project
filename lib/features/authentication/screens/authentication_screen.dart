import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_account.dart';
import '../providers/authentication_provider.dart';
import '../widgets/authentication_button.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserAccount> account = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticate"),
      ),
      body: account.when(
        data: (googleAccount) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuthenticationButton(),
              if (googleAccount.displayName.isNotEmpty)
                Center(
                  child: Text('Signed in as: ${googleAccount.displayName}'),
                ),
              if (googleAccount.email.isNotEmpty)
                Center(
                  child: Text('Email: ${googleAccount.email}'),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

