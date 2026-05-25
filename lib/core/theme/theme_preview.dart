import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemePreview extends StatelessWidget {
  final bool collapsed;

  const ThemePreview({super.key, this.collapsed = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: collapsed ? _buildCollapsed(context, colors) : _buildExpanded(context, colors),
    );
  }

  Widget _buildCollapsed(BuildContext context, AppColors colors) {
    return GestureDetector(
      onTap: () => _showDialog(context, colors),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.palette, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('ThemePreview (dev only)', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorSwatch(label: 'primary', color: colors.primary),
            _ColorSwatch(label: 'accent', color: colors.accent),
            _ColorSwatch(label: 'bgDark', color: colors.bgDark),
            _ColorSwatch(label: 'bgLight', color: colors.bgLight),
            _ColorSwatch(label: 'surface', color: colors.surface),
          ],
        ),
        const SizedBox(height: 12),
        Text('Dark mode', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorSwatch(label: 'primary', color: AppColors.dark.primary),
            _ColorSwatch(label: 'accent', color: AppColors.dark.accent),
            _ColorSwatch(label: 'bgDark', color: AppColors.dark.bgDark),
            _ColorSwatch(label: 'surface', color: AppColors.dark.surface),
          ],
        ),
        const SizedBox(height: 12),
        Text('Text styles', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            Text('displayLarge', style: Theme.of(context).textTheme.displayLarge),
            Text('headline', style: Theme.of(context).textTheme.headlineMedium),
            Text('body', style: Theme.of(context).textTheme.bodyMedium),
            Text('label', style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ThemePreview'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Light Colors', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._colorEntries(colors),
              const SizedBox(height: 16),
              Text('Dark Colors', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._colorEntries(AppColors.dark),
              const SizedBox(height: 16),
              Text('Spacing', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildSpacingGrid(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<Widget> _colorEntries(AppColors colors) {
    return [
      _ColorEntry('primary', colors.primary),
      _ColorEntry('accent', colors.accent),
      _ColorEntry('bgDark', colors.bgDark),
      _ColorEntry('bgLight', colors.bgLight),
      _ColorEntry('surface', colors.surface),
      _ColorEntry('textSecondary', colors.textSecondary),
    ];
  }

  Widget _buildSpacingGrid() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SpacingRow('xs', AppSpacing.xs),
        _SpacingRow('sm', AppSpacing.sm),
        _SpacingRow('md', AppSpacing.md),
        _SpacingRow('lg', AppSpacing.lg),
        _SpacingRow('xl', AppSpacing.xl),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatch({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _ColorEntry extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorEntry(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black26),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          Text(
            '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _SpacingRow extends StatelessWidget {
  final String label;
  final double size;

  const _SpacingRow(this.label, this.size);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: size, height: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('$label = ${size}px', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}