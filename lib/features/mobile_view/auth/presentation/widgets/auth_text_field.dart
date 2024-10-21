import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.textFieldKey,
    this.isObscure = false,
    required this.inputAction,
    this.validator,
    this.onSaved,
    this.inputType,
    this.textCapitalization = TextCapitalization.none,
    this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(textFieldKey),
      maxLength: 40,
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      onSaved: onSaved,
      textCapitalization: textCapitalization,
      textInputAction: inputAction,
      keyboardType: inputType,
      decoration: InputDecoration(
        counter: const SizedBox.shrink(),
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(color: Colors.black38),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
