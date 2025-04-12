import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(supabase: Supabase.instance.client);
});

class NotificationRepository {
  final SupabaseClient supabase;

  NotificationRepository({required this.supabase});

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((events) => 
            events.map((event) => NotificationModel.fromJson(event)).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}