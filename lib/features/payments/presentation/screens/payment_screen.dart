import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_india/upi_india.dart';
import 'package:vpay/features/payments/presentation/providers/payment_provider.dart';
import 'package:vpay/shared/models/task_model.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final TaskModel task;
  final String payerId;
  final String payeeId;

  const PaymentScreen({
    super.key,
    required this.task,
    required this.payerId,
    required this.payeeId,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(paymentProvider.notifier).loadUpiApps(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: paymentState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task: ${widget.task.title}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amount: ₹${widget.task.amount}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select Payment Method',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: paymentState.upiApps.length,
                      itemBuilder: (context, index) {
                        final app = paymentState.upiApps[index];
                        return InkWell(
                          onTap: () => _initiatePayment(app),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.memory(
                                  app.icon,
                                  height: 48,
                                  width: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  app.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (paymentState.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        paymentState.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  void _initiatePayment(UpiApp app) async {
    await ref.read(paymentProvider.notifier).initiatePayment(
          taskId: widget.task.id,
          payerId: widget.payerId,
          payeeId: widget.payeeId,
          amount: widget.task.amount,
          app: app,
        );

    if (mounted && ref.read(paymentProvider).error == null) {
      Navigator.pop(context);
    }
  }
}