import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/constants/constants.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton(this.whichSignIn, {super.key});

  final String whichSignIn;

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: whichSignIn == 'Email'
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
                minimumSize: const Size(350, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                Routemaster.of(context).push('/email-signup');
              },
              child: const Text(
                'Sign Up With Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: () => signInWithGoogle(context, ref),
              icon: Image.asset(Constants.googlePath, width: 35),
              label: const Text(
                'Continue with Google',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
    );
  }
}
