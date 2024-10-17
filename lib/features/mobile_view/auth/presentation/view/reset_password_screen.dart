import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/helper/asset_mapper.dart';
import '../../../../../core/util/mixin/validation_mixin.dart';
import '../../../../../core/util/widgets/custom_snackbar.dart';
import '../bloc/auth_bloc.dart';
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
      backgroundColor: AppConstants.kAppColor,
      body: BlocListener<AuthBloc, AuthState>(
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
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            Image.asset(
              AssetMapper.appIconImage,
              width: size.width * .25,
              height: size.width * .25,
            ),
            Center(
              child: Text(
                AppConstants.kAppName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: size.width * .8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Enter email and follow the instruction mail",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      AuthTextField(
                        textFieldKey: "email",
                        hintText: "Email",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.emailAddress,
                        validator: validateEmail,
                        onSaved: (value) => _email = value.toString().trim(),
                      ),
                      const SizedBox(height: 20.0),
                      ValueListenableBuilder(
                        valueListenable: _loading,
                        builder: (ctx, loading, _) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: loading
                                ? const SizedBox(
                                    height: 25.0,
                                    width: 25.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: _onReset,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.white54),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: AppConstants.kFontFamily,
                                      ),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Reset"),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
