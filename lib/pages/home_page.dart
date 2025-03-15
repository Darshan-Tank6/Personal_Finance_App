import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../helpers/database_helper.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ////////////////////////////////////////////////////////////
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Expense> _expenses = [];
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  void _fetchExpenses() async {
    final expenses = await _dbHelper.getExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> expenseData = {};
    double totalExpense = 0;

    Future<double> calculateRemainingIncome() async {
      final totalIncomenew = await _dbHelper.calculateTotalIncome();
      return totalIncomenew;
    }
    //double totalIncomenew = _dbHelper.calculateTotalIncome;

    ///////////////////////////////////////////////////////////////////////////
    _expenses.forEach((expense) {
      totalExpense += expense.amount;
      if (expenseData.containsKey(expense.type)) {
        expenseData[expense.type] = expenseData[expense.type]! + expense.amount;
      } else {
        expenseData[expense.type] = expense.amount;
      }
    });
    //////////////////////////////////////////////////////////////////////////////

    return FutureBuilder<double>(
      future: _dbHelper.calculateTotalIncome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final totalIncome = snapshot.data ?? 0.0;
        return Scaffold(
          appBar: AppBar(title: Text('Finance Tracker')),
          // appBar: AppBar(
          //   title: Text('Budget Tracker'),
          // ),
          body: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center the columns
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min, // Minimize column height
                    children: [
                      Text(
                        'Incomes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '\₹').format(totalIncome),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  // Add a small horizontal space between columns
                  Column(
                    mainAxisSize: MainAxisSize.min, // Minimize column height
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          symbol: '\₹',
                        ).format(totalExpense),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  dataMap: expenseData,
                  animationDuration: Duration(milliseconds: 800),
                  chartRadius: MediaQuery.of(context).size.width / 1.7,
                  totalValue: totalIncome,
                  colorList: [
                    Colors.blueAccent.withOpacity(0.8),
                    Colors.redAccent.withOpacity(0.8),
                    Colors.greenAccent.withOpacity(0.8),
                    Colors.purpleAccent.withOpacity(0.8),
                    Colors.orangeAccent.withOpacity(0.8),
                  ],
                  initialAngleInDegree: 135,
                  chartType: ChartType.ring,
                  baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                  //baseChartColor: Colors.blueGrey[50]!,
                  ringStrokeWidth: 20,
                  //centerText: NumberFormat.currency(symbol: '₹').format(
                  //    totalExpense),
                  //centerText: "Expense",
                  //centerWidget: Container(child: const Text("Expense")),
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
