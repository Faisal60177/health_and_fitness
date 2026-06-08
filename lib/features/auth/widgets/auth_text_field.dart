import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete; // NEW

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText      = false,
    this.keyboardType     = TextInputType.text,
    this.errorText,
    this.suffixIcon,
    this.validator,
    this.onEditingComplete, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller:         controller,
          obscureText:        obscureText,
          keyboardType:       keyboardType,
          validator:          validator,
          onEditingComplete:  onEditingComplete, // NEW
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText:   hint,
            hintStyle:  const TextStyle(color: AppColors.textHint),
            suffixIcon: suffixIcon,
            errorText:  errorText,
            filled:     true,
            fillColor:  AppColors.surfaceMuted,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}



