import 'package:firebase_database/firebase_database.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

class HomeHelper {
  final FirebaseDatabase _firebaseDatabase;

  HomeHelper(this._firebaseDatabase);

  Future<String> getCurrentExpenseId(String userId) async {
    final result =
        await _firebaseDatabase.ref("${FirebasePath.userNode}/$userId").get();

    if (result.child("current_expense_id").exists) {
      final expenseData = await _firebaseDatabase
          .ref(
            FirebasePath.expensePath(
              result.child("current_expense_id").value.toString(),
            ),
          )
          .get();
      if (expenseData.exists) {
        return result.child("current_expense_id").value.toString();
      }
    }
    //get any id from joined expense node
    for (final expense in result.child("joined_expenses").children) {
      final expenseData = await _firebaseDatabase
          .ref(FirebasePath.expensePath(expense.key.toString()))
          .get();
      if (expenseData.exists) {
        return expenseData.key.toString();
      }
    }

    return "";
  }
}
