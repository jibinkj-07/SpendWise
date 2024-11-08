import 'package:flutter/material.dart';
import 'package:spend_wise/core/util/mixin/validation_mixin.dart';

import '../../../../core/util/widget/outlined_text_field.dart';
import '../widget/auth_bg.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 16:45:07

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with ValidationMixin {
  String _firstName = "";
  String _lastName = "";
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: AuthBg(
          title: "Create your Account",
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedTextField(
                    textFieldKey: "first",
                    hintText: "First Name",
                    maxLength: 30,
                    inputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: validateUsername,
                    onSaved: (data) => _firstName = data.toString().trim(),
                  ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: OutlinedTextField(
                    textFieldKey: "last",
                    hintText: "Last Name",
                    maxLength: 30,
                    inputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: validateUsername,
                    onSaved: (data) => _lastName = data.toString().trim(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            OutlinedTextField(
              textFieldKey: "email",
              hintText: "Email",
              maxLength: 50,
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
                onPressed: () {},
                child: Text("Create"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
