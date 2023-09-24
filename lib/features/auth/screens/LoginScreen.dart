import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/common/SignInButton.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';
import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            Constants.LogoPath,
            height: 40,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => signInAsGuest(ref, context),
              child: const Text(
                'Skip',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Dive into anything',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.LoginEmotePath,
                    height: 400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(),
              ],
            ),
    );
  }
}
