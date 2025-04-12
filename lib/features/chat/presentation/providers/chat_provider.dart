import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/chat/data/chat_repository.dart';
import 'package:vpay/features/chat/domain/chat_message.dart';

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, taskId) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repository, taskId);
  },
);

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final String taskId;
  StreamSubscription<List<ChatMessage>>? _subscription;

  ChatNotifier(this._repository, this.taskId) : super(ChatState.initial()) {
    _listenToMessages();
  }

  void _listenToMessages() {
    _subscription?.cancel();
    _subscription = _repository.streamMessages(taskId).listen(
      (messages) {
        state = state.copyWith(messages: messages);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> sendMessage(String message, String senderId, String receiverId) async {
    try {
      final chatMessage = ChatMessage(
        id: DateTime.now().toString(), // Will be replaced by Supabase
        taskId: taskId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
      );
      await _repository.sendMessage(chatMessage);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    required this.isLoading,
    this.error,
  });

  factory ChatState.initial() => ChatState(
        messages: [],
        isLoading: false,
      );

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

