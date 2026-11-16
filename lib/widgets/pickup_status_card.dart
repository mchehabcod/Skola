import 'package:flutter/material.dart';
import '../models/pickup_state.dart';
import '../ui_ux/app_colors.dart';
import 'skola_card.dart';

class PickupStatusCard extends StatelessWidget {
  final PickupHeroState state;
  final double distanceMeters;
  final int secondsRemaining;
  final double progress;
  final ProximityMode proximityMode;
  final double accelerometerDelta;
  final String? releaseTime;

  const PickupStatusCard({
    super.key,
    required this.state,
    required this.distanceMeters,
    required this.secondsRemaining,
    required this.progress,
    required this.proximityMode,
    required this.accelerometerDelta,
    this.releaseTime,
  });

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color fg, Color bg, String title, String subtitle) =
        switch (state) {
      PickupHeroState.session => (
          Icons.schedule_rounded,
          AppColors.textSecondary,
          AppColors.background,
          'School in session',
          'Dismissal starts at 3:00 PM',
        ),
      PickupHeroState.approaching => (
          Icons.directions_car_rounded,
          AppColors.blue,
          AppColors.blueTint,
          "You're approaching school",
          '${distanceMeters.round()} m away from school gate',
        ),
      PickupHeroState.zone => (
          Icons.directions_car_rounded,
          AppColors.blue,
          AppColors.blueTint,
          'Inside the 50 m school zone',
          'Please stop and park (accel ≤ 0.30 m/s²) to notify the teacher',
        ),
      PickupHeroState.verifying => (
          Icons.hourglass_top_rounded,
          AppColors.amber,
          AppColors.amberTint,
          proximityMode == ProximityMode.timeLimit
              ? 'Verifying proximity time limit'
              : "Confirming you're parked",
          proximityMode == ProximityMode.timeLimit
              ? 'Stay inside 50 m for $secondsRemaining s'
              : 'Accelerometer stationary (${accelerometerDelta.toStringAsFixed(2)} m/s²) · $secondsRemaining s left',
        ),
      PickupHeroState.notified => (
          Icons.notifications_active_rounded,
          AppColors.teal,
          AppColors.tealTint,
          'Mrs. Alvarez has been notified',
          'Leo is being called to the gate',
        ),
      PickupHeroState.released => (
          Icons.check_circle_rounded,
          AppColors.green,
          AppColors.greenTint,
          'Leo has been released',
          'Released by Mrs. Alvarez at ${releaseTime ?? "3:07 PM"}. Safe trip home!',
        ),
      PickupHeroState.excluded => (
          Icons.error_outline_rounded,
          AppColors.red,
          AppColors.redTint,
          'Excluded from pickup',
          'Leo is marked absent today, so no pickup alert is sent.',
        ),
    };

    return SkolaCard(
      padding: const EdgeInsets.all(18),
      border: state == PickupHeroState.excluded
          ? const BorderSide(color: Color(0xFFFECACA))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PICKUP STATUS',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              if (state == PickupHeroState.verifying)
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: CircularProgressIndicator(
                          value: (1.0 - progress).clamp(0.0, 1.0),
                          strokeWidth: 4,
                          backgroundColor: AppColors.amberTint,
                          color: AppColors.amber,
                        ),
                      ),
                      Text(
                        '$secondsRemaining',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(17),
                    border: state == PickupHeroState.zone
                        ? Border.all(
                            color: AppColors.blue.withValues(alpha: 0.25),
                            width: 5,
                          )
                        : null,
                  ),
                  child: Icon(icon, size: 26, color: fg),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (state == PickupHeroState.session) ...[
            const SizedBox(height: 18),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            const Row(
              children: [
                CircleAvatar(radius: 3.5, backgroundColor: AppColors.inputBorder),
                SizedBox(width: 8),
                Text(
                  'Pickup tracking will be available this afternoon',
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                ),
              ],
            ),
          ] else if (state == PickupHeroState.approaching) ...[
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('150 m', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                Text('50 m zone', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ((150 - distanceMeters) / 100).clamp(0.05, 1.0),
                minHeight: 7,
                backgroundColor: AppColors.blueTint,
                color: AppColors.blue,
              ),
            ),
          ] else if (state == PickupHeroState.zone) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Accelerometer active · Motion detected (${accelerometerDelta.toStringAsFixed(2)} m/s²)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
