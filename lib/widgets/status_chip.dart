import 'package:flutter/material.dart';
import '../ui_ux/app_colors.dart';

enum ChipTone { success, warning, danger, info, neutral }

class StatusChip extends StatelessWidget {
  final String label;
  final ChipTone tone;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData defaultIcon) = switch (tone) {
      ChipTone.success => (
          AppColors.successText,
          AppColors.greenTint,
          Icons.check_circle_outline_rounded,
        ),
      ChipTone.warning => (
          AppColors.warningText,
          AppColors.amberTint,
          Icons.schedule_rounded,
        ),
      ChipTone.danger => (
          AppColors.dangerText,
          AppColors.redTint,
          Icons.cancel_outlined,
        ),
      ChipTone.info => (
          AppColors.blue,
          AppColors.blueSoft,
          Icons.info_outline_rounded,
        ),
      ChipTone.neutral => (
          AppColors.textSecondary,
          AppColors.background,
          Icons.circle_outlined,
        ),
    };

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? defaultIcon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
