import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/config/app_config.dart';
import 'package:spend_wise/core/util/widget/filled_text_field.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../budget/presentation/bloc/category_bloc.dart';
import '../../../home/presentation/widgets/bottom_category_sheet.dart';

/// @author : Jibin K John
/// @date   : 18/12/2024
/// @time   : 22:48:41

class TransactionEntryScreen extends StatefulWidget {
  final TransactionModel? transactionModel;

  const TransactionEntryScreen({super.key, this.transactionModel});

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  late ValueNotifier<DateTime> _date;
  late ValueNotifier<CategoryModel?> _category;

  String _title = "";
  String _description = "";
  double _amount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.transactionModel == null) {
      _date = ValueNotifier(DateTime.now());
      _category = ValueNotifier(null);
    } else {
      _date = ValueNotifier(widget.transactionModel!.date);

      final categories = context.read<CategoryBloc>().state.categories;
      final index = categories.indexWhere(
        (item) => item.id == widget.transactionModel!.categoryId,
      );
      if (index > -1) {
        _categoryController.text = categories[index].name;
        _category = ValueNotifier(categories[index]);
      } else {
        _category = ValueNotifier(null);
      }
    }
    _dateController.text = DateFormat.yMMMMEEEEd().format(_date.value);
  }

  @override
  void dispose() {
    super.dispose();
    _loading.dispose();
    _date.dispose();
    _dateController.dispose();
    _category.dispose();
    _categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Transaction"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
          vertical: 10.0,
        ),
        child: Column(
          children: [
            //Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _tile(
                      icon: Icons.calendar_month_rounded,
                      title: "Date",
                      child: FilledTextField(
                        maxLines: 1,
                        controller: _dateController,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _date.value,
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _date.value = date;
                            _dateController.text =
                                DateFormat.yMMMMEEEEd().format(_date.value);
                          }
                        },
                        readOnly: true,
                        textFieldKey: "date",
                        inputAction: TextInputAction.none,
                      ),
                      color: Colors.orange,
                    ),
                    _tile(
                      icon: Icons.title_rounded,
                      title: "Title",
                      child: FilledTextField(
                        textFieldKey: "title",
                        hintText: "eg: Haircut",
                        initialValue: widget.transactionModel?.title,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 50,
                        minLines: 1,
                        validator: (data) {
                          if (data.toString().trim().isEmpty) {
                            return "Please fill title";
                          }
                          return null;
                        },
                        onSaved: (data) => _title = data.toString().trim(),
                        inputAction: TextInputAction.next,
                      ),
                      color: Colors.blue,
                    ),
                    _tile(
                      icon: Icons.money_rounded,
                      title: "Amount",
                      child: FilledTextField(
                        textFieldKey: "amount",
                        numberOnly: true,
                        hintText: "eg: 54.0",
                        initialValue:
                            widget.transactionModel?.amount.toString(),
                        maxLines: 1,
                        maxLength: 30,
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return "Amount is empty";
                          } else if (double.parse(
                                value.toString().trim(),
                              ) <
                              .1) {
                            return "Minimum amount is .1";
                          }
                          return null;
                        },
                        onSaved: (value) => _amount = double.parse(
                          value.toString().trim(),
                        ),
                        inputAction: TextInputAction.next,
                      ),
                      color: Colors.teal,
                    ),
                    _tile(
                      icon: Icons.category_rounded,
                      title: "Category",
                      child: FilledTextField(
                        maxLines: 1,
                        controller: _categoryController,
                        hintText: "Select Category",
                        onTap: () async {
                          CategoryModel? result = await showModalBottomSheet(
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
                            _categoryController.text = result.name;
                          }
                        },
                        validator: (data) {
                          if (data.toString().trim().isEmpty) {
                            return "Please select a category";
                          }
                          return null;
                        },
                        readOnly: true,
                        textFieldKey: "category",
                        inputAction: TextInputAction.none,
                      ),
                      color: Colors.red,
                    ),
                    _tile(
                      icon: Icons.description_rounded,
                      title: "Description [Optional]",
                      child: FilledTextField(
                        textFieldKey: "description",
                        minLines: 2,
                        maxLines: 5,
                        maxLength: 150,
                        hintText: "eg: A lifestyle expense..",
                        inputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        onSaved: (value) =>
                            _description = value.toString().trim(),
                        initialValue: widget.transactionModel?.title,
                      ),
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),
            // Button
            LoadingFilledButton(
              onPressed: () {},
              loading: false,
              child:
                  Text("${widget.transactionModel == null ? "Add" : "Update"}"
                      " Transaction"),
            )
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required Widget child,
    required Color color,
  }) =>
      ListTile(
        contentPadding: EdgeInsets.only(bottom: 8.0),
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            size: 22.0,
            color: color,
          ),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black54,
              size: 20.0,
            ),
          ],
        ),
        subtitle: child,
      );
}
