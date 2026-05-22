import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OcariTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const OcariTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
  });

  @override
  State<OcariTextField> createState() => _OcariTextFieldState();
}

class _OcariTextFieldState extends State<OcariTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.label(colors.onBgLight),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText && _isObscured,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: AppTextStyles.body(colors.onBgLight),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusLg,
              borderSide: BorderSide(
                color: widget.errorText != null ? colors.error : colors.textSecondary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusLg,
              borderSide: BorderSide(
                color: widget.errorText != null ? colors.error : colors.textSecondary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusLg,
              borderSide: BorderSide(color: colors.accent),
            ),
            errorText: widget.errorText,
            errorStyle: AppTextStyles.caption(colors.error),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: colors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _isObscured = !_isObscured);
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}