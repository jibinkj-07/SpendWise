import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/image_preview.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../account/domain/model/user.dart';
import '../../../account/presentation/helper/account_helper.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../domain/model/transaction_model.dart';
import '../bloc/transaction_edit_bloc.dart';
import 'transaction_entry_screen.dart';

/// @author : Jibin K John
/// @date   : 29/12/2024
/// @time   : 16:35:03

class TransactionDetailView extends StatefulWidget {
  final TransactionModel transaction;
  final CategoryModel category;

  const TransactionDetailView({
    super.key,
    required this.transaction,
    required this.category,
  });

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final ValueNotifier<User?> _createdUser = ValueNotifier(null);
  final ValueNotifier<bool> _deleting = ValueNotifier(false);
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  void initState() {
    _getCreatedUser();
    super.initState();
  }

  @override
  void dispose() {
    _createdUser.dispose();
    _deleting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          // Top BG Color
          Container(
            height: size.height * .35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.category.color.withOpacity(.2),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.viewPaddingOf(context).top,
              bottom: 15.0,
            ),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.arrow_left_2),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Transaction Details",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    PopupMenuButton(
                      surfaceTintColor: Colors.transparent,
                      position: PopupMenuPosition.under,
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      icon: const Icon(Iconsax.receipt_edit),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          child: Text("Edit"),
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => TransactionEntryScreen(
                                transactionModel: widget.transaction,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: Text("Duplicate"),
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => TransactionEntryScreen(
                                transactionModel: widget.transaction,
                                isDuplicate: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Body
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
                    children: [
                      Hero(
                        tag: widget.transaction.id,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: widget.category.color,
                          child: Center(
                            child: Icon(
                              AppHelper.getIconFromString(widget.category.icon),
                              size: 50.0,
                              color:
                                  widget.category.color.computeLuminance() < .5
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        AppHelper.formatAmount(
                            context, widget.transaction.amount),
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        widget.transaction.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10.0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              widget.transaction.description,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        // padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: .2, color: Colors.black26),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            _listTile("Category", widget.category.name),
                            _listTile(
                              "Transaction Date",
                              DateFormat.yMMMEd()
                                  .format(widget.transaction.date),
                            ),
                            _listTile(
                              "Created Date",
                              DateFormat.yMMMEd()
                                  .format(widget.transaction.createdDatetime),
                            ),
                            _listTile(
                              "Created Time",
                              DateFormat.jm()
                                  .format(widget.transaction.createdDatetime),
                            ),
                            ValueListenableBuilder(
                                valueListenable: _createdUser,
                                builder: (ctx, user, _) {
                                  return _listTile("Created By",
                                      user == null ? "......" : user.name);
                                }),
                            if (widget.transaction.docUrl.isNotEmpty) ...[
                              ListTile(
                                title: Text(
                                  "Document",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: Hero(
                                  tag: "document",
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ImagePreview(
                                            name: widget.transaction.title,
                                            url: widget.transaction.docUrl,
                                            tag: "document",
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.transaction.docUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (
                                          context,
                                          url,
                                          downloadProgress,
                                        ) =>
                                            Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppConfig.primaryColor,
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (
                                          context,
                                          url,
                                          error,
                                        ) =>
                                            const Icon(
                                          Iconsax.warning_2,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //Delete button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppHelper.horizontalPadding(size),
                  ),
                  child:
                      BlocListener<TransactionEditBloc, TransactionEditState>(
                    listener:
                        (BuildContext context, TransactionEditState state) {
                      _deleting.value = state is DeletingTransaction;
                      if (state is TransactionErrorOccurred) {
                        state.error.showSnackBar(context);
                      }
                      if (state is TransactionDeleted) {
                        Navigator.pop(context);
                      }
                    },
                    child: ValueListenableBuilder(
                        valueListenable: _deleting,
                        builder: (ctx, deleting, _) {
                          return LoadingFilledButton(
                            isDelete: true,
                            onPressed: _onDelete,
                            loading: deleting,
                            child: Text("Delete"),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTile(String title, String child) => ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          child,
          style: TextStyle(fontSize: 14.0),
        ),
      );

  Future<void> _getCreatedUser() async {
    final user = await _accountHelper.getUserInfoByID(
        id: widget.transaction.createdUserId);
    if (user.isRight) {
      _createdUser.value = user.right;
    }
  }

  Future _onDelete() {
    return showDialog(
      context: context,
      builder: (ctx) => CustomAlertDialog(
        message: 'Are you sure you want to delete this transaction',
        title: 'Delete Transaction',
        actionWidget: LoadingFilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.read<TransactionEditBloc>().add(
                  DeleteTransaction(
                    budgetId: (context.read<BudgetViewBloc>().state
                            as BudgetSubscribed)
                        .budget
                        .id,
                    transactionId: widget.transaction.id,
                    createdDate: widget.transaction.date,
                  ),
                );
          },
          loading: false,
          isDelete: true,
          child: Text("Delete"),
        ),
        isLoading: false,
      ),
    );
  }
}
