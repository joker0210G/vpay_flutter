import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/features/chat/domain/chat_message.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(supabase: Supabase.instance.client);
});

class ChatRepository {
  final SupabaseClient supabase;

  ChatRepository({required this.supabase});

  Stream<List<ChatMessage>> streamMessages(String taskId) {
    return supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('task_id', taskId)
        .order('timestamp')
        .map((events) => events.map((msg) => ChatMessage.fromJson(msg)).toList());
  }

  Future<void> sendMessage(ChatMessage message) async {
    await supabase.from('chat_messages').insert(message.toJson());
  }

  Future<void> markAsRead(String messageId) async {
    await supabase
        .from('chat_messages')
        .update({'is_read': true})
        .eq('id', messageId);
  }
}

