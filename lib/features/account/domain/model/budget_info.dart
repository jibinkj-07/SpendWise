import '../../../budget/domain/model/budget_model.dart';
import 'user.dart';

class BudgetInfo {
  final BudgetModel budget;
  final User admin;
  final DateTime date;

  BudgetInfo({
    required this.budget,
    required this.admin,
    required this.date,
  });
}
