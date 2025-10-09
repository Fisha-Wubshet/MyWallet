import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _amountCtl = TextEditingController();
  String _type = 'expense';
  String _category = 'General';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleCtl.dispose();
    _amountCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final t = TransactionModel(
      title: _titleCtl.text.trim(),
      amount: double.parse(_amountCtl.text.trim()),
      category: _category,
      type: _type,
      date: _date,
    );

    await ref.read(transactionProvider.notifier).addTransaction(t);
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _titleCtl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountCtl,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter amount';
                final val = double.tryParse(v);
                if (val == null) return 'Enter valid number';
                if (val <= 0) return 'Amount must be > 0';
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(value: 'expense', child: Text('Expense')),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? 'expense'),
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: 'General', child: Text('General')),
                      DropdownMenuItem(value: 'Food', child: Text('Food')),
                      DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                      DropdownMenuItem(value: 'Salary', child: Text('Salary')),
                      DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                    ],
                    onChanged: (v) => setState(() => _category = v ?? 'General'),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Date: ${_date.toLocal().toIso8601String().split('T').first}')),
                TextButton(onPressed: _pickDate, child: const Text('Pick date')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Save Transaction'),
            )
          ]),
        ),
      ),
    );
  }
}
