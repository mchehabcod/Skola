import 'package:flutter/material.dart';
import '../../models/guardian_pass.dart';
import '../../models/school_note.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/skola_buttons.dart';

class EarlyPickupScreen extends StatefulWidget {
  final GuardianPass? guardianPass;
  final VoidCallback onBack;
  final ValueChanged<SchoolNote> onSend;

  const EarlyPickupScreen({
    super.key,
    required this.guardianPass,
    required this.onBack,
    required this.onSend,
  });

  @override
  State<EarlyPickupScreen> createState() => _EarlyPickupScreenState();
}

class _EarlyPickupScreenState extends State<EarlyPickupScreen> {
  static const _reasons = ['Appointment', 'Family event', 'Other'];
  String _reason = 'Appointment';
  TimeOfDay _time = const TimeOfDay(hour: 13, minute: 30);
  bool _byGuardian = false;

  String get _formattedTime {
    final h12 = _time.hourOfPeriod == 0 ? 12 : _time.hourOfPeriod;
    final period = _time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h12:${_time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _submit() {
    final collector = _byGuardian
        ? (widget.guardianPass?.guardianName ?? 'Guardian')
        : 'David Vance';
    widget.onSend(
      SchoolNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        kind: SchoolNoteKind.early,
        title: '$_reason, early pickup $_formattedTime',
        date: 'Today',
        status: 'Sent',
        time: _formattedTime,
        teacherNote: '$collector will pick up Leo at $_formattedTime.',
        isToday: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pass = widget.guardianPass;

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
          'Early pickup',
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
              'Pickup time',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(AppTheme.radiusInput),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formattedTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.access_time_rounded, color: AppColors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

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
              'Who will pick up Leo?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _segBtn('Me', !_byGuardian, () => setState(() => _byGuardian = false)),
                  _segBtn('Guardian', _byGuardian, () => setState(() => _byGuardian = true)),
                ],
              ),
            ),
            if (_byGuardian) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF99F6E4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.tealTint,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pass?.guardianName ?? 'No active Guardian Pass',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          pass != null
                              ? '${pass.relationship} · PIN ${pass.pin}'
                              : 'Create a pass from Home first',
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
            ],
            const SizedBox(height: 36),
            SkolaPrimaryButton(
              label: 'Send to teacher',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _segBtn(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected ? AppTheme.softShadow : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.navy : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
