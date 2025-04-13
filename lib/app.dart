import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';
import 'package:vpay/shared/theme/app_theme.dart';
import 'package:vpay/features/router/router.dart';


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // You can create a provider to manage theme mode if needed
    // final isDarkMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'vPay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or use your theme provider
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
