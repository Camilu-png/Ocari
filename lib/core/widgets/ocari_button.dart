import 'package:flutter/material.dart';
import 'package:ocari/core/theme/app_theme.dart';

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
    final isEffectivelyDisabled = !isLoading && onPressed == null;
    final Color bgColor = isEffectivelyDisabled
        ? colors.accent.withValues(alpha: 0.38)
        : colors.accent;

    final Color fgColor = isEffectivelyDisabled
        ? colors.onAccent.withValues(alpha: 0.6)
        : colors.onAccent;

    return SizedBox(
      key: const Key('ocari_button_sized_box'),
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: FilledButton(
        onPressed: (isLoading || isEffectivelyDisabled) ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor,
          disabledForegroundColor: fgColor,
          shape: const RoundedRectangleBorder(
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
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(color: fgColor),
              ),
      ),
    );
  }
}
