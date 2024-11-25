import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../../core/util/widget/outlined_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/category_model.dart';
import '../helper/category_helper.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "${widget.category == null ? "New" : "Update"} Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
      ),
      // body: BlocListener<ExpenseBloc, ExpenseState>(
      //   listener: (BuildContext context, state) {
      //     _loading.value =
      //         state.expenseStatus == ExpenseStatus.categoryCreating;
      //
      //     /// Close current screen for success category creation
      //     if (state.expenseStatus == ExpenseStatus.categoryCreated) {
      //       Navigator.pop(context);
      //     }
      //
      //     /// Show error snack bar if any!
      //     if (state.error != null) {
      //       state.error!.showSnackBar(context);
      //     }
      //   },
      //   child: ListView(
      //     padding: const EdgeInsets.all(20.0),
      //     children: [
      //       Form(
      //         key: _formKey,
      //         child: OutlinedTextField(
      //           controller: _textEditingController,
      //           initialValue: widget.category?.name,
      //           textFieldKey: "name",
      //           hintText: "Name",
      //           maxLength: 30,
      //           textCapitalization: TextCapitalization.words,
      //           validator: (value) {
      //             if (value.toString().trim().isEmpty) {
      //               return "Fill this field";
      //             }
      //             return null;
      //           },
      //           onSaved: (value) => _name = value.toString().trim(),
      //           inputAction: TextInputAction.done,
      //         ),
      //       ),
      //       const SizedBox(height: 15.0),
      //       ListTile(
      //         onTap: _showIconPicker,
      //         contentPadding: EdgeInsets.zero,
      //         leading: Icon(Icons.add_reaction_rounded),
      //         title: Text(
      //           "Icon",
      //           style: TextStyle(
      //             fontSize: 15.5,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         subtitle: Text("Add an unique icon"),
      //         trailing: ValueListenableBuilder(
      //           valueListenable: _iconName,
      //           builder: (ctx, iconName, _) {
      //             return Icon(
      //               AppHelper.getIconFromString(iconName),
      //               color: AppConfig.primaryColor,
      //               size: 30.0,
      //             );
      //           },
      //         ),
      //       ),
      //       const SizedBox(height: 15.0),
      //       ListTile(
      //         onTap: _showColorPickerDialog,
      //         contentPadding: EdgeInsets.zero,
      //         leading: Icon(Icons.palette_rounded),
      //         title: Text(
      //           "Color",
      //           style: TextStyle(
      //             fontSize: 15.5,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         subtitle: Text("Provide an unique color"),
      //         trailing: ValueListenableBuilder(
      //           valueListenable: _color,
      //           builder: (ctx, color, _) {
      //             return Container(
      //               height: 40.0,
      //               width: 40.0,
      //               decoration: BoxDecoration(
      //                 color: color,
      //                 shape: BoxShape.circle,
      //                 border: Border.all(color: Colors.grey, width: .5),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //       if (widget.category == null) ...[
      //         const SizedBox(height: 20.0),
      //         Text("Suggestions"),
      //         GridView.builder(
      //           padding: const EdgeInsets.symmetric(vertical: 10.0),
      //           shrinkWrap: true,
      //           physics: const NeverScrollableScrollPhysics(),
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2,
      //               mainAxisSpacing: 10.0,
      //               crossAxisSpacing: 10.0,
      //               childAspectRatio: 1 / .25),
      //           itemCount: _suggestions.length,
      //           itemBuilder: (ctx, index) {
      //             return OutlinedButton.icon(
      //               onPressed: () {
      //                 _textEditingController.text = _suggestions[index].name;
      //                 _color.value = _suggestions[index].color;
      //                 _iconName.value = _suggestions[index].icon;
      //               },
      //               style: FilledButton.styleFrom(
      //                 side: BorderSide(
      //                   color: _suggestions[index].color.withOpacity(.5),
      //                 ),
      //                 foregroundColor: _suggestions[index].color,
      //               ),
      //               icon: Icon(
      //                   AppHelper.getIconFromString(_suggestions[index].icon)),
      //               label: Text(_suggestions[index].name),
      //             );
      //           },
      //         ),
      //       ],
      //       const SizedBox(height: 20.0),
      //       ValueListenableBuilder(
      //         valueListenable: _loading,
      //         builder: (ctx, loading, _) {
      //           return LoadingFilledButton(
      //             onPressed: _onCreateOrUpdate,
      //             loading: loading,
      //             child: Text(widget.category == null ? "Create" : "Update"),
      //           );
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  // Function to show icon picker
  Future _showIconPicker() {
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
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select an Icon",
                    style: TextStyle(fontSize: 20.0),
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
      final CategoryModel categoryModel = CategoryModel(
        id: _name.toLowerCase().split(" ").first,
        name: _name,
        color: _color.value,
        icon: _iconName.value,
        createdOn: DateTime.now(),
        createdBy:
            context.read<AuthBloc>().state.currentUser?.uid ?? "unknownUser",
      );
      if (widget.categories != null) {
        /// Dont need to call bloc, because it is called from Expense creation screen
        widget.categories!.value = List.from(widget.categories!.value)
          ..add(categoryModel);
        Navigator.pop(context);
      } else {
        // context.read<ExpenseBloc>().add(
        //       InsertCategory(category: categoryModel),
        //     );
      }
    }
  }
}
