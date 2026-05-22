import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

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
    final canPop = showBackButton && Navigator.canPop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const appBarBg = Color(0xFF7F77DD);
    const appBarFg = Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarBg,
          foregroundColor: appBarFg,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: appBarFg, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          title: title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    color: appBarFg,
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
                    color: const Color(0xFF6C63D4),
                  ),
                ),
        ),
        body: SafeArea(child: body),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
