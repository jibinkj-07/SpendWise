import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_budget/core/util/error/failure.dart';
import 'package:my_budget/features/common/data/data_source/expense_fb_data_source.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';
import 'package:my_budget/features/common/domain/repo/expense_repo.dart';

class ExpenseRepoImpl implements ExpenseRepo {
  final ExpenseFbDataSource _expenseFbDataSource;

  ExpenseRepoImpl(this._expenseFbDataSource);

  @override
  Future<Either<Failure, ExpenseModel>> addExpense({
    required ExpenseModel expenseModel,
    required UserModel user,
    required List<XFile> documents,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.addExpense(
        expenseModel: expenseModel,
        user: user,
        documents: documents,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense({
    required String adminId,
    required ExpenseModel expense,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.deleteExpense(
        adminId: adminId,
        expense: expense,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseModel>>> getAllExpense({
    required String adminId,
    required DateTime date,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.getAllExpense(
        adminId: adminId,
        date: date,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }
}
