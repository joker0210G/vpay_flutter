import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_india/upi_india.dart';
import 'package:vpay/features/payments/data/payment_repository.dart';
import 'package:vpay/features/payments/domain/payment_model.dart';

final paymentProvider =
    StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository);
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(PaymentState.initial());

  Future<void> loadUpiApps() async {
    state = state.copyWith(isLoading: true);
    try {
      final apps = await _repository.getUpiApps();
      state = state.copyWith(
        upiApps: apps,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> initiatePayment({
    required String taskId,
    required String payerId,
    required String payeeId,
    required double amount,
    required UpiApp app,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final payment = await _repository.initiatePayment(
        taskId: taskId,
        payerId: payerId,
        payeeId: payeeId,
        amount: amount,
        app: app,
      );
      state = state.copyWith(
        currentPayment: payment,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}

class PaymentState {
  final bool isLoading;
  final String? error;
  final List<UpiApp> upiApps;
  final PaymentModel? currentPayment;

  PaymentState({
    required this.isLoading,
    this.error,
    required this.upiApps,
    this.currentPayment,
  });

  factory PaymentState.initial() => PaymentState(
        isLoading: false,
        upiApps: [],
      );

  PaymentState copyWith({
    bool? isLoading,
    String? error,
    List<UpiApp>? upiApps,
    PaymentModel? currentPayment,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      upiApps: upiApps ?? this.upiApps,
      currentPayment: currentPayment ?? this.currentPayment,
    );
  }
}