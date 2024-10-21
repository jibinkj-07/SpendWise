import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_budget/core/constants/app_constants.dart';

class OutlinedTextField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final bool? readOnly;
  final bool? enabled;
  final Widget? icon;
  final String hintText;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLength;

  const OutlinedTextField({
    super.key,
    required this.textFieldKey,
    required this.isObscure,
    this.icon,
    this.maxLines,
    required this.hintText,
    required this.inputAction,
    this.validator,
    this.onSaved,
    this.suffixIcon,
    this.inputType,
    required this.textCapitalization,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.readOnly,
    this.minLines,
    this.onTap,
    this.enabled,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(key),
      enabled: enabled,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly ?? false,
      obscureText: isObscure,
      textInputAction: inputAction,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines,
      minLines: minLines,
      initialValue: initialValue,
      maxLength: maxLength,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // Allows only digits
      ],
      decoration: InputDecoration(
        counter: const SizedBox(),
        // hiding counter values under the text field
        // prefix: icon,
        prefixText: "s",
        suffixIcon: suffixIcon,
        hintText: hintText,
        // labelStyle: const TextStyle(
        //   color: Colors.grey,
        //   fontSize: 14.0,
        // ),

        contentPadding: const EdgeInsets.all(15.0),
        hintStyle: const TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),

        ),
      ),
    );
  }
}
