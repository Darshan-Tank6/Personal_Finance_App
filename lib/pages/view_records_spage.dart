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
//     //   final recordFetchers = {
//     //     'Income':
//     //         () => _dbHelper.getRecordsByMonthYear(
//     //           _currentMonthYear,
//     //           'incomes',
//     //           (map) => Income.fromMap(map),
//     //         ),
//     //     'Expense':
//     //         () => _dbHelper.getRecordsByMonthYear(
//     //           _currentMonthYear,
//     //           'expenses',
//     //           (map) => Expense.fromMap(map),
//     //         ),
//     //     'Borrow':
//     //         () => _dbHelper.getRecordsByMonthYear(
//     //           _currentMonthYear,
//     //           'borrows',
//     //           (map) => Borrow.fromMap(map),
//     //         ),
//     //     'Lending':
//     //         () => _dbHelper.getRecordsByMonthYear(
//     //           _currentMonthYear,
//     //           'lendings',
//     //           (map) => Lending.fromMap(map),
//     //         ),
//     //   };

//     //   return recordFetchers[type]!();
//     // }

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
//               type: map['type'],
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

//   // void _deleteSelectedRecords() async {
//   //   for (var id in _selectedRecords) {
//   //     await _dbHelper.deleteRecordById(id);
//   //   }
//   //   setState(() => _selectedRecords.clear());
//   // }

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
//       _selectedRecords.clear();
//     });
//   }

//   void _toggleSelection(int id) {
//     setState(
//       () =>
//           _selectedRecords.contains(id)
//               ? _selectedRecords.remove(id)
//               : _selectedRecords.add(id),
//     );
//   }

//   final _nameController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _statusController = TextEditingController();

//   DateTime _selectedDate = DateTime.now();
//   String dateselected = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String monthYear = DateFormat('yyyy-MM').format(DateTime.now());
//   DateFormat formatter = DateFormat('yyyy-MM-dd');

//   List<String> _expenseTypes = ["Food", "Transport", "Shopping", "Rent"];
//   String? _selectedType;

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

//   void _showAddExpenseDialog(BuildContext context) {
//     TextEditingController _expensetypecontroller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Add Expense Type"),
//           content: TextField(
//             controller: _expensetypecontroller,
//             decoration: InputDecoration(hintText: "Enter new expense type"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   String newType = _expensetypecontroller.text.trim();
//                   if (newType.isNotEmpty && !_expenseTypes.contains(newType)) {
//                     _expenseTypes.add(newType);
//                     _selectedType = newType;
//                   }
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
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
//           if (type == 'Borrow' || type == 'Lend') {
//             return [
//               ..._getCommonFields(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Status', style: TextStyle(fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _statusController.text = 'Pending';
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               _statusController.text == 'Pending'
//                                   ? Colors
//                                       .blue // Highlight if selected
//                                   : Colors.grey[300],
//                           foregroundColor:
//                               _statusController.text == 'Pending'
//                                   ? Colors.white
//                                   : Colors.black,
//                         ),
//                         child: const Text('Pending'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _statusController.text = 'Paid';
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               _statusController.text == 'Paid'
//                                   ? Colors
//                                       .blue // Highlight if selected
//                                   : Colors.grey[300],
//                           foregroundColor:
//                               _statusController.text == 'Paid'
//                                   ? Colors.white
//                                   : Colors.black,
//                         ),
//                         child: const Text('Paid'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ];
//           }
//           if (type == "Expense") {
//             return [
//               ..._getCommonFields(),
//               Center(
//                 child: Wrap(
//                   spacing: 10.0,
//                   children: [
//                     ..._expenseTypes.map((type) {
//                       return ChoiceChip(
//                         label: Text(type),
//                         selected: _selectedType == type,
//                         onSelected: (selected) {
//                           setState(() {
//                             _selectedType = type; // Always selects a type
//                           });
//                         },
//                       );
//                     }).toList(),
//                     ActionChip(
//                       label: Text("➕ Add"),
//                       onPressed: () => _showAddExpenseDialog(context),
//                     ),
//                   ],
//                 ),
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
//           final expenseType = _selectedType ?? '';

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
//                   Expense(
//                     name: name,
//                     amount: amount,
//                     date: formattedDate,
//                     type: expenseType,
//                   ),
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
//                     type: expenseType,
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

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
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
//         children:
//             [
//               'Income',
//               'Expense',
//               'Lending',
//               'Borrow',
//             ].map((type) => _buildRecordList(type)).toList(),
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

//         return ListView.builder(
//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) {
//             final record = snapshot.data![index];
//             final isSelected = _selectedRecords.contains(record.id);

//             return GestureDetector(
//               onLongPress: () => _toggleSelection(record.id),
//               onTap:
//                   () =>
//                       _selectedRecords.isNotEmpty
//                           ? _toggleSelection(record.id)
//                           : null,
//               child: Card(
//                 color: isSelected ? Colors.blueAccent.withOpacity(0.2) : null,
//                 shape:
//                     isSelected
//                         ? RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.blueAccent, width: 2),
//                           borderRadius: BorderRadius.circular(12),
//                         )
//                         : RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                 child: ListTile(
//                   title: Text(record is Income ? record.source : record.name),
//                   // subtitle: Text('₹ ${record.amount} | ${record.date}'),
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
//                                   : (record is Expense)
//                                   ? '₹ ${record.amount} | ${record.date} | ${record.type}'
//                                   : '₹ ${record.amount} | ${record.date}',
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
//                       isSelected
//                           ? const Icon(
//                             Icons.check_circle,
//                             color: Colors.blueAccent,
//                           )
//                           : IconButton(
//                             icon: const Icon(Icons.edit, size: 20),
//                             onPressed: () => _editRecord(context, type, record),
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                           ),
//                 ),
//               ),
//             );
//           },
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
import 'package:provider/provider.dart';
import '../helpers/transaction_provider.dart';
import '../widgets/transaction_dialog.dart';

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
  final Set<int> _selectedRecords = {};
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  final DateFormat _formatter = DateFormat('dd-MM-yyyy');
  late final String _currentMonthYear;

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _expenseTypes = ["Food", "Transport", "Shopping", "Rent"];
  String? _selectedType;

  List<String> _paymentMethodTypes = ["Cash", "UPI", "Card"];
  String? _selectedPaymentType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentMonthYear = DateFormat('MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _fetchRecords(String type) async {
    final fetchers = {
      'Income':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'incomes',
            (map) => Income.fromMap(map),
          ),
      'Expense':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'expenses',
            (map) => Expense.fromMap(map),
          ),
      'Borrow':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'borrows',
            (map) => Borrow.fromMap(map),
          ),
      'Lending':
          () => _dbHelper.getRecordsByMonthYear(
            _currentMonthYear,
            'lendings',
            (map) => Lending.fromMap(map),
          ),
    };
    return fetchers[type]!();
  }

  void _deleteSelectedRecords() async {
    for (var id in _selectedRecords) {
      switch (_tabController.index) {
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
    setState(() => _selectedRecords.clear());
  }

  void _toggleSelection(int id) {
    setState(
      () =>
          _selectedRecords.contains(id)
              ? _selectedRecords.remove(id)
              : _selectedRecords.add(id),
    );
  }

  // void _pickDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) setState(() => _selectedDate = picked);
  // }

  void _editRecord(BuildContext context, String type, dynamic record) {
    _showEditDialog(context, type, record);
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

  // void _showAddExpenseDialog(BuildContext context) {
  //   final TextEditingController _controller = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Add Expense Type"),
  //         content: TextField(
  //           controller: _controller,
  //           decoration: InputDecoration(
  //             hintText: "Enter new expense type",
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               String newType = _controller.text.trim();
  //               if (newType.isEmpty || _expenseTypes.contains(newType)) {
  //                 Navigator.of(context).pop(); // Close dialog without updates
  //                 return;
  //               }

  //               setState(() {
  //                 _expenseTypes.add(newType);
  //                 _selectedType = newType; // Immediately select the new type
  //               });

  //               Navigator.of(context).pop(); // Close the dialog after adding
  //             },
  //             child: Text("Add"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  ValueNotifier<String> selectedStatus = ValueNotifier<String>('');
  ValueNotifier<String> selectedStatusNew = ValueNotifier<String>('');

  void _showEditDialog(BuildContext context, String type, dynamic transaction) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    // Pre-fill fields with existing transaction data
    provider.setEditingTransaction(transaction, type);

    showDialog(
      context: context,
      builder:
          (context) => TransactionDialog(
            type: type,
            transaction: transaction, // Pass existing transaction for editing
            onSubmit: (
              String name,
              double amount,
              String date,
              String status,
              String paymentMethod, [
              String? expenseType,
              String? repetetive,
            ]) async {
              final dbHelper = DatabaseHelper();

              switch (type) {
                case 'Income':
                  await dbHelper.updateIncome(
                    Income(
                      id: transaction.id,
                      source: name,
                      amount: amount,
                      date: transaction.date,
                      paymentMethod: paymentMethod,
                    ),
                  );
                  break;
                case 'Expense':
                  await dbHelper.updateExpense(
                    Expense(
                      id: transaction.id,
                      name: name,
                      amount: amount,
                      date: transaction.date,
                      type: expenseType ?? transaction.type,
                      paymentMethod: paymentMethod,
                      repetetive: repetetive ?? transaction.repetetive,
                    ),
                  );
                  break;
                case 'Lend':
                  await dbHelper.updateLending(
                    Lending(
                      id: transaction.id,
                      name: name,
                      amount: amount,
                      date: transaction.date,
                      clearedDate: date,
                      status: status,
                      paymentMethod: paymentMethod,
                    ),
                  );
                  break;
                case 'Borrow':
                  await dbHelper.updateBorrow(
                    Borrow(
                      id: transaction.id,
                      name: name,
                      amount: amount,
                      date: transaction.date,
                      clearedDate: date,
                      status: status,
                      paymentMethod: paymentMethod,
                    ),
                  );
                  break;
                default:
                  print("Invalid transaction type: $type");
              }

              provider.clearInputs(); // Reset after editing
              //Navigator.of(context).pop();
            },
          ),
    );
  }

  Widget _buildInfoTile(dynamic record, String type, bool isSelected) {
    return Card(
      color: isSelected ? Colors.blueAccent.withOpacity(0.2) : null,
      shape: RoundedRectangleBorder(
        side:
            isSelected
                ? BorderSide(color: Colors.blueAccent, width: 2)
                : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(record is Income ? record.source : record.name),
        subtitle: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            children: [
              TextSpan(
                text:
                    // '₹ ${record.amount} | ${DateFormat('dd-MM-yyyy').format(record.date)}',
                    '₹ ${record.amount} | ${record.date} | ${record.paymentMethod}',
              ),
              if (record is Expense)
                TextSpan(text: ' | ${record.type} | ${record.repetetive}'),
              if (record is Borrow || record is Lending) ...[
                TextSpan(
                  text:
                      record.status == "Pending"
                          ? ' | Pending'
                          : ' | Cleared: ${record.clearedDate}',
                  style: TextStyle(
                    color:
                        record.status == "Pending"
                            ? Colors.red[200]
                            : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        // trailing:
        //     isSelected
        //         ? Icon(Icons.check_circle, color: Colors.blueAccent)
        //         : IconButton(
        //           icon: Icon(Icons.edit, size: 20),
        //           onPressed: () => _editRecord(context, type, record),
        //         ),
        onLongPress: () => _toggleSelection(record.id),
        onTap:
            () =>
                _selectedRecords.isNotEmpty
                    ? _toggleSelection(record.id)
                    : _editRecord(context, type, record),
      ),
    );
  }

  Widget _buildRecordList(String type) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchRecords(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(child: Text('No $type records found.'));
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final record = snapshot.data![index];
            return _buildInfoTile(
              record,
              type,
              _selectedRecords.contains(record.id),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Records for ${DateFormat("MMMM yyyy").format(DateTime.now())}',
        ),
        actions:
            _selectedRecords.isNotEmpty
                ? [
                  IconButton(
                    icon: Icon(Icons.delete),
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
}
