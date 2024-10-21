import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/config/route/route_mapper.dart';
import '../../../../../core/util/mixin/validation_mixin.dart';
import '../../../../../core/util/widgets/loading_button.dart';
import '../bloc/auth_bloc.dart';
import '../util/auth_helper.dart';
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
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (ctx, state) {
            // Updating loading variable
            _loading.value = state.authStatus == AuthStatus.creating;

            // Routing user to mobile home screen
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
                          "Create an account",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AuthHelper.formTitle(title: "Name"),
                      AuthTextField(
                        textFieldKey: "name",
                        inputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        validator: validateUsername,
                        onSaved: (value) => _name = value.toString().trim(),
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
                              onPressed: _onCreate,
                              loading: loading,
                              loadingLabel: "Creating",
                              child: const Text("Create"),
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
                  const Text("Already have an account?"),
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
