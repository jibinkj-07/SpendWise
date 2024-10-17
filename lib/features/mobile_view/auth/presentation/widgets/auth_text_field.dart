import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final String hintText;
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
    required this.hintText,
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
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      onSaved: onSaved,
      textCapitalization: textCapitalization,
      textInputAction: inputAction,
      keyboardType: inputType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
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
