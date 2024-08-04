import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/sign_in_button.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const Image(
                image: AssetImage(
                  'assets/images/login01.png',
                ),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 450,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Color.fromARGB(255, 125, 68, 224),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 125, 68, 224),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const SignInButton('Email'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 42),
                    child: Row(
                      children: [
                        Container(
                          width: 82,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'or use social sign up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 82,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SignInButton('Google'),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Routemaster.of(context).push("/email-login");
                    },
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
