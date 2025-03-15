// lib/models/borrow.dart
class Borrow {
  int? id;
  String name;
  double amount;
  String status;
  String date;
  String clearedDate;

  Borrow({
    this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    required this.clearedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'status': status,
      'date': date,
      'clearedDate': clearedDate,
    };
  }
}
