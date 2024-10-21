import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/helper/asset_mapper.dart';
import '../../../../../core/util/mixin/validation_mixin.dart';
import '../../../../../core/util/widgets/custom_snackbar.dart';
import '../../../../../core/util/widgets/loading_button.dart';
import '../bloc/auth_bloc.dart';
import '../util/auth_helper.dart';
import '../widgets/auth_text_field.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 19:25:51

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  // Notifiers
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _email = "";

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (ctx, state) {
            // Updating loading variable
            _loading.value = state.authStatus == AuthStatus.resetting;

            // Checking for errors
            if (state.error != null) {
              state.error!.showSnackBar(context);
            }

            // Showing success snack bar
            if (state.authStatus == AuthStatus.resetInstructionSent) {
              CustomSnackBar.showSuccessSnackBar(
                context,
                "Check your mail for password reset",
              );
              // Closing the screen auto in 3 sec
              Future.delayed(const Duration(seconds: 3), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: [
              /// header
              AuthHelper.formHeader(size),

              /// body
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    width: .2,
                    color: Colors.grey.withOpacity(.5),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Enter email and follow the instruction mail",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AuthHelper.formTitle(title: "Email"),
                      AuthTextField(
                        textFieldKey: "email",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.emailAddress,
                        validator: validateEmail,
                        onSaved: (value) => _email = value.toString().trim(),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 30.0,
                          bottom: 15.0,
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: _loading,
                          builder: (ctx, loading, _) {
                            return LoadingButton(
                              onPressed: _onReset,
                              loading: loading,
                              loadingLabel: "Sending",
                              child: const Text("Send Instruction"),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Remember Password"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onReset() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(ResetPassword(email: _email));
    }
  }
}
