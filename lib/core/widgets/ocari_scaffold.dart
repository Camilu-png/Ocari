import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ocari/core/theme/app_theme.dart';

class OcariScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  final Color? backgroundColor;

  const OcariScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colors.accent,
          foregroundColor: colors.onAccent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: colors.onAccent, size: 20),
                  onPressed: () => context.pop(),
                )
              : null,
          title: title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: colors.onAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                )
              : null,
          actions: actions,
          bottom: isDark
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    color: colors.accent.withValues(alpha: 0.6),
                  ),
                ),
        ),
        body: SafeArea(child: body),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
