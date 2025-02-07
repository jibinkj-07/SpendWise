import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/budget_info.dart';
import '../bloc/account_bloc.dart';

class InvitationTile extends StatelessWidget {
  final bool isUserRequest;
  final BudgetInfo budget;

  const InvitationTile({
    super.key,
    this.isUserRequest = false,
    required this.budget,
  });

  void _onRemovePressed(BuildContext context) {
    final authBloc = (context.read<AuthBloc>().state as Authenticated);
    if (isUserRequest) {
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
  }

  void _onAcceptPressed(BuildContext context) {
    final authBloc = (context.read<AuthBloc>().state as Authenticated);
    context.read<AccountBloc>().add(
          AcceptBudgetRequest(
            userId: authBloc.user.uid,
            userName: authBloc.user.name,
            budgetId: budget.budget.id,
            budgetName: budget.budget.name,
          ),
        );
  }

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
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState state) {
          final loading = (state is Deleting) || (state is Accepting);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              if (!loading) ...[
                const Divider(
                  height: 0,
                  thickness: .5,
                  color: Colors.grey,
                ),
                _buildFooter(context),
              ] else
                const _LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget.budget.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${budget.budget.currencySymbol} ${budget.budget.currency}",
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Admin",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    budget.admin.name,
                    style:
                        const TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMd().add_jm().format(budget.date),
                style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: isUserRequest
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => _onRemovePressed(context),
          style: TextButton.styleFrom(
            foregroundColor: AppConfig.errorColor,
          ),
          child: const Text("Remove"),
        ),
        if (!isUserRequest)
          TextButton(
            onPressed: () => _onAcceptPressed(context),
            child: const Text("Accept"),
          ),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50.0,
      width: 50.0,
      child: CustomLoading(),
    );
  }
}
