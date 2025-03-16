// lib/models/lending.dart
class Lending {
  int? id;
  String name;
  double amount;
  String status;
  String date;
  String clearedDate;
  String paymentMethod;

  Lending({
    this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    required this.clearedDate,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'status': status,
      'date': date,
      'clearedDate': clearedDate,
      'paymentMethod': paymentMethod,
    };
  }

  factory Lending.fromMap(Map<String, dynamic> map) {
    return Lending(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      status: map['status'],
      date: map['date'],
      clearedDate: map['clearedDate'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
