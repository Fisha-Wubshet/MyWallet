import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final transactions =
        ref
            .watch(transactionProvider)
            .where(
              (t) =>
                  t.date.year == selectedMonth.year &&
                  t.date.month == selectedMonth.month,
            )
            .toList();

    final notifier = ref.read(transactionProvider.notifier);
    final currentIncome = notifier.totalIncome(month: selectedMonth);
    final currentExpense = notifier.totalExpense(month: selectedMonth);
    final currentNet = currentIncome - currentExpense;

    // previous month
    final prevMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    final prevNet =
        notifier.totalIncome(month: prevMonth) -
        notifier.totalExpense(month: prevMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
            
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
            ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 🗓️ Month Selector
      

          // 📊 Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Net Balance'),
                    Text(
                      '\$${currentNet.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Prev Month: \$${prevNet.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            currentNet >= prevNet ? Colors.green : Colors.red,
                      ),
                    ),
                    Text('Income: \$${currentIncome.toStringAsFixed(2)}'),
                    Text('Expense: \$${currentExpense.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),
  Padding(
  padding: const EdgeInsets.all(8.0),
  child: DropdownButton<String>(
    value: "${selectedMonth.year}-${selectedMonth.month}",
    items: List.generate(12, (i) {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month - i);
      return DropdownMenuItem(
        value: "${date.year}-${date.month}",
        child: Text(DateFormat('MMMM yyyy').format(date)),
      );
    }),
    onChanged: (value) {
      if (value != null) {
        final parts = value.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        ref.read(selectedMonthProvider.notifier).state = DateTime(year, month);
      }
    },
  ),
),
          // 📋 Transaction List
          Expanded(
            child:
                transactions.isEmpty
                    ? const Center(child: Text('No transactions this month'))
                    : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final t = transactions[index];
                        return TransactionTile(
                          t: t,
                          onDelete:
                              () => ref
                                  .read(transactionProvider.notifier)
                                  .deleteTransaction(t.id!),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<DateTime>> _monthItems(DateTime selectedMonth) {
    final now = DateTime.now();
    final List<DropdownMenuItem<DateTime>> items = [];
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i);
      items.add(
        DropdownMenuItem(
          value: date,
          child: Text(DateFormat('MMMM yyyy').format(date)),
        ),
      );
    }

    // Ensure selectedMonth is one of the items
    if (!items.any(
      (item) =>
          item.value!.year == selectedMonth.year &&
          item.value!.month == selectedMonth.month,
    )) {
      // fallback to first item if selectedMonth not in list
      selectedMonth = items.first.value!;
    }

    return items;
  }
}
