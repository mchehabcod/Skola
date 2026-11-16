import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../../ui_ux/app_theme.dart';
import '../../widgets/skola_buttons.dart';

class GuardianPassScreen extends StatelessWidget {
  final SkolaController controller;
  final VoidCallback onBack;
  final VoidCallback onCreate;

  const GuardianPassScreen({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final pass = controller.guardianPass;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: onBack,
        ),
        title: const Text(
          'Guardian Pass',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let a trusted person pick up Leo. They must show a 4-digit PIN to the teacher.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            if (pass == null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 50,
                          color: AppColors.teal,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'No active guardian pass',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create a secure, one-day pass for someone you trust.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 260,
                        child: SkolaPrimaryButton(
                          label: 'Create a guardian pass',
                          onPressed: onCreate,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.tealDark,
                      AppColors.teal,
                      AppColors.tealDeep,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AUTHORIZED GUARDIAN PASS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF86EFAC),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                pass.isVerified ? 'Verified' : 'Active',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: AppColors.pinYellow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pass.guardianName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${pass.relationship} · for Leo Vance',
                              style: const TextStyle(
                                color: AppColors.tealTint,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Valid today until 6:00 PM',
                      style: TextStyle(color: AppColors.tealTint, fontSize: 11),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '4-DIGIT PIN',
                              style: TextStyle(
                                color: Color(0xFF99F6E4),
                                fontSize: 9,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pass.pin,
                              style: const TextStyle(
                                color: AppColors.pinYellow,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 10,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: pass.pin));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PIN copied')),
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.14),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SkolaSecondaryButton(
                label: 'Regenerate PIN',
                onPressed: () => _confirmRegenerate(context),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => _confirmRevoke(context),
                  child: const Text(
                    'Revoke pass',
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmRegenerate(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate a new PIN?'),
        content:
            const Text('The current PIN will stop working immediately.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.regenerateGuardianPin();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New PIN generated')),
              );
            },
            child: const Text('Generate new PIN'),
          ),
        ],
      ),
    );
  }

  void _confirmRevoke(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke guardian pass?'),
        content: Text(
          '${controller.guardianPass?.guardianName} will no longer be authorized to pick up Leo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.setGuardianPass(null);
            },
            child: const Text('Revoke pass'),
          ),
        ],
      ),
    );
  }
}
