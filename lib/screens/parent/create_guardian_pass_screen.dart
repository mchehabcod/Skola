import 'package:flutter/material.dart';
import '../../models/guardian_pass.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/skola_buttons.dart';

class CreateGuardianPassScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<GuardianPass> onCreated;

  const CreateGuardianPassScreen({
    super.key,
    required this.onBack,
    required this.onCreated,
  });

  @override
  State<CreateGuardianPassScreen> createState() =>
      _CreateGuardianPassScreenState();
}

class _CreateGuardianPassScreenState extends State<CreateGuardianPassScreen> {
  final _nameCtrl = TextEditingController(text: 'Uncle David Miller');
  final _phoneCtrl = TextEditingController(text: '+1 (555) 014-8290');
  String _relationship = 'Uncle';
  bool _notifyOnRelease = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onCreated(
      GuardianPass(
        guardianName: _nameCtrl.text.trim(),
        relationship: _relationship,
        phone: _phoneCtrl.text.trim(),
        date: DateTime.now().toIso8601String().substring(0, 10),
        notifyOnRelease: _notifyOnRelease,
        pin: '7419',
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
          'Create guardian pass',
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
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.tealTint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trusted pickup',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'This pass is valid for Leo Vance only.',
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
            _label('Guardian full name'),
            _input(_nameCtrl),
            const SizedBox(height: 16),
            _label('Relationship'),
            DropdownButtonFormField<String>(
              initialValue: _relationship,
              decoration: _inputDecoration(),
              items: const [
                'Uncle',
                'Aunt',
                'Grandparent',
                'Driver',
                'Neighbor',
                'Other',
              ]
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _relationship = v);
              },
            ),
            const SizedBox(height: 16),
            _label('Phone number'),
            _input(_phoneCtrl, type: TextInputType.phone),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _notifyOnRelease,
              activeTrackColor: AppColors.green,
              title: const Text(
                'Release notification',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Notify me when Leo is released to this guardian',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              onChanged: (v) => setState(() => _notifyOnRelease = v),
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 20),
            SkolaPrimaryButton(
              label: 'Generate pass & PIN',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, {TextInputType? type}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
    );
  }
}
