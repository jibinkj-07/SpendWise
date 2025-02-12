import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/config/injection/imports.dart';
import 'package:spend_wise/core/util/widget/filled_text_field.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../home/presentation/widgets/bottom_category_sheet.dart';
import '../../../home/presentation/widgets/xFile_image_view.dart';
import '../../domain/model/transaction_model.dart';

/// @author : Jibin K John
/// @date   : 18/12/2024
/// @time   : 22:48:41

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

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<XFile?> _document = ValueNotifier(null);
  late ValueNotifier<DateTime> _date;
  late ValueNotifier<CategoryModel?> _category;
  final SharedPrefHelper _sharedPrefHelper = sl<SharedPrefHelper>();

  String _title = "";
  String _description = "";
  double _amount = 0.0;

  @override
  void initState() {
    super.initState();

    _category = ValueNotifier(null);
    _date = ValueNotifier(DateTime.now());
    if (widget.transactionModel != null) {
      _date = ValueNotifier(widget.transactionModel!.date);
      final categories =
          (context
              .read<CategoryViewBloc>()
              .state as CategorySubscribed)
              .categories;
      final index = categories.indexWhere(
            (item) => item.id == widget.transactionModel!.categoryId,
      );
      if (index > -1) {
        _categoryController.text = categories[index].name;
        _category = ValueNotifier(categories[index]);
      }
    }
    _dateController.text = DateFormat("dd MMM, y").format(_date.value);
  }

  @override
  void dispose() {
    super.dispose();
    _loading.dispose();
    _date.dispose();
    _dateController.dispose();
    _category.dispose();
    _categoryController.dispose();
    _document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
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
                      icon: Iconsax.calendar_1,
                      title: "Date",
                      child: FilledTextField(
                        maxLines: 1,
                        controller: _dateController,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _date.value,
                            firstDate: DateTime(1800),
                            lastDate: DateTime(3000),
                          );
                          if (date != null) {
                            _date.value = date;
                            _dateController.text =
                                DateFormat("dd MMM, y").format(_date.value);
                          }
                        },
                        readOnly: true,
                        textFieldKey: "date",
                        inputAction: TextInputAction.none,
                      ),
                      color: Colors.brown.shade800,
                    ),
                    _tile(
                      icon: Iconsax.text,
                      title: "Title",
                      child: Autocomplete(
                        optionsBuilder: (TextEditingValue value) {
                          if (value.text
                              .trim()
                              .isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _sharedPrefHelper
                              .getTransactionSuggestions()
                              .where(
                                (title) => title.contains(value.text.trim()),
                          );
                        },
                        fieldViewBuilder: (context,
                            textEditingController,
                            focusNode,
                            onFieldSubmitted,) {
                          if (widget.transactionModel != null && textEditingController.text.isEmpty) {
                            textEditingController.text = widget.transactionModel!.title;
                          }
                          return FilledTextField(
                            textFieldKey: "title",
                            hintText: "eg: Haircut",
                            focusNode: focusNode,
                            onFieldSubmitted: (value) => onFieldSubmitted(),
                            controller: textEditingController,
                            textCapitalization: TextCapitalization.words,
                            maxLength: 50,
                            minLines: 1,
                            validator: (data) {
                              if (data
                                  .toString()
                                  .trim()
                                  .isEmpty) {
                                return "Please fill title";
                              }
                              return null;
                            },
                            onSaved: (data) => _title = data.toString().trim(),
                            inputAction: TextInputAction.next,
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .75,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final String option =
                                    options.elementAt(index);
                                    return ListTile(
                                      title: Text(
                                        option,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onTap: () {
                                        onSelected(option);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      color: Colors.blue,
                    ),
                    _tile(
                      icon: Iconsax.money_send,
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
                          if (value
                              .toString()
                              .trim()
                              .isEmpty) {
                            return "Amount is empty";
                          } else if (double.parse(
                            value.toString().trim(),
                          ) <
                              .1) {
                            return "Minimum amount is .1";
                          }
                          return null;
                        },
                        onSaved: (value) =>
                        _amount = double.parse(
                          value.toString().trim(),
                        ),
                        inputAction: TextInputAction.next,
                      ),
                      color: Colors.teal,
                    ),
                    _tile(
                      icon: Iconsax.category_2,
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
                            builder: (context) =>
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery
                                        .of(context)
                                        .viewInsets
                                        .bottom,
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
                          if (data
                              .toString()
                              .trim()
                              .isEmpty) {
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
                      icon: Iconsax.document_text_1,
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
                        initialValue: widget.transactionModel?.description,
                      ),
                      color: Colors.deepPurple,
                    ),
                    _tile(
                      icon: Iconsax.folder,
                      title: "Document [Optional]",
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: .15,
                            color: Colors.grey,
                          ),
                        ),
                        child: ValueListenableBuilder(
                            valueListenable: _document,
                            builder: (ctx, doc, _) {
                              return Column(
                                children: [
                                  if (doc != null)
                                    XFileImageView(image: doc)
                                  else
                                    Text(
                                      "Choose document",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (doc == null)
                                        const SizedBox.shrink()
                                      else
                                        TextButton(
                                          onPressed: () =>
                                          _document.value = null,
                                          child: Text("Remove"),
                                        ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              _document.value =
                                              await ImagePicker().pickImage(
                                                source: ImageSource.gallery,
                                              );
                                            },
                                            icon: Icon(Iconsax.attach_circle),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              _document.value =
                                              await ImagePicker().pickImage(
                                                source: ImageSource.camera,
                                              );
                                            },
                                            icon: Icon(Iconsax.camera),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                      color: Colors.orange.shade600,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            // Button
            BlocListener<TransactionEditBloc, TransactionEditState>(
              listener: (BuildContext context, TransactionEditState state) {
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
                  return LoadingFilledButton(
                    onPressed: _onAddOrUpdate,
                    loading: loading,
                    child: Text(
                        "${widget.isDuplicate ? "Duplicate" : widget
                            .transactionModel == null ? "Add" : "Update"}"
                            " Transaction"),
                  );
                },
              ),
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
          radius: 20.0,
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            size: 20.0,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
            color: Colors.black54,
          ),
        ),
        subtitle: child,
      );

  void _onAddOrUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      String admin = "unknownUser";
      final authBloc = context.read<AuthBloc>();
      if (authBloc.state is Authenticated) {
        admin = (authBloc.state as Authenticated).user.uid;
      }
      final today = DateTime.now();
      final transactionModel = TransactionModel(
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
      final transBloc = context.read<TransactionEditBloc>();
      final budgetBloc =
      (context
          .read<BudgetViewBloc>()
          .state as BudgetSubscribed);

      // for duplication and creating new one adding id as current datetime stamp
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
}
