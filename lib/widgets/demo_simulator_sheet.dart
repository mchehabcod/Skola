import 'package:flutter/material.dart';
import '../models/pickup_state.dart';
import '../state/skola_controller.dart';
import '../ui_ux/app_colors.dart';
import '../ui_ux/app_theme.dart';

class DemoSimulatorSheet extends StatelessWidget {
  final SkolaController controller;

  const DemoSimulatorSheet({super.key, required this.controller});

  static void show(BuildContext context, SkolaController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnimatedBuilder(
        animation: controller,
        builder: (_, _) => DemoSimulatorSheet(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dist = controller.distanceMeters;
    final inside50 = controller.isInside50m;
    final mode = controller.proximityMode;
    final accel = controller.accelerometerDelta;
    final parked = controller.isParked;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusSheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup simulator',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Simulate GPS proximity & accelerometer range',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Mode Switcher (Supervisor Comment #3)
            const Text(
              'TRIGGER MODE',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _modeButton(
                    label: '50m + Accel (IF-AND)',
                    selected: mode == ProximityMode.accelerometerIfAnd,
                    onTap: () => controller
                        .setProximityMode(ProximityMode.accelerometerIfAnd),
                  ),
                  _modeButton(
                    label: '50m Time Limit Only',
                    selected: mode == ProximityMode.timeLimit,
                    onTap: () =>
                        controller.setProximityMode(ProximityMode.timeLimit),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Distance Slider
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'GPS DISTANCE TO GATE',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Text(
                          '${dist.round()} m',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: inside50 ? AppColors.green : AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: dist,
                    min: 5,
                    max: 150,
                    divisions: 145,
                    activeColor: inside50 ? AppColors.green : AppColors.navy,
                    onChanged: controller.setDistance,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 m', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                      Text(
                        '50 m school zone threshold',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                      Text('150 m', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Accelerometer Range (Active when Mode = accelerometerIfAnd)
            if (mode == ProximityMode.accelerometerIfAnd) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: inside50 ? AppColors.blueSoft : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: inside50
                        ? AppColors.blue.withValues(alpha: 0.3)
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            inside50
                                ? 'ACCELEROMETER SENSOR (ACTIVE ≤ 50m)'
                                : 'ACCELEROMETER (STANDBY > 50m)',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                              color: inside50
                                  ? AppColors.blue
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ),
                        Text(
                          '${accel.toStringAsFixed(2)} m/s²',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: parked ? AppColors.green : AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: accel,
                      min: 0.0,
                      max: 2.5,
                      divisions: 50,
                      activeColor: parked ? AppColors.green : AppColors.amber,
                      onChanged: controller.setAccelerometerDelta,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          parked
                              ? 'In parked range (≤ 0.30 m/s²)'
                              : 'Vehicle moving (> 0.30 m/s²)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: parked ? AppColors.green : AppColors.amber,
                          ),
                        ),
                        Switch.adaptive(
                          value: parked,
                          activeTrackColor: AppColors.green,
                          onChanged: controller.setParked,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Fast demo switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fast demo timer',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '5 s instead of 25 s dwell time limit',
                      style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: controller.fastDemo,
                  activeTrackColor: AppColors.green,
                  onChanged: controller.setFastDemo,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: controller.resetPickupDemo,
                child: const Text(
                  'Reset demo',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected ? AppTheme.softShadow : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.navy : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
