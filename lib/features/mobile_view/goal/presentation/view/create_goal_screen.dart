import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_model.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/goal_bloc.dart';

/// @author : Jibin K John
/// @date   : 24/10/2024
/// @time   : 17:46:41

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _title = "";
  double _budget = 0.0;

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
        title: const Text("Set a Goal"),
        centerTitle: true,
      ),
      body: BlocListener<GoalBloc, GoalState>(
        listener: (BuildContext context, GoalState state) {
          _loading.value = state.status == GoalStatus.adding;

          if (state.status == GoalStatus.added) {
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
              AuthHelper.formTitle(title: "Title"),
              OutlinedTextField(
                textFieldKey: "title",
                inputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                maxLength: 50,
                maxLines: 1,
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Title is empty";
                  }
                  return null;
                },
                onSaved: (value) => _title = value.toString().trim(),
              ),
              AuthHelper.formTitle(title: "Budget Amount"),
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
                  } else if (double.parse(value.toString().trim()) < 10) {
                    return "Minimum budget is 10";
                  }
                  return null;
                },
                onSaved: (value) =>
                    _budget = double.parse(value.toString().trim()),
              ),
              const SizedBox(height: 40.0),
              ValueListenableBuilder(
                valueListenable: _loading,
                builder: (ctx, loading, _) {
                  return LoadingButton(
                    onPressed: _onCreate,
                    loading: loading,
                    loadingLabel: "Creating",
                    child: const Text("Create"),
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
      final model = GoalModel(
        id: date.millisecondsSinceEpoch.toString(),
        budget: _budget,
        createdOn: date,
        title: _title,
        transactions: [],
      );
      context.read<GoalBloc>().add(
            AddGoal(
              adminId: context.read<AuthBloc>().state.userInfo?.adminId ?? "",
              model: model,
            ),
          );
    }
  }
}
