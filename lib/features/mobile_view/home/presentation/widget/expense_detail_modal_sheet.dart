import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import '../../../../common/data/model/category_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../view/image_preview.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 22:16:22

class ExpenseDetailModalSheet extends StatefulWidget {
  final ExpenseModel expenseModel;
  final CategoryModel category;

  const ExpenseDetailModalSheet({
    super.key,
    required this.expenseModel,
    required this.category,
  });

  @override
  State<ExpenseDetailModalSheet> createState() =>
      _ExpenseDetailModalSheetState();
}

class _ExpenseDetailModalSheetState extends State<ExpenseDetailModalSheet> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (ctx, state) {
        _loading.value = state.expenseStatus == ExpenseStatus.deleting;
        if (state.expenseStatus == ExpenseStatus.deleted) {
          Navigator.pop(context);
        }
        if (state.error != null) {
          state.error!.showSnackBar(context);
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.35,
        minChildSize: 0.35,
        maxChildSize: 0.65,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.expenseModel.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        width: 5.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: AppHelper.hexToColor(
                                            widget.category.color,
                                          ),
                                        ),
                                      ),
                                      Text(widget.category.title)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                AppHelper.amountFormatter(
                                    widget.expenseModel.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.expenseModel.description,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.expenseModel.createdUser.name),
                              Text(
                                DateFormat.MMMEd().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.expenseModel.id),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ImagePreview(
                                      name: widget.expenseModel.title,
                                      url: widget.expenseModel.documents[index],
                                    ),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.expenseModel.documents[index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                          itemCount: widget.expenseModel.documents.length,
                        ),
                        ValueListenableBuilder(
                            valueListenable: _loading,
                            builder: (ctx, loading, _) {
                              return LoadingButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text("Delete"),
                                          content: const Text(
                                              "Are you sure want to delete this expense?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                log("Deleting ${widget.expenseModel.id}");
                                                Navigator.pop(ctx);
                                                context.read<ExpenseBloc>().add(
                                                      DeleteExpense(
                                                        adminId: context
                                                            .read<AuthBloc>()
                                                            .state
                                                            .userInfo!
                                                            .adminId,
                                                        expense:
                                                            widget.expenseModel,
                                                      ),
                                                    );
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                              child: const Text("Delete"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                loading: loading,
                                isDelete: true,
                                loadingLabel: "Deleting",
                                child: const Text("Delete"),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
