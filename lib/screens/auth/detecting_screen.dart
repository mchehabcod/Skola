import 'package:flutter/material.dart';
import '../../ui_ux/app_colors.dart';
import '../../widgets/skola_logo.dart';

class DetectingScreen extends StatelessWidget {
  const DetectingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkolaLogo(),
              SizedBox(height: 28),
              Text(
                'Detecting your account...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Connecting to Al-Noor International School',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
