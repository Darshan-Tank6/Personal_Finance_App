// // lib/models/expense.dart
// class Expense {
//   int? id;
//   String name;
//   double amount;
//   String date;
//   String type;

//   Expense({
//     this.id,
//     required this.name,
//     required this.amount,
//     required this.date,
//     required this.type,
//   });

//   Expense copyWith({
//     int? id,
//     String? name,
//     double? amount,
//     String? date,
//     String? type,
//   }) {
//     return Expense(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       amount: amount ?? this.amount,
//       date: date ?? this.date,
//       type: type ?? this.type,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'amount': amount,
//       'date': date,
//       'type': type,
//     };
//   }
// }

class Expense {
  int? id;
  String name;
  double amount;
  String date;
  String type;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.type,
  });

  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    String? date,
    String? type,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'type': type,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      amount: map['amount'].toDouble(), // Ensure correct type conversion
      date: map['date'],
      type: map['type'],
    );
  }
}
