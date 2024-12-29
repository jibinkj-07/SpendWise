import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../budget/presentation/bloc/category_bloc.dart';
import '../view/transaction_detail_view.dart';

/// @author : Jibin K John
/// @date   : 16/12/2024
/// @time   : 20:24:26

class TransactionListTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (ctx, state) {
      final category = state.categories.firstWhere(
        (item) => item.id == transaction.categoryId,
        orElse: CategoryModel.deleted,
      );
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionDetailView(
                category: category,
                transaction: transaction,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: .15,
              color: Colors.grey,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: [
              /// Category color and name
              Container(
                width: 38.0,
                height: 38.0,
                margin: const EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: category.color,
                ),
                child: Center(
                  child: Text(
                    category.name.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: category.color.computeLuminance() < .5
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),

              /// Title and category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      category.name,
                      style: TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              /// Amount

              Text(
                AppHelper.formatAmount(context, transaction.amount),
                style: TextStyle(fontSize: 13.0),
              ),
            ],
          ),
        ),
      );
    });
  }
}
