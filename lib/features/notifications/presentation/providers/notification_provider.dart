import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notification_repository.dart';
import '../../domain/notification_model.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription? _subscription;

  NotificationNotifier(this._repository) : super(NotificationState.initial());

  void startListening(String userId) {
    _subscription?.cancel();
    _subscription = _repository.streamNotifications(userId).listen(
      (notifications) {
        state = state.copyWith(notifications: notifications);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    required this.notifications,
    required this.isLoading,
    this.error,
  });

  factory NotificationState.initial() => NotificationState(
        notifications: [],
        isLoading: false,
      );

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}