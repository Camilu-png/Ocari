import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme Tokens', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildColorSection(context, 'Light Theme', colors),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Dark Theme', AppColors.dark),
            const SizedBox(height: 24),
            _buildSpacingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(BuildContext context, String title, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('primary', colors.primaryColor),
            _ColorChip('accent', colors.accentColor),
            _ColorChip('bgDark', colors.bgDark),
            _ColorChip('bgLight', colors.bgLight),
            _ColorChip('surface', colors.surfaceDark),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...[
          ('xs', AppSpacing.xs),
          ('sm', AppSpacing.sm),
          ('md', AppSpacing.md),
          ('lg', AppSpacing.lg),
          ('xl', AppSpacing.xl),
          ('xxl', AppSpacing.xxl),
        ].map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(width: e.$2, height: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('${e.$1} = ${e.$2}px', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        )),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}