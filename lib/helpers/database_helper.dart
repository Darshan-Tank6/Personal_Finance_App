import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../models/income.dart';
import '../models/expense.dart';
import '../models/lend.dart';
import '../models/borrow.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'expense_v1.3');
    return await openDatabase(
      path,
      version: 3, // Incremented version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incomes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source TEXT,
            amount REAL,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            date TEXT,
            type TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE lendings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            status INTEGER,
            date TEXT,
            clearedDate TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE borrows(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            status INTEGER,
            date TEXT,
            clearedDate TEXT
          )
        ''');
        // await db.execute('''
        //   CREATE TABLE budgets(
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     name TEXT,
        //     amount REAL,
        //     date TEXT,
        //     actualBudget REAL,
        //     actualBalance REAL
        //   )
        // ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // // Add new column actualBalance and remove the old one (if required)
          // await db.execute('''
          //   ALTER TABLE budgets ADD COLUMN actualBudget REAL;
          // ''');
          // await db.execute('''
          //   ALTER TABLE budgets ADD COLUMN actualBalance REAL;
          // ''');
          // await db.execute('''
          // ALTER TABLE budgets DROP COLUMN type;''');
          //
          // await db.execute('''
          // ALTER TABLE incomes ADD COLUMN date TEXT;''');
          // await db.execute('''
          // ALTER TABLE budgets ADD COLUMN date TEXT;''');
          // await db.execute('''
          // ALTER TABLE borrows ADD COLUMN date TEXT;''');
          // await db.execute('''
          // ALTER TABLE lendings ADD COLUMN date TEXT;''');
          // print("column added");
        }
        // Handle other future upgrades if necessary
      },
    );
  }

  // CRUD operations for Income
  Future<int> insertIncome(Income income) async {
    final db = await database;
    return await db.insert('incomes', income.toMap());
  }

  Future<List<Income>> getIncomes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incomes');
    return List.generate(maps.length, (i) {
      return Income(
        id: maps[i]['id'],
        source: maps[i]['source'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }

  // CRUD operations for Expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        type: maps[i]['type'],
      );
    });
  }

  // CRUD operations for Lending
  Future<int> insertLending(Lending lending) async {
    final db = await database;
    return await db.insert('lendings', lending.toMap());
  }

  Future<List<Lending>> getLendings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lendings');
    return List.generate(maps.length, (i) {
      return Lending(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        status: maps[i]['status'],
        date: maps[i]['date'],
        clearedDate: maps[i]['clearedDate'],
      );
    });
  }

  // Future<int> updateLending(Lending lending) async {
  //   final db = await database;
  //   return await db.update(
  //     'lendings',
  //     lending.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [lending.id],
  //   );
  // }

  // CRUD operations for Credit
  Future<int> insertBorrow(Borrow borrow) async {
    final db = await database;
    return await db.insert('borrows', borrow.toMap());
  }

  Future<List<Borrow>> getBorrows() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('borrows');
    return List.generate(maps.length, (i) {
      return Borrow(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        status: maps[i]['status'],
        date: maps[i]['date'],
        clearedDate: maps[i]['clearedDate'],
      );
    });
  }

  // Future<int> updateBorrow(Borrow borrow) async {
  //   final db = await database;
  //   return await db.update(
  //     'borrows',
  //     borrow.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [borrow.id],
  //   );
  // }

  // CRUD operations for Budget
  // Future<int> insertBudget(Budget budget) async {
  //   final db = await database;
  //   return await db.insert('budgets', budget.toMap());
  // }

  // Future<int> insertBudgets(Budget budget) async {
  //   final db = await database;

  //   // Set the actualBudget to the budget amount and set actualBalance to the same value
  //   return await db.insert('budgets', {
  //     'name': budget.name,
  //     'amount': budget.amount,
  //     //'type': budget.type,
  //     'actualBudget': budget.amount,
  //     // Initialize with the amount
  //     'actualBalance': budget.amount,
  //     // Initialize actualBalance with the same amount
  //     'date': budget.date,
  //   });
  //   ; // Return success
  // }

  // Future<List<Budget>> getBudgets() async {
  //   try {
  //     final db = await database;
  //     final List<Map<String, dynamic>> maps = await db.query('budgets');
  //     return List.generate(maps.length, (i) {
  //       return Budget(
  //         id: maps[i]['id'],
  //         name: maps[i]['name'],
  //         amount: maps[i]['amount'],
  //         //type: maps[i]['type'],
  //         actualBudget: maps[i]['actualBudget'],
  //         actualBalance: maps[i]['actualBalance'],
  //         date: maps[i]['date'],
  //       );
  //     });
  //   } catch (e) {
  //     print('Error fetching budgets: $e');
  //     // Handle the error, e.g., return an empty list or throw a custom exception
  //     return [];
  //   }
  // }

  // In your DatabaseHelper class
  // Future<List<String>> getBudgetTypes() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //     'SELECT DISTINCT name FROM budgets',
  //   );
  //   return List.generate(maps.length, (i) {
  //     return maps[i]['name'];
  //   });
  // }

  // Future<List<String>> getBudgetNames() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //     'SELECT DISTINCT name,actualBalance FROM budgets',
  //   );
  //   return List.generate(maps.length, (i) {
  //     return maps[i]['name'];
  //   });
  // }

  // /////////////////////////////////
  // Future<List<String>> getBudgetNames3() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //     'SELECT DISTINCT name, actualBalance FROM budgets',
  //   );
  //   return List.generate(maps.length, (i) {
  //     final name = maps[i]['name'];
  //     final balance = maps[i]['actualBalance'];
  //     return '$name (Balance: $balance)';
  //   });
  // }

  // //////////////////////////////////////////
  // Future<List<Map<String, dynamic>>> getBudgetNames2() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //     'SELECT DISTINCT name, actualBalance FROM budgets',
  //   );
  //   return maps;
  // }

  // Future<void> clearAllBudgets() async {
  //   final db = await database;
  //   await db.delete('budgets');
  //   print("all budgets cleared");
  //   // setState(() {}); // If you're using a StateFulWidget, update the UI
  // }

  // Future<void> editBudget(Budget budget) async {
  //   final db = await database;
  //   await db.update(
  //     'budgets',
  //     budget.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [budget.id],
  //   );
  // }

  // //Delete a specific row n budgets
  // Future<void> deleteBudget(int id) async {
  //   final db = await database;
  //   await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  // }

  // // Method to update actualBalance after an expense is recorded
  // Future<void> updateActualBalance(double amount, String type) async {
  //   final db = await database;

  //   // Retrieve the budget with the specified type and positive actualBalance
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'budgets',
  //     where: 'name = ? AND actualBalance > 0',
  //     whereArgs: [type],
  //   );

  //   if (result.isNotEmpty) {
  //     double actualBudget = result[0]['actualBudget'];
  //     double actualBalance = result[0]['actualBalance'];

  //     // Deduct the expense amount from the actualBalance
  //     actualBalance -= amount;

  //     // Update the actualBalance in the database
  //     await db.update(
  //       'budgets',
  //       {'actualBalance': actualBalance},
  //       where: 'id = ?',
  //       whereArgs: [result[0]['id']],
  //     );
  //   }
  // }

  // // Method to update actualBalance after an expense is recorded
  // Future<void> revertUpdateonBudget(double amount, String type) async {
  //   final db = await database;

  //   // Retrieve the budget with the specified type and positive actualBalance
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'budgets',
  //     where: 'name = ? AND actualBalance > 0',
  //     whereArgs: [type],
  //   );

  //   if (result.isNotEmpty) {
  //     double actualBudget = result[0]['actualBudget'];
  //     double actualBalance = result[0]['actualBalance'];

  //     // Deduct the expense amount from the actualBalance
  //     actualBalance += amount;

  //     // Update the actualBalance in the database
  //     await db.update(
  //       'budgets',
  //       {'actualBalance': actualBalance},
  //       where: 'id = ?',
  //       whereArgs: [result[0]['id']],
  //     );
  //   }
  // }

  Future<void> clearAllIncomes() async {
    final db = await database;
    await db.delete('incomes');
    print("all income cleared");
    // setState(() {}); // If you're using a StateFulWidget, update the UI
  }

  Future<void> clearAllExpenses() async {
    final db = await database;
    await db.delete('expenses');
    print("all expenses cleared");
    // setState(() {}); // If you're using a StateFulWidget, update the UI
  }

  Future<void> clearAllLendings() async {
    final db = await database;
    await db.delete('lendings');
    print("all lendings cleared");
    // setState(() {}); // If you're using a StateFulWidget, update the UI
  }

  Future<void> clearAllCredits() async {
    final db = await database;
    await db.delete('borrows');
    print("all borrows cleared");
    // setState(() {}); // If you're using a StateFulWidget, update the UI
  }

  Future<double> calculateTotalIncome2() async {
    final db = await database;
    final List<Map<String, dynamic>> incomes = await db.query('incomes');

    double totalIncome = 0;
    for (var income in incomes) {
      totalIncome += income['amount'];
    }

    return totalIncome;
  }

  ////////////////////////////////////
  Future<int> updateIncome(Income income) async {
    final db = await database;
    return await db.update(
      'income',
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> updateLending(Lending lending) async {
    final db = await database;
    return await db.update(
      'lendings',
      lending.toMap(),
      where: 'id = ?',
      whereArgs: [lending.id],
    );
  }

  Future<int> updateBorrow(Borrow borrow) async {
    final db = await database;
    return await db.update(
      'borrows',
      borrow.toMap(),
      where: 'id = ?',
      whereArgs: [borrow.id],
    );
  }
  /////////////////////////////////////////////////

  Future<double> calculateTotalIncome() async {
    final db = await database;
    final List<Map<String, dynamic>> incomes = await db.query('incomes');

    double totalIncome = 0;
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    for (var income in incomes) {
      // Assuming the date format is 'YYYY-MM-DD'
      final incomeDate = DateTime.parse(
        income['date'],
      ); // Parse the TEXT date into DateTime object
      if (incomeDate.month == currentMonth && incomeDate.year == currentYear) {
        totalIncome += income['amount'];
      }
    }

    return totalIncome;
  }

  // Future<double> calculateTotalBudget2() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> budgets = await db.query('budgets');

  //   double totalBudget = 0;
  //   for (var budget in budgets) {
  //     totalBudget += budget['amount'];
  //   }

  //   return totalBudget;
  // }

  // Future<double> calculateTotalBudget() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> budgets = await db.query('budgets');

  //   double totalBudget = 0;
  //   final currentDate = DateTime.now();
  //   final currentMonth = currentDate.month;
  //   final currentYear = currentDate.year;

  //   for (var budget in budgets) {
  //     // Assuming the date format is 'YYYY-MM-DD'
  //     final budgetDate = DateTime.parse(
  //       budget['date'],
  //     ); // Parse the TEXT date into DateTime object
  //     if (budgetDate.month == currentMonth && budgetDate.year == currentYear) {
  //       totalBudget += budget['amount'];
  //     }
  //   }

  //   return totalBudget;
  // }

  Future<double> calculateTotalExpense() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    double totalExpense = 0;
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    for (var expense in maps) {
      // Assuming the date format is 'YYYY-MM-DD'
      final expenseDate = DateTime.parse(
        expense['date'],
      ); // Parse the TEXT date into DateTime object
      if (expenseDate.month == currentMonth &&
          expenseDate.year == currentYear) {
        totalExpense += expense['amount'];
      }
    }

    return totalExpense;
  }

  //Delete a specific row in expenses
  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  //Edit specific expense
  Future<void> editExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  //Delete a specific row in incomes
  Future<void> deleteIncome(int id) async {
    final db = await database;
    await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  //delete credit
  Future<void> deleteCredit(int id) async {
    final db = await database;
    await db.delete('borrows', where: 'id = ?', whereArgs: [id]);
  }

  //Delete lendings
  Future<void> deleteLending(int id) async {
    final db = await database;
    await db.delete('lendings', where: 'id = ?', whereArgs: [id]);
  }

  //very chutiya chiz
  // List<Map<String, dynamic>> groupExpensesByMonthYear(List<Expense> expenses) {
  //   Map<String, List<Expense>> groupedExpenses = {};
  //
  //   for (Expense expense in expenses) {
  //     DateTime? date = parseDate(expense.date);
  //     if (date != null) {
  //       String key = '${date.year}-${date.month}';
  //       groupedExpenses.putIfAbsent(key, () => []);
  //       groupedExpenses[key]!.add(expense);
  //     }
  //   }
  //
  //   return groupedExpenses.entries.map((entry) {
  //     return {
  //       'monthYear': entry.key,
  //       'expenses': entry.value,
  //     };
  //   }).toList();
  // }

  // Widget buildExpansionTile(Map<String, dynamic> group) {
  //   return ExpansionTile(
  //     title: Text(group['monthYear']),
  //     children: group['expenses'].map((expense) {
  //       return ListTile(
  //         title: Text(expense.name),
  //         subtitle: Text(
  //             '₹${expense.amount.toStringAsFixed(2)} - ${expense.date.toLocal()
  //                 .toString()
  //                 .split(' ')[0]}'),
  //       );
  //     }).toList(),
  //   );
  // }

  // Function to get distinct months and years
  Future<List<String>> getDistinctMonthsYears(String tableName) async {
    final allowedTables = [
      'expenses',
      'incomes',
      'borrows',
      'lendings',
    ]; // Example allowed tables

    if (!allowedTables.contains(tableName)) {
      throw Exception('Invalid table name');
    }

    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT DISTINCT substr(date, 1, 7) AS month_year
    FROM $tableName
    ORDER BY month_year DESC
  ''');
    return results.map((row) => row['month_year'] as String).toList();
  }

  // Function to get expenses for a given month and year
  Future<List<Expense>> getExpensesByMonthYearExpenses(String monthYear) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: "substr(date, 1, 7) = ?",
      whereArgs: [monthYear],
    );
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        type: maps[i]['type'],
      );
    });
  }

  //get Incomes based on monthyear
  Future<List<Income>> getIncomesByMonthYearIncomes(String monthYear) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'incomes',
      where: "substr(date, 1, 7) = ?",
      whereArgs: [monthYear],
    );
    return List.generate(maps.length, (i) {
      return Income(
        id: maps[i]['id'],
        source: maps[i]['source'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }

  // //get Budgets on basis of monthyear
  // Future<List<Budget>> getBudgetsByMonthYearBudgets(String monthYear) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'budgets',
  //     where: "substr(date, 1, 7) = ?",
  //     whereArgs: [monthYear],
  //   );
  //   return List.generate(maps.length, (i) {
  //     return Budget(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       amount: maps[i]['amount'],
  //       actualBudget: maps[i]['actualBudget'],
  //       actualBalance: maps[i]['actualBalance'],
  //       date: maps[i]['date'],
  //     );
  //   });
  // }

  //3 function to one by chatgpt
  //This is important don't fuck up this
  Future<List<T>> getRecordsByMonthYear<T>(
    String monthYear,
    String tableName,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "substr(date, 1, 7) = ?",
      whereArgs: [monthYear],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  //experimental
  Future<List<T>> getRecords<T>(
    String tableName,
    String monthYear,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final db = await database;

    // Sanitize or validate the table name if necessary
    final allowedTables = [
      'expenses',
      'incomes',
      'borrows',
      'lendings',
    ]; // Example allowed tables
    if (!allowedTables.contains(tableName)) {
      throw Exception('Invalid table name: $tableName');
    }

    try {
      // Log the parameters
      print('Querying table: $tableName for monthYear: $monthYear');

      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: "substr(date, 1, 7) = ?",
        whereArgs: [monthYear],
      );

      // Log the result of the query
      print('Query results: $maps');

      // Convert each map into the desired object using the provided fromMap function
      return List.generate(maps.length, (i) => fromMap(maps[i]));
    } catch (e) {
      print('Error fetching records by monthYear: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecords2(
    String tableName,
    String monthYear,
  ) async {
    final db = await database;

    // Validate if the table name is allowed or exists
    final allowedTables = ['expenses', 'incomes', 'borrows', 'lendings'];
    if (!allowedTables.contains(tableName)) {
      throw Exception('Invalid table name');
    }

    try {
      // Query the database to get records by month-year filter
      final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: "substr(date, 1, 7) = ?",
        whereArgs: [monthYear],
      );
      print('Fetched records from $tableName: $result');
      return result;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }
}
