class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'income' or 'expense'
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'type': type,
        'date': date.toIso8601String(),
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
        title: map['title'] ?? '',
        amount: (map['amount'] is double) ? map['amount'] as double : double.parse(map['amount'].toString()),
        category: map['category'] ?? '',
        type: map['type'] ?? 'expense',
        date: DateTime.parse(map['date']),
      );
}
