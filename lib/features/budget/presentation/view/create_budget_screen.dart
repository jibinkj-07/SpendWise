import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spend_wise/core/util/helper/app_helper.dart';
import 'package:spend_wise/core/util/widget/filled_text_field.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../account/domain/model/user.dart';
import '../../../account/presentation/view/invite_members_screen.dart';
import '../../../account/presentation/widget/display_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/category_model.dart';
import '../../../home/presentation/view/category_entry_screen.dart';
import '../bloc/budget_edit_bloc.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 16:53:20

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  final ValueNotifier<List<CategoryModel>> _categories = ValueNotifier([]);
  final ValueNotifier<List<User>> _members = ValueNotifier([]);
  final ValueNotifier<Currency?> _currency = ValueNotifier(null);
  final TextEditingController _currencyController = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _currencyController.dispose();
    _categories.dispose();
    _members.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_2),
        ),
        title: Text("New Budget"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppHelper.horizontalPadding(size),
            vertical: 10.0,
          ),
          children: [
            _heading("Details"),
            FilledTextField(
              textFieldKey: "name",
              labelText: "Budget Name",
              maxLength: 40,
              inputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              onSaved: (data) => _name = data.toString().trim(),
              validator: (data) {
                if (data.toString().trim().isEmpty) {
                  return "Please enter a name";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            FilledTextField(
              readOnly: true,
              onTap: _currencySelector,
              controller: _currencyController,
              textFieldKey: "currency",
              labelText: "Currency",
              inputAction: TextInputAction.next,
              validator: (data) {
                if (data.toString().trim().isEmpty) {
                  return "Please choose a currency";
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            _heading("Categories"),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: .15, color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _categories,
                    builder: (ctx, categories, child) {
                      return categories.isNotEmpty
                          ? Wrap(
                              spacing: 10,
                              children: List.generate(
                                categories.length,
                                (index) => FilledButton.icon(
                                  onPressed: () {
                                    _categories.value = _categories.value
                                        .where((item) =>
                                            item.id != categories[index].id)
                                        .toList();
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: categories[index]
                                        .color
                                        .withOpacity(.15),
                                    foregroundColor: categories[index].color,
                                  ),
                                  icon: Icon(
                                    AppHelper.getIconFromString(
                                        categories[index].icon),
                                  ),
                                  label: Text(categories[index].name),
                                ),
                              ),
                            )
                          : child!;
                    },
                    child: const SizedBox.shrink(),
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CategoryEntryScreen(categories: _categories),
                        ),
                      );
                    },
                    icon: Icon(Iconsax.add),
                  ),
                ],
              ),
            ),
            _heading("Invite Members"),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: .15, color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _members,
                    builder: (ctx, members, child) {
                      return members.isNotEmpty
                          ? ListView.builder(
                              itemCount: members.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) => Material(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: ListTile(
                                    tileColor: Colors.grey.withOpacity(.15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    leading: DisplayImage(
                                      imageUrl: members[index].imageUrl,
                                      width: 50.0,
                                      height: 50.0,
                                    ),
                                    title: Text(members[index].name),
                                    subtitle: Text(members[index].email),
                                    trailing: IconButton(
                                      onPressed: () {
                                        _members.value = _members.value
                                            .where((item) =>
                                                item.uid != members[index].uid)
                                            .toList();
                                      },
                                      style: IconButton.styleFrom(
                                        foregroundColor: AppConfig.errorColor,
                                      ),
                                      icon: Icon(Iconsax.close_circle),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : child!;
                    },
                    child: const SizedBox.shrink(),
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              InviteMembersScreen(members: _members),
                        ),
                      );
                    },
                    icon: Icon(
                      Iconsax.people,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            BlocListener<BudgetEditBloc, BudgetEditState>(
              listener: (ctx, state) {
                _loading.value = state is AddingBudget;

                if (state is BudgetAdded) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteName.home,
                    (_) => false,
                  );
                }
                if (state is BudgetErrorOccurred) {
                  state.error.showSnackBar(context);
                }
              },
              child: ValueListenableBuilder(
                valueListenable: _loading,
                builder: (ctx, loading, _) {
                  return LoadingFilledButton(
                    onPressed: _onCreate,
                    loading: loading,
                    child: Text("Create"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      String admin = "unknownUser";
      final authBloc = context.read<AuthBloc>();
      if (authBloc.state is Authenticated) {
        admin = (authBloc.state as Authenticated).user.uid;
      }
      context.read<BudgetEditBloc>().add(
            AddBudget(
              name: _name,
              admin: admin,
              currency: _currency.value!,
              categories: _categories.value,
              members: _members.value,
            ),
          );
    }
  }

  Widget _heading(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );

  void _currencySelector() {
    showCurrencyPicker(
      context: context,
      showFlag: false,
      onSelect: (value) {
        _currency.value = value;
        _currencyController.text = "${value.symbol} ${value.name}";
      },
    );
  }
}
