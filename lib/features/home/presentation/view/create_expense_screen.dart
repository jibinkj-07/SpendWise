import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/helper/app_helper.dart';
import 'package:spend_wise/core/util/widget/outlined_text_field.dart';
import 'package:spend_wise/features/home/presentation/view/home_screen.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../account/domain/model/user.dart';
import '../../../account/presentation/view/invite_members_screen.dart';
import '../../../account/presentation/widget/display_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/category_model.dart';
import 'category_entry_screen.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 16:53:20

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = Uuid().v1();
  String _name = "";
  final ValueNotifier<List<CategoryModel>> _categories = ValueNotifier([]);
  final ValueNotifier<List<User>> _members = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _categories.dispose();
    _members.dispose();
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
          "New Expense",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
      ),
      // body: BlocListener<ExpenseBloc, ExpenseState>(
      //   listener: (BuildContext context, ExpenseState state) {
      //     _loading.value = state.expenseStatus == ExpenseStatus.expenseCreating;
      //
      //     if (state.expenseStatus == ExpenseStatus.expenseCreated) {
      //       Navigator.of(context)
      //           .pushNamedAndRemoveUntil(RouteName.home, (_) => false);
      //     }
      //
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
      //           textFieldKey: "name",
      //           hintText: "Expense name",
      //           maxLength: 50,
      //           textCapitalization: TextCapitalization.words,
      //           validator: (value) {
      //             if (value.toString().trim().isEmpty) {
      //               return "Name field is empty";
      //             }
      //             return null;
      //           },
      //           onSaved: (name) => _name = name.toString().trim(),
      //           inputAction: TextInputAction.done,
      //         ),
      //       ),
      //       const SizedBox(height: 20.0),
      //       ListTile(
      //         contentPadding: EdgeInsets.zero,
      //         leading: Icon(Icons.category_rounded),
      //         title: Text(
      //           "Categories",
      //           style: TextStyle(
      //             fontSize: 15.5,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         subtitle: Text("Easily organize your expenses by category"),
      //         trailing: IconButton(
      //           onPressed: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (_) =>
      //                     CategoryEntryScreen(categories: _categories),
      //               ),
      //             );
      //           },
      //           icon: Icon(Icons.add_rounded),
      //         ),
      //       ),
      //       ValueListenableBuilder(
      //         valueListenable: _categories,
      //         builder: (ctx, categories, _) {
      //           return ListView.builder(
      //             itemCount: categories.length,
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             itemBuilder: (ctx, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.symmetric(vertical: 5.0),
      //                 child: ListTile(
      //                   tileColor: Colors.grey.withOpacity(.15),
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(15.0),
      //                   ),
      //                   leading: Icon(
      //                     AppHelper.getIconFromString(categories[index].icon),
      //                     color: categories[index].color,
      //                   ),
      //                   title: Text(categories[index].name),
      //                   trailing: IconButton(
      //                     icon: Icon(Icons.delete_outline_rounded),
      //                     onPressed: () {
      //                       _categories.value = _categories.value
      //                           .where(
      //                             (item) => item.id != categories[index].id,
      //                           )
      //                           .toList();
      //                     },
      //                   ),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      //       const SizedBox(height: 10.0),
      //       ListTile(
      //         contentPadding: EdgeInsets.zero,
      //         leading: Icon(Icons.diversity_3_rounded),
      //         title: Text(
      //           "Invite",
      //           style: TextStyle(
      //             fontSize: 15.5,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         subtitle: Text(
      //             "Share this expense with friends or family so they can contribute as well"),
      //         trailing: IconButton(
      //           onPressed: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (_) => InviteMembersScreen(members: _members),
      //               ),
      //             );
      //           },
      //           icon: Icon(Icons.add_rounded),
      //         ),
      //       ),
      //       ValueListenableBuilder(
      //         valueListenable: _members,
      //         builder: (ctx, members, _) {
      //           return ListView.builder(
      //             itemCount: members.length,
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             itemBuilder: (ctx, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.symmetric(vertical: 5.0),
      //                 child: ListTile(
      //                   tileColor: Colors.blue.shade50,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(15.0),
      //                   ),
      //                   leading: DisplayImage(
      //                     height: 50.0,
      //                     width: 50.0,
      //                     imageUrl: members[index].imageUrl,
      //                   ),
      //                   title: Text(members[index].firstName),
      //                   subtitle: Text(members[index].email),
      //                   trailing: IconButton(
      //                     icon: Icon(Icons.delete_outline_rounded),
      //                     onPressed: () {
      //                       _members.value = _members.value
      //                           .where(
      //                             (item) => item.uid != members[index].uid,
      //                           )
      //                           .toList();
      //                     },
      //                   ),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      //       const SizedBox(height: 20.0),
      //       ValueListenableBuilder(
      //         valueListenable: _loading,
      //         builder: (ctx, loading, _) {
      //           return LoadingFilledButton(
      //             onPressed: _onCreate,
      //             loading: loading,
      //             child: Text("Create"),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final date = DateTime.now();
      // final ExpenseModel expenseModel = ExpenseModel(
      //   id: _id,
      //   name: _name,
      //   adminId:
      //       context.read<AuthBloc>().state.currentUser?.uid ?? "unknownUser",
      //   createdOn: date,
      //   members: [],
      //   invitedUsers: _members.value,
      //   categories: _categories.value,
      //   transactions: [],
      // );
      //
      // context.read<ExpenseBloc>().add(InsertExpense(expense: expenseModel));
    }
  }
}
