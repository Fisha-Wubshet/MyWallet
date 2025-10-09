import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_model.dart';
import '../data/db/database_helper.dart';

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now(); // default: current month
});

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = await DatabaseHelper.instance.getTransactions();
  }

  Future<void> addTransaction(TransactionModel t) async {
    await DatabaseHelper.instance.insertTransaction(t);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await loadTransactions();
  }

  double totalIncome({DateTime? month}) {
    final m = month ?? DateTime.now();
    return state
        .where((t) => t.type == 'income' && _isSameMonth(t.date, m))
        .fold(0.0, (a, b) => a + b.amount);
  }

  double totalExpense({DateTime? month}) {
    final m = month ?? DateTime.now();
    return state
        .where((t) => t.type == 'expense' && _isSameMonth(t.date, m))
        .fold(0.0, (a, b) => a + b.amount);
  }

  List<TransactionModel> transactionsByMonth(DateTime month) {
    return state.where((t) => _isSameMonth(t.date, month)).toList();
  }

  bool _isSameMonth(DateTime d, DateTime m) {
    return d.year == m.year && d.month == m.month;
  }
}
