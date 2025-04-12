import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_provider.dart';
import '../../domain/notification_model.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.error != null
              ? Center(child: Text(notificationState.error!))
              : ListView.builder(
                  itemCount: notificationState.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationState.notifications[index];
                    return NotificationTile(notification: notification);
                  },
                ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: _getNotificationIcon(notification.type),
      title: Text(notification.title),
      subtitle: Text(notification.message),
      trailing: notification.isRead
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationProvider.notifier)
              .markAsRead(notification.id);
        }
        // Handle notification tap
      },
    );
  }

  Icon _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.taskCreated:
        return const Icon(Icons.assignment);
      case NotificationType.taskAssigned:
        return const Icon(Icons.person_add);
      case NotificationType.paymentReceived:
        return const Icon(Icons.payment);
      case NotificationType.newMessage:
        return const Icon(Icons.message);
      case NotificationType.taskCompleted:
        return const Icon(Icons.check_circle);
    }
  }
}