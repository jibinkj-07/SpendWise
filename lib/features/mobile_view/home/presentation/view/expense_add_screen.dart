import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/widgets/custom_snackbar.dart';
import 'package:my_budget/core/util/widgets/form_text_field.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/features/common/data/model/category_model.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/bottom_category_sheet.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/document_view.dart';
import '../../../../../core/util/widgets/custom_bottom_sheet.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';
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
  final ValueNotifier<List<XFile>> _documents = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {
    final catList = context.read<CategoryBloc>().state.categoryList;
    if (catList.isNotEmpty) {
      _category.value = catList.first;
    }
    super.initState();
  }

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
        centerTitle: true,
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
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            children: [
              /// DATE || CATEGORY
              Row(
                children: [
                  // Date
                  Expanded(
                    child: FilledButton.icon(
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
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.black87,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _date,
                            builder: (ctx, date, _) {
                              return Text(
                                DateFormat("E, dd/MM").format(date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  //Category
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const BottomCategorySheet(),
                        );
                        if (result != null) {
                          _category.value = result;
                        }
                      },
                      icon: const Icon(
                        Icons.category_outlined,
                        color: Colors.black87,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _category,
                            builder: (ctx, category, _) {
                              return Text(
                                category == null ? "Choose" : category.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),

              /// TITLE || AMOUNT || DESCRIPTION
              FormTextField(
                textFieldKey: "title",
                maxLength: 50,
                maxLines: 1,
                hintText: "Expense title",
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
              const SizedBox(height: 10.0),
              FormTextField(
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
                hintText: "0.0",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
                textFieldKey: "amount",
                maxLength: 10,
                inputAction: TextInputAction.next,
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
              const SizedBox(height: 10.0),
              FormTextField(
                textFieldKey: "description",
                hintText: "Add comment...",
                minLines: 2,
                maxLines: 5,
                inputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => _description = value.toString().trim(),
              ),

              /// DOCUMENTS
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: .2, color: Colors.black87),
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _documents,
                      builder: (ctx, documents, child) {
                        if (documents.isEmpty) return child!;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: documents.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                Expanded(
                                  child: DocumentView(
                                    image: documents[index],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _deleteImage(documents[index]),
                                  child: const Text("Remove"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Upload supporting documents",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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

              /// SUBMIT BUTTON
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
    _documents.value = [..._documents.value, image];
  }

  void _deleteImage(XFile image) {
    _documents.value = _documents.value.where((item) => item != image).toList();
  }
}
