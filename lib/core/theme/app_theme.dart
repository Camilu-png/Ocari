import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color onAccent;
  final Color bgDark;
  final Color onBgDark;
  final Color bgLight;
  final Color onBgLight;
  final Color surface;
  final Color textSecondary;
  final Color error;
  final Color onError;

  final Color diffEasyBg;
  final Color diffEasyText;
  final Color diffMediumBg;
  final Color diffMediumText;
  final Color diffHardBg;
  final Color diffHardText;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.bgDark,
    required this.onBgDark,
    required this.bgLight,
    required this.onBgLight,
    required this.surface,
    required this.textSecondary,
    required this.error,
    required this.onError,
    required this.diffEasyBg,
    required this.diffEasyText,
    required this.diffMediumBg,
    required this.diffMediumText,
    required this.diffHardBg,
    required this.diffHardText,
  });

  static const AppColors light = AppColors(
    primary: Color(0xFF2C2C2A),
    onPrimary: Color(0xFFF1EFE8),
    accent: Color(0xFF7F77DD),
    onAccent: Color(0xFFFFFFFF),
    bgDark: Color(0xFF0D0D1A),
    onBgDark: Color(0xFFF1EFE8),
    bgLight: Color(0xFFFAF7F0),
    onBgLight: Color(0xFF2C2C2A),
    surface: Color(0xFFF3EFE6),
    textSecondary: Color(0xFF888780),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    diffEasyBg: Color(0xFF4CAF50),
    diffEasyText: Color(0xFFFFFFFF),
    diffMediumBg: Color(0xFFFF9800),
    diffMediumText: Color(0xFFFFFFFF),
    diffHardBg: Color(0xFFF44336),
    diffHardText: Color(0xFFFFFFFF),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFFF1EFE8),
    onPrimary: Color(0xFF2C2C2A),
    accent: Color(0xFF7F77DD),
    onAccent: Color(0xFFFFFFFF),
    bgDark: Color(0xFF0D0D1A),
    onBgDark: Color(0xFFF1EFE8),
    bgLight: Color(0xFF2C2C2A),
    onBgLight: Color(0xFFF1EFE8),
    surface: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF888780),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    diffEasyBg: Color(0xFF388E3C),
    diffEasyText: Color(0xFFFFFFFF),
    diffMediumBg: Color(0xFFF57C00),
    diffMediumText: Color(0xFFFFFFFF),
    diffHardBg: Color(0xFFD32F2F),
    diffHardText: Color(0xFFFFFFFF),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? onAccent,
    Color? bgDark,
    Color? onBgDark,
    Color? bgLight,
    Color? onBgLight,
    Color? surface,
    Color? textSecondary,
    Color? error,
    Color? onError,
    Color? diffEasyBg,
    Color? diffEasyText,
    Color? diffMediumBg,
    Color? diffMediumText,
    Color? diffHardBg,
    Color? diffHardText,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      bgDark: bgDark ?? this.bgDark,
      onBgDark: onBgDark ?? this.onBgDark,
      bgLight: bgLight ?? this.bgLight,
      onBgLight: onBgLight ?? this.onBgLight,
      surface: surface ?? this.surface,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      diffEasyBg: diffEasyBg ?? this.diffEasyBg,
      diffEasyText: diffEasyText ?? this.diffEasyText,
      diffMediumBg: diffMediumBg ?? this.diffMediumBg,
      diffMediumText: diffMediumText ?? this.diffMediumText,
      diffHardBg: diffHardBg ?? this.diffHardBg,
      diffHardText: diffHardText ?? this.diffHardText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      bgDark: Color.lerp(bgDark, other.bgDark, t)!,
      onBgDark: Color.lerp(onBgDark, other.onBgDark, t)!,
      bgLight: Color.lerp(bgLight, other.bgLight, t)!,
      onBgLight: Color.lerp(onBgLight, other.onBgLight, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      diffEasyBg: Color.lerp(diffEasyBg, other.diffEasyBg, t)!,
      diffEasyText: Color.lerp(diffEasyText, other.diffEasyText, t)!,
      diffMediumBg: Color.lerp(diffMediumBg, other.diffMediumBg, t)!,
      diffMediumText: Color.lerp(diffMediumText, other.diffMediumText, t)!,
      diffHardBg: Color.lerp(diffHardBg, other.diffHardBg, t)!,
      diffHardText: Color.lerp(diffHardText, other.diffHardText, t)!,
    );
  }
}

class AppTextStyles {
  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          fontFamily: '.SF Pro Text',
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          fontFamily: '.SF Pro Text',
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          fontFamily: '.SF Pro Text',
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          fontFamily: '.SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          fontFamily: '.SF Pro Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          fontFamily: '.SF Pro Display',
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          fontFamily: '.SF Pro Text',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          fontFamily: '.SF Pro Text',
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          fontFamily: '.SF Pro Text',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          fontFamily: '.SF Pro Text',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          fontFamily: '.SF Pro Text',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          fontFamily: '.SF Pro Text',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          fontFamily: '.SF Pro Text',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: '.SF Pro Text',
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: '.SF Pro Text',
        ),
      );

  static TextStyle heading(Color color) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: '.SF Pro Display',
      );

  static TextStyle body(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        fontFamily: '.SF Pro Text',
      );

  static TextStyle caption(Color color) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        fontFamily: '.SF Pro Text',
      );

  static TextStyle label(Color color) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        fontFamily: '.SF Pro Text',
      );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(xl));
}

extension AppThemeExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

class AppTheme {
  static ThemeData get lightTheme {
    final colors = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.accent,
        onPrimary: colors.onAccent,
        secondary: colors.accent,
        onSecondary: colors.onAccent,
        surface: colors.bgLight,
        onSurface: colors.onBgLight,
        error: colors.error,
        onError: colors.onError,
      ),
      scaffoldBackgroundColor: colors.bgLight,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: colors.onBgLight,
        displayColor: colors.onBgLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgLight,
        foregroundColor: colors.onBgLight,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.onAccent,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.accent),
        ),
      ),
      extensions: [AppColors.light],
    );
  }

  static ThemeData get darkTheme {
    final colors = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.accent,
        onPrimary: colors.onAccent,
        secondary: colors.accent,
        onSecondary: colors.onAccent,
        surface: colors.bgDark,
        onSurface: colors.onBgDark,
        error: colors.error,
        onError: colors.onError,
      ),
      scaffoldBackgroundColor: colors.bgDark,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: colors.onBgDark,
        displayColor: colors.onBgDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgDark,
        foregroundColor: colors.onBgDark,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.onAccent,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: colors.accent),
        ),
      ),
      extensions: [AppColors.dark],
    );
  }
}
