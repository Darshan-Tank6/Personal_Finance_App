import 'package:flutter/material.dart';

class RecurringExpense {
  final int id;
  final String name;
  final double amount;
  final String type;
  final List<int> daysOfWeek; // Example: [1, 3, 5] for Mon, Wed, Fri
  final TimeOfDay time; // Time of insertion
  final String paymentMethod;
  final DateTime createdAt;

  RecurringExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.daysOfWeek,
    required this.time,
    required this.paymentMethod,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'daysOfWeek': daysOfWeek.join(","), // Store as comma-separated string
      'time': '${time.hour}:${time.minute}', // Store as string "HH:MM"
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
