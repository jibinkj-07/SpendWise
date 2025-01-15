import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text("Budget Detail"),
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
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppHelper.horizontalPadding(size),
            ),
            margin: const EdgeInsets.only(bottom: 15.0),
            color: Colors.white,
            child: Column(
              children: [
                _listTile("Name", widget.budget.name),
                _listTile("Currency",
                    "${widget.budget.currencySymbol} - ${widget.budget.currency}"),
                ValueListenableBuilder(
                    valueListenable: _admin,
                    builder: (ctx, admin, _) {
                      return _listTile("Admin", admin);
                    }),
                _listTile("Created On",
                    DateFormat("dd-MM-y,").add_jm().format(widget.budget.createdOn)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppHelper.horizontalPadding(size),
            ),
            child: Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryViewBloc, CategoryViewState>(
              builder: (ctx, state) {
                if (state is CategorySubscribed &&
                    state.categories.isNotEmpty) {
                  return Material(
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: state.categories.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppHelper.horizontalPadding(size),
                        vertical: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            tileColor: Colors.grey.withOpacity(.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
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
                                  .withOpacity(.15),
                              child: Icon(
                                AppHelper.getIconFromString(
                                  state.categories[index].icon,
                                ),
                                color: state.categories[index].color,
                              ),
                            ),
                            title: Text(state.categories[index].name),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15.0,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Empty(
                  message: "No Categories",
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _listTile(String title, String child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13.0, color: Colors.black54),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                child,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );

  Future<void> _getAdminName() async {
    final result = await _accountHelper.getUserInfoByID(
      id: widget.budget.admin,
    );
    if (result.isRight) {
      _admin.value = result.right.name;
    }
  }
}
