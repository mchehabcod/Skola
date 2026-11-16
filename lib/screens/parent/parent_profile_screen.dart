import 'package:flutter/material.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../widgets/skola_buttons.dart';
import '../../widgets/skola_card.dart';
import '../../widgets/student_avatar.dart';

class ParentProfileScreen extends StatefulWidget {
  final SkolaController controller;

  const ParentProfileScreen({super.key, required this.controller});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final leo = c.activeStudent;

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
                'DV',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PARENT ACCOUNT',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'David Vance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    c.email,
                    style: const TextStyle(
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
          'CHILDREN',
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
            children: [
              StudentAvatar(initials: leo.initials, size: 48),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leo.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Grade 2B · Room 104 · Mrs. Alvarez',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'VEHICLE',
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blue Honda CR-V',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    leo.vehicleInfo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'NOTIFICATIONS',
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
                value: c.parentNotifyArrival,
                activeTrackColor: AppColors.green,
                title: const Text(
                  'Geofence arrival alerts',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Notify when entering 50 m zone',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                onChanged: (v) => setState(() => c.parentNotifyArrival = v),
              ),
              const Divider(height: 1, color: AppColors.border),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: c.parentNotifyRelease,
                activeTrackColor: AppColors.green,
                title: const Text(
                  'Release confirmation',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Push receipt when teacher releases Leo',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                onChanged: (v) => setState(() => c.parentNotifyRelease = v),
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
}
