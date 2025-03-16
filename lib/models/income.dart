// lib/models/income.dart
class Income {
  int? id;
  String source;
  double amount;
  String date;
  String paymentMethod;

  Income({
    this.id,
    required this.source,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'date': date,
      'paymentMethod': paymentMethod,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      source: map['source'],
      amount: map['amount'],
      date: map['date'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
