import 'package:expense_tracker/Widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/Widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final url = Uri.https(
      'flutter-prep-f8ad1-default-rtdb.firebaseio.com', 'expense-list.json');
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(),
    );
  }

  @override
  void initState() {
    super.initState();
    _addExpense();
  }

  void _addExpense() async {
    final response = await http.get(url);
    final Map<String, dynamic> Data = json.decode(response.body);
    final List<Expense> newData = [];
    for (final item in Data.entries) {
      newData.add(Expense(
        title: item.value['title'],
        amount: item.value['amount'],
        date: DateTime.parse(item.value['date']),
        category: Category.values.firstWhere(
          (c) => c.toString() == 'Category.' + item.value['category'],
        ),
      ));
    }
    setState(() {
      _registeredExpenses.addAll(newData);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          const Text('The Chart'),
          Expanded(
              child: ExpensesList(
            expenses: _registeredExpenses,
            onRemovedExpense: _removeExpense,
          ))
        ],
      ),
    );
  }
}
