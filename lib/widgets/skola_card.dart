import 'package:flutter/material.dart';
import '../ui_ux/app_colors.dart';
import '../ui_ux/app_theme.dart';

class SkolaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderSide? border;

  const SkolaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: border != null ? Border.fromBorderSide(border!) : null,
        boxShadow: AppTheme.softShadow,
      ),
      child: child,
    );
  }
}
