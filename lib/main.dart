// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: HomeScreen());
//   }
// }

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
  String dateselected = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String monthYear = DateFormat('yyyy-MM').format(DateTime.now());
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  List<String> _expenseTypes = ["Food", "Transport", "Shopping", "Rent"];
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

  void _showDialog(BuildContext context, String type) {
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

          setState(() {});
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

  void _showTransactionDialog(
    BuildContext context,
    String type, {
    dynamic transaction,
  }) {
    if (transaction != null) {
      _nameController.text = transaction.name ?? transaction.source ?? '';
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
          if (type == 'Borrow') {
            return [
              ..._getCommonFields(),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Status'),
                value: transaction?.status ?? 'Pending',
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
          final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
          final status = _statusController.text;
          final expenseType = _selectedType!;

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

  //Add expense
  void _addExpense() async {
    if (_selectedType == null) {
      // Show an error message if no type is selected
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a type')));
      return;
    }

    final name = _nameController.text;
    final amount = double.parse(_amountController.text);

    final type = _selectedType!; // Use the selected type for the expense
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    print(formattedDate);
    final expense = Expense(
      name: name,
      amount: amount,
      date: formattedDate,
      type: type,
    );

    await _dbHelper.insertExpense(expense); // Insert expense into the database

    // Update the actualBalance in the budget after recording the expense
    //await _dbHelper.updateActualBalance(amount, type);

    setState(() {}); // Refresh the page
    _nameController.clear(); // Clear text fields
    _amountController.clear();
  }

  //Add income
  void _addIncome() async {
    final source = _nameController.text;
    final amount = double.parse(_amountController.text);
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final income = Income(source: source, amount: amount, date: formattedDate);
    await _dbHelper.insertIncome(income);
    setState(() {});
    _nameController.clear();
    _amountController.clear();
  }

  //Add lendings
  void _addLending() async {
    final name = _nameController.text;
    final amount = double.parse(_amountController.text);
    final status = _statusController.text;
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final lending = Lending(
      name: name,
      amount: amount,
      date: formattedDate,
      clearedDate: formattedDate,
      status: status,
    );
    await _dbHelper.insertLending(lending);
    setState(() {});
    _nameController.clear();
    _amountController.clear();
  }

  //Add borrows
  void _addBorrow() async {
    final name = _nameController.text;
    final amount = double.parse(_amountController.text);
    final status = _statusController.text;
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final borrow = Borrow(
      name: name,
      amount: amount,
      date: formattedDate,
      clearedDate: formattedDate,
      status: status,
    );
    await _dbHelper.insertBorrow(borrow);
    setState(() {});
    _nameController.clear();
    _amountController.clear();
  }

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
