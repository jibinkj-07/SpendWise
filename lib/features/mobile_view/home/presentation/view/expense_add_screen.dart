import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/core/util/widgets/custom_snackbar.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';
import 'package:my_budget/features/common/data/model/category_model.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/bottom_category_sheet.dart';

import '../../../../../core/util/widgets/custom_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 22:14:01

class ExpenseAddScreen extends StatefulWidget {
  const ExpenseAddScreen({super.key});

  @override
  State<ExpenseAddScreen> createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  double _amount = 0.0;

  final ValueNotifier<DateTime> _date = ValueNotifier(DateTime.now());
  final ValueNotifier<CategoryModel?> _category = ValueNotifier(null);
  final ValueNotifier<List<File>> _documents = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _date.dispose();
    _category.dispose();
    _documents.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Expense",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (ctx, state) {
          _loading.value = state.expenseStatus == ExpenseStatus.adding;
          // Popping current screen if added
          if (state.expenseStatus == ExpenseStatus.added) {
            Navigator.pop(context);
          }
          // Showing error snackbar
          if (state.error != null) {
            state.error!.showSnackBar(context);
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(15.0),
                  children: [
                    AuthHelper.formTitle(title: "Choose Date"),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _date.value,
                          firstDate: DateTime(1890),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          _date.value = date;
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        side: BorderSide(color: Colors.blue.shade200),
                        foregroundColor: Colors.blue,
                      ),
                      label: ValueListenableBuilder(
                          valueListenable: _date,
                          builder: (ctx, date, _) {
                            return Text(
                              DateFormat.yMMMEd().format(date),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            );
                          }),
                      icon: const Icon(Icons.calendar_month_rounded),
                    ),
                    AuthHelper.formTitle(title: "Title"),
                    OutlinedTextField(
                      textFieldKey: "title",
                      maxLength: 50,
                      maxLines: 1,
                      inputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Title is empty";
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value.toString().trim(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthHelper.formTitle(title: "Amount"),
                              OutlinedTextField(
                                maxLines: 1,
                                textFieldKey: "amount",
                                maxLength: 10,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.number,
                                numberOnly: true,
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthHelper.formTitle(title: "Category"),
                              SizedBox(
                                width: double.infinity,
                                child: ValueListenableBuilder(
                                    valueListenable: _category,
                                    builder: (ctx, category, _) {
                                      return OutlinedButton(
                                        onPressed: () async {
                                          final result =
                                              await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                const BottomCategorySheet(),
                                          );
                                          if (result != null) {
                                            _category.value = result;
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          side: BorderSide(
                                              color: category != null
                                                  ? AppHelper.hexToColor(
                                                      category.color,
                                                    )
                                                  : Colors.blue.shade200),
                                          foregroundColor: category != null
                                              ? AppHelper.hexToColor(
                                                  category.color,
                                                )
                                              : Colors.blue,
                                          padding: const EdgeInsets.all(15.0),
                                        ),
                                        child: ValueListenableBuilder(
                                          valueListenable: _category,
                                          builder: (ctx, category, _) {
                                            return Text(
                                              category == null
                                                  ? "Select"
                                                  : category.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AuthHelper.formTitle(title: "Description [Optional]"),
                    OutlinedTextField(
                      textFieldKey: "description",
                      minLines: 2,
                      maxLines: 5,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (value) =>
                          _description = value.toString().trim(),
                    ),
                    AuthHelper.formTitle(title: "Documents [Optional]"),
                    ValueListenableBuilder(
                      valueListenable: _documents,
                      builder: (ctx, documents, _) {
                        return Column(
                          children: List.generate(
                            documents.length,
                            (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: ListTile(
                                  tileColor: Colors.blue.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  leading: Image.file(
                                    height: 100.0,
                                    width: 100.0,
                                    documents[index],
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text("Document ${index + 1}"),
                                  trailing: IconButton(
                                    onPressed: () =>
                                        _deleteImage(documents[index]),
                                    icon: const Icon(
                                        Icons.delete_outline_rounded),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: () {
                        CustomBottomSheet.showImagePickerDialog(
                          context: context,
                          title: "Upload",
                          subtitle: "Choose your upload option",
                          onTakePhoto: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (image != null) {
                              _addImage(image);
                            }
                          },
                          onChoosePhoto: () async {
                            final image = await ImagePicker().pickMultiImage();
                            for (final img in image) {
                              _addImage(img);
                            }
                          },
                        );
                      },
                      label: const Text("Upload"),
                      icon: const Icon(Icons.cloud_upload_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ValueListenableBuilder(
                    valueListenable: _loading,
                    builder: (ctx, loading, _) {
                      return LoadingButton(
                        onPressed: _onAdd,
                        loading: loading,
                        loadingLabel: "Adding",
                        child: const Text("Add"),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAdd() {
    if (_formKey.currentState!.validate()) {
      if (_category.value == null) {
        CustomSnackBar.showErrorSnackBar(context, "Choose category");
        return;
      }
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      /// Variables for function call
      final date = DateTime.now();
      final user = context.read<AuthBloc>().state.userInfo!;
      final expenseModel = ExpenseModel(
        id: date.millisecondsSinceEpoch.toString(),
        date: _date.value,
        amount: _amount,
        title: _title,
        category: _category.value!,
        description: _description,
        documents: [],
        createdUser: user,
      );

      /// Calling bloc function to add expense
      context.read<ExpenseBloc>().add(
            AddExpense(
              expenseModel: expenseModel,
              user: user,
              documents: _documents.value,
            ),
          );
    }
  }

  void _addImage(XFile image) {
    _documents.value = [..._documents.value, File(image.path)];
  }

  void _deleteImage(File image) {
    _documents.value = _documents.value.where((item) => item != image).toList();
  }
}
