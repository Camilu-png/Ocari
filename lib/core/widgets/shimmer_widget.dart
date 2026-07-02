import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:ocari/core/theme/app_theme.dart';

class SongCardShimmer extends StatelessWidget {
  final int itemCount;

  const SongCardShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseColor =
        isDark ? const Color(0xFF252545) : const Color(0xFFE0DCD3);
    final Color highlightColor =
        isDark ? const Color(0xFF303060) : const Color(0xFFF5F1E8);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            children: List.generate(
              itemCount,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ShimmerSongCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerSongCard extends StatelessWidget {
  const _ShimmerSongCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: const Row(
        children: [
          _ShimmerCircle(size: 32),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerLine(
                  widthRatio: 0.7,
                  height: 14,
                  borderRadius: 7,
                ),
                SizedBox(height: AppSpacing.xs),
                _ShimmerLine(
                  widthRatio: 0.4,
                  height: 12,
                  borderRadius: 6,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          _ShimmerLine(
            widthRatio: null,
            width: 40,
            height: 20,
            borderRadius: 100,
          ),
          SizedBox(width: AppSpacing.sm),
          _ShimmerLine(
            widthRatio: null,
            width: 30,
            height: 12,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;

  const _ShimmerCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final double? widthRatio;
  final double? width;
  final double height;
  final double borderRadius;

  const _ShimmerLine({
    this.widthRatio,
    this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ??
          (widthRatio != null
              ? MediaQuery.of(context).size.width * widthRatio!
              : null),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
