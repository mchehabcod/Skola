import 'package:flutter/material.dart';
import '../../models/school_note.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/skola_card.dart';

class NotesOverviewScreen extends StatelessWidget {
  final SkolaController controller;
  final VoidCallback onReportAbsence;
  final VoidCallback onEarlyPickup;

  const NotesOverviewScreen({
    super.key,
    required this.controller,
    required this.onReportAbsence,
    required this.onEarlyPickup,
  });

  @override
  Widget build(BuildContext context) {
    final notes = controller.notes;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        const Text(
          'PARENT NOTES',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Notes for Leo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Keep Mrs. Alvarez updated about Leo's day.",
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 22),

        Row(
          children: [
            Expanded(
              child: _NoteActionCard(
                icon: Icons.thermostat_rounded,
                title: 'Report absence',
                subtitle: "Leo won't attend school",
                fg: AppColors.dangerText,
                bg: AppColors.redTint,
                border: const Color(0xFFFECACA),
                onTap: onReportAbsence,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _NoteActionCard(
                icon: Icons.access_time_rounded,
                title: 'Early pickup',
                subtitle: 'Plan an earlier release',
                fg: AppColors.warningText,
                bg: AppColors.amberTint,
                border: const Color(0xFFFDE68A),
                onTap: onEarlyPickup,
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),

        const Text(
          'RECENT NOTES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        if (notes.isEmpty)
          const SkolaCard(
            child: Center(
              child: Text(
                'No notes yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...notes.map((note) {
            final isAbsence = note.kind == SchoolNoteKind.absence;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SkolaCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isAbsence
                            ? AppColors.redTint
                            : AppColors.amberTint,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        isAbsence
                            ? Icons.thermostat_rounded
                            : Icons.access_time_rounded,
                        size: 20,
                        color: isAbsence ? AppColors.red : AppColors.amber,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            note.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.status == 'Seen by teacher' ? 'Seen' : 'Sent',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _NoteActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color fg;
  final Color bg;
  final Color border;
  final VoidCallback onTap;

  const _NoteActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.fg,
    required this.bg,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: fg, size: 24),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: fg.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
