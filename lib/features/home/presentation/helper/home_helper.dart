import 'package:firebase_database/firebase_database.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

class HomeHelper {
  final FirebaseDatabase _firebaseDatabase;

  HomeHelper(this._firebaseDatabase);

  Future<String> getCurrentExpenseId(String userId) async {
    final result =
        await _firebaseDatabase.ref("${FirebasePath.userNode}/$userId").get();

    if (result.child("current_budget_id").exists) {
      final budgetData = await _firebaseDatabase
          .ref(
            FirebasePath.budgetPath(
              result.child("current_budget_id").value.toString(),
            ),
          )
          .get();
      if (budgetData.exists) {
        return result.child("current_budget_id").value.toString();
      }
    }
    //get any id from joined budget node
    for (final budget in result.child("joined_budgets").children) {
      final budgetData = await _firebaseDatabase
          .ref(FirebasePath.budgetPath(budget.key.toString()))
          .get();
      if (budgetData.exists) {
        return budgetData.key.toString();
      }
    }

    return "";
  }
}
