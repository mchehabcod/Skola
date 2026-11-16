import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../widgets/skola_buttons.dart';
import '../../widgets/skola_card.dart';

class TeacherProfileScreen extends StatefulWidget {
  final SkolaController controller;

  const TeacherProfileScreen({super.key, required this.controller});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final presentCount =
        c.students.where((s) => s.attendance == AttendanceStatus.present).length;
    final absentCount =
        c.students.where((s) => s.attendance == AttendanceStatus.absent).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                'SA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TEACHER ACCOUNT',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Mrs. Sara Alvarez',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Grade 2B · Room 104',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          'ATTENDANCE TODAY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        SkolaCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('${c.students.length}', 'Total', AppColors.navy),
              _stat('$presentCount', 'Present', AppColors.green),
              _stat('$absentCount', 'Absent', AppColors.red),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'NOTIFICATION SETTINGS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        SkolaCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: c.teacherSoundAlerts,
                activeTrackColor: AppColors.green,
                title: const Text(
                  'Arrival chime',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Play sound when a parent parks at the gate',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                onChanged: (v) => setState(() => c.teacherSoundAlerts = v),
              ),
              const Divider(height: 1, color: AppColors.border),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: c.teacherVibrationAlerts,
                activeTrackColor: AppColors.green,
                title: const Text(
                  'Vibration alert',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Vibrate on guardian PIN arrivals',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                onChanged: (v) => setState(() => c.teacherVibrationAlerts = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SkolaSecondaryButton(
          label: 'Sign out',
          foregroundColor: AppColors.red,
          onPressed: c.signOut,
        ),
      ],
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
