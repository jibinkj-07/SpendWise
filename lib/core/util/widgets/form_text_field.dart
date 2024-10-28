import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final bool numberOnly;
  final bool? readOnly;
  final bool? enabled;
  final Widget? icon;
  final String? hintText;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
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

  const FormTextField({
    super.key,
    required this.textFieldKey,
    this.isObscure = false,
    this.icon,
    this.maxLines,
    this.hintText,
    this.numberOnly = false,
    required this.inputAction,
    this.validator,
    this.onSaved,
    this.suffixIcon,
    this.inputType,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.readOnly,
    this.minLines,
    this.onTap,
    this.enabled,
    this.maxLength,
    this.style,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style ?? const TextStyle(fontWeight: FontWeight.w500),
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
      inputFormatters: numberOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*'), // Allow digits and optional decimal
              ),
            ]
          : null,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        counter: const SizedBox(),
        prefix: icon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        contentPadding: const EdgeInsets.all(0.0),
        hintStyle: hintStyle ?? const TextStyle(color: Colors.black38),
        border: InputBorder.none,
      ),
    );
  }
}
