import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/budget_model.dart';
import '../../domain/model/category_model.dart';

abstract class BudgetFbDataSource {
  /// Category
  Stream<Either<Failure, List<CategoryModel>>> subscribeCategory(
      {required String budgetId});

  Future<Either<Failure, bool>> addCategory({
    required String budgetId,
    required CategoryModel category,
  });

  Future<Either<Failure, bool>> deleteCategory({
    required String budgetId,
    required String categoryId,
  });

  /// Budget
  Stream<Either<Failure, BudgetModel>> subscribeBudget({
    required String budgetId,
  });

  Future<Either<Failure, bool>> addBudget({
    required String name,
    required String admin,
    required Currency currency,
    required List<CategoryModel> categories,
    required List<User> members,
  });

  Future<Either<Failure, bool>> deleteBudget({
    required String budgetId,
    required String budgetName,
  });
}
