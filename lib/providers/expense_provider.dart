
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  late Box<Expense> _box;
  bool _isLoading = true;

  ExpenseProvider() {
    _init();
  }

  List<Expense> get expenses => _expenses;

  double get totalExpense =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  bool get isLoading => _isLoading;

  Future<void> _init() async {
    try {
      _box = Hive.box<Expense>('expenses');
      _expenses = _box.values.toList();
    } catch (e) {
      print("Error loading Hive box: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addExpense(Expense e) {
    _box.add(e);
    _refreshList();
  }

  void deleteExpense(int index) {
    _box.deleteAt(index);
    _refreshList();
  }

  void _refreshList() {
    _expenses = _box.values.toList();
    notifyListeners();
  }
}
