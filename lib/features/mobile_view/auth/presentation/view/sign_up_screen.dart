import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/helper/asset_mapper.dart';
import '../../../../../core/util/mixin/validation_mixin.dart';
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
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          Image.asset(
            AssetMapper.appIconImage,
            width: size.width * .25,
            height: size.width * .25,
          ),
          const Center(
            child: Text(
              "Create an account",
              style: TextStyle(
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
                    // const Text(
                    //   "Login to continue",
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    // const SizedBox(height: 10.0),
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
                    OutlinedButton(
                      onPressed: _onCreate,
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
                      child: const Text("Create"),
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
    );
  }

  void _onCreate() {
    // log("hey");
    if (_formKey.currentState!.validate()) {
      // log("ere $_email $_password");
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
    }
  }
}
