import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/widgets/song_card.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

const _iconSizeLg = 48.0;

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  ConsumerState<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends ConsumerState<SongsScreen> {
  final _searchController = TextEditingController();
  Difficulty? _difficultyFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Song> _filteredSongs(List<Song> songs) {
    var result = songs;
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      result = result.where((s) {
        return s.title.toLowerCase().contains(lowerQuery) ||
            s.artist.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    if (_difficultyFilter != null) {
      result =
          result.where((s) => s.difficulty == _difficultyFilter).toList();
    }
    return result;
  }

  void _showPremiumComingSoon() {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: _iconSizeLg, color: colors.accent),
            const SizedBox(height: AppSpacing.md),
            Text('Próximamente', style: context.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Esta canción estará disponible pronto, la desarrolladora está a un paso de la locura.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(songsProvider);
    final colors = context.colors;

    return OcariScaffold(
      title: 'Canciones',
      showBackButton: false,
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: _iconSizeLg,
                  color: colors.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Error al cargar canciones',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.onBgLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$err',
                  style: AppTextStyles.caption(colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(songsProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (songs) {
          final filtered = _filteredSongs(songs);
          final hasFilters = _searchController.text.isNotEmpty ||
              _difficultyFilter != null;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Text(
                      'Canciones',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: colors.onBgLight,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${songs.length} ${songs.length == 1 ? 'canción' : 'canciones'}',
                      style: AppTextStyles.body(colors.textSecondary),
                    ),
                  ],
                ),
              ),
              _SearchField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              _DifficultyFilter(
                selected: _difficultyFilter,
                onChanged: (v) => setState(() => _difficultyFilter = v),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasFilters
                                  ? Icons.search_off_rounded
                                  : Icons.music_note_rounded,
                              size: _iconSizeLg,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              hasFilters
                                  ? 'No se encontraron canciones'
                                  : 'No hay canciones disponibles',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(songsProvider.notifier).refresh(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.md,
                            right: AppSpacing.md,
                            bottom: AppSpacing.md,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final song = filtered[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: SongCard(
                                title: song.title,
                                artist: song.artist,
                                difficulty: song.difficulty,
                                durationSeconds: song.durationSeconds,
                                isLocked: song.isPremium,
                                onTap: () {
                                  if (song.isPremium) {
                                    _showPremiumComingSoon();
                                  } else {
                                    context.push('/player/${song.id}');
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.body(colors.onBgLight),
        decoration: InputDecoration(
          hintText: 'Buscar canciones...',
          hintStyle: AppTextStyles.body(colors.textSecondary),
          prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: colors.surface,
          border: const OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusLg,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusLg,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusLg,
            borderSide: BorderSide(color: colors.accent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

class _DifficultyFilter extends StatelessWidget {
  final Difficulty? selected;
  final ValueChanged<Difficulty?> onChanged;

  const _DifficultyFilter({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final chipData = <({
      Difficulty? value,
      String label,
      Color selectedBg,
      Color selectedFg,
    })>[
      (
        value: null,
        label: 'Todas',
        selectedBg: colors.accent.withValues(alpha: 0.2),
        selectedFg: colors.accent,
      ),
      (
        value: Difficulty.easy,
        label: 'Fácil',
        selectedBg: colors.diffEasyBg,
        selectedFg: colors.diffEasyText,
      ),
      (
        value: Difficulty.medium,
        label: 'Medio',
        selectedBg: colors.diffMediumBg,
        selectedFg: colors.diffMediumText,
      ),
      (
        value: Difficulty.hard,
        label: 'Difícil',
        selectedBg: colors.diffHardBg,
        selectedFg: colors.diffHardText,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chipData.map((c) {
            final isSelected = selected == c.value;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(c.label),
                selected: isSelected,
                selectedColor: c.selectedBg,
                backgroundColor: colors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? c.selectedFg : colors.onBgLight,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                onSelected: (_) => onChanged(c.value),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
