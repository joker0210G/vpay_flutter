import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/auth/presentation/screens/login_screen.dart';
import 'package:vpay/features/auth/presentation/screens/register_screen.dart';
import 'package:vpay/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:vpay/features/notifications/presentation/screens/notification_screen.dart';
import 'package:vpay/features/auth/presentation/providers/auth_provider.dart';
import 'package:vpay/features/auth/presentation/screens/sign_in_sign_up_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/sign-in-sign-up', // Changed to '/sign-in-sign-up'
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.uri.toString() == '/login';
      final isSignInSignUpRoute = state.uri.toString() == '/sign-in-sign-up';

      if (!isLoggedIn && !isLoginRoute && !isSignInSignUpRoute) return '/sign-in-sign-up';
      if (!isLoggedIn && isLoginRoute) return '/sign-in-sign-up';
      if (isLoggedIn && isSignInSignUpRoute) return '/tasks';
      if (isLoggedIn && isLoginRoute) return '/tasks';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
       GoRoute(
        path: '/sign-in-sign-up',
        builder: (context, state) => const SignInSignUpScreen(),
      ),
    ],
  );
});
