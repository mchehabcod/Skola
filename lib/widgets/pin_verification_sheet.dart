import 'package:flutter/material.dart';
import '../ui_ux/app_colors.dart';
import '../ui_ux/app_theme.dart';
import 'skola_buttons.dart';

class PinVerificationSheet extends StatefulWidget {
  final String guardianName;
  final String relationship;
  final String correctPin;
  final VoidCallback onVerified;

  const PinVerificationSheet({
    super.key,
    required this.guardianName,
    required this.relationship,
    required this.correctPin,
    required this.onVerified,
  });

  static Future<void> show(
    BuildContext context, {
    required String guardianName,
    required String relationship,
    required String correctPin,
    required VoidCallback onVerified,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PinVerificationSheet(
        guardianName: guardianName,
        relationship: relationship,
        correctPin: correctPin,
        onVerified: onVerified,
      ),
    );
  }

  @override
  State<PinVerificationSheet> createState() => _PinVerificationSheetState();
}

class _PinVerificationSheetState extends State<PinVerificationSheet> {
  String _pin = '';
  bool _hasError = false;

  void _press(String key) {
    setState(() {
      _hasError = false;
      if (key == 'delete') {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else if (_pin.length < 4) {
        _pin += key;
      }
    });
  }

  void _verify() {
    if (_pin == widget.correctPin) {
      Navigator.pop(context);
      widget.onVerified();
    } else {
      setState(() {
        _hasError = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusSheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBorder,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const Text(
            'Verify guardian PIN',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ask the guardian for the 4-digit code in their Skola pass.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.tealTint,
                  foregroundColor: AppColors.tealDark,
                  child: const Text(
                    'DM',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.guardianName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Authorized guardian · ${widget.relationship}',
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
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < _pin.length;
              return Container(
                width: 48,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _hasError
                        ? AppColors.red
                        : (filled ? AppColors.blue : AppColors.inputBorder),
                    width: filled ? 2 : 1,
                  ),
                ),
                child: Text(
                  filled ? '•' : '',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
          ),
          if (_hasError) ...[
            const SizedBox(height: 8),
            const Text(
              'Incorrect PIN. Try again.',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 2.1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'delete']
                  .map((key) {
                if (key.isEmpty) return const SizedBox.shrink();
                return Material(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _press(key),
                    child: Center(
                      child: key == 'delete'
                          ? const Icon(Icons.backspace_outlined, size: 20)
                          : Text(
                              key,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          SkolaPrimaryButton(
            label: 'Verify',
            onPressed: _pin.length == 4 ? _verify : null,
          ),
        ],
      ),
    );
  }
}
