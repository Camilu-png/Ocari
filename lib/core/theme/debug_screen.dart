import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';
import 'package:ocari/core/widgets/difficulty_badge.dart';
import 'package:ocari/core/widgets/ocari_button.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/widgets/ocari_text_field.dart';
import 'package:ocari/core/widgets/song_card.dart';

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
            Text(
              'Theme Tokens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildColorSection(context, 'Current Theme', colors),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Light Theme', AppColors.light),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Dark Theme', AppColors.dark),
            const SizedBox(height: 24),
            _buildSpacingSection(context),
            const SizedBox(height: 24),
            _buildButtonsSection(context),
            const SizedBox(height: 24),
            _buildDifficultySection(context, colors),
            const SizedBox(height: 24),
            const _TextFieldsPreview(),
            const SizedBox(height: 24),
            _buildScaffoldSection(context),
            const SizedBox(height: 24),
            _buildSongCardsSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(
    BuildContext context,
    String title,
    AppColors colors,
  ) {
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
            _ColorChip('onPrimary', colors.onPrimary),
            _ColorChip('accent', colors.accent),
            _ColorChip('onAccent', colors.onAccent),
            _ColorChip('bgDark', colors.bgDark),
            _ColorChip('onBgDark', colors.onBgDark),
            _ColorChip('bgLight', colors.bgLight),
            _ColorChip('onBgLight', colors.onBgLight),
            _ColorChip('surface', colors.surface),
            _ColorChip('textSecondary', colors.textSecondary),
            _ColorChip('error', colors.error),
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
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: e.$2,
                  height: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${e.$1} = ${e.$2}px',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariButton(
          label: 'Default Button',
          onPressed: () {},
        ),
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
        OcariButton(
          label: 'Not Full Width',
          isFullWidth: false,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Colors',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('easyBg', colors.diffEasyBg),
            _ColorChip('easyText', colors.diffEasyText),
            _ColorChip('mediumBg', colors.diffMediumBg),
            _ColorChip('mediumText', colors.diffMediumText),
            _ColorChip('hardBg', colors.diffHardBg),
            _ColorChip('hardText', colors.diffHardText),
          ],
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            DifficultyBadge(difficulty: 'easy'),
            DifficultyBadge(difficulty: 'medium'),
            DifficultyBadge(difficulty: 'hard'),
          ],
        ),
      ],
    );
  }

  Widget _buildScaffoldSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Scaffold', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariButton(
          label: 'Open Scaffold Preview',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const _ScaffoldPreviewRoute(),
              ),
            );
          },
          isFullWidth: false,
        ),
      ],
    );
  }

  Widget _buildSongCardsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Song Cards'),
        SizedBox(height: 16),
        SongCard(
          title: 'Twinkle Twinkle',
          artist: 'Mozart',
          difficulty: 'easy',
          durationSeconds: 120,
          onTap: () {},
        ),
        SizedBox(height: 8),
        SongCard(
          title: 'Moonlight Sonata',
          artist: 'Beethoven',
          difficulty: 'medium',
          durationSeconds: 420,
          onTap: () {},
        ),
        SizedBox(height: 8),
        SongCard(
          title: 'Flight of the Bumblebee',
          artist: 'Rimsky-Korsakov',
          difficulty: 'hard',
          durationSeconds: 90,
          onTap: () {},
        ),
        SizedBox(height: 8),
        SongCard(
          title: 'Locked Song',
          artist: 'Unknown',
          difficulty: 'hard',
          durationSeconds: 180,
          isLocked: true,
          onTap: () {},
        ),
      ],
    );
  }
}

class _ScaffoldPreviewRoute extends StatelessWidget {
  const _ScaffoldPreviewRoute();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OcariScaffold(
      title: 'Scaffold Preview',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OcariScaffold in action',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'The AppBar uses AppColors.primary as background '
              'with AppTextStyles.heading for the title.',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Tap back to return to debug screen.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldsPreview extends StatefulWidget {
  const _TextFieldsPreview();

  @override
  State<_TextFieldsPreview> createState() => _TextFieldsPreviewState();
}

class _TextFieldsPreviewState extends State<_TextFieldsPreview> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _errorController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text Fields', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Password',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'With Error',
          controller: _errorController,
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
