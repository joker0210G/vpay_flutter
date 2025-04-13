import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vpay/features/auth/presentation/screens/login_screen.dart';
import 'package:vpay/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:vpay/features/auth/presentation/providers/auth_provider.dart';
import 'package:vpay/features/notifications/presentation/screens/notification_screen.dart';
import 'package:vpay/shared/theme/app_theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/tasks';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
});

class VPayApp extends ConsumerWidget {
  const VPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'vPay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

