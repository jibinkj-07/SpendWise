import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/helper/firebase_path.dart';
import '../../../budget/domain/model/budget_model.dart';

class HomeHelper {
  final FirebaseDatabase _firebaseDatabase;

  HomeHelper(this._firebaseDatabase);

  Future<BudgetModel?> getBudgetDetail(String id) async {
    try {
      final result =
          await _firebaseDatabase.ref(FirebasePath.budgetDetailPath(id)).once();
      if (result.snapshot.exists) {
        return BudgetModel.fromFirebase(result.snapshot,id);
      }
    } catch (e) {
      log("er: [home_helper.dart][getBudgetDetail] $e");
    }
    return null;
  }
}
