import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/config/app_config.dart';
import 'package:spend_wise/core/config/injection/imports.dart';
import 'package:spend_wise/core/util/helper/app_helper.dart';

import '../../../budget/domain/model/category_model.dart';
import '../../../home/presentation/widgets/bottom_category_sheet.dart';
import '../../domain/model/transaction_model.dart';

class TransactionEntryScreen extends StatefulWidget {
  final TransactionModel? transactionModel;
  final bool isDuplicate;

  const TransactionEntryScreen({
    super.key,
    this.transactionModel,
    this.isDuplicate = false,
  });

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _loading = ValueNotifier<bool>(false);
  late ValueNotifier<DateTime> _date;
  late ValueNotifier<CategoryModel?> _category;
  String _amountUnit = '\$';
  // final SharedPrefHelper _sharedPrefHelper = sl<SharedPrefHelper>();
  final Map<String, String> _errorMap = {};

  // Recent transactions for quick fill
  List<TransactionModel> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadRecentTransactions();
  }

  void _initializeData() {
    _category = ValueNotifier(null);
    _date = ValueNotifier(DateTime.now());

    if (widget.transactionModel != null) {
      _date.value = widget.transactionModel!.date;
      final categories = _getCategories();
      final category = categories.firstWhere(
        (item) => item.id == widget.transactionModel!.categoryId,
        orElse: () => categories.first,
      );
      _category.value = category;
    }

    final budgetState = context.read<BudgetViewBloc>().state;
    if (budgetState is BudgetSubscribed) {
      _amountUnit = budgetState.budget.currencySymbol;
    }

    // clear errors on user type
    _titleController.addListener(() {
      if (_errorMap.containsKey('title')) {
        setState(() {
          _errorMap.remove('title');
        });
      }
    });
    _amountController.addListener(() {
      if (_errorMap.containsKey('amount')) {
        setState(() {
          _errorMap.remove('amount');
        });
      }
    });
  }

  List<CategoryModel> _getCategories() {
    final state = context.read<CategoryViewBloc>().state;
    return state is CategorySubscribed ? state.categories : [];
  }

  void _loadRecentTransactions() {
    // Load recent transactions from your data source
    // This is a placeholder - implement based on your data layer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<MonthTransViewBloc>().state;

      if (state is SubscribedMonthTransState) {
        setState(() {
          _recentTransactions = state.transactions.take(10).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _loading.dispose();
    _date.dispose();
    _category.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Iconsax.arrow_left_2)),
        title: Text("New Expense"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          spacing: 20.0,
          children: [
            // DATE PICKER
            FilledButton.icon(
              icon: Icon(Iconsax.calendar_1),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _date.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _date.value = date;
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: AppConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(100),
                ),
              ),
              label: ValueListenableBuilder(
                  valueListenable: _date,
                  builder: (_, date, __) {
                    return Text(
                      DateFormat("dd MMM y").format(date),
                    );
                  }),
            ),

            // AMOUNT
            Column(
              children: [
                Text('Total Amount'),
                IntrinsicWidth(
                  child: TextFormField(
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                    ),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    maxLength: 10,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        counter: const SizedBox.shrink(),
                        prefixIcon: Text(
                          _amountUnit,
                          style: TextStyle(
                            color: AppConfig.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(),
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount is required";
                      } else if (double.parse(value.toString().trim()) < 0.1) {
                        return "Minimum amount is 0.1";
                      }
                      return null;
                    },
                  ),
                ),
                if (_errorMap.containsKey("amount"))
                  _errorText(_errorMap["amount"] ?? "")
              ],
            ),

            // TITLE
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IntrinsicWidth(
                    child: TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 30,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        counter: const SizedBox.shrink(),
                        hintText: 'What the expense for?',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                if (_errorMap.containsKey("title"))
                  _errorText(_errorMap["title"] ?? ""),
              ],
            ),

            // CATEGORY
            Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: _category,
                    builder: (_, category, __) {
                      return FilledButton.icon(
                        icon: category != null
                            ? Icon(AppHelper.getIconFromString(category.icon))
                            : Icon(Iconsax.category),
                        onPressed: () async {
                          if (_errorMap.containsKey('category')) {
                            setState(() {
                              _errorMap.remove('category');
                            });
                          }

                          final result =
                              await showModalBottomSheet<CategoryModel>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: const BottomCategorySheet(),
                            ),
                          );
                          if (result != null) {
                            _category.value = result;
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: category == null
                              ? Colors.blue.shade100
                              : category.color.withValues(alpha: .15),
                          foregroundColor: category == null
                              ? AppConfig.primaryColor
                              : category.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(100),
                          ),
                        ),
                        label: ValueListenableBuilder(
                            valueListenable: _date,
                            builder: (_, date, __) {
                              return Text(category == null
                                  ? "Select category"
                                  : category.name);
                            }),
                      );
                    }),
                if (_errorMap.containsKey("category"))
                  _errorText(_errorMap["category"] ?? ""),
              ],
            ),

            // SUGGESTION
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: .5,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Suggestion expenses',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: size.height * .05,
                  child: ListView.builder(
                      itemCount: _recentTransactions.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        final transaction = _recentTransactions[index];
                        final category = getCategory(transaction.categoryId);

                        return Center(
                            child: FilledButton.icon(
                          icon:
                              Icon(AppHelper.getIconFromString(category!.icon)),
                          onPressed: () =>
                              _autoFillFromTransaction(transaction),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: category.color,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: category.color,
                                width: 1,
                              ),
                              borderRadius: BorderRadiusGeometry.circular(100),
                            ),
                          ),
                          label: Text(transaction.title),
                        ));
                      }),
                )
              ],
            ),

            // DESCRIPTION
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                key: const ValueKey("description"),
                textCapitalization: TextCapitalization.sentences,
                initialValue: widget.transactionModel?.description,
                minLines: 3,
                maxLines: 5,
                maxLength: 150,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  counter: const SizedBox.shrink(),
                  hintText: "eg: Grocery shopping at supermarket",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),

            // SUBMIT BUTTON
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  void _validateFields() {
    _errorMap.clear();
    if (_titleController.text.isEmpty ||
        _titleController.text.toString().trim().isEmpty) {
      _errorMap['title'] = 'Title is required';
    }

    final amount = _amountController.text.toString().trim();
    if (_amountController.text.isEmpty || amount.isEmpty) {
      _errorMap['amount'] = 'Amount is required';
    } else if (double.tryParse(amount) == null) {
      _errorMap['amount'] = 'Invalid number';
    } else if (double.parse(amount) < 0.1) {
      _errorMap['amount'] = 'Minimum amount is 0.1';
    }

    if (_category.value == null) {
      _errorMap['category'] = 'Please select a category';
    }

    setState(() {});
  }

  Widget _buildSaveButton() {
    return BlocListener<TransactionEditBloc, TransactionEditState>(
      listener: (context, state) {
        _loading.value = state is AddingTransaction;
        if (state is TransactionErrorOccurred) {
          state.error.showSnackBar(context);
        }
        if (state is TransactionAdded) {
          Navigator.pop(context);
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _loading,
        builder: (ctx, loading, _) {
          return FilledButton(
            onPressed: loading
                ? null
                : () {
                    _validateFields();
                  },
            style: FilledButton.styleFrom(
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            child: Text(
              loading
                  ? "Saving"
                  : widget.isDuplicate
                      ? "Duplicate Expense"
                      : widget.transactionModel == null
                          ? "Save Expense"
                          : "Update Expense",
            ),
          );
        },
      ),
    );
  }

  Widget _errorText(String error) {
    return Text(
      error,
      style: TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  void _autoFillFromTransaction(TransactionModel transaction) {
    setState(() {
      _titleController.text = transaction.title;
      _descriptionController.text = transaction.description;
      _amountController.text = transaction.amount.toString();
      _category.value = getCategory(transaction.categoryId);
    });
  }

  CategoryModel? getCategory(String id) {
    final category = context.read<CategoryViewBloc>().state;

    if (category is CategorySubscribed) {
      final index = category.categories.indexWhere((i) => i.id == id);
      if (index != -1) {
        return category.categories[index];
      } else {
        return category.categories.first;
      }
    }
  }
}
