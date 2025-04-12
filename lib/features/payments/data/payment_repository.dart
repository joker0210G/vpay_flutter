import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upi_india/upi_india.dart';
import '../domain/payment_model.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    supabase: Supabase.instance.client,
    upiIndia: UpiIndia(),
  );
});

class PaymentRepository {
  final SupabaseClient supabase;
  final UpiIndia upiIndia;

  PaymentRepository({
    required this.supabase,
    required this.upiIndia,
  });

  Future<List<UpiApp>> getUpiApps() async {
    return await upiIndia.getAllUpiApps();
  }

  Future<PaymentModel> initiatePayment({
    required String taskId,
    required String payerId,
    required String payeeId,
    required double amount,
    required UpiApp app,
  }) async {
    // Create payment record
    final payment = PaymentModel(
      id: DateTime.now().toString(),
      taskId: taskId,
      payerId: payerId,
      payeeId: payeeId,
      amount: amount,
      createdAt: DateTime.now(),
    );

    final response = await supabase
        .from('payments')
        .insert(payment.toJson())
        .select()
        .single();

    final createdPayment = PaymentModel.fromJson(response);

    // Initiate UPI transaction
    final upiResponse = await upiIndia.startTransaction(
      app: app,
      receiverUpiId: "merchant@upi", // Replace with actual UPI ID
      receiverName: "vPay",
      transactionRefId: createdPayment.id,
      transactionNote: 'Payment for Task #$taskId',
      amount: amount,
    );

    // Update payment status based on UPI response
    final status = _getPaymentStatus(upiResponse);
    await supabase
        .from('payments')
        .update({
          'status': status.toString().split('.').last,
          'transaction_id': upiResponse.transactionId,
          'failure_reason': status == PaymentStatus.failed 
              ? upiResponse.responseCode
              : null,
        })
        .eq('id', createdPayment.id);

    return createdPayment.copyWith(
      status: status,
      transactionId: upiResponse.transactionId,
    );
  }

  PaymentStatus _getPaymentStatus(UpiResponse response) {
    switch (response.status) {
      case UpiPaymentStatus.SUCCESS:
        return PaymentStatus.completed;
      case UpiPaymentStatus.FAILURE:
        return PaymentStatus.failed;
      case UpiPaymentStatus.SUBMITTED:
        return PaymentStatus.processing;
      default:
        return PaymentStatus.pending;
    }
  }

  Stream<PaymentModel> watchPayment(String paymentId) {
    return supabase
        .from('payments')
        .stream(primaryKey: ['id'])
        .eq('id', paymentId)
        .map((event) => PaymentModel.fromJson(event.first));
  }
}