import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';
import 'package:my_budget/features/common/data/model/category_model.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';

import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 13:35:31

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<Color> _selectedColor = ValueNotifier(Colors.purple);
  String _category = "";

  @override
  void dispose() {
    _loading.dispose();
    _selectedColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add Category"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHelper.formTitle(title: "Category Name"),
              OutlinedTextField(
                textFieldKey: "name",
                inputAction: TextInputAction.done,
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Category name is empty";
                  }
                  return null;
                },
                onSaved: (value) => _category = value.toString().trim(),
              ),
              AuthHelper.formTitle(title: "Category Color"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _selectedColor,
                    builder: (ctx, color, _) {
                      return CircleAvatar(
                        backgroundColor: color,
                        radius: 20.0,
                      );
                    },
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      _showColorPickerDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: BorderSide(color: Colors.blue.shade200),
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    child: const Text("Pick Color"),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              ValueListenableBuilder(
                  valueListenable: _loading,
                  builder: (ctx, loading, _) {
                    return LoadingButton(
                      onPressed: _onAdd,
                      loading: loading,
                      loadingLabel: "Adding",
                      child: const Text("Add"),
                    );
                  }),
              const Divider(),
              Expanded(
                  child: BlocConsumer<CategoryBloc, CategoryState>(
                builder: (ctx, state) {
                  return state.categoryList.isEmpty
                      ? const Center(child: Text("No Categories"))
                      : ListView.builder(
                          itemCount: state.categoryList.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: AppHelper.hexToColor(
                                  state.categoryList[index].color,
                                ),
                              ),
                              title: Text(
                                state.categoryList[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                DateFormat.yMMMEd().add_jm().format(
                                    state.categoryList[index].createdOn),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: IconButton(
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
                                                Navigator.pop(ctx);

                                                final authBloc = context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .userInfo;
                                                context
                                                    .read<CategoryBloc>()
                                                    .add(
                                                      DeleteCategory(
                                                        adminId:
                                                            authBloc!.adminId,
                                                        categoryId: state
                                                            .categoryList[index]
                                                            .id,
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
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            );
                          },
                        );
                },
                listener: (BuildContext context, CategoryState state) {
                  _loading.value =
                      state.categoryStatus == CategoryStatus.adding;
                  if (state.categoryStatus == CategoryStatus.added) {
                    Navigator.pop(context);
                  }
                  if (state.error != null) {
                    state.error!.showSnackBar(context);
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _onAdd() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final authBloc = context.read<AuthBloc>().state.userInfo;
      final date = DateTime.now();
      final model = CategoryModel(
        id: date.millisecondsSinceEpoch.toString(),
        title: _category,
        createdOn: date,
        color: _selectedColor.value.value.toRadixString(16).substring(2),
      );
      context.read<CategoryBloc>().add(
            AddCategory(
              categoryModel: model,
              adminId: authBloc!.adminId,
            ),
          );
    }
  }

  // Function to show the color picker dialog
  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color color = Colors.blue;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              paletteType: PaletteType.hueWheel,
              enableAlpha: false,
              hexInputBar: false,
              onColorChanged: (Color clr) => color = clr,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            FilledButton(
              child: const Text('Done'),
              onPressed: () {
                _selectedColor.value = color;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
