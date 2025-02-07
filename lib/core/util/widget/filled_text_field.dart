import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_config.dart';

class FilledTextField extends StatelessWidget {
  final String textFieldKey;
  final bool isObscure;
  final bool? readOnly;
  final bool? enabled;
  final bool numberOnly;
  final Widget? icon;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
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
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const FilledTextField({
    super.key,
    required this.textFieldKey,
    this.isObscure = false,
    this.numberOnly = false,
    this.icon,
    this.maxLines = 1,
    this.labelText,
    this.hintText,
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
    this.fillColor,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      key: ValueKey(key),
      enabled: enabled,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly ?? false,
      obscureText: isObscure,
      textInputAction: inputAction,
      cursorColor: AppConfig.primaryColor,
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
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white,
        counter: const SizedBox(),
        // hiding counter values under the text field
        prefixIcon: icon,
        prefixIconColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.focused)) {
              return AppConfig.primaryColor;
            }
            return Colors.grey;
          },
        ),
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        floatingLabelStyle: TextStyle(color: AppConfig.primaryColor),
        labelStyle: const TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.all(15.0),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: .1, color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: .15, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: .5, color: AppConfig.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: .15, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
    );
  }
}
