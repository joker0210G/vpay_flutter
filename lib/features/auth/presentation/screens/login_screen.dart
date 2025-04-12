import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/auth/presentation/providers/auth_provider.dart';
import 'package:vpay/shared/theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    color: AppColors.primaryDark,
                  ),
                  const Positioned(
                    left: 75,
                    top: 0,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 262,
                      height: 262,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 194,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const ShapeDecoration(
                        color: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(206),
                          ),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 80, 50, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Login\nWelcome back!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.black80,
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Username / Email',
                                  hintStyle: TextStyle(
                                    color: AppColors.black70,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.black05,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Password',
                                  hintStyle: TextStyle(
                                    color: AppColors.black70,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.black05,
                                  suffixIcon: IconButton(
                                    icon: Image.asset(
                                      'assets/images/eye_icon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _handleForgotPassword,
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.linkBlue,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Sign in',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 24,
                                  fontFamily: 'Righteous',
                                  height: 0.83,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    " Don't have an account? ",
                                    style: TextStyle(
                                      color: AppColors.black80,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _navigateToRegister,
                                    child: const Text(
                                      'Signup',
                                      style: TextStyle(
                                        color: AppColors.linkBlue,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: _buildDivider()),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Or',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: _buildDivider()),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialLoginButton(
                                    'assets/images/google_icon.png',
                                    onTap: _handleGoogleLogin,
                                  ),
                                  const SizedBox(width: 44),
                                  _buildSocialLoginButton(
                                    'assets/images/facebook_icon.png',
                                    onTap: _handleFacebookLogin,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (authState.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (authState.error != null)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red.withOpacity(0.8),
                child: Text(
                  authState.error!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.black50,
    );
  }

  Widget _buildSocialLoginButton(String iconPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(iconPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    final email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    ref.read(authProvider.notifier).sendPasswordResetEmail(email);
  }

  void _navigateToRegister() {
    context.push('/register');
  }

  void _handleGoogleLogin() {
    ref.read(authProvider.notifier).signInWithGoogle();
  }

  void _handleFacebookLogin() {
    ref.read(authProvider.notifier).signInWithFacebook();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

