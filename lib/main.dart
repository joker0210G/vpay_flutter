import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/shared/config/supabase_config.dart';
import 'package:vpay/shared/services/notification_service.dart';
import 'package:vpay/shared/theme/app_theme.dart';
import 'package:vpay/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Notification Service
  final notificationService = NotificationService(
    messaging: FirebaseMessaging.instance,
    localNotifications: FlutterLocalNotificationsPlugin(),
  );
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Provide the notification service
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const MyApp(),
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