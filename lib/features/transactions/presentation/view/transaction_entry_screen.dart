import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/config/app_config.dart';
import 'package:spend_wise/core/config/injection/imports.dart';
import 'package:spend_wise/core/util/helper/app_helper.dart';

import '../../../../core/config/injection/injection_container.dart';
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
  final SharedPrefHelper _sharedPrefHelper = sl<SharedPrefHelper>();
  final ValueNotifier<Map<String, String>> _errorMap = ValueNotifier({});

  // Recent transactions for quick fill
  final ValueNotifier<List<TransactionModel>> _recentTransactions =
      ValueNotifier([]);
  final ValueNotifier<List<String>> _titleSuggestions = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadRecentTransactions();
  }

  void _initializeData() {
    _category = ValueNotifier(null);
    _date = ValueNotifier(DateTime.now());
    final savedTitles = _sharedPrefHelper.getTransactionSuggestions();
    if (widget.transactionModel != null) {
      _date.value = widget.transactionModel!.date;
      final categories = _getCategories();
      final category = categories.firstWhere(
        (item) => item.id == widget.transactionModel!.categoryId,
        orElse: () => categories.first,
      );
      _category.value = category;
      _titleController.text = widget.transactionModel!.title;
      _amountController.text = widget.transactionModel!.amount.toString();
      _descriptionController.text = widget.transactionModel!.description;
    }

    final budgetState = context.read<BudgetViewBloc>().state;
    if (budgetState is BudgetSubscribed) {
      _amountUnit = budgetState.budget.currencySymbol;
    }

    // clear errors on user type
    _titleController.addListener(() {
      final title = _titleController.text.toString().trim();

      _titleSuggestions.value = title.isEmpty
          ? []
          : savedTitles
              .where(
                (item) => item.contains(title),
              )
              .toList();

      if (_errorMap.value.containsKey('title')) {
        final updatedMap = Map<String, String>.from(_errorMap.value);
        updatedMap.remove('title');
        _errorMap.value = updatedMap;
      }
    });

    _amountController.addListener(() {
      if (_errorMap.value.containsKey('amount')) {
        final updatedMap = Map<String, String>.from(_errorMap.value);
        updatedMap.remove('amount');
        _errorMap.value = updatedMap;
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
        _recentTransactions.value = state.transactions.take(10).toList();
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
    _errorMap.dispose();
    _recentTransactions.dispose();
    _titleSuggestions.dispose();
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // DATE PICKER
          Center(
            child: FilledButton.icon(
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
                backgroundColor: Colors.transparent,
                foregroundColor: AppConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppConfig.primaryColor,
                  ),
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
          ),

          const SizedBox(height: 30.0),
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _errorMap,
                  builder: (_, errorMap, __) {
                    if (errorMap.containsKey("amount")) {
                      return _errorText(errorMap["amount"] ?? "");
                    }

                    return const SizedBox.shrink();
                  })
            ],
          ),

          const SizedBox(height: 30.0),
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
                    key: const ValueKey("title"),
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
              ValueListenableBuilder(
                  valueListenable: _errorMap,
                  builder: (_, errorMap, __) {
                    if (errorMap.containsKey("title")) {
                      return _errorText(errorMap["title"] ?? "");
                    }

                    return const SizedBox.shrink();
                  })
            ],
          ),

          // TITLE SUGGESTION
          ValueListenableBuilder(
              valueListenable: _titleSuggestions,
              builder: (_, titleSuggestion, __) {
                if (titleSuggestion.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: size.height * .05,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20.0, top: 10),
                      itemCount: titleSuggestion.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text(
                              titleSuggestion[index],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            side: BorderSide(color: Colors.transparent),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _titleController.text = titleSuggestion[index];
                              _titleSuggestions.value.clear();
                            },
                          ),
                        ));
                      }),
                );
              }),
          const SizedBox(height: 10.0),
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
                        if (_errorMap.value.containsKey('category')) {
                          _errorMap.value.remove('category');
                        }

                        final result =
                            await showModalBottomSheet<CategoryModel>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
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
              ValueListenableBuilder(
                  valueListenable: _errorMap,
                  builder: (_, errorMap, __) {
                    if (errorMap.containsKey("category")) {
                      return _errorText(errorMap["category"] ?? "");
                    }

                    return const SizedBox.shrink();
                  })
            ],
          ),
          // SUGGESTION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Divider(
                thickness: .5,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Quick Tags',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              SizedBox(
                height: size.height * .05,
                child: ValueListenableBuilder(
                    valueListenable: _recentTransactions,
                    builder: (_, recentTrans, __) {
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: recentTrans.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            final transaction = recentTrans[index];
                            final category =
                                getCategory(transaction.categoryId);

                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                  label: Row(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        AppHelper.getIconFromString(
                                            category!.icon),
                                        size: 20,
                                        color: category.color,
                                      ),
                                      Text(
                                        transaction.title,
                                        style: TextStyle(color: category.color),
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      category.color.withValues(alpha: .15),
                                  side: BorderSide(color: Colors.transparent),
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      _autoFillFromTransaction(transaction)),
                            ));
                          });
                    }),
              )
            ],
          ),

          const SizedBox(height: 30.0),
          // DESCRIPTION
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              key: const ValueKey("description"),
              textCapitalization: TextCapitalization.sentences,
              controller: _descriptionController,
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

          const SizedBox(height: 50.0),
          // SUBMIT BUTTON
          _buildSaveButton(),
        ],
      ),
    );
  }

  void _validateFields() {
    _errorMap.value.clear();
    Map<String, String> errors = {};
    if (_titleController.text.isEmpty ||
        _titleController.text.toString().trim().isEmpty) {
      errors['title'] = 'Title is required';
    }

    final amount = _amountController.text.toString().trim();
    if (_amountController.text.isEmpty || amount.isEmpty) {
      errors['amount'] = 'Amount is required';
    } else if (double.tryParse(amount) == null) {
      errors['amount'] = 'Invalid number';
    } else if (double.parse(amount) < 0.1) {
      errors['amount'] = 'Minimum amount is 0.1';
    }

    if (_category.value == null) {
      errors['category'] = 'Please select a category';
    }

    _errorMap.value = errors;
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
          return Center(
            child: FilledButton(
              onPressed: loading ? null : _onAddOrUpdate,
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
    _titleController.text = transaction.title;
    _descriptionController.text = transaction.description;
    _amountController.text = transaction.amount.toString();
    _category.value = getCategory(transaction.categoryId);
    _titleSuggestions.value.clear();
  }

  void _onAddOrUpdate() {
    _validateFields();
    if (_errorMap.value.isNotEmpty) return;

    FocusScope.of(context).unfocus();

    final transactionModel = _createTransactionModel();
    final transBloc = context.read<TransactionEditBloc>();
    final budgetBloc = context.read<BudgetViewBloc>().state as BudgetSubscribed;

    if (widget.transactionModel == null || widget.isDuplicate) {
      transBloc.add(
        AddTransaction(
          budgetId: budgetBloc.budget.id,
          transaction: transactionModel,
          doc: null,
        ),
      );
    } else {
      transBloc.add(
        UpdateTransaction(
          budgetId: budgetBloc.budget.id,
          transaction: transactionModel,
          oldTransactionDate: widget.transactionModel!.createdDatetime,
          doc: null,
        ),
      );
    }
  }

  TransactionModel _createTransactionModel() {
    final today = DateTime.now();
    final authBloc = context.read<AuthBloc>();
    String admin = "unknownUser";

    if (authBloc.state is Authenticated) {
      admin = (authBloc.state as Authenticated).user.uid;
    }

    return TransactionModel(
      id: widget.isDuplicate || widget.transactionModel == null
          ? today.millisecondsSinceEpoch.toString()
          : widget.transactionModel!.id,
      date: _date.value,
      amount: double.parse(_amountController.text.toString().trim()),
      title: _titleController.text.toString().trim(),
      createdDatetime: today,
      docUrl: widget.transactionModel?.docUrl ?? "",
      description: _descriptionController.text.toString().trim(),
      categoryId: _category.value?.id ?? "",
      createdUserId: admin,
    );
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
    return null;
  }
}
