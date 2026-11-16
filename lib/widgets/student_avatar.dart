import 'package:flutter/material.dart';
import '../ui_ux/app_colors.dart';

class StudentAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const StudentAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.blueTint,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: textColor ?? AppColors.navy,
          fontSize: size * 0.30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
