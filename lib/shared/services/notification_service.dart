import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotifications;
  final RealtimeChannel _channel;

  NotificationService({
    required this.localNotifications,
  }) : _channel = Supabase.instance.client.channel('messages');

  Future<void> initialize() async {
    // Request local notifications permissions
    await localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    // Initialize local notifications
    await localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    // Initialize Supabase listener
    _listenForNewMessages();
  }

  void _listenForNewMessages() {
    _channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        _showNewMessageNotification();
      },
    ).subscribe();
  }

  Future<void> _showNewMessageNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await localNotifications.show(
        0, 'New Message', 'You have a new message!', notificationDetails);
  }

}