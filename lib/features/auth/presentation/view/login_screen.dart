import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spend_wise/core/config/route/app_routes.dart';
import 'package:spend_wise/core/util/helper/asset_mapper.dart';
import 'package:spend_wise/core/util/mixin/validation_mixin.dart';
import 'package:spend_wise/core/util/widget/custom_snackbar.dart';
import 'package:spend_wise/core/util/widget/outlined_text_field.dart';
import 'package:spend_wise/features/auth/presentation/widget/auth_bg.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 15:11:43

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  String _email = "";
  String _password = "";
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _isVisible = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    _loading.dispose();
    _isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBg(
      formKey: _formKey,
      title: "Log into your Account",
      children: [
        OutlinedTextField(
          textFieldKey: "email",
          hintText: "Email",
          inputAction: TextInputAction.next,
          inputType: TextInputType.emailAddress,
          validator: validateEmail,
          onSaved: (data) => _email = data.toString().trim(),
        ),
        const SizedBox(height: 10.0),
        ValueListenableBuilder(
            valueListenable: _isVisible,
            builder: (ctx, isVisible, _) {
              return OutlinedTextField(
                textFieldKey: "password",
                hintText: "Password",
                isObscure: !isVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _isVisible.value = !_isVisible.value;
                  },
                ),
                inputAction: TextInputAction.done,
                validator: validatePassword,
                onSaved: (data) => _password = data.toString().trim(),
              );
            }),
        const SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              CustomSnackBar.showInfoSnackBar(context, "unable to delete this becausen");
            },
            child: Text("Login"),
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteName.passwordReset),
          child: Text("Forgot Password?"),
        ),
        Divider(
          thickness: .5,
          color: Colors.grey,
        ),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(
              AssetMapper.googleSVG,
              height: 20.0,
              width: 20.0,
            ),
            label: Text("Continue with Google"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don\'t have an account?"),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteName.createAccount),
              child: Text("Create"),
            ),
          ],
        ),
      ],
    );
  }
}
