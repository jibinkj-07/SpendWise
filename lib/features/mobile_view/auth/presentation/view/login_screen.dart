import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/route/route_mapper.dart';
import 'package:my_budget/core/util/mixin/validation_mixin.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/util/auth_helper.dart';
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
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
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
                          "Login to continue",
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
                      AuthHelper.formTitle(title: "Password"),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isObscure,
                        builder: (ctx, obscure, Widget? child) {
                          return AuthTextField(
                            textFieldKey: "password",
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
                              onPressed: _onLogin,
                              loading: loading,
                              loadingLabel: "Logging",
                              child: const Text("Login"),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteMapper.create),
                    child: const Text("Register"),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteMapper.reset),
                    child: const Text("Forgot Password?"),
                  ),
                ],
              )
            ],
          ),
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
