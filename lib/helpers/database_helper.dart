import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/income.dart';
import '../models/expense.dart';
import '../models/lend.dart';
import '../models/borrow.dart';

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
    String path = join(await getDatabasesPath(), 'expense_v1.7');
    return await openDatabase(
      path,
      version: 3, // Incremented version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incomes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source TEXT,
            amount REAL,
            date TEXT,
            paymentMethod TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            date TEXT,
            type TEXT,
            paymentMethod TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE lendings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            status INTEGER,
            date TEXT,
            clearedDate TEXT,
            paymentMethod TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE borrows(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            status INTEGER,
            date TEXT,
            clearedDate TEXT,
            paymentMethod TEXT
          )
        ''');
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
        paymentMethod: maps[i]['paymentMethod'],
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
        paymentMethod: maps[i]['paymentMethod'],
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
        paymentMethod: maps[i]['paymentMethod'],
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
        paymentMethod: maps[i]['paymentMethod'],
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
      'incomes',
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

  Future<double> calculateTotalIncome1() async {
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

  Future<double> calculateTotalIncome() async {
    final db = await database;
    final List<Map<String, dynamic>> incomes = await db.query('incomes');

    double totalIncome = 0;
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    for (var income in incomes) {
      final String? dateString = income['date'];

      if (dateString == null || dateString.trim().isEmpty) {
        print("Skipping entry with invalid date: $income");
        continue;
      }

      try {
        String cleanDate = dateString.trim();
        List<String> parts = cleanDate.split('-');

        print("Raw date: $cleanDate, Extracted parts: $parts");

        if (parts.length == 3) {
          int day = int.parse(parts[0]); // ✅ Fix: Swap day and year
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);

          final DateTime incomeDate = DateTime(year, month, day);
          print("Parsed incomeDate: $incomeDate");

          if (incomeDate.month == currentMonth &&
              incomeDate.year == currentYear) {
            final amount = (income['amount'] ?? 0).toDouble();
            print("Adding amount: $amount from entry: $income");
            totalIncome += amount;
          }
        } else {
          print("Invalid date format: $cleanDate");
        }
      } catch (e) {
        print("Error parsing date: '$dateString' - Exception: $e");
      }
    }

    print("Final totalIncome: $totalIncome");
    return totalIncome;
  }

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
    final allowedTables = ['expenses', 'incomes', 'borrows', 'lendings'];

    if (!allowedTables.contains(tableName)) {
      throw Exception('Invalid table name');
    }

    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT DISTINCT substr(date, 4, 7) AS month_year
    FROM $tableName
    ORDER BY month_year DESC;
  ''');

    return results.map((row) => row['month_year'] as String).toList();
  }

  // Function to get expenses for a given month and year
  // Future<List<Expense>> getExpensesByMonthYearExpenses(String monthYear) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'expenses',
  //     where: "substr(date, 1, 7) = ?",
  //     whereArgs: [monthYear],
  //   );
  //   return List.generate(maps.length, (i) {
  //     return Expense(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       amount: maps[i]['amount'],
  //       date: maps[i]['date'],
  //       type: maps[i]['type'],
  //       paymentMethod: maps[i]['paymentMethod'],
  //     );
  //   });
  // }

  // //get Incomes based on monthyear
  // Future<List<Income>> getIncomesByMonthYearIncomes(String monthYear) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'incomes',
  //     where: "substr(date, 1, 7) = ?",
  //     whereArgs: [monthYear],
  //   );
  //   return List.generate(maps.length, (i) {
  //     return Income(
  //       id: maps[i]['id'],
  //       source: maps[i]['source'],
  //       amount: maps[i]['amount'],
  //       date: maps[i]['date'],
  //       paymentMethod: maps[i]['paymentMethod'],
  //     );
  //   });
  // }

  //3 function to one by chatgpt
  //This is important don't fuck up this
  // Future<List<T>> getRecordsByMonthYear<T>(
  //   String monthYear,
  //   String tableName,
  //   T Function(Map<String, dynamic>) fromMap,
  // ) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     tableName,
  //     where: "substr(date, 4, 7) = ?",
  //     whereArgs: [monthYear],
  //   );
  //   return maps.map((map) => fromMap(map)).toList();
  // }

  Future<List<T>> getRecordsByMonthYear<T>(
    String monthYear, // Format: MM-YYYY
    String tableName,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "substr(date, 4, 7) = ?", // Extract MM-YYYY from DD-MM-YYYY
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
