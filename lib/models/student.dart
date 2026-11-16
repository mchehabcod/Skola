enum AttendanceStatus { present, earlyLeave, absent }

enum ParentPickupStage {
  notArrived,
  approaching,
  verifying,
  ready,
  released,
}

class Student {
  final String id;
  final String fullName;
  final String grade;
  final String parentName;
  final String vehicleInfo;
  AttendanceStatus attendance;
  ParentPickupStage pickupStage;
  String? note;
  String? earlyPickupTime;
  String? releaseTime;
  String? releasedBy;
  String? approachingDetail;
  double? verifyingProgress;

  Student({
    required this.id,
    required this.fullName,
    required this.grade,
    required this.parentName,
    required this.vehicleInfo,
    this.attendance = AttendanceStatus.present,
    this.pickupStage = ParentPickupStage.notArrived,
    this.note,
    this.earlyPickupTime,
    this.releaseTime,
    this.releasedBy,
    this.approachingDetail,
    this.verifyingProgress,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}
