import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel t;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.t,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = t.type == 'income';

    return Card(
      color: isIncome ? Colors.green[50] : Colors.red[50], // 🌈 Different background
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
        title: Text(
          t.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${t.date.toLocal()}'.split(' ')[0],
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (isIncome ? '+' : '-') + '\$${t.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isIncome ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
