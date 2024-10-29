import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view_model/account_view_model.dart';

import '../../../../../core/util/mixin/validation_mixin.dart';
import '../../../../../core/util/widgets/loading_button.dart';
import '../../../../../core/util/widgets/outlined_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/util/auth_helper.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 16:53:23

class UserAccess extends StatefulWidget {
  const UserAccess({super.key});

  @override
  State<UserAccess> createState() => _UserAccessState();
}

enum AccessMode { grant, revoke }

class _UserAccessState extends State<UserAccess> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<AccessMode> _accessMode = ValueNotifier(AccessMode.grant);
  String _email = "";

  @override
  void dispose() {
    _loading.dispose();
    _accessMode.dispose();
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
        title: const Text("User Access"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHelper.formTitle(title: "Member Email"),
              OutlinedTextField(
                textFieldKey: "email",
                inputAction: TextInputAction.done,
                maxLength: 60,
                inputType: TextInputType.emailAddress,
                maxLines: 1,
                validator: validateEmail,
                onSaved: (value) => _email = value.toString().trim(),
              ),
              ValueListenableBuilder(
                valueListenable: _accessMode,
                builder: (ctx, mode, _) {
                  return Column(
                    children: [
                      RadioListTile<AccessMode>(
                        title: Text('Grant'),
                        value: AccessMode.grant,
                        groupValue: mode,
                        onChanged: (AccessMode? value) =>
                            _accessMode.value = value!,
                      ),
                      RadioListTile<AccessMode>(
                        title: Text('Revoke'),
                        value: AccessMode.revoke,
                        groupValue: mode,
                        onChanged: (AccessMode? value) =>
                            _accessMode.value = value!,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25.0),
              ValueListenableBuilder(
                valueListenable: _loading,
                builder: (ctx, loading, _) {
                  return LoadingButton(
                    onPressed: _onAddMember,
                    loading: loading,
                    loadingLabel: "Loading",
                    child: const Text("Apply"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAddMember() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _loading.value = true;
      final result = _accessMode.value == AccessMode.grant
          ? await AccountViewModel.grantAccess(memberEmail: _email)
          : await AccountViewModel.revokeAccess(memberEmail: _email);
      _loading.value = false;
      if (!mounted) return;
      if (result.isRight) {
        Navigator.pop(context);
      } else {
        result.left.showSnackBar(context);
      }
    }
  }
}
