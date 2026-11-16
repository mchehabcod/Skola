import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../widgets/pin_verification_sheet.dart';
import '../../widgets/skola_card.dart';
import '../../widgets/student_avatar.dart';

/// Teacher Afternoon Dismissal screen with 3 tabs per supervisor feedback:
/// 1) Ready & Approaching
/// 2) Dismissed
/// 3) Absent
class TeacherDismissalScreen extends StatefulWidget {
  final SkolaController controller;

  const TeacherDismissalScreen({super.key, required this.controller});

  @override
  State<TeacherDismissalScreen> createState() => _TeacherDismissalScreenState();
}

class _TeacherDismissalScreenState extends State<TeacherDismissalScreen> {
  int _selectedTab = 0; // 0: Ready & Approaching, 1: Dismissed, 2: Absent

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final all = c.students;

    final readyParents = all
        .where(
          (s) =>
              s.attendance != AttendanceStatus.absent &&
              s.pickupStage == ParentPickupStage.ready,
        )
        .toList();

    final approachingParents = all
        .where(
          (s) =>
              s.attendance != AttendanceStatus.absent &&
              (s.pickupStage == ParentPickupStage.approaching ||
                  s.pickupStage == ParentPickupStage.verifying),
        )
        .toList();

    final dismissedList = all
        .where((s) => s.pickupStage == ParentPickupStage.released)
        .toList();

    final absentList =
        all.where((s) => s.attendance == AttendanceStatus.absent).toList();

    final activeCount = readyParents.length + approachingParents.length;

    return Column(
      children: [
        // Header
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Afternoon dismissal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '3:00 – 3:45 PM',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.greenTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: AppColors.green),
                    SizedBox(width: 6),
                    Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3 Tabs (Doctor Feedback #2)
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              _tabItem(0, 'Ready & Approaching', activeCount),
              _tabItem(1, 'Dismissed', dismissedList.length),
              _tabItem(2, 'Absent', absentList.length),
            ],
          ),
        ),

        // Tab Body
        Expanded(
          child: _selectedTab == 0
              ? _buildReadyAndApproaching(
                  readyParents,
                  approachingParents,
                  c,
                )
              : _selectedTab == 1
                  ? _buildDismissed(dismissedList)
                  : _buildAbsent(absentList),
        ),
      ],
    );
  }

  Widget _tabItem(int index, String label, int count) {
    final active = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.blue : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: active ? AppColors.blue : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: active ? AppColors.blueTint : AppColors.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active ? AppColors.blue : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadyAndApproaching(
    List<Student> readyParents,
    List<Student> approachingParents,
    SkolaController c,
  ) {
    if (readyParents.isEmpty && approachingParents.isEmpty) {
      return _emptyState(
        Icons.check_circle_outline_rounded,
        'All clear for now',
        'No parents are parked or approaching the gate yet.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (readyParents.isNotEmpty) ...[
          _sectionTitle('READY AT GATE (PARKED)', readyParents.length, AppColors.green),
          const SizedBox(height: 10),
          ...readyParents.map((s) => _buildReadyCard(s, c)),
          const SizedBox(height: 20),
        ],
        if (approachingParents.isNotEmpty) ...[
          _sectionTitle(
            'APPROACHING / VERIFYING',
            approachingParents.length,
            AppColors.amber,
          ),
          const SizedBox(height: 10),
          ...approachingParents.map(_buildApproachingRow),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildReadyCard(Student s, SkolaController c) {
    final isActiveStudent = s.id == SkolaController.activeStudentId;
    final pass = isActiveStudent ? c.guardianPass : null;
    final locked = pass != null && !pass.isVerified;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SkolaCard(
        border: const BorderSide(color: AppColors.green, width: 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StudentAvatar(initials: s.initials, size: 54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Parent: ${s.parentName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        s.vehicleInfo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.greenTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Parked',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.successText,
                    ),
                  ),
                ),
              ],
            ),

            if (pass != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: locked ? AppColors.amberTint : AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: locked
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFF99F6E4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      locked ? Icons.shield_outlined : Icons.verified_rounded,
                      color: locked ? AppColors.amber : AppColors.teal,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locked
                                ? 'Guardian pickup: PIN required'
                                : 'Guardian verified',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: locked
                                  ? AppColors.warningText
                                  : AppColors.tealDark,
                            ),
                          ),
                          Text(
                            '${pass.guardianName} · ${pass.relationship}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (locked)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          PinVerificationSheet.show(
                            context,
                            guardianName: pass.guardianName,
                            relationship: pass.relationship,
                            correctPin: pass.pin,
                            onVerified: () => c.verifyGuardianPin(pass.pin),
                          );
                        },
                        child: const Text(
                          'Verify PIN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),
            InkWell(
              onTap: locked
                  ? null
                  : () {
                      c.releaseStudent(s.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${s.fullName} released. Parent notified.'),
                          backgroundColor: AppColors.green,
                        ),
                      );
                    },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: locked ? AppColors.background : AppColors.greenTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: locked ? AppColors.inputBorder : AppColors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        locked ? Icons.lock_rounded : Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm handover and release ${s.fullName.split(" ").first}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: locked
                                  ? AppColors.textTertiary
                                  : AppColors.successText,
                            ),
                          ),
                          if (locked)
                            const Text(
                              'Locked until guardian PIN is verified',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.dangerText,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApproachingRow(Student s) {
    final isVerifying = s.pickupStage == ParentPickupStage.verifying;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SkolaCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            StudentAvatar(initials: s.initials, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${s.parentName} (for ${s.fullName})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.approachingDetail ?? 'Inside 50 m zone · moving',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isVerifying && s.verifyingProgress != null) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: s.verifyingProgress!.clamp(0.05, 1.0),
                        minHeight: 5,
                        backgroundColor: AppColors.amberTint,
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isVerifying
                  ? Icons.hourglass_top_rounded
                  : Icons.directions_car_rounded,
              color: isVerifying ? AppColors.amber : AppColors.blue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissed(List<Student> dismissedList) {
    if (dismissedList.isEmpty) {
      return _emptyState(
        Icons.check_circle_outline_rounded,
        'No dismissed students yet',
        'Released students will appear here with handover timestamps.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: dismissedList.length,
      itemBuilder: (context, index) {
        final s = dismissedList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SkolaCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.greenTint,
                  child: Icon(Icons.check_rounded, color: AppColors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Released at ${s.releaseTime ?? "3:07 PM"} by ${s.releasedBy ?? "Mrs. Alvarez"}',
                        style: const TextStyle(
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
        );
      },
    );
  }

  Widget _buildAbsent(List<Student> absentList) {
    if (absentList.isEmpty) {
      return _emptyState(
        Icons.event_available_rounded,
        'Full attendance today',
        'No absent students in Grade 2B.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: absentList.length,
      itemBuilder: (context, index) {
        final s = absentList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SkolaCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                StudentAvatar(
                  initials: s.initials,
                  size: 44,
                  backgroundColor: AppColors.redTint,
                  textColor: AppColors.dangerText,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        s.note ?? "Not included in today's pickup queue",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.redTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Excluded',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dangerText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: AppColors.textTertiary),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
