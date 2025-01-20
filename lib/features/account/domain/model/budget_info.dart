import '../../../budget/domain/model/budget_model.dart';
import 'user.dart';

class BudgetInfo {
  final BudgetModel budget;
  final User admin;

  BudgetInfo({required this.budget, required this.admin});
}
