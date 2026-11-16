class GuardianPass {
  final String guardianName;
  final String relationship;
  final String phone;
  final String date;
  final bool notifyOnRelease;
  final String pin;
  bool isVerified;

  GuardianPass({
    required this.guardianName,
    required this.relationship,
    required this.phone,
    required this.date,
    required this.notifyOnRelease,
    required this.pin,
    this.isVerified = false,
  });

  GuardianPass copyWith({
    String? guardianName,
    String? relationship,
    String? phone,
    String? date,
    bool? notifyOnRelease,
    String? pin,
    bool? isVerified,
  }) {
    return GuardianPass(
      guardianName: guardianName ?? this.guardianName,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      date: date ?? this.date,
      notifyOnRelease: notifyOnRelease ?? this.notifyOnRelease,
      pin: pin ?? this.pin,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
