import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/borrow.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/lend.dart';

class ViewPastRecords extends StatefulWidget {
  const ViewPastRecords({Key? key}) : super(key: key);

  @override
  _ViewPastRecordsState createState() => _ViewPastRecordsState();
}

class _ViewPastRecordsState extends State<ViewPastRecords> {
  late Future<List<String>> _monthsYearsFuture;
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _monthsYearsFuture = _dbHelper.getDistinctMonthsYears(
      'incomes',
    ); // Fetch distinct months-years
    print("_monthsYearsFuture : ${_monthsYearsFuture}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Records')),
      body: FutureBuilder<List<String>>(
        future: _monthsYearsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          final monthsYears = snapshot.data!;
          print("Month Years before: $monthsYears");

          return ListView.builder(
            itemCount: monthsYears.length,
            itemBuilder: (context, index) {
              final monthYear = monthsYears[index];

              try {
                // Parse MM-yyyy correctly
                DateTime parsedDate = DateFormat("MM-yyyy").parse(monthYear);
                String formattedMonthYear = DateFormat(
                  "MMMM yyyy",
                ).format(parsedDate);

                return ListTile(
                  title: Text(formattedMonthYear),
                  onTap: () {
                    print("monthYear: $monthYear");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecordsTabsScreen(
                              monthYear: monthYear,
                              dbHelper: _dbHelper,
                            ),
                      ),
                    );
                  },
                );
              } catch (e) {
                return ListTile(title: Text("Invalid date format"));
              }
            },
          );
        },
      ),
    );
  }
}

class RecordsTabsScreen extends StatefulWidget {
  final String monthYear;
  final DatabaseHelper dbHelper;

  const RecordsTabsScreen({required this.monthYear, required this.dbHelper});

  @override
  _RecordsTabsScreenState createState() => _RecordsTabsScreenState();
}

class _RecordsTabsScreenState extends State<RecordsTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _fetchRecords(String type) {
    final recordFetchers = {
      'Income':
          () => widget.dbHelper.getRecordsByMonthYear(
            widget.monthYear,
            'incomes',
            (map) => Income(
              id: map['id'],
              source: map['source'],
              amount: map['amount'],
              date: map['date'],
              paymentMethod: map['paymentMethod'],
            ),
          ),
      'Expense':
          () => widget.dbHelper.getRecordsByMonthYear(
            widget.monthYear,
            'expenses',
            (map) => Expense(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              date: map['date'],
              type: map['type'],
              paymentMethod: map['paymentMethod'],
              repetetive: map['repetetive'],
            ),
          ),
      'Borrow':
          () => widget.dbHelper.getRecordsByMonthYear(
            widget.monthYear,
            'borrows',
            (map) => Borrow(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              clearedDate: map['clearedDate'],
              date: map['date'],
              status: map['status'],
              paymentMethod: map['paymentMethod'],
            ),
          ),
      'Lending':
          () => widget.dbHelper.getRecordsByMonthYear(
            widget.monthYear,
            'lendings',
            (map) => Lending(
              id: map['id'],
              name: map['name'],
              amount: map['amount'],
              date: map['date'],
              clearedDate: map['clearedDate'],
              status: map['status'],
              paymentMethod: map['paymentMethod'],
            ),
          ),
    };

    return recordFetchers[type]!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records for ${widget.monthYear}'),
        bottom: TabBar(
          //labelColor: Colors.blue, // Color for the selected tab text
          labelColor: Colors.purpleAccent[100], // Color for unselected tab text
          indicatorColor: Colors.purpleAccent[100],
          controller: _tabController,
          tabs: [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
            Tab(text: 'Lendigs'),
            Tab(text: 'Borrows'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecordList('Income'),
          _buildRecordList('Expense'),
          _buildRecordList('Borrow'),
          _buildRecordList('Lending'),
        ],
      ),
    );
  }

  Widget _buildRecordList(String type) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchRecords(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $type records found.'));
        }

        final records = snapshot.data!;
        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            if (record is Expense) {
              return ListTile(
                title: Text(record.name),
                subtitle: Text('₹ ${record.amount} | ${record.type}'),
                trailing: Text(record.date),
              );
            } else if (record is Income) {
              return ListTile(
                title: Text(record.source),
                subtitle: Text('₹ ${record.amount}'),
                trailing: Text(record.date),
              );
            } else if (record is Lending || record is Borrow) {
              return ListTile(
                title: Text(record.name),
                subtitle: Text('₹ ${record.amount} | ${record.status}'),
                trailing: Text(record.date),
              );
            }
            //else if
            // (record is Budget) {
            //   return ListTile(
            //     title: Text(record.name),
            //     subtitle: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Budget: ${record.actualBudget}'),
            //         Text('Balance: ${record.actualBalance}'),
            //       ],
            //     ),
            //     trailing: Text('Amount: ${record.amount}'),
            //   );
            // }
            else {
              return SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
