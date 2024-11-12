import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/mixin/validation_mixin.dart';

import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../../core/util/widget/outlined_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widget/auth_bg.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 16:59:26

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen>
    with ValidationMixin {
  String _email = "";
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    _loading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _loading.value = state.authStatus == AuthStatus.resetting;

        /// Pop current screen for success reset
        if (state.authStatus == AuthStatus.reset) {
          Navigator.of(context).pop();
        }

        /// Show error if any occurs
        if (state.error != null) {
          state.error!.showSnackBar(context);
        }
      },
      child: AuthBg(
        formKey: _formKey,
        title: "Reset your Password",
        children: [
          Text(
              "A password reset email will be sent to the address you entered below."
              " Please follow the instructions in the email.\n\nIf you don’t see it in your inbox,"
              " check your spam folder.\n"),
          OutlinedTextField(
            textFieldKey: "email",
            hintText: "Email",
            inputAction: TextInputAction.done,
            inputType: TextInputType.emailAddress,
            validator: validateEmail,
            onSaved: (data) => _email = data.toString().trim(),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, _) {
                return LoadingFilledButton(
                  loading: loading,
                  onPressed: _onReset,
                  child: Text("Reset"),
                );
              },
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"),
            ),
          )
        ],
      ),
    );
  }

  /// FUNCTIONS
  void _onReset() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      context.read<AuthBloc>().add(ResetPassword(email: _email));
    }
  }
}
