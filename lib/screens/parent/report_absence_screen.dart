import 'package:flutter/material.dart';
import '../../models/school_note.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/skola_buttons.dart';

class ReportAbsenceScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<SchoolNote> onSend;

  const ReportAbsenceScreen({
    super.key,
    required this.onBack,
    required this.onSend,
  });

  @override
  State<ReportAbsenceScreen> createState() => _ReportAbsenceScreenState();
}

class _ReportAbsenceScreenState extends State<ReportAbsenceScreen> {
  static const _reasons = [
    'Sick',
    'Medical appointment',
    'Family reason',
    'Other',
  ];

  String _reason = 'Sick';
  final _noteCtrl = TextEditingController();
  String? _attachedFile;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _noteCtrl.text.trim();
    widget.onSend(
      SchoolNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        kind: SchoolNoteKind.absence,
        title: _reason == 'Sick' ? 'Sick leave' : _reason,
        date: 'Today',
        status: 'Sent',
        teacherNote: text.isNotEmpty
            ? text
            : '$_reason — Leo will not attend today.',
        isToday: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Report absence',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reason',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons.map((item) {
                final selected = _reason == item;
                return ChoiceChip(
                  label: Text(item),
                  selected: selected,
                  selectedColor: AppColors.blueSoft,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.blue : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: selected ? AppColors.blue : AppColors.inputBorder,
                  ),
                  onSelected: (_) => setState(() => _reason = item),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            const Text(
              'Add a note for the teacher (optional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Share anything Mrs. Alvarez should know',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Medical note (optional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () =>
                  setState(() => _attachedFile = 'medical-note-leo.pdf'),
              borderRadius: BorderRadius.circular(AppTheme.radiusInput),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  border: Border.all(color: AppColors.textTertiary),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upload_file_rounded, color: AppColors.blue),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _attachedFile ?? 'Attach medical note',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _attachedFile != null
                              ? 'PDF · 248 KB'
                              : 'PDF, JPG or PNG',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            SkolaPrimaryButton(
              label: 'Send to teacher',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
