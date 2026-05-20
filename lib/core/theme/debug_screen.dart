import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';
import '../widgets/ocari_button.dart';
import '../widgets/ocari_text_field.dart';

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
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme Tokens',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildColorSection(context, 'Light Theme', colors),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Dark Theme', AppColors.dark),
            const SizedBox(height: 24),
            _buildSpacingSection(context),
            const SizedBox(height: 24),
            _buildButtonsSection(context),
            const SizedBox(height: 24),
            _buildDifficultySection(context, colors),
            const SizedBox(height: 24),
            _buildTextFieldsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(
      BuildContext context, String title, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('primary', colors.primary),
            _ColorChip('accent', colors.accent),
            _ColorChip('bgDark', colors.bgDark),
            _ColorChip('onBgDarl', colors.onBgDark),
            _ColorChip('bgLight', colors.bgLight),
            _ColorChip('onBgLight', colors.onBgLight),
            _ColorChip('surface', colors.surface),
            _ColorChip('textSecondary', colors.textSecondary),
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
        ].map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                      width: e.$2,
                      height: 20,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('${e.$1} = ${e.$2}px',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        const OcariButton(label: 'Default Button'),
        const SizedBox(height: 12),
        const OcariButton(
          label: 'Loading Button',
          isLoading: true,
        ),
        const SizedBox(height: 12),
        const OcariButton(
          label: 'Disabled Button',
          onPressed: null,
        ),
        const SizedBox(height: 12),
        const OcariButton(
          label: 'Not Full Width',
          isFullWidth: false,
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Difficulty Colors',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('Easy', colors.diffEasyBg),
            _ColorChip('Medium', colors.diffMediumBg),
            _ColorChip('Hard', colors.diffHardBg),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldsSection(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text Fields', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Password',
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'With Error',
          controller: TextEditingController(),
          errorText: 'This field is required',
        ),
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
