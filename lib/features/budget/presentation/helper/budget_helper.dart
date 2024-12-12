import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

class BudgetHelper {
  final BudgetRepo _budgetRepo;

  BudgetHelper(this._budgetRepo);

  Future<Either<Failure, bool>> insertBudget({
    required String name,
    required String admin,
    required Currency currency,
    required List<CategoryModel> categories,
    required List<User> members,
  }) async =>
      await _budgetRepo.insertBudget(
        name: name,
        admin: admin,
        currency: currency,
        categories: categories,
        members: members,
      );
}
