/// Visual pickup status states displayed on the Parent Home hero card.
enum PickupHeroState {
  session,
  approaching,
  zone,
  verifying,
  notified,
  released,
  excluded,
}

/// Proximity trigger mode requested by the supervisor:
/// - [timeLimit]: Continuous residence inside 50m for the dwell duration.
/// - [accelerometerIfAnd]: IF distance <= 50m, switch to Accelerometer AND
///   require stationary range (|a| <= 0.30 m/s^2) for the dwell duration.
enum ProximityMode {
  timeLimit,
  accelerometerIfAnd,
}
