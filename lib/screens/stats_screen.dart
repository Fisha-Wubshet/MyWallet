// lib/screens/stats_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../widgets/chart_widget.dart';
import '../core/utils/date_utils.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);
    final income = notifier.totalIncome();
    final expense = notifier.totalExpense();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('Overview for ${formatMonthYear(DateTime.now())}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [const Text('Income'), Text('\$${income.toStringAsFixed(2)}')]),
                  Column(children: [const Text('Expense'), Text('\$${expense.toStringAsFixed(2)}')]),
                  Column(children: [const Text('Balance'), Text('\$${(income - expense).toStringAsFixed(2)}')]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: ChartWidget(income: income, expense: expense)),
        ]),
      ),
    );
  }
}