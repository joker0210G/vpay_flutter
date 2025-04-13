import 'package:flutter/material.dart';

class SignInSignUpScreen extends StatelessWidget {
  const SignInSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark Blue Background
          Container(
            color: const Color(0xFF001730),
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
          ),
          // Light Blue Tab
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB9E1F2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Sign In action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001730),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Sign Up action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001730),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logo
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo_1.png',
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
