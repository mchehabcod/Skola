import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../widgets/skola_buttons.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/student_avatar.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final SkolaController controller;

  const TeacherAttendanceScreen({super.key, required this.controller});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  String _query = '';
  AttendanceStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final students = widget.controller.students;
    final presentCount =
        students.where((s) => s.attendance == AttendanceStatus.present).length;
    final earlyCount = students
        .where((s) => s.attendance == AttendanceStatus.earlyLeave)
        .length;
    final absentCount =
        students.where((s) => s.attendance == AttendanceStatus.absent).length;

    final filtered = students.where((s) {
      final matchesQuery =
          s.fullName.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter =
          _filterStatus == null || s.attendance == _filterStatus;
      return matchesQuery && matchesFilter;
    }).toList();

    return Column(
      children: [
        // Header
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade 2B',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Room 104 · 20 Students · Present by default',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenTint,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$presentCount/${students.length} in',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.successText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Summary Filter Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _filterChip(
                    label: 'All (${students.length})',
                    selected: _filterStatus == null,
                    fg: AppColors.navy,
                    bg: AppColors.blueTint,
                    onTap: () => setState(() => _filterStatus = null),
                  ),
                  _filterChip(
                    label: 'Present $presentCount',
                    selected: _filterStatus == AttendanceStatus.present,
                    fg: AppColors.successText,
                    bg: AppColors.greenTint,
                    onTap: () => setState(
                      () => _filterStatus =
                          _filterStatus == AttendanceStatus.present
                              ? null
                              : AttendanceStatus.present,
                    ),
                  ),
                  _filterChip(
                    label: 'Early $earlyCount',
                    selected: _filterStatus == AttendanceStatus.earlyLeave,
                    fg: AppColors.warningText,
                    bg: AppColors.amberTint,
                    onTap: () => setState(
                      () => _filterStatus =
                          _filterStatus == AttendanceStatus.earlyLeave
                              ? null
                              : AttendanceStatus.earlyLeave,
                    ),
                  ),
                  _filterChip(
                    label: 'Absent $absentCount',
                    selected: _filterStatus == AttendanceStatus.absent,
                    fg: AppColors.dangerText,
                    bg: AppColors.redTint,
                    onTap: () => setState(
                      () => _filterStatus =
                          _filterStatus == AttendanceStatus.absent
                              ? null
                              : AttendanceStatus.absent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Search bar
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search student or tap an icon below...',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),

        // Compact Grid of Initials Icons (Doctor Feedback #1)
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    'No students match this filter.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final s = filtered[index];
                    return _StudentInitialTile(
                      student: s,
                      onTap: () => _openStudentPopup(context, s),
                    );
                  },
                ),
        ),

        // Sticky Submit Bar
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SkolaPrimaryButton(
            label: 'Confirm & save attendance',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Submit attendance?'),
                  content: Text(
                    '$presentCount present, $earlyCount early leave, and $absentCount absent. '
                    '$absentCount students will be excluded from afternoon pickup alerts.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Attendance saved. $absentCount students excluded from pickup.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Save attendance'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required Color fg,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? fg : bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : fg,
          ),
        ),
      ),
    );
  }

  void _openStudentPopup(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AnimatedBuilder(
        animation: widget.controller,
        builder: (_, _) {
          final current = widget.controller.students
              .firstWhere((e) => e.id == student.id);
          final (String stLabel, ChipTone stTone) = switch (current.attendance) {
            AttendanceStatus.present => ('Present', ChipTone.success),
            AttendanceStatus.earlyLeave => (
                'Early · ${current.earlyPickupTime ?? "1:30 PM"}',
                ChipTone.warning,
              ),
            AttendanceStatus.absent => ('Absent', ChipTone.danger),
          };

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StudentAvatar(initials: current.initials, size: 50),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.fullName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Parent: ${current.parentName}',
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
                const SizedBox(height: 12),
                StatusChip(label: stLabel, tone: stTone),
                if (current.note != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.amberTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          size: 16,
                          color: AppColors.warningText,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            current.note!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.warningText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                const Text(
                  'MARK STATUS',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _statusAction(
                        label: 'Present',
                        selected:
                            current.attendance == AttendanceStatus.present,
                        activeColor: AppColors.green,
                        onTap: () {
                          widget.controller.updateStudentAttendance(
                            current.id,
                            AttendanceStatus.present,
                          );
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _statusAction(
                        label: 'Early',
                        selected:
                            current.attendance == AttendanceStatus.earlyLeave,
                        activeColor: AppColors.amber,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: const TimeOfDay(hour: 13, minute: 30),
                          );
                          final formatted = picked != null
                              ? '${picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? "AM" : "PM"}'
                              : '1:30 PM';
                          widget.controller.updateStudentAttendance(
                            current.id,
                            AttendanceStatus.earlyLeave,
                            earlyTime: formatted,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _statusAction(
                        label: 'Absent',
                        selected: current.attendance == AttendanceStatus.absent,
                        activeColor: AppColors.red,
                        onTap: () {
                          widget.controller.updateStudentAttendance(
                            current.id,
                            AttendanceStatus.absent,
                          );
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
                if (current.attendance == AttendanceStatus.absent) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Excluded from afternoon pickup alerts.',
                    style: TextStyle(fontSize: 11, color: AppColors.red),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusAction({
    required String label,
    required bool selected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? activeColor : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? activeColor : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _StudentInitialTile extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentInitialTile({
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (Color border, Color bg, Color fg) = switch (student.attendance) {
      AttendanceStatus.present => (
          AppColors.green,
          AppColors.greenTint,
          AppColors.successText,
        ),
      AttendanceStatus.earlyLeave => (
          AppColors.amber,
          AppColors.amberTint,
          AppColors.warningText,
        ),
      AttendanceStatus.absent => (
          AppColors.red,
          AppColors.redTint,
          AppColors.dangerText,
        ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                  border: Border.all(color: border, width: 2.5),
                ),
                child: Text(
                  student.initials,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
              if (student.note != null)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.description_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
