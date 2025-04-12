import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/shared/theme/app_theme.dart';
import 'package:vpay/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can create a provider to manage theme mode if needed
    // final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'vPay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or use your theme provider
      home: const VPayApp(),
    );
  }
}