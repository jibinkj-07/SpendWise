import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spend_wise/core/util/widget/custom_snackbar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../home/presentation/view/category_entry_screen.dart';
import '../helper/account_helper.dart';
import '../widget/budget_delete_dialog.dart';

/// @author : Jibin K John
/// @date   : 14/01/2025
/// @time   : 21:45:18

class BudgetDetailScreen extends StatefulWidget {
  final BudgetModel budget;
  final String userId;

  const BudgetDetailScreen({
    super.key,
    required this.budget,
    required this.userId,
  });

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  final ValueNotifier<String> _admin = ValueNotifier("");
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  void initState() {
    _getAdminName();
    super.initState();
  }

  @override
  void dispose() {
    _admin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Detail"),
        centerTitle: true,
        actions: [
          if (widget.budget.admin == widget.userId)
            TextButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => BudgetDeleteDialog(
                    budgetId: widget.budget.id,
                    budgetName: widget.budget.name,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            margin: EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.budget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  "${widget.budget.currencySymbol} - ${widget.budget.currency}",
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Admin",
                    style: TextStyle(fontSize: 13.0),
                  ),
                  trailing: ValueListenableBuilder(
                      valueListenable: _admin,
                      builder: (ctx, admin, _) {
                        return Text(
                          admin,
                          style: TextStyle(fontSize: 14.0),
                        );
                      }),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Created",
                    style: TextStyle(fontSize: 13.0),
                  ),
                  trailing: Text(
                    DateFormat("dd-MM-y,")
                        .add_jm()
                        .format(widget.budget.createdOn),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: BlocBuilder<CategoryViewBloc, CategoryViewState>(
                      builder: (ctx, state) {
                    return ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        "Categories",
                        style: TextStyle(fontSize: 13.0),
                      ),
                      children: (state is CategorySubscribed &&
                              state.categories.isNotEmpty)
                          ? List.generate(
                              state.categories.length,
                              (index) => ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CategoryEntryScreen(
                                        category: state.categories[index],
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: state.categories[index].color
                                      .withValues(alpha: .15),
                                  child: Icon(
                                    AppHelper.getIconFromString(
                                      state.categories[index].icon,
                                    ),
                                    color: state.categories[index].color,
                                  ),
                                ),
                                title: Text(state.categories[index].name),
                                trailing: Icon(
                                  Iconsax.arrow_right_3,
                                  size: 15.0,
                                ),
                              ),
                            )
                          : [
                              SizedBox(
                                height: size.height * .2,
                                child: Empty(message: "No Categories"),
                              )
                            ],
                    );
                  }),
                )
              ],
            ),
          ),
          Text(
            "Share your budget",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Share this budget with your family, friends, or close relatives to join and manage it together. Please keep this information private, as it is confidential. Click the share button to send an invitation.",
            style: TextStyle(fontSize: 13.0),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.budget.id))
                          .then(
                        (_) => CustomSnackBar.showInfoSnackBar(
                            context, "ID copied to clipboard"),
                      );
                    },
                    child: Text("Copy ID")),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: FilledButton(
                    onPressed: () {
                      SharePlus.instance.share(
                      ShareParams(text:   "Let’s join ${AppConfig.name} to manage your budget effortlessly and stay on top of your expenses!\n\n"
                          "Join the ${widget.budget.name} budget by copying the Budget ID below and pasting it in the 'Join Budget' section of the ${AppConfig.name} app.\n\nStart collaborating today!\n\n\n"
                          "ID - ${widget.budget.id}",)
                      );
                    },
                    child: Text("Share Now")),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _getAdminName() async {
    final result = await _accountHelper.getUserInfoByID(
      id: widget.budget.admin,
    );
    if (result.isRight) {
      _admin.value = result.right.name;
    }
  }
}
