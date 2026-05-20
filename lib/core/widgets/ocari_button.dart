import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OcariButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;

  const OcariButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: colors.onPrimaryColor,
          disabledBackgroundColor: colors.primaryColor.withValues(alpha: 0.5),
          disabledForegroundColor: colors.onPrimaryColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors.onPrimaryColor,
                  ),
                ),
              )
            : Text(
                label,
                style: context.textTheme.labelLarge,
              ),
      ),
    );
  }
}