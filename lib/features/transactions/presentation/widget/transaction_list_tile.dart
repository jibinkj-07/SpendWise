import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../domain/model/transaction_model.dart';
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
    return BlocBuilder<CategoryViewBloc, CategoryViewState>(
      builder: (ctx, state) {
        if (state is CategorySubscribed) {
          final category = state.categories.firstWhere(
            (item) => item.id == transaction.categoryId,
            orElse: CategoryModel.deleted,
          );

          return ListTile(
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
            leading: Hero(
              tag: transaction.id,
              child: CircleAvatar(
                backgroundColor: category.color,
                child: Center(
                  child: Icon(
                    AppHelper.getIconFromString(category.icon),
                    size: 20.0,
                    color: category.color.computeLuminance() < .5
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              transaction.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              category.name,
              style: TextStyle(fontSize: 12.0),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              AppHelper.formatAmount(context, transaction.amount),
              style: TextStyle(fontSize: 13.0),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
