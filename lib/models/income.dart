// lib/models/income.dart
class Income {
  int? id;
  String source;
  double amount;
  String date;

  Income({
    this.id,
    required this.source,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'source': source, 'amount': amount, 'date': date};
  }
}
