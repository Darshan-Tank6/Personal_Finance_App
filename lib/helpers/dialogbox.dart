import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart'; // Your database helper
import '../models/income.dart';
import '../models/expense.dart';
import '../models/lend.dart';
import '../models/borrow.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
DateTime _selectedDate = DateTime.now();
final formatter = DateFormat('yyyy-MM-dd');

final _dbHelper = DatabaseHelper();

void showTransactionDialog(BuildContext context, String type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> _getCommonFields() => [
        TextField(
          decoration: InputDecoration(
            labelText: type == 'Income' ? 'Source' : 'Name',
          ),
          controller: _nameController,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
          controller: _amountController,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Date: ${formatter.format(_selectedDate)}",
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            IconButton(
              onPressed: _pickDate,
              icon: Icon(
                Icons.date_range_rounded,
                color: Colors.purpleAccent[100],
              ),
              iconSize: 18,
              tooltip: 'Pick a date',
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ];

      List<Widget> _getInputFields() {
        if (type == 'Borrow') {
          return [
            ..._getCommonFields(),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Status'),
              items:
                  ['Pending', 'Paid']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
              onChanged: (value) {},
            ),
          ];
        }
        return _getCommonFields();
      }

      Future<void> _handleSubmit() async {
        final name = _nameController.text;
        final amount = double.parse(_amountController.text);
        final formattedDate = formatter.format(_selectedDate);

        switch (type) {
          case 'Income':
            await _dbHelper.insertIncome(
              Income(source: name, amount: amount, date: formattedDate),
            );
            break;
          case 'Expense':
            await _dbHelper.insertExpense(
              Expense(name: name, amount: amount, date: formattedDate),
            );
            break;
          case 'Lend':
            await _dbHelper.insertLending(
              Lending(
                name: name,
                amount: amount,
                date: formattedDate,
                clearedDate: formattedDate,
              ),
            );
            break;
          case 'Borrow':
            await _dbHelper.insertBorrow(
              Borrow(
                name: name,
                amount: amount,
                date: formattedDate,
                clearedDate: formattedDate,
              ),
            );
            break;
          default:
            print('Invalid type');
            return;
        }

        _nameController.clear();
        _amountController.clear();
        Navigator.of(context).pop();
      }

      return AlertDialog(
        title: Text('Add $type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _getInputFields(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(onPressed: _handleSubmit, child: Text('Submit')),
        ],
      );
    },
  );
}

Future<void> _pickDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  }
  print(_selectedDate);
}
