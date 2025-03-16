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
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Expense> _expenses = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  Map<String, double> _expenseData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final expenses = await _dbHelper.getExpenses();
    final totalIncome = await _dbHelper.calculateTotalIncome();

    double totalExpense = 0;
    Map<String, double> expenseData = {};

    for (var expense in expenses) {
      totalExpense += expense.amount;
      expenseData[expense.type] =
          (expenseData[expense.type] ?? 0) + expense.amount;
    }

    setState(() {
      _expenses = expenses;
      _totalIncome = totalIncome;
      _totalExpense = totalExpense;
      _expenseData = expenseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finance Tracker')),
      body:
          _expenses.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SizedBox(height: 20),
                  _buildIncomeExpenseRow(),
                  SizedBox(height: 20),
                  Expanded(child: _buildPieChart()),
                ],
              ),
    );
  }

  Widget _buildIncomeExpenseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoColumn('Incomes', _totalIncome),
        SizedBox(width: 40),
        _buildInfoColumn('Expenses', _totalExpense),
      ],
    );
  }

  Widget _buildInfoColumn(String title, double amount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          NumberFormat.currency(symbol: '₹').format(amount),
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      dataMap: _expenseData,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width / 1.7,
      totalValue: _totalIncome,
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
      ringStrokeWidth: 20,
      legendOptions: LegendOptions(
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValues: true,
        showChartValuesInPercentage: true,
        decimalPlaces: 1,
      ),
    );
  }
}
