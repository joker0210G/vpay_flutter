import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/app.dart';
import 'package:vpay/shared/config/supabase_config.dart';
import 'package:vpay/shared/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vpay/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  // Initialize Notification Service
  final notificationService = NotificationService(
    localNotifications: FlutterLocalNotificationsPlugin(),
  );
  await notificationService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}


