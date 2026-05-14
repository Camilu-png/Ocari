import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color accentColor;
  final Color onAccentColor;
  final Color bgDark;
  final Color onBgDark;
  final Color bgLight;
  final Color onBgLight;
  final Color surfaceDark;
  final Color surfaceLight;
  final Color error;
  final Color onError;

  const AppColors({
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.accentColor,
    required this.onAccentColor,
    required this.bgDark,
    required this.onBgDark,
    required this.bgLight,
    required this.onBgLight,
    required this.surfaceDark,
    required this.surfaceLight,
    required this.error,
    required this.onError,
  });

  static AppColors get light => const AppColors(
    primaryColor: Color(0xFF2C2C2A),
    onPrimaryColor: Color(0xFFF1EFE8),
    accentColor: Color(0xFF7F77DD),
    onAccentColor: Color(0xFFFFFFFF),
    bgDark: Color(0xFF0D0D1A),
    onBgDark: Color(0xFFF1EFE8),
    bgLight: Color(0xFFF1EFE8),
    onBgLight: Color(0xFF2C2C2A),
    surfaceDark: Color(0xFF1A1A2E),
    surfaceLight: Color(0xFFFFFFFF),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
  );

  static AppColors get dark => const AppColors(
    primaryColor: Color(0xFFF1EFE8),
    onPrimaryColor: Color(0xFF2C2C2A),
    accentColor: Color(0xFF7F77DD),
    onAccentColor: Color(0xFFFFFFFF),
    bgDark: Color(0xFF0D0D1A),
    onBgDark: Color(0xFFF1EFE8),
    bgLight: Color(0xFFF1EFE8),
    onBgLight: Color(0xFF2C2C2A),
    surfaceDark: Color(0xFF1A1A2E),
    surfaceLight: Color(0xFF1A1A2E),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
  );

  @override
  AppColors copyWith({
    Color? primaryColor,
    Color? onPrimaryColor,
    Color? accentColor,
    Color? onAccentColor,
    Color? bgDark,
    Color? onBgDark,
    Color? bgLight,
    Color? onBgLight,
    Color? surfaceDark,
    Color? surfaceLight,
    Color? error,
    Color? onError,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      accentColor: accentColor ?? this.accentColor,
      onAccentColor: onAccentColor ?? this.onAccentColor,
      bgDark: bgDark ?? this.bgDark,
      onBgDark: onBgDark ?? this.onBgDark,
      bgLight: bgLight ?? this.bgLight,
      onBgLight: onBgLight ?? this.onBgLight,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      error: error ?? this.error,
      onError: onError ?? this.onError,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      onPrimaryColor: Color.lerp(onPrimaryColor, other.onPrimaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      onAccentColor: Color.lerp(onAccentColor, other.onAccentColor, t)!,
      bgDark: Color.lerp(bgDark, other.bgDark, t)!,
      onBgDark: Color.lerp(onBgDark, other.onBgDark, t)!,
      bgLight: Color.lerp(bgLight, other.bgLight, t)!,
      onBgLight: Color.lerp(onBgLight, other.onBgLight, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
    );
  }
}

class AppTextStyles {
  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets paddingXs =
      EdgeInsets.all(xs);
  static const EdgeInsets paddingSm =
      EdgeInsets.all(sm);
  static const EdgeInsets paddingMd =
      EdgeInsets.all(md);
  static const EdgeInsets paddingLg =
      EdgeInsets.all(lg);
  static const EdgeInsets paddingXl =
      EdgeInsets.all(xl);

  static const EdgeInsets horizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets verticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets horizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets verticalLg =
      EdgeInsets.symmetric(vertical: lg);
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderRadiusXxl =
      BorderRadius.all(Radius.circular(xxl));
}

extension AppThemeExtension on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

class AppTheme {
  static ThemeData get lightTheme {
    final colors = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primaryColor,
        onPrimary: colors.onPrimaryColor,
        secondary: colors.accentColor,
        onSecondary: colors.onAccentColor,
        surface: colors.bgLight,
        onSurface: colors.onBgLight,
        error: colors.error,
        onError: colors.onError,
      ),
      scaffoldBackgroundColor: colors.bgLight,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgLight,
        foregroundColor: colors.onBgLight,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: colors.onPrimaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryColor,
          side: BorderSide(color: colors.primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceLight,
        elevation: 0,
shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
      ),
      iconTheme: IconThemeData(
        color: colors.primaryColor,
        size: 24,
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
        primary: colors.accentColor,
        onPrimary: colors.onAccentColor,
        secondary: colors.accentColor,
        onSecondary: colors.onAccentColor,
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
          backgroundColor: colors.accentColor,
          foregroundColor: colors.onAccentColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.accentColor,
          side: BorderSide(color: colors.accentColor),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceDark,
        elevation: 0,
shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
      ),
      iconTheme: IconThemeData(
        color: colors.onBgDark,
        size: 24,
      ),
      extensions: [AppColors.dark],
    );
  }
}
