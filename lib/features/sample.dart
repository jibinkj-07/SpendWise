import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/config/injection/imports.dart';
import 'package:spend_wise/features/transactions/domain/model/transaction_model.dart';

import '../../../../core/config/injection/injection_container.dart';
import 'budget/domain/model/category_model.dart';
import 'home/presentation/widgets/bottom_category_sheet.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _loading = ValueNotifier<bool>(false);
  final _document = ValueNotifier<XFile?>(null);
  late ValueNotifier<DateTime> _date;
  late ValueNotifier<CategoryModel?> _category;
  final SharedPrefHelper _sharedPrefHelper = sl<SharedPrefHelper>();

  String _title = "";
  String _description = "";
  double _amount = 0.0;

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
      _categoryController.text = category.name;
      _category.value = category;
    }

    _dateController.text = DateFormat("dd MMM y").format(_date.value);
  }

  List<CategoryModel> _getCategories() {
    final state = context.read<CategoryViewBloc>().state;
    return state is CategorySubscribed ? state.categories : [];
  }

  void _loadRecentTransactions() {
    // Load recent transactions from your data source
    // This is a placeholder - implement based on your data layer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionState = context.read<TransactionBloc>().state;
      setState(() {
        _recentTransactions = transactionState.transactions.take(10).toList();
      });
    });
  }

  void _autoFillFromTransaction(TransactionModel transaction) {
    setState(() {
      _title = transaction.title;
      _description = transaction.description;
      _amount = transaction.amount;

      final categories = _getCategories();
      final category = categories.firstWhere(
        (item) => item.id == transaction.categoryId,
        orElse: () => categories.first,
      );
      _categoryController.text = category.name;
      _category.value = category;

      // Update form fields
      _formKey.currentState?.reset();
      _formKey.currentState?.save();
    });
  }

  @override
  void dispose() {
    _loading.dispose();
    _date.dispose();
    _dateController.dispose();
    _category.dispose();
    _categoryController.dispose();
    _document.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.transactionModel == null ? "New Expense" : "Edit Expense",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Quick Fill Section
              if (_recentTransactions.isNotEmpty) _buildQuickFillSection(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Amount Section
                      _buildAmountSection(size, theme),
                      const SizedBox(height: 24),

                      // Title Section
                      _buildTitleSection(size, theme),
                      const SizedBox(height: 24),

                      // Date and Category Section
                      _buildDateCategorySection(),
                      const SizedBox(height: 24),

                      // Description Section
                      _buildDescriptionSection(theme),
                      const SizedBox(height: 32),

                      // Save Button
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFillSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border:
            const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Fill",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _recentTransactions[index];
                return _buildQuickFillItem(transaction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFillItem(TransactionModel transaction) {
    return GestureDetector(
      onTap: () => _autoFillFromTransaction(transaction),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "₹${transaction.amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(Size size, ThemeData theme) {
    return Column(
      children: [
        Text(
          "Total Amount",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: size.width * 0.8,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TextFormField(
                key: const ValueKey("amount"),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                initialValue: widget.transactionModel != null
                    ? widget.transactionModel?.amount.toString()
                    : "0",
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Amount is required";
                  } else if (double.parse(value.toString().trim()) < 0.1) {
                    return "Minimum amount is 0.1";
                  }
                  return null;
                },
                cursorColor: theme.colorScheme.primary,
                onSaved: (value) =>
                    _amount = double.parse(value.toString().trim()),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(
                    fontSize: 48,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              Positioned(
                left: 0,
                child: Text(
                  "₹",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(Size size, ThemeData theme) {
    return Container(
      width: size.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue value) {
          if (value.text.trim().isEmpty) {
            return const Iterable<String>.empty();
          }
          return _sharedPrefHelper.getTransactionSuggestions().where(
                (title) => title
                    .toLowerCase()
                    .contains(value.text.trim().toLowerCase()),
              );
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          if (widget.transactionModel != null &&
              textEditingController.text.isEmpty) {
            textEditingController.text = widget.transactionModel!.title;
          }
          return TextFormField(
            key: const ValueKey("title"),
            focusNode: focusNode,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            cursorColor: theme.colorScheme.primary,
            onFieldSubmitted: (value) => onFieldSubmitted(),
            controller: textEditingController,
            textCapitalization: TextCapitalization.words,
            maxLength: 50,
            validator: (data) {
              if (data.toString().trim().isEmpty) {
                return "Title is required";
              }
              return null;
            },
            onSaved: (data) => _title = data.toString().trim(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              counter: const SizedBox.shrink(),
              hintText: "What's this expense for?",
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final String option = options.elementAt(index);
                    return ListTile(
                      title: Text(option),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateCategorySection() {
    return Row(
      children: [
        Expanded(child: _buildDateField()),
        const SizedBox(width: 12),
        Expanded(child: _buildCategoryField()),
      ],
    );
  }

  Widget _buildDateField() {
    return _buildFormField(
      controller: _dateController,
      label: "Date",
      icon: Iconsax.calendar,
      onTap: _selectDate,
    );
  }

  Widget _buildCategoryField() {
    return _buildFormField(
      controller: _categoryController,
      label: "Category",
      icon: Iconsax.category,
      onTap: _selectCategory,
      validator: (data) {
        if (data.toString().trim().isEmpty) {
          return "Please select a category";
        }
        return null;
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: validator,
      onTap: onTap,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description (optional)",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            key: const ValueKey("description"),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            cursorColor: theme.colorScheme.primary,
            textCapitalization: TextCapitalization.sentences,
            onSaved: (value) => _description = value.toString().trim(),
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
      ],
    );
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
            onPressed: _onAddOrUpdate,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    widget.isDuplicate
                        ? "Duplicate Expense"
                        : widget.transactionModel == null
                            ? "Save Expense"
                            : "Update Expense",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      _date.value = date;
      _dateController.text = DateFormat("dd MMM, y").format(_date.value);
    }
  }

  Future<void> _selectCategory() async {
    final result = await showModalBottomSheet<CategoryModel>(
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
      _categoryController.text = result.name;
    }
  }

  void _onAddOrUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      final transactionModel = _createTransactionModel();
      final transBloc = context.read<TransactionEditBloc>();
      final budgetBloc =
          context.read<BudgetViewBloc>().state as BudgetSubscribed;

      if (widget.transactionModel == null || widget.isDuplicate) {
        transBloc.add(
          AddTransaction(
            budgetId: budgetBloc.budget.id,
            transaction: transactionModel,
            doc: _document.value,
          ),
        );
      } else {
        transBloc.add(
          UpdateTransaction(
            budgetId: budgetBloc.budget.id,
            transaction: transactionModel,
            doc: _document.value,
            oldTransactionDate: widget.transactionModel!.createdDatetime,
          ),
        );
      }
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
      amount: _amount,
      title: _title,
      createdDatetime: today,
      docUrl: widget.transactionModel?.docUrl ?? "",
      description: _description,
      categoryId: _category.value?.id ?? "",
      createdUserId: admin,
    );
  }
}
