import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextEditingController controller;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.obscureText = false,
    this.onChanged, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: colors.secondary),
      borderRadius: BorderRadius.circular(40),
    );

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.deny(RegExp(r',')),
        FilteringTextInputFormatter.deny(RegExp(r'-')),
      ],

      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        isDense: true,
        label: label != null ? Text(label!) : null,
        hintText: hint,
        focusColor: colors.primary,
      ),
    );
  }
}
