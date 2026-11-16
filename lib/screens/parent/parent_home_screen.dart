import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/demo_simulator_sheet.dart';
import '../../widgets/pickup_status_card.dart';
import '../../widgets/skola_card.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/student_avatar.dart';

class ParentHomeScreen extends StatelessWidget {
  final SkolaController controller;
  final VoidCallback onOpenGuardianPass;
  final VoidCallback onOpenNotes;

  const ParentHomeScreen({
    super.key,
    required this.controller,
    required this.onOpenGuardianPass,
    required this.onOpenNotes,
  });

  @override
  Widget build(BuildContext context) {
    final leo = controller.activeStudent;
    final (String attLabel, ChipTone attTone) = switch (leo.attendance) {
      AttendanceStatus.present => ('Present', ChipTone.success),
      AttendanceStatus.earlyLeave => (
          'Early · ${leo.earlyPickupTime ?? "1:30 PM"}',
          ChipTone.warning,
        ),
      AttendanceStatus.absent => ('Absent', ChipTone.danger),
    };

    return Stack(
      children: [
        Column(
          children: [
            // Header
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good afternoon, David',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Monday, Nov 16',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.navy,
                        ),
                      ),
                      Positioned(
                        right: 11,
                        top: 10,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
                children: [
                  SkolaCard(
                    child: Row(
                      children: [
                        StudentAvatar(initials: leo.initials, size: 60),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    leo.fullName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  StatusChip(label: attLabel, tone: attTone),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Grade 2B · Room 104',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Text(
                                'Teacher: Mrs. Sara Alvarez',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  PickupStatusCard(
                    state: controller.parentHeroState,
                    distanceMeters: controller.distanceMeters,
                    secondsRemaining: controller.dwellSecondsRemaining,
                    progress: controller.dwellProgress,
                    proximityMode: controller.proximityMode,
                    accelerometerDelta: controller.accelerometerDelta,
                    releaseTime: leo.releaseTime,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionTile(
                          icon: Icons.shield_outlined,
                          iconColor: AppColors.teal,
                          iconBg: AppColors.tealTint,
                          title: 'Guardian Pass',
                          subtitle: controller.guardianPass != null
                              ? 'PIN ${controller.guardianPass!.pin} active'
                              : 'Authorized pickup',
                          onTap: onOpenGuardianPass,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickActionTile(
                          icon: Icons.note_alt_outlined,
                          iconColor: AppColors.blue,
                          iconBg: AppColors.blueTint,
                          title: 'Absence / Early pickup',
                          subtitle: 'Send a note',
                          onTap: onOpenNotes,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SkolaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HOW IT WORKS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _howStep('1', 'Get within 50 m school zone'),
                        const SizedBox(height: 10),
                        _howStep(
                          '2',
                          'Stay 25 s or park (accel ≤ 0.30 m/s²)',
                        ),
                        const SizedBox(height: 10),
                        _howStep('3', 'Teacher releases Leo at the gate'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Floating Simulate Button
        Positioned(
          right: 14,
          bottom: 14,
          child: ElevatedButton.icon(
            onPressed: () => DemoSimulatorSheet.show(context, controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            icon: const Icon(Icons.tune_rounded, size: 16),
            label: const Text(
              'Simulate',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _howStep(String numText, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.blueTint,
            shape: BoxShape.circle,
          ),
          child: Text(
            numText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
