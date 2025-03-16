import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'pages/home_page.dart';
import 'pages/setting_page.dart';
import 'pages/view_records_spage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'helpers/database_helper.dart';
import 'models/expense.dart';
import 'models/borrow.dart';
import 'models/income.dart';
import 'models/lend.dart';
import 'pages/setting_page.dart';
import 'pages/view_past_records.dart';
import 'pages/theme_provider.dart';
import 'helpers/transaction_provider.dart';
import 'widgets/transaction_dialog.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      //themeMode: ThemeMode.system,
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/settings': (context) => const SettingsPage(),
        '/view-records': (context) => const ViewPastRecords(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tracks the selected tab
  final _dbHelper = DatabaseHelper();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  final _typeController = TextEditingController();

  // List of primary pages for the BottomNavigationBar
  final List<Widget> _pages = [
    CurrentMonthRecordsScreen(),
    HomePage(),
    SettingsPage(),
    // IncomePage(),
    // ExpensePage(),
    // BudgetsPage(),
  ];

  // Function to handle BottomNavigationBar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DateTime _selectedDate = DateTime.now();
  String dateselected = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String monthYear = DateFormat('yyyy-MM').format(DateTime.now());
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  List<String> _expenseTypes = ["Food", "Transport", "Shopping", "Rent"];

  final List<String> _paymentMethodTypes = ["Cash", "UPI", "Card"];
  String _selectedPaymentType = "Cash";

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedPaymentType = _paymentMethodTypes.first; // Default selection
  // }

  String? _selectedType;

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
    print("Selected Date: ${_selectedDate}");
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

  ValueNotifier<String> selectedStatus = ValueNotifier<String>('');

  void _showDialog(BuildContext context, String type) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.clearInputs(); // Ensure fresh inputs

    showDialog(
      context: context,
      builder:
          (context) => TransactionDialog(
            type: type,
            onSubmit: (
              String name,
              double amount,
              String date,
              String? status,
              String paymentMethod, [
              String? expenseType,
            ]) async {
              final dbHelper = DatabaseHelper();

              switch (type) {
                case 'Income':
                  await dbHelper.insertIncome(
                    Income(
                      source: name,
                      amount: amount,
                      date: date,
                      paymentMethod: paymentMethod,
                    ),
                  );
                  print("Successfully inserted date: ${date}");
                  break;
                case 'Expense':
                  await dbHelper.insertExpense(
                    Expense(
                      name: name,
                      amount: amount,
                      date: date,
                      type: expenseType ?? '',
                      paymentMethod: paymentMethod,
                    ),
                  );
                  print("Successfully inserted data: ");
                  break;
                case 'Lend':
                  await dbHelper.insertLending(
                    Lending(
                      name: name,
                      amount: amount,
                      date: date,
                      clearedDate: date,
                      status: status ?? ' ',
                      paymentMethod: paymentMethod,
                    ),
                  );
                  print("Successfully inserted data: ");
                  break;
                case 'Borrow':
                  await dbHelper.insertBorrow(
                    Borrow(
                      name: name,
                      amount: amount,
                      date: date,
                      clearedDate: date,
                      status: status ?? '',
                      paymentMethod: paymentMethod,
                    ),
                  );
                  print("Successfully inserted data: ");
                  break;
                default:
                  print("Invalid transaction type: $type");
              }

              provider.clearInputs(); // Reset after adding
              //Navigator.of(context).pop();
            },
          ),
    );
  }

  // void _showTransactionDialog(
  //   BuildContext context,
  //   String type, {
  //   dynamic transaction,
  // }) {
  //   if (transaction != null) {
  //     _nameController.text = transaction.name ?? transaction.source ?? '';
  //     _amountController.text = transaction.amount.toString();
  //     _selectedDate = DateTime.parse(transaction.date);
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       List<Widget> _getCommonFields() => [
  //         TextField(
  //           decoration: InputDecoration(
  //             labelText: type == 'Income' ? 'Source' : 'Name',
  //           ),
  //           controller: _nameController,
  //         ),
  //         TextField(
  //           decoration: InputDecoration(labelText: 'Amount'),
  //           keyboardType: TextInputType.number,
  //           controller: _amountController,
  //         ),
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               "Date: ${formatter.format(_selectedDate)}",
  //               style: TextStyle(fontSize: 14),
  //             ),
  //             Spacer(),
  //             IconButton(
  //               onPressed: _pickDate,
  //               icon: Icon(
  //                 Icons.date_range_rounded,
  //                 color: Colors.purpleAccent[100],
  //               ),
  //               iconSize: 18,
  //               tooltip: 'Pick a date',
  //               padding: EdgeInsets.zero,
  //               constraints: BoxConstraints(),
  //             ),
  //           ],
  //         ),
  //       ];
  //
  //       List<Widget> _getInputFields() {
  //         if (type == 'Borrow') {
  //           return [
  //             ..._getCommonFields(),
  //             DropdownButtonFormField(
  //               decoration: InputDecoration(labelText: 'Status'),
  //               value: transaction?.status ?? 'Pending',
  //               items:
  //                   ['Pending', 'Paid']
  //                       .map(
  //                         (status) => DropdownMenuItem(
  //                           value: status,
  //                           child: Text(status),
  //                         ),
  //                       )
  //                       .toList(),
  //               onChanged: (value) {},
  //             ),
  //           ];
  //         }
  //         return _getCommonFields();
  //       }
  //
  //       Future<void> _handleSubmit() async {
  //         final name = _nameController.text;
  //         final amount = double.parse(_amountController.text);
  //         final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
  //         final status = _statusController.text;
  //         final expenseType = _selectedType!;
  //
  //         if (transaction == null) {
  //           // Add new transaction
  //           switch (type) {
  //             case 'Income':
  //               await _dbHelper.insertIncome(
  //                 Income(source: name, amount: amount, date: formattedDate),
  //               );
  //               break;
  //             case 'Expense':
  //               await _dbHelper.insertExpense(
  //                 Expense(
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   type: expenseType,
  //                 ),
  //               );
  //               break;
  //             case 'Lend':
  //               await _dbHelper.insertLending(
  //                 Lending(
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   clearedDate: formattedDate,
  //                   status: status,
  //                 ),
  //               );
  //               break;
  //             case 'Borrow':
  //               await _dbHelper.insertBorrow(
  //                 Borrow(
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   clearedDate: formattedDate,
  //                   status: status,
  //                 ),
  //               );
  //               break;
  //             default:
  //               print('Invalid type');
  //               return;
  //           }
  //         } else {
  //           // Update existing transaction
  //           switch (type) {
  //             case 'Income':
  //               await _dbHelper.updateIncome(
  //                 Income(
  //                   id: transaction.id,
  //                   source: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                 ),
  //               );
  //               break;
  //             case 'Expense':
  //               await _dbHelper.updateExpense(
  //                 Expense(
  //                   id: transaction.id,
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   type: expenseType,
  //                 ),
  //               );
  //               break;
  //             case 'Lend':
  //               await _dbHelper.updateLending(
  //                 Lending(
  //                   id: transaction.id,
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   clearedDate: formattedDate,
  //                   status: status,
  //                 ),
  //               );
  //               break;
  //             case 'Borrow':
  //               await _dbHelper.updateBorrow(
  //                 Borrow(
  //                   id: transaction.id,
  //                   name: name,
  //                   amount: amount,
  //                   date: formattedDate,
  //                   clearedDate: formattedDate,
  //                   status: status,
  //                 ),
  //               );
  //               break;
  //             default:
  //               print('Invalid type');
  //               return;
  //           }
  //         }
  //
  //         setState(() {});
  //         _nameController.clear();
  //         _amountController.clear();
  //         Navigator.of(context).pop();
  //       }
  //
  //       return AlertDialog(
  //         title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: _getInputFields(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: _handleSubmit,
  //             child: Text(transaction == null ? 'Submit' : 'Update'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Finance Tracker')),
      //body: Center(child: Text('Home Screen')),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purpleAccent[100],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              //  color: Colors.purpleAccent,
            ),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              //color: Colors.purpleAccent,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              //  color: Colors.purpleAccent,
            ),
            label: 'Settings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.account_balance,
          //     //  color: Colors.purpleAccent,
          //   ),
          //   label: 'Budget',
          // ),
        ],
      ),
      floatingActionButton: SpeedDial(
        //animatedIcon: AnimatedIcons.ellipsis_search,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.purpleAccent.withOpacity(0.8),
        spacing: 5,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.account_balance_wallet),
            label: 'Lendings',
            onTap: () => _showDialog(context, 'Lend'),
          ),
          SpeedDialChild(
            child: Icon(Icons.credit_card),
            label: 'Borrows', //Credits page
            onTap: () => _showDialog(context, 'Borrow'),
          ),

          SpeedDialChild(
            child: Icon(Icons.money_off),
            label: 'Expense',
            onTap: () => _showDialog(context, 'Expense'),
          ),

          SpeedDialChild(
            child: Icon(Icons.currency_rupee),
            label: 'Income',
            onTap: () => _showDialog(context, 'Income'),
          ),
        ],
      ),
    );
  }
}
