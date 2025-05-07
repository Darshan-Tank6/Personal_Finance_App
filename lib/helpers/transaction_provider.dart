// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TransactionProvider extends ChangeNotifier {
//   DateTime _selectedDate = DateTime.now();
//   String _selectedType = '';
//   String _selectedPaymentType = 'Cash';
//   String _selectedStatus = 'Pending';

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController statusController = TextEditingController();

//   DateTime get selectedDate => _selectedDate;
//   String get selectedType => _selectedType;
//   String get selectedPaymentType => _selectedPaymentType;
//   String get selectedStatus => _selectedStatus;

//   void pickDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       _selectedDate = picked;
//       notifyListeners();
//     }
//   }

//   void setType(String type) {
//     _selectedType = type;
//     notifyListeners();
//   }

//   void setPaymentMethod(String method) {
//     _selectedPaymentType = method;
//     notifyListeners();
//   }

//   void setStatus(String status) {
//     _selectedStatus = status;
//     statusController.text = status;
//     notifyListeners();
//   }

//   void clearInputs() {
//     nameController.clear();
//     amountController.clear();
//     _selectedType = '';
//     _selectedStatus = 'Pending';
//     _selectedPaymentType = 'Cash';
//     _selectedDate = DateTime.now();
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedPaymentType = "Cash";
  String selectedStatus = "Pending";
  String selectedExpenseType = "";
  String repetetive = "false";

  List<String> expenseTypes = ["Food", "Transport", "Shopping"];
  List<String> paymentMethods = ["Cash", "UPI", "Card"]; // ✅ Added this

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  void setPaymentMethod(String newMethod) {
    selectedPaymentType = newMethod;
    notifyListeners();
  }

  void setExpenseType(String newType) {
    selectedExpenseType = newType;
    notifyListeners();
  }

  void setStatus(String newStatus) {
    selectedStatus = newStatus;
    notifyListeners();
  }

  void setrepetetive(String newrepetetive) {
    repetetive = newrepetetive;
    notifyListeners();
  }

  void setEditingTransaction(dynamic transaction, String type) {
    nameController.text =
        type == 'Income' ? transaction.source ?? '' : transaction.name ?? '';
    amountController.text = transaction.amount.toString();

    try {
      selectedDate = DateFormat("dd-MM-yyyy").parse(transaction.date);
    } catch (e) {
      selectedDate = DateTime.now(); // Default to today if parsing fails
    }

    selectedPaymentType = transaction.paymentMethod ?? "Cash";
    if (type == 'Expense') {
      selectedExpenseType = transaction.type ?? "";
      repetetive = transaction.repetetive ?? "false";
    }
    if (type == 'Lend' || type == 'Borrow') {
      selectedStatus = transaction.status ?? "Pending";
    }
    notifyListeners();
  }

  void clearInputs() {
    nameController.clear();
    amountController.clear();
    statusController.clear();
    selectedDate = DateTime.now();
    selectedPaymentType = "Cash";
    selectedStatus = "Pending";
    selectedExpenseType = "";
    repetetive = "False";
    notifyListeners();
  }

  void addExpenseType(String newType) {
    if (newType.isNotEmpty && !expenseTypes.contains(newType)) {
      expenseTypes = [
        ...expenseTypes,
        newType,
      ]; // ✅ Create a new list to trigger rebuild
      selectedExpenseType = newType; // ✅ Auto-select new type
      notifyListeners();
    }
  }

  // void addExpenseType(String newType) {
  //   if (newType.isNotEmpty && !expenseTypes.contains(newType)) {
  //     expenseTypes = [...expenseTypes, newType];
  //     notifyListeners();
  //   }
  // }

  void removeExpenseType(String type) {
    expenseTypes.remove(type);
    notifyListeners();
  }

  void addPaymentMethod(String newMethod) {
    if (newMethod.isNotEmpty && !paymentMethods.contains(newMethod)) {
      paymentMethods = [...paymentMethods, newMethod];
      notifyListeners();
    }
  }

  void removePaymentMethod(String method) {
    paymentMethods.remove(method);
    notifyListeners();
  }
}
