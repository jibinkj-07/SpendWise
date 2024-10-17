import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/route/route_mapper.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'package:my_budget/core/util/helper/asset_mapper.dart';
import 'package:my_budget/core/util/mixin/validation_mixin.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/widgets/auth_text_field.dart';

import '../bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 15:05:13

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  // Notifiers
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _email = "";
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
          _loading.value = state.authStatus == AuthStatus.loggingIn;

          // Checking for errors
          if (state.error != null) {
            state.error!.showSnackBar(context);
          }
          // Handle authenticated states
          if (state.userInfo != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteMapper.mobileHomeScreen,
              (route) => false,
            );
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
                "Welcome to ${AppConstants.kAppName}",
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
                        "Login to continue",
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
                        builder: (ctx, loading, child1) {
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
                                : child1,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(RouteMapper.reset),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppConstants.kFontFamily,
                                ),
                              ),
                              child: const Text("Forgot Password?"),
                            ),
                            OutlinedButton(
                              onPressed: _onLogin,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppConstants.kFontFamily,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                      ),
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
                            "Don\'t have an account?",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(RouteMapper.create),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: AppConstants.kFontFamily,
                              ),
                            ),
                            child: const Text("Create"),
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

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      context
          .read<AuthBloc>()
          .add(LoginUser(email: _email, password: _password));
    }
  }
}
