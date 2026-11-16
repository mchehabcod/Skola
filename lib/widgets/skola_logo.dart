import 'package:flutter/material.dart';
import '../ui_ux/app_colors.dart';
import '../ui_ux/app_theme.dart';

class SkolaLogo extends StatelessWidget {
  final bool compact;
  final bool inverted;

  const SkolaLogo({
    super.key,
    this.compact = false,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 44.0 : 92.0;
    final radius = compact ? 13.0 : 24.0;
    final iconSize = compact ? 22.0 : 44.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: inverted ? AppColors.surface : AppColors.navy,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: compact ? null : AppTheme.softShadow,
      ),
      child: Icon(
        Icons.school_rounded,
        size: iconSize,
        color: inverted ? AppColors.navy : AppColors.surface,
      ),
    );
  }
}
