enum TransactionType { payment, refund, cashback }
enum TransactionStatus { pending, completed, failed }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime timestamp;
  final String description;
  final String? paymentMethod;
  final String? referenceId;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.description,
    this.paymentMethod,
    this.referenceId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values.byName(json['type']),
      status: TransactionStatus.values.byName(json['status']),
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      paymentMethod: json['payment_method'],
      referenceId: json['reference_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'amount': amount,
        'type': type.name,
        'status': status.name,
        'timestamp': timestamp.toIso8601String(),
        'description': description,
        'payment_method': paymentMethod,
        'reference_id': referenceId,
      };
}