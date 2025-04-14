import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/auth/domain/auth_repository.dart';
import 'package:go_router/go_router.dart';

class SignInSignUpScreen extends StatefulWidget {
  const SignInSignUpScreen({super.key});

  @override
  State<SignInSignUpScreen> createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _isSigningIn = true;
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isSigningIn)
                        TextFormField(
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: 'User Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      if (!_isSigningIn) const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _isSigningIn ? _signIn(ref) : _signUp(ref);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001730),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                            child: Text(
                              _isSigningIn ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text('or'),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSigningIn = !_isSigningIn;
                          });
                        },
                        child: Text(
                          _isSigningIn
                              ? 'Create an account'
                              : 'I already have an account',
                          style: const TextStyle(
                            color: Color(0xFF001730),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

  Future<void> _signIn(WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!context.mounted) return;
      context.go('/tasks');
    } catch (e) {
      print(e); // Keep for debugging if needed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Sign in failed: ${e.toString()}')) // Or a more user-friendly message
            );
      }
    }
  }

  Future<void> _signUp(WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signUp(
            email: _emailController.text,
            fullName: _userNameController.text,
            password: _passwordController.text,
          );
      if (context.mounted) {
        context.go('/tasks');
      }
    } catch (e) {
      print(e);
    }
  }
}
