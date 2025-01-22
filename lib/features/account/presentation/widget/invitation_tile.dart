import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../root.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/budget_info.dart';
import '../bloc/account_bloc.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 19:03:13

class InvitationTile extends StatelessWidget {
  final bool isMyRequest;
  final BudgetInfo budget;

  const InvitationTile({
    super.key,
    this.isMyRequest = false,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppHelper.horizontalPadding(size),
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: BlocConsumer<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState state) {
          final loading = (state is Deleting) || (state is Accepting);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.budget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${budget.budget.currencySymbol} ${budget.budget.currency}",
                      style: TextStyle(fontSize: 12.0, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              budget.admin.name,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.yMMMd().add_jm().format(budget.date),
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!loading) ...[
                Divider(
                  height: 0,
                  thickness: .5,
                  color: Colors.grey.shade300,
                ),
                Row(
                  mainAxisAlignment: isMyRequest
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        final authBloc =
                            (context.read<AuthBloc>().state as Authenticated);
                        if (isMyRequest) {
                          context.read<AccountBloc>().add(
                                RemoveMyBudgetRequest(
                                  userId: authBloc.user.uid,
                                  budgetId: budget.budget.id,
                                ),
                              );
                        } else {
                          context.read<AccountBloc>().add(
                                RemoveBudgetRequest(
                                  userId: authBloc.user.uid,
                                  userName: authBloc.user.name,
                                  budgetId: budget.budget.id,
                                  budgetName: budget.budget.name,
                                ),
                              );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppConfig.errorColor,
                      ),
                      child: Text("Remove"),
                    ),
                    if (!isMyRequest)
                      TextButton(
                        onPressed: () {
                          final authBloc =
                              (context.read<AuthBloc>().state as Authenticated);
                          context.read<AccountBloc>().add(
                                AcceptBudgetRequest(
                                  userId: authBloc.user.uid,
                                  userName: authBloc.user.name,
                                  budgetId: budget.budget.id,
                                  budgetName: budget.budget.name,
                                ),
                              );
                        },
                        child: Text("Accept"),
                      ),
                  ],
                ),
              ] else
                Container(
                  height: 50.0,
                  width: 50.0,
                  padding: const EdgeInsets.all(15.0),
                  child: const CustomLoading(),
                )
            ],
          );
        },
        listener: (BuildContext ctx, AccountState state) {
          if (state is AccountStateError) {
            state.error.showSnackBar(context);
          }

          if (state is Accepted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => Root(
                  userId: (context.read<AuthBloc>().state as Authenticated)
                      .user
                      .uid,
                  budgetId: state.budgetId,
                ),
              ),
              (_) => false,
            );
          }
        },
      ),
    );
  }
}
