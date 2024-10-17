import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/route/route_mapper.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/helper/asset_mapper.dart';
import '../../../../../core/util/mixin/validation_mixin.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 18:14:14

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  // Notifiers
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _email = "";
  String _name = "";
  String _password = "";

  @override
  void dispose() {
    _isObscure.dispose();
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
          _loading.value = state.authStatus == AuthStatus.creating;

          // Routing user to email verification screen
          if (state.authStatus == AuthStatus.created) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteMapper.mobileHomeScreen,
              (route) => false,
            );
          }

          // Checking for errors
          if (state.error != null) {
            state.error!.showSnackBar(context);
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
                        "Create an account",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      AuthTextField(
                        textFieldKey: "name",
                        hintText: "Name",
                        inputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        validator: validateUsername,
                        onSaved: (value) => _name = value.toString().trim(),
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
                      const SizedBox(height: 10.0),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isObscure,
                        builder: (ctx, obscure, Widget? child) {
                          return AuthTextField(
                            textFieldKey: "password",
                            hintText: "Password",
                            isObscure: obscure,
                            inputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _isObscure.value = !_isObscure.value;
                              },
                            ),
                            validator: validatePassword,
                            onSaved: (value) =>
                                _password = value.toString().trim(),
                          );
                        },
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
                                      onPressed: _onCreate,
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
                                      child: const Text("Create"),
                                    ),
                            );
                          }),
                      Divider(
                        thickness: .5,
                        color: Colors.grey,
                        indent: 20.0,
                        endIndent: 20.0,
                        height: size.height * .1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: AppConstants.kFontFamily,
                              ),
                            ),
                            child: const Text("Login"),
                          ),
                        ],
                      )
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

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
            CreateUser(
              name: _name,
              email: _email,
              password: _password,
            ),
          );
    }
  }
}
