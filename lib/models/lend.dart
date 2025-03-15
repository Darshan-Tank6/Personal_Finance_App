// lib/models/lending.dart
class Lending {
  int? id;
  String name;
  double amount;
  String status;
  String date;
  String clearedDate;

  Lending({
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
