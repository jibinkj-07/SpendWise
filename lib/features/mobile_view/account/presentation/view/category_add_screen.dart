import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';
import 'package:my_budget/features/common/data/model/category_model.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';
import '../../../../../core/util/widgets/form_text_field.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 13:35:31

class CategoryAddScreen extends StatefulWidget {
  final VoidCallback? refreshData;

  const CategoryAddScreen({super.key, this.refreshData});

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
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (BuildContext context, CategoryState state) {
          _loading.value = state.categoryStatus == CategoryStatus.adding;
          if (state.categoryStatus == CategoryStatus.added) {
            if (widget.refreshData != null) {
              widget.refreshData!();
            }
            Navigator.pop(context);
          }
          if (state.error != null) {
            state.error!.showSnackBar(context);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              OutlinedTextField(
                textFieldKey: "name",
                maxLength: 50,
                maxLines: 1,
                hintText: "Category name",
                inputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Name is empty";
                  }
                  return null;
                },
                onSaved: (value) => _category = value.toString().trim(),
              ),
              const SizedBox(height: 20.0),
              ValueListenableBuilder(
                valueListenable: _selectedColor,
                builder: (ctx, color, _) {
                  bool isDark = color.computeLuminance() < 0.5;
                  return FilledButton.icon(
                    onPressed: () => _showColorPickerDialog(context),
                    icon: Icon(
                      Icons.category_outlined,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    style: FilledButton.styleFrom(backgroundColor: color),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _selectedColor,
                          builder: (ctx, color, _) {
                            return Text(
                              "Color",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            );
                          },
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ValueListenableBuilder(
                  valueListenable: _loading,
                  builder: (ctx, loading, _) {
                    return LoadingButton(
                      onPressed: _onAdd,
                      loading: loading,
                      loadingLabel: "Adding",
                      child: const Text("Add"),
                    );
                  },
                ),
              ),
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
