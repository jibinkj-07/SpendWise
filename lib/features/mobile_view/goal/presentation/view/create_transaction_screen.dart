import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';
import '../bloc/goal_bloc.dart';

/// @author : Jibin K John
/// @date   : 24/10/2024
/// @time   : 18:54:41

class CreateTransactionScreen extends StatefulWidget {
  final UserModel user;
  final String goalId;

  const CreateTransactionScreen({
    super.key,
    required this.user,
    required this.goalId,
  });

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  double _amount = 0.0;

  @override
  void dispose() {
    super.dispose();
    _loading.dispose();
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
        title: const Text("New Transaction"),
        centerTitle: true,
      ),
      body: BlocListener<GoalBloc, GoalState>(
        listener: (BuildContext context, GoalState state) {
          _loading.value = state.status == GoalStatus.transAdding;

          if (state.status == GoalStatus.transAdded) {
            Navigator.pop(context);
          }

          if (state.error != null) {
            state.error!.showSnackBar(context);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              AuthHelper.formTitle(title: "Amount"),
              OutlinedTextField(
                textFieldKey: "budget",
                inputAction: TextInputAction.done,
                inputType: TextInputType.number,
                numberOnly: true,
                maxLength: 15,
                maxLines: 1,
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Budget is empty";
                  } else if (double.parse(value.toString().trim()) < 1) {
                    return "Minimum budget is 1";
                  }
                  return null;
                },
                onSaved: (value) =>
                    _amount = double.parse(value.toString().trim()),
              ),
              const SizedBox(height: 40.0),
              ValueListenableBuilder(
                valueListenable: _loading,
                builder: (ctx, loading, _) {
                  return LoadingButton(
                    onPressed: _onCreate,
                    loading: loading,
                    loadingLabel: "Adding",
                    child: const Text("Add"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final date = DateTime.now();
      final model = GoalTransactionModel(
        id: date.millisecondsSinceEpoch.toString(),
        addedBy: widget.user,
        createdOn: date,
        amount: _amount,
      );
      context.read<GoalBloc>().add(
            AddGoalTransaction(
              adminId: widget.user.adminId,
              goalId: widget.goalId,
              model: model,
            ),
          );
    }
  }
}
