import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/filled_text_field.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../../budget/presentation/bloc/category_edit_bloc.dart';
import '../helper/category_helper.dart';
import '../widgets/category_delete_dialog.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 18:57:01

class CategoryEntryScreen extends StatefulWidget {
  final ValueNotifier<List<CategoryModel>>? categories;
  final CategoryModel? category;

  const CategoryEntryScreen({
    super.key,
    this.categories,
    this.category,
  });

  @override
  State<CategoryEntryScreen> createState() => _CategoryEntryScreenState();
}

class _CategoryEntryScreenState extends State<CategoryEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  final TextEditingController _textEditingController = TextEditingController();
  late ValueNotifier<String> _iconName;
  late ValueNotifier<Color> _color;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  List<CategoryModel> _suggestions = [];

  @override
  void initState() {
    if (widget.category != null) {
      _iconName = ValueNotifier(widget.category!.icon);
      _color = ValueNotifier(widget.category!.color);
      _textEditingController.text = widget.category!.name;
    } else {
      _iconName = ValueNotifier(
        AppHelper.categoryIconMap.keys.first,
      );
      _color = ValueNotifier(AppConfig.primaryColor);
      _suggestions = CategoryHelper.suggestionCategories();
    }

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _iconName.dispose();
    _color.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.category == null ? Colors.white : null,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "${widget.category == null ? "New" : "Update"} Category",
        ),
        centerTitle: true,
        actions: [
          if (widget.category != null)
            TextButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,

                  context: context,
                  builder: (ctx) => CategoryDeleteDialog(
                    categoryId: widget.category?.id ?? "",
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
        ],
      ),
      body: ListView(
        children: [
          if (widget.category == null)
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text("Suggestions For You"),
                subtitle: Text(
                  "Click to expand",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.white,
                tilePadding: EdgeInsets.symmetric(
                  horizontal: AppHelper.horizontalPadding(size),
                ),
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: AppHelper.horizontalPadding(size),
                  vertical: 10.0,
                ),
                children: [
                  Wrap(
                    spacing: 10,
                    children: List.generate(
                      _suggestions.length,
                      (index) => FilledButton.icon(
                        onPressed: () {
                          _textEditingController.text =
                              _suggestions[index].name;
                          _color.value = _suggestions[index].color;
                          _iconName.value = _suggestions[index].icon;
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              _suggestions[index].color.withOpacity(.15),
                          foregroundColor: _suggestions[index].color,
                        ),
                        icon: Icon(
                          AppHelper.getIconFromString(_suggestions[index].icon),
                        ),
                        label: Text(_suggestions[index].name),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppHelper.horizontalPadding(size),
              vertical: 20.0,
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: FilledTextField(
                    textFieldKey: "name",
                    labelText: "Category Name",
                    controller: _textEditingController,
                    maxLength: 40,
                    textCapitalization: TextCapitalization.words,
                    inputAction: TextInputAction.done,
                    onSaved: (data) => _name = data.toString().trim(),
                    validator: (data) {
                      if (data.toString().trim().isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: .15, // Border width
                    ),
                    borderRadius:
                        BorderRadius.circular(10.0), // Optional rounded corners
                  ),
                  child: ListTile(
                    onTap: _showIconPicker,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text(
                      "Icon",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: ValueListenableBuilder(
                      valueListenable: _iconName,
                      builder: (ctx, iconName, _) {
                        return ValueListenableBuilder(
                          valueListenable: _color,
                          builder: (ctx, color, _) {
                            return Icon(
                              AppHelper.getIconFromString(iconName),
                              color: color,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: .15, // Border width
                    ),
                    borderRadius:
                        BorderRadius.circular(10.0), // Optional rounded corners
                  ),
                  child: ListTile(
                    onTap: _showColorPickerDialog,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text(
                      "Color",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: ValueListenableBuilder(
                      valueListenable: _color,
                      builder: (ctx, color, _) {
                        return Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: .15, // Border width
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                BlocListener<CategoryEditBloc, CategoryEditState>(
                  listener: (BuildContext context, CategoryEditState state) {
                    _loading.value = state is AddingCategory;
                    if (state is CategoryErrorOccurred) {
                      state.error.showSnackBar(context);
                    }
                    if (state is CategoryAdded) {
                      Navigator.pop(context);
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _loading,
                    builder: (ctx, loading, _) {
                      return LoadingFilledButton(
                        onPressed: _onCreateOrUpdate,
                        loading: loading,
                        child: const Text("Done"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show icon picker
  Future _showIconPicker() {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.all(15.0),
          height: MediaQuery.sizeOf(context).height * .45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select an Icon",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.close_rounded),
                  )
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: AppHelper.categoryIconMap.values.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemBuilder: (ctx, index) {
                    final iconName =
                        AppHelper.categoryIconMap.keys.toList()[index];

                    return IconButton(
                      onPressed: () {
                        _iconName.value = iconName;
                        Navigator.pop(ctx);
                      },
                      style: IconButton.styleFrom(
                        foregroundColor: _iconName.value == iconName
                            ? AppConfig.primaryColor
                            : null,
                      ),
                      icon: Icon(AppHelper.getIconFromString(iconName)),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Function to show the color picker dialog
  void _showColorPickerDialog() {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (context) {
        Color color = _color.value;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: color,
              onColorChanged: (Color clr) => color = clr,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            FilledButton(
              child: const Text('Confirm'),
              onPressed: () {
                _color.value = color;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onCreateOrUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      String admin = "unknownUser";
      final authBloc = context.read<AuthBloc>();
      if (authBloc.state is Authenticated) {
        admin = (authBloc.state as Authenticated).user.uid;
      }
      final CategoryModel categoryModel = CategoryModel(
        id: widget.category?.id ?? _name.toLowerCase().split(" ").first,
        name: _name,
        color: _color.value,
        icon: _iconName.value,
        createdOn: DateTime.now(),
        createdBy: admin,
      );
      if (widget.categories != null) {
        /// Do not need to call Category bloc, because
        /// category will automatically get added to firebase
        /// when creating budget [this section only trigger from budget creation screen]
        widget.categories!.value = List.from(widget.categories!.value)
          ..add(categoryModel);
        Navigator.pop(context);
      } else {
        context.read<CategoryEditBloc>().add(
              AddCategory(
                budgetId:
                    (context.read<BudgetViewBloc>().state as BudgetSubscribed)
                        .budget
                        .id,
                category: categoryModel,
              ),
            );
      }
    }
  }
}
