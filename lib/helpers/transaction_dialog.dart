import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showTransactionDialog({
  required BuildContext context,
  required String type,
  dynamic transaction,
  required Function(
    String name,
    double amount,
    String date,
    String status,
    String paymentMethod, [
    String? expenseType,
  ])
  onSubmit,
  required List<String> paymentMethods,
  required List<String> expenseTypes,
}) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  DateTime selectedDate =
      transaction != null ? DateTime.parse(transaction.date) : DateTime.now();
  String? selectedPaymentType = paymentMethods.first;
  String? selectedExpenseType =
      expenseTypes.isNotEmpty ? expenseTypes.first : null;

  if (transaction != null) {
    _nameController.text =
        type == 'Income' ? transaction.source ?? '' : transaction.name ?? '';
    _amountController.text = transaction.amount.toString();
    _statusController.text = transaction.status ?? '';
    selectedPaymentType = transaction.paymentMethod ?? paymentMethods.first;
    selectedExpenseType =
        transaction.type ??
        (expenseTypes.isNotEmpty ? expenseTypes.first : null);
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate = picked;
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: type == 'Income' ? 'Source' : 'Name',
                ),
                controller: _nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              Row(
                children: [
                  Text(
                    "Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(
                      Icons.date_range_rounded,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: selectedPaymentType,
                decoration: const InputDecoration(labelText: "Payment Method"),
                items:
                    paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  selectedPaymentType = newValue;
                },
              ),
              if (type == "Expense")
                DropdownButtonFormField<String>(
                  value: selectedExpenseType,
                  decoration: const InputDecoration(labelText: "Expense Type"),
                  items:
                      expenseTypes.map((expenseType) {
                        return DropdownMenuItem(
                          value: expenseType,
                          child: Text(expenseType),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    selectedExpenseType = newValue;
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSubmit(
                _nameController.text.trim(),
                double.tryParse(_amountController.text) ?? 0.0,
                DateFormat('dd-MM-yyyy').format(selectedDate),
                _statusController.text,
                selectedPaymentType!,
                selectedExpenseType,
              );
              Navigator.of(context).pop();
            },
            child: Text(transaction == null ? 'Submit' : 'Update'),
          ),
        ],
      );
    },
  );
}
