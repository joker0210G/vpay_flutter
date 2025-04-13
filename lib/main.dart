import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/app.dart';
import 'package:vpay/features/auth/presentation/screens/sign_in_sign_up_screen.dart';
import 'package:vpay/shared/config/supabase_config.dart';
import 'package:vpay/shared/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Initialize Notification Service
  final notificationService = NotificationService(
    localNotifications: FlutterLocalNotificationsPlugin(),
  );
  await notificationService.initialize();
  runApp(const ProviderScope(child: MyApp()));
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
      home: const SignInSignUpScreen(),
    );
  }
}
