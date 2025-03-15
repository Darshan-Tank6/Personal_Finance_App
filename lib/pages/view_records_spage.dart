// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../helpers/database_helper.dart';
// import '../models/borrow.dart';
// import '../models/expense.dart';
// import '../models/income.dart';
// import '../models/lend.dart';

// class CurrentMonthRecordsScreen extends StatefulWidget {
//   const CurrentMonthRecordsScreen({Key? key}) : super(key: key);

//   @override
//   _CurrentMonthRecordsScreenState createState() =>
//       _CurrentMonthRecordsScreenState();
// }

// class _CurrentMonthRecordsScreenState extends State<CurrentMonthRecordsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _dbHelper = DatabaseHelper();
//   late String _currentMonthYear;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _currentMonthYear = DateFormat('yyyy-MM').format(DateTime.now());
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<List<dynamic>> _fetchRecords(String type) {
//     final recordFetchers = {
//       'Income':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'incomes',
//             (map) => Income(
//               id: map['id'],
//               source: map['source'],
//               amount: map['amount'],
//               date: map['date'],
//             ),
//           ),
//       'Expense':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'expenses',
//             (map) => Expense(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               date: map['date'],
//             ),
//           ),
//       'Borrow':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'borrows',
//             (map) => Borrow(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               clearedDate: map['clearedDate'],
//               date: map['date'],
//             ),
//           ),
//       'Lending':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'lendings',
//             (map) => Lending(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               date: map['date'],
//               clearedDate: map['clearedDate'],
//             ),
//           ),
//     };

//     return recordFetchers[type]!();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Records for ${DateFormat("MMMM yyyy").format(DateTime.now())}',
//         ),
//         bottom: TabBar(
//           labelColor: Colors.purpleAccent[100],
//           indicatorColor: Colors.purpleAccent[100],
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Income'),
//             Tab(text: 'Expense'),
//             Tab(text: 'Lending'),
//             Tab(text: 'Borrow'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildRecordList('Income'),
//           _buildRecordList('Expense'),
//           _buildRecordList('Lending'),
//           _buildRecordList('Borrow'),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecordList(String type) {
//     return FutureBuilder<List<dynamic>>(
//       future: _fetchRecords(type),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No $type records found.'));
//         }

//         final records = snapshot.data!;
//         return ListView.builder(
//           itemCount: records.length,
//           itemBuilder: (context, index) {
//             final record = records[index];
//             final recordId = record.id;
//             final isSelected = _selectedRecords.contains(recordId);
//             if (record is Expense) {
//               return ListTile(
//                 title: Text(record.name),
//                 subtitle: Text('Amount: ${record.amount}'),
//                 trailing: Text(record.date),
//               );
//             } else if (record is Income) {
//               return ListTile(
//                 title: Text("${record.source}"),
//                 subtitle: Text(
//                   'Amount: ${record.amount}',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 //trailing: Text(record.date),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () => _deleteIncome(record.id!),
//                   iconSize: 18,
//                   tooltip: 'Delete Income',
//                   padding: EdgeInsets.zero,
//                   constraints: BoxConstraints(),
//                 ),
//               );
//             } else if (record is Borrow) {
//               return ListTile(
//                 title: Text(record.name),
//                 subtitle: Text('Amount: ${record.amount}'),
//                 trailing: Text(record.date),
//               );
//             } else if (record is Lending) {
//               return ListTile(
//                 title: Text(record.name),
//                 subtitle: Text('Amount: ${record.amount}'),
//                 trailing: Text(record.date),
//               );
//             } else {
//               return const SizedBox.shrink();
//             }
//           },
//         );
//       },
//     );
//   }

//   //delete income
//   void _deleteIncome(int id) async {
//     await _dbHelper.deleteIncome(id);
//     setState(() {});
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../helpers/database_helper.dart';
// import '../models/borrow.dart';
// import '../models/expense.dart';
// import '../models/income.dart';
// import '../models/lend.dart';

// class CurrentMonthRecordsScreen extends StatefulWidget {
//   const CurrentMonthRecordsScreen({Key? key}) : super(key: key);

//   @override
//   _CurrentMonthRecordsScreenState createState() =>
//       _CurrentMonthRecordsScreenState();
// }

// class _CurrentMonthRecordsScreenState extends State<CurrentMonthRecordsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _dbHelper = DatabaseHelper();
//   late String _currentMonthYear;
//   final Set<int> _selectedRecords = {};

//   final _nameController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _statusController = TextEditingController();

//   DateTime _selectedDate = DateTime.now();
//   String dateselected = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String monthYear = DateFormat('yyyy-MM').format(DateTime.now());
//   DateFormat formatter = DateFormat('yyyy-MM-dd');

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _currentMonthYear = DateFormat('yyyy-MM').format(DateTime.now());
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<List<dynamic>> _fetchRecords(String type) {
//     final recordFetchers = {
//       'Income':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'incomes',
//             (map) => Income(
//               id: map['id'],
//               source: map['source'],
//               amount: map['amount'],
//               date: map['date'],
//             ),
//           ),
//       'Expense':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'expenses',
//             (map) => Expense(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               date: map['date'],
//             ),
//           ),
//       'Borrow':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'borrows',
//             (map) => Borrow(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               clearedDate: map['clearedDate'],
//               date: map['date'],
//               status: map['status'],
//             ),
//           ),
//       'Lending':
//           () => _dbHelper.getRecordsByMonthYear(
//             _currentMonthYear,
//             'lendings',
//             (map) => Lending(
//               id: map['id'],
//               name: map['name'],
//               amount: map['amount'],
//               date: map['date'],
//               clearedDate: map['clearedDate'],
//               status: map['status'],
//             ),
//           ),
//     };

//     return recordFetchers[type]!();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Records for ${DateFormat("MMMM yyyy").format(DateTime.now())}',
//         ),
//         actions:
//             _selectedRecords.isNotEmpty
//                 ? [
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: _deleteSelectedRecords,
//                   ),
//                 ]
//                 : null,
//         bottom: TabBar(
//           labelColor: theme.colorScheme.secondary,
//           indicatorColor: theme.colorScheme.secondary,
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Income'),
//             Tab(text: 'Expense'),
//             Tab(text: 'Lending'),
//             Tab(text: 'Borrow'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildRecordList('Income', isDarkMode),
//           _buildRecordList('Expense', isDarkMode),
//           _buildRecordList('Lending', isDarkMode),
//           _buildRecordList('Borrow', isDarkMode),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecordList(String type, bool isDarkMode) {
//     return FutureBuilder<List<dynamic>>(
//       future: _fetchRecords(type),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Text(
//               'No $type records found.',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           );
//         }

//         final records = snapshot.data!;
//         return ListView.separated(
//           itemCount: records.length,
//           separatorBuilder: (context, index) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final record = records[index];
//             final recordId = record.id;
//             final isSelected = _selectedRecords.contains(recordId);
//             final selectionColor = Theme.of(
//               context,
//             ).colorScheme.secondary.withOpacity(0.3);

//             return GestureDetector(
//               onLongPress: () => _toggleSelection(recordId),
//               onTap: () {
//                 if (_selectedRecords.isNotEmpty) {
//                   _toggleSelection(recordId);
//                 }
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 decoration: BoxDecoration(
//                   color: isSelected ? selectionColor : null,
//                   border:
//                       isSelected
//                           ? Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             width: 2,
//                           )
//                           : null,
//                 ),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   title: Text(
//                     record is Income ? record.source : record.name,
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   // subtitle: Text(
//                   //   (record != Borrow || record != Lending)
//                   //       ? 'Amount: ${record.amount} | ${record.status} '
//                   //       : 'Amount: ${record.amount}',
//                   //   style: TextStyle(color: Colors.grey[600]),
//                   // ),
//                   subtitle: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ), // Default style
//                       children: [
//                         TextSpan(
//                           text:
//                               (record is Borrow || record is Lending)
//                                   ? '₹ ${record.amount} | '
//                                   : '₹ ${record.amount}',
//                         ),
//                         if (record is Borrow || record is Lending) ...[
//                           if (record.status == "Pending")
//                             TextSpan(
//                               text: record.status,
//                               style: TextStyle(
//                                 color: Colors.red[200],
//                               ), // Red status
//                             ),
//                           if (record.status != 'Pending')
//                             TextSpan(
//                               text: 'Cleared: ${record.clearedDate}',
//                               style: TextStyle(color: Colors.grey[600]),
//                             ),
//                         ],
//                       ],
//                     ),
//                   ),

//                   trailing:
//                       _selectedRecords.isEmpty
//                           ? Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (record is Income)
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, size: 20),
//                                   onPressed:
//                                       () => _deleteRecord(type, record.id!),
//                                   //onPressed: () => _deleteIncome(record.id!),
//                                   padding: EdgeInsets.zero,
//                                   constraints: const BoxConstraints(),
//                                 ),
//                               IconButton(
//                                 icon: const Icon(Icons.edit, size: 20),
//                                 onPressed:
//                                     () => _editRecord(context, type, record),
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                             ],
//                           )
//                           : null,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _toggleSelection(int id) {
//     setState(() {
//       if (_selectedRecords.contains(id)) {
//         _selectedRecords.remove(id);
//       } else {
//         _selectedRecords.add(id);
//       }
//     });
//   }

//   void _deleteSelectedRecords() async {
//     for (var id in _selectedRecords) {
//       final currentIndex = _tabController.index;
//       switch (currentIndex) {
//         case 0:
//           await _dbHelper.deleteIncome(id);
//           break;
//         case 1:
//           await _dbHelper.deleteExpense(id);
//           break;
//         case 2:
//           await _dbHelper.deleteLending(id);
//           break;
//         case 3:
//           await _dbHelper.deleteCredit(id);
//           break;
//       }
//     }
//     setState(() {
//       _selectedRecords.clear;
//     });
//   }

//   void _deleteRecord(String type, int id) async {
//     switch (type) {
//       case "Income":
//         await _dbHelper.deleteIncome(id);
//         break;
//       case "Expense":
//         await _dbHelper.deleteExpense(id);
//         break;
//       case "Lending":
//         await _dbHelper.deleteCredit(id);
//         break;
//       case "Borrow":
//         await _dbHelper.deleteLending(id);
//         break;
//       default:
//         print("Inavlid choice");

//         setState(() {});
//     }
//     await _dbHelper.deleteCredit(id);
//     setState(() {});
//   }

//   void _editRecord(BuildContext context, String type, dynamic record) {
//     _showTransactionDialog(context, type, transaction: record);
//     setState(() {});
//   }

//   void _pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//     print(_selectedDate);
//   }

//   void _showTransactionDialog(
//     BuildContext context,
//     String type, {
//     dynamic transaction,
//   }) {
//     if (transaction != null) {
//       if (type == 'Income') {
//         _nameController.text =
//             transaction.source ?? ''; // 'Income' uses 'source'
//       } else {
//         _nameController.text = transaction.name ?? ''; // Other types use 'name'
//       }

//       _amountController.text = transaction.amount.toString();
//       _selectedDate = DateTime.parse(transaction.date);
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         List<Widget> _getCommonFields() => [
//           TextField(
//             decoration: InputDecoration(
//               labelText: type == 'Income' ? 'Source' : 'Name',
//             ),
//             controller: _nameController,
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: 'Amount'),
//             keyboardType: TextInputType.number,
//             controller: _amountController,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Date: ${formatter.format(_selectedDate)}",
//                 style: TextStyle(fontSize: 14),
//               ),
//               Spacer(),
//               IconButton(
//                 onPressed: _pickDate,
//                 icon: Icon(
//                   Icons.date_range_rounded,
//                   color: Colors.purpleAccent[100],
//                 ),
//                 iconSize: 18,
//                 tooltip: 'Pick a date',
//                 padding: EdgeInsets.zero,
//                 constraints: BoxConstraints(),
//               ),
//             ],
//           ),
//         ];

//         List<Widget> _getInputFields() {
//           if (type == 'Borrow') {
//             return [
//               ..._getCommonFields(),
//               DropdownButtonFormField(
//                 decoration: const InputDecoration(labelText: 'Status'),
//                 value:
//                     _statusController.text.isNotEmpty
//                         ? _statusController.text
//                         : 'Pending',
//                 items:
//                     ['Pending', 'Paid']
//                         .map(
//                           (status) => DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           ),
//                         )
//                         .toList(),
//                 onChanged: (value) {
//                   if (value != null) {
//                     _statusController.text = value; // Store the selected value
//                   }
//                 },
//               ),
//             ];
//           }
//           return _getCommonFields();
//         }

//         Future<void> _handleSubmit() async {
//           final name = _nameController.text;
//           final amount = double.parse(_amountController.text);
//           final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
//           final status = _statusController.text;

//           if (transaction == null) {
//             // Add new transaction
//             switch (type) {
//               case 'Income':
//                 await _dbHelper.insertIncome(
//                   Income(source: name, amount: amount, date: formattedDate),
//                 );
//                 break;
//               case 'Expense':
//                 await _dbHelper.insertExpense(
//                   Expense(name: name, amount: amount, date: formattedDate),
//                 );
//                 break;
//               case 'Lend':
//                 await _dbHelper.insertLending(
//                   Lending(
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                     clearedDate: formattedDate,
//                     status: status,
//                   ),
//                 );
//                 break;
//               case 'Borrow':
//                 await _dbHelper.insertBorrow(
//                   Borrow(
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                     clearedDate: formattedDate,
//                     status: status,
//                   ),
//                 );
//                 break;
//               default:
//                 print('Invalid type');
//                 return;
//             }
//           } else {
//             // Update existing transaction
//             switch (type) {
//               case 'Income':
//                 await _dbHelper.updateIncome(
//                   Income(
//                     id: transaction.id,
//                     source: name,
//                     amount: amount,
//                     date: formattedDate,
//                   ),
//                 );
//                 break;
//               case 'Expense':
//                 await _dbHelper.updateExpense(
//                   Expense(
//                     id: transaction.id,
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                   ),
//                 );
//                 break;
//               case 'Lend':
//                 await _dbHelper.updateLending(
//                   Lending(
//                     id: transaction.id,
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                     clearedDate: formattedDate,
//                     status: status,
//                   ),
//                 );
//                 break;
//               case 'Borrow':
//                 await _dbHelper.updateBorrow(
//                   Borrow(
//                     id: transaction.id,
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                     clearedDate: formattedDate,
//                     status: status,
//                   ),
//                 );
//                 break;
//               default:
//                 print('Invalid type');
//                 return;
//             }
//           }

//           setState(() {});
//           _nameController.clear();
//           _amountController.clear();
//           Navigator.of(context).pop();
//         }

//         return AlertDialog(
//           title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: _getInputFields(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: _handleSubmit,
//               child: Text(transaction == null ? 'Submit' : 'Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/borrow.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/lend.dart';

class CurrentMonthRecordsScreen extends StatefulWidget {
  const CurrentMonthRecordsScreen({Key? key}) : super(key: key);

  @override
  _CurrentMonthRecordsScreenState createState() =>
      _CurrentMonthRecordsScreenState();
}

class _CurrentMonthRecordsScreenState extends State<CurrentMonthRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dbHelper = DatabaseHelper();
  late String _currentMonthYear;
  final Set<int> _selectedRecords = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentMonthYear = DateFormat('yyyy-MM').format(DateTime.now());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _fetchRecords(String type) {
    //   final recordFetchers = {
    //     'Income':
    //         () => _dbHelper.getRecordsByMonthYear(
    //           _currentMonthYear,
    //           'incomes',
    //           (map) => Income.fromMap(map),
    //         ),
    //     'Expense':
    //         () => _dbHelper.getRecordsByMonthYear(
    //           _currentMonthYear,
    //           'expenses',
    //           (map) => Expense.fromMap(map),
    //         ),
    //     'Borrow':
    //         () => _dbHelper.getRecordsByMonthYear(
    //           _currentMonthYear,
    //           'borrows',
    //           (map) => Borrow.fromMap(map),
    //         ),
    //     'Lending':
    //         () => _dbHelper.getRecordsByMonthYear(
    //           _currentMonthYear,
    //           'lendings',
    //           (map) => Lending.fromMap(map),
    //         ),
    //   };

    //   return recordFetchers[type]!();
    // }

    final recordFetchers = {
      'Income':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'incomes',
            (map) => Income(
              id: map['id'],
              source: map['source'],
              amount: map['amount'],
              date: map['date'],
            ),
          ),
      'Expense':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'expenses',
            (map) => Expense(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              date: map['date'],
              type: map['type'],
            ),
          ),
      'Borrow':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'borrows',
            (map) => Borrow(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              clearedDate: map['clearedDate'],
              date: map['date'],
              status: map['status'],
            ),
          ),
      'Lending':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'lendings',
            (map) => Lending(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              date: map['date'],
              clearedDate: map['clearedDate'],
              status: map['status'],
            ),
          ),
    };

    return recordFetchers[type]!();
  }

  // void _deleteSelectedRecords() async {
  //   for (var id in _selectedRecords) {
  //     await _dbHelper.deleteRecordById(id);
  //   }
  //   setState(() => _selectedRecords.clear());
  // }

  void _deleteSelectedRecords() async {
    for (var id in _selectedRecords) {
      final currentIndex = _tabController.index;
      switch (currentIndex) {
        case 0:
          await _dbHelper.deleteIncome(id);
          break;
        case 1:
          await _dbHelper.deleteExpense(id);
          break;
        case 2:
          await _dbHelper.deleteLending(id);
          break;
        case 3:
          await _dbHelper.deleteCredit(id);
          break;
      }
    }
    setState(() {
      _selectedRecords.clear();
    });
  }

  void _toggleSelection(int id) {
    setState(
      () =>
          _selectedRecords.contains(id)
              ? _selectedRecords.remove(id)
              : _selectedRecords.add(id),
    );
  }

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String dateselected = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String monthYear = DateFormat('yyyy-MM').format(DateTime.now());
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  List<String> _expenseTypes = ["Food", "Transport", "Shopping", "Rent"];
  String? _selectedType;

  void _editRecord(BuildContext context, String type, dynamic record) {
    _showTransactionDialog(context, type, transaction: record);
    setState(() {});
  }

  void _pickDate() async {
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

  void _showAddExpenseDialog(BuildContext context) {
    TextEditingController _expensetypecontroller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Expense Type"),
          content: TextField(
            controller: _expensetypecontroller,
            decoration: InputDecoration(hintText: "Enter new expense type"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newType = _expensetypecontroller.text.trim();
                  if (newType.isNotEmpty && !_expenseTypes.contains(newType)) {
                    _expenseTypes.add(newType);
                    _selectedType = newType;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showTransactionDialog(
    BuildContext context,
    String type, {
    dynamic transaction,
  }) {
    if (transaction != null) {
      if (type == 'Income') {
        _nameController.text =
            transaction.source ?? ''; // 'Income' uses 'source'
      } else {
        _nameController.text = transaction.name ?? ''; // Other types use 'name'
      }

      _amountController.text = transaction.amount.toString();
      _selectedDate = DateTime.parse(transaction.date);
    }

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
          if (type == 'Borrow' || type == 'Lend') {
            return [
              ..._getCommonFields(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _statusController.text = 'Pending';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _statusController.text == 'Pending'
                                  ? Colors
                                      .blue // Highlight if selected
                                  : Colors.grey[300],
                          foregroundColor:
                              _statusController.text == 'Pending'
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        child: const Text('Pending'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _statusController.text = 'Paid';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _statusController.text == 'Paid'
                                  ? Colors
                                      .blue // Highlight if selected
                                  : Colors.grey[300],
                          foregroundColor:
                              _statusController.text == 'Paid'
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        child: const Text('Paid'),
                      ),
                    ],
                  ),
                ],
              ),
            ];
          }
          if (type == "Expense") {
            return [
              ..._getCommonFields(),
              Center(
                child: Wrap(
                  spacing: 10.0,
                  children: [
                    ..._expenseTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: _selectedType == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = type; // Always selects a type
                          });
                        },
                      );
                    }).toList(),
                    ActionChip(
                      label: Text("➕ Add"),
                      onPressed: () => _showAddExpenseDialog(context),
                    ),
                  ],
                ),
              ),
            ];
          }
          return _getCommonFields();
        }

        Future<void> _handleSubmit() async {
          final name = _nameController.text;
          final amount = double.parse(_amountController.text);
          final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
          final status = _statusController.text;
          final expenseType = _selectedType ?? '';

          if (transaction == null) {
            // Add new transaction
            switch (type) {
              case 'Income':
                await _dbHelper.insertIncome(
                  Income(source: name, amount: amount, date: formattedDate),
                );
                break;
              case 'Expense':
                await _dbHelper.insertExpense(
                  Expense(
                    name: name,
                    amount: amount,
                    date: formattedDate,
                    type: expenseType,
                  ),
                );
                break;
              case 'Lend':
                await _dbHelper.insertLending(
                  Lending(
                    name: name,
                    amount: amount,
                    date: formattedDate,
                    clearedDate: formattedDate,
                    status: status,
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
                    status: status,
                  ),
                );
                break;
              default:
                print('Invalid type');
                return;
            }
          } else {
            // Update existing transaction
            switch (type) {
              case 'Income':
                await _dbHelper.updateIncome(
                  Income(
                    id: transaction.id,
                    source: name,
                    amount: amount,
                    date: formattedDate,
                  ),
                );
                break;
              case 'Expense':
                await _dbHelper.updateExpense(
                  Expense(
                    id: transaction.id,
                    name: name,
                    amount: amount,
                    date: formattedDate,
                    type: expenseType,
                  ),
                );
                break;
              case 'Lend':
                await _dbHelper.updateLending(
                  Lending(
                    id: transaction.id,
                    name: name,
                    amount: amount,
                    date: formattedDate,
                    clearedDate: formattedDate,
                    status: status,
                  ),
                );
                break;
              case 'Borrow':
                await _dbHelper.updateBorrow(
                  Borrow(
                    id: transaction.id,
                    name: name,
                    amount: amount,
                    date: formattedDate,
                    clearedDate: formattedDate,
                    status: status,
                  ),
                );
                break;
              default:
                print('Invalid type');
                return;
            }
          }

          setState(() {});
          _nameController.clear();
          _amountController.clear();
          Navigator.of(context).pop();
        }

        return AlertDialog(
          title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
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
            TextButton(
              onPressed: _handleSubmit,
              child: Text(transaction == null ? 'Submit' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Records for ${DateFormat("MMMM yyyy").format(DateTime.now())}',
        ),

        actions:
            _selectedRecords.isNotEmpty
                ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSelectedRecords,
                  ),
                ]
                : null,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
            Tab(text: 'Lending'),
            Tab(text: 'Borrow'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            [
              'Income',
              'Expense',
              'Lending',
              'Borrow',
            ].map((type) => _buildRecordList(type)).toList(),
      ),
    );
  }

  Widget _buildRecordList(String type) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchRecords(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $type records found.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final record = snapshot.data![index];
            final isSelected = _selectedRecords.contains(record.id);

            return GestureDetector(
              onLongPress: () => _toggleSelection(record.id),
              onTap:
                  () =>
                      _selectedRecords.isNotEmpty
                          ? _toggleSelection(record.id)
                          : null,
              child: Card(
                color: isSelected ? Colors.blueAccent.withOpacity(0.2) : null,
                shape:
                    isSelected
                        ? RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        )
                        : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                child: ListTile(
                  title: Text(record is Income ? record.source : record.name),
                  // subtitle: Text('₹ ${record.amount} | ${record.date}'),
                  subtitle: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ), // Default style
                      children: [
                        TextSpan(
                          text:
                              (record is Borrow || record is Lending)
                                  ? '₹ ${record.amount} | '
                                  : (record is Expense)
                                  ? '₹ ${record.amount} | ${record.date} | ${record.type}'
                                  : '₹ ${record.amount} | ${record.date}',
                        ),
                        if (record is Borrow || record is Lending) ...[
                          if (record.status == "Pending")
                            TextSpan(
                              text: record.status,
                              style: TextStyle(
                                color: Colors.red[200],
                              ), // Red status
                            ),
                          if (record.status != 'Pending')
                            TextSpan(
                              text: 'Cleared: ${record.clearedDate}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                        ],
                      ],
                    ),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check_circle,
                            color: Colors.blueAccent,
                          )
                          : IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editRecord(context, type, record),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
