enum PaymentStatus { pending, processing, completed, failed }

class PaymentModel {
  final String id;
  final String taskId;
  final String payerId;
  final String payeeId;
  final double amount;
  final PaymentStatus status;
  final String? transactionId;
  final DateTime createdAt;
  final String? failureReason;

  PaymentModel({
    required this.id,
    required this.taskId,
    required this.payerId,
    required this.payeeId,
    required this.amount,
    this.status = PaymentStatus.pending,
    this.transactionId,
    required this.createdAt,
    this.failureReason,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      taskId: json['task_id'],
      payerId: json['payer_id'],
      payeeId: json['payee_id'],
      amount: json['amount'].toDouble(),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      transactionId: json['transaction_id'],
      createdAt: DateTime.parse(json['created_at']),
      failureReason: json['failure_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'payer_id': payerId,
      'payee_id': payeeId,
      'amount': amount,
      'status': status.toString().split('.').last,
      'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
      'failure_reason': failureReason,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? taskId,
    String? payerId,
    String? payeeId,
    double? amount,
    PaymentStatus? status,
    String? transactionId,
    DateTime? createdAt,
    String? failureReason,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      payerId: payerId ?? this.payerId,
      payeeId: payeeId ?? this.payeeId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}