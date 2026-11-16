import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/guardian_pass.dart';
import '../models/pickup_state.dart';
import '../models/school_note.dart';
import '../models/student.dart';

enum AppRoute { splash, signIn, detecting, parent, teacher }

class SkolaController extends ChangeNotifier {
  static const String activeStudentId = 'STU-01';
  static const double geofenceRadiusMeters = 50.0;
  static const double stationaryAccelThreshold = 0.30;

  AppRoute _route = AppRoute.splash;
  String _email = 'david.vance@email.com';

  // Parent Telemetry Simulation
  double _distanceMeters = 150.0;
  ProximityMode _proximityMode = ProximityMode.accelerometerIfAnd;
  double _accelerometerDelta = 1.20; // m/s^2 (<= 0.30 is stationary/parked)
  bool _fastDemo = true; // 5s vs 25s
  int _dwellSecondsRemaining = 0;
  double _dwellProgress = 0.0;
  Timer? _dwellTimer;

  // Shared Feature State
  GuardianPass? _guardianPass;
  late List<SchoolNote> _notes;
  late List<Student> _students;

  // Profile Notification Toggles
  bool parentNotifyArrival = true;
  bool parentNotifyRelease = true;
  bool teacherSoundAlerts = true;
  bool teacherVibrationAlerts = true;

  SkolaController() {
    _resetData();
  }

  void _resetData() {
    _notes = [
      const SchoolNote(
        id: '1',
        kind: SchoolNoteKind.absence,
        title: 'Sick leave',
        date: 'Oct 21',
        status: 'Seen by teacher',
      ),
      const SchoolNote(
        id: '2',
        kind: SchoolNoteKind.early,
        title: 'Dentist, early pickup 1:30 PM',
        date: 'Oct 14',
        status: 'Seen by teacher',
        time: '1:30 PM',
      ),
      const SchoolNote(
        id: '3',
        kind: SchoolNoteKind.absence,
        title: 'Family trip',
        date: 'Sep 30',
        status: 'Seen by teacher',
      ),
    ];

    // 20-student Grade 2B roster: ALL default to Present (Attendance by Exception)
    _students = [
      Student(
        id: 'STU-01',
        fullName: 'Leo Vance',
        grade: 'Grade 2B',
        parentName: 'David Vance',
        vehicleInfo: 'Blue Honda CR-V · 582-ABC',
      ),
      Student(
        id: 'STU-02',
        fullName: 'Maya Patel',
        grade: 'Grade 2B',
        parentName: 'Rina & Arjun Patel',
        vehicleInfo: 'Silver Tesla Model Y · 914-XYZ',
      ),
      Student(
        id: 'STU-03',
        fullName: "Liam O'Connor",
        grade: 'Grade 2B',
        parentName: "Emma O'Connor",
        vehicleInfo: 'White Toyota RAV4 · 320-LMN',
        pickupStage: ParentPickupStage.approaching,
        approachingDetail: 'Inside 50m zone · Moving (accel 1.45 m/s²)',
      ),
      Student(
        id: 'STU-04',
        fullName: 'Amina Yusuf',
        grade: 'Grade 2B',
        parentName: 'Nadia Yusuf',
        vehicleInfo: 'Black Hyundai Tucson · 771-QWE',
        attendance: AttendanceStatus.absent,
        note: 'Viral fever from Nadia Yusuf',
      ),
      Student(
        id: 'STU-05',
        fullName: 'Lucas Garcia',
        grade: 'Grade 2B',
        parentName: 'Elena Garcia',
        vehicleInfo: 'Red Subaru Outback · 104-VBN',
        attendance: AttendanceStatus.earlyLeave,
        earlyPickupTime: '1:30 PM',
        note: 'Early pickup 1:30 PM · dentist',
      ),
      Student(
        id: 'STU-06',
        fullName: 'Noor Hassan',
        grade: 'Grade 2B',
        parentName: 'Kareem Hassan',
        vehicleInfo: 'Grey Kia Sportage · 412-JKL',
      ),
      Student(
        id: 'STU-07',
        fullName: 'Omar Khalil',
        grade: 'Grade 2B',
        parentName: 'Layla Khalil',
        vehicleInfo: 'Blue Mazda CX-5 · 883-DFG',
      ),
      Student(
        id: 'STU-08',
        fullName: 'Sofia Rossi',
        grade: 'Grade 2B',
        parentName: 'Marco Rossi',
        vehicleInfo: 'White Volvo XC60 · 219-RTY',
        pickupStage: ParentPickupStage.verifying,
        approachingDetail: 'Verifying parked dwell · 18 s left',
        verifyingProgress: 0.3,
      ),
      Student(
        id: 'STU-09',
        fullName: 'Zara Mansour',
        grade: 'Grade 2B',
        parentName: 'Tariq Mansour',
        vehicleInfo: 'Silver Nissan X-Trail · 654-UIO',
      ),
      Student(
        id: 'STU-10',
        fullName: 'Ethan Brooks',
        grade: 'Grade 2B',
        parentName: 'Hannah Brooks',
        vehicleInfo: 'Black Ford Explorer · 309-PAS',
      ),
      Student(
        id: 'STU-11',
        fullName: 'Chloe Kim',
        grade: 'Grade 2B',
        parentName: 'Daniel Kim',
        vehicleInfo: 'White Honda Civic · 741-MNB',
      ),
      Student(
        id: 'STU-12',
        fullName: 'Youssef Nabil',
        grade: 'Grade 2B',
        parentName: 'Salma Nabil',
        vehicleInfo: 'Grey Toyota Camry · 518-ZXC',
      ),
      Student(
        id: 'STU-13',
        fullName: 'Hana Takahashi',
        grade: 'Grade 2B',
        parentName: 'Kenji Takahashi',
        vehicleInfo: 'Blue Subaru Forester · 902-QAZ',
      ),
      Student(
        id: 'STU-14',
        fullName: 'Adam Al-Farsi',
        grade: 'Grade 2B',
        parentName: 'Mona Al-Farsi',
        vehicleInfo: 'White Lexus RX · 137-WSX',
      ),
      Student(
        id: 'STU-15',
        fullName: 'Clara Bennett',
        grade: 'Grade 2B',
        parentName: 'Oliver Bennett',
        vehicleInfo: 'Green Jeep Compass · 465-EDC',
      ),
      Student(
        id: 'STU-16',
        fullName: 'Rami Haddad',
        grade: 'Grade 2B',
        parentName: 'Rana Haddad',
        vehicleInfo: 'Silver Audi Q5 · 824-RFV',
      ),
      Student(
        id: 'STU-17',
        fullName: 'Isla Campbell',
        grade: 'Grade 2B',
        parentName: 'Claire Campbell',
        vehicleInfo: 'Red VW Tiguan · 693-TGB',
      ),
      Student(
        id: 'STU-18',
        fullName: 'Bilal Ahmad',
        grade: 'Grade 2B',
        parentName: 'Farah Ahmad',
        vehicleInfo: 'Black BMW X3 · 248-YHN',
      ),
      Student(
        id: 'STU-19',
        fullName: 'Mia Kowalski',
        grade: 'Grade 2B',
        parentName: 'Piotr Kowalski',
        vehicleInfo: 'White Skoda Kodiaq · 376-UJM',
      ),
      Student(
        id: 'STU-20',
        fullName: 'Tariq Zayd',
        grade: 'Grade 2B',
        parentName: 'Amira Zayd',
        vehicleInfo: 'Grey Peugeot 3008 · 591-IKL',
      ),
    ];
  }

  // Getters
  AppRoute get route => _route;
  String get email => _email;
  double get distanceMeters => _distanceMeters;
  ProximityMode get proximityMode => _proximityMode;
  double get accelerometerDelta => _accelerometerDelta;
  bool get isParked => _accelerometerDelta <= stationaryAccelThreshold;
  bool get isInside50m => _distanceMeters <= geofenceRadiusMeters;
  bool get fastDemo => _fastDemo;
  int get dwellSecondsRemaining => _dwellSecondsRemaining;
  int get dwellTargetSeconds => _fastDemo ? 5 : 25;
  double get dwellProgress => _dwellProgress;
  GuardianPass? get guardianPass => _guardianPass;
  List<SchoolNote> get notes => List.unmodifiable(_notes);
  List<Student> get students => List.unmodifiable(_students);

  Student get activeStudent =>
      _students.firstWhere((s) => s.id == activeStudentId);

  bool get isLeoAbsent =>
      activeStudent.attendance == AttendanceStatus.absent;

  PickupHeroState get parentHeroState {
    if (isLeoAbsent) return PickupHeroState.excluded;
    switch (activeStudent.pickupStage) {
      case ParentPickupStage.released:
        return PickupHeroState.released;
      case ParentPickupStage.ready:
        return PickupHeroState.notified;
      case ParentPickupStage.verifying:
        return PickupHeroState.verifying;
      case ParentPickupStage.approaching:
      case ParentPickupStage.notArrived:
        if (_distanceMeters >= 150) return PickupHeroState.session;
        if (_distanceMeters > geofenceRadiusMeters) {
          return PickupHeroState.approaching;
        }
        return PickupHeroState.zone;
    }
  }

  // Navigation / Auth Actions
  void finishSplash() {
    if (_route == AppRoute.splash) {
      _route = AppRoute.signIn;
      notifyListeners();
    }
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void signIn() {
    _route = AppRoute.detecting;
    notifyListeners();
    Timer(const Duration(milliseconds: 1100), () {
      _route = _email.toLowerCase().contains('teacher')
          ? AppRoute.teacher
          : AppRoute.parent;
      notifyListeners();
    });
  }

  void signOut() {
    _route = AppRoute.signIn;
    notifyListeners();
  }

  void switchRoleDemo() {
    if (_route == AppRoute.parent) {
      _route = AppRoute.teacher;
    } else if (_route == AppRoute.teacher) {
      _route = AppRoute.parent;
    }
    notifyListeners();
  }

  // Simulator & Proximity Engine
  void setDistance(double meters) {
    _distanceMeters = meters;
    _evaluateProximity();
    notifyListeners();
  }

  void setProximityMode(ProximityMode mode) {
    _proximityMode = mode;
    _cancelDwellTimer();
    if (activeStudent.pickupStage != ParentPickupStage.ready &&
        activeStudent.pickupStage != ParentPickupStage.released) {
      activeStudent.pickupStage = ParentPickupStage.notArrived;
    }
    _evaluateProximity();
    notifyListeners();
  }

  void setAccelerometerDelta(double value) {
    _accelerometerDelta = value;
    _evaluateProximity();
    notifyListeners();
  }

  void setParked(bool parked) {
    _accelerometerDelta = parked ? 0.08 : 1.20;
    _evaluateProximity();
    notifyListeners();
  }

  void setFastDemo(bool fast) {
    _fastDemo = fast;
    _cancelDwellTimer();
    if (activeStudent.pickupStage == ParentPickupStage.verifying) {
      activeStudent.pickupStage = ParentPickupStage.notArrived;
    }
    _evaluateProximity();
    notifyListeners();
  }

  void _evaluateProximity() {
    final leo = activeStudent;
    if (leo.pickupStage == ParentPickupStage.released ||
        leo.pickupStage == ParentPickupStage.ready) {
      return;
    }

    if (isLeoAbsent) {
      _cancelDwellTimer();
      leo.pickupStage = ParentPickupStage.notArrived;
      leo.approachingDetail = null;
      return;
    }

    if (!isInside50m) {
      _cancelDwellTimer();
      leo.pickupStage = ParentPickupStage.notArrived;
      leo.approachingDetail = null;
      return;
    }

    // Inside 50m radius!
    if (_proximityMode == ProximityMode.timeLimit) {
      // Mode A: Continuous time limit inside 50m proximity triggers ready
      if (leo.pickupStage != ParentPickupStage.verifying) {
        _startDwellTimer('In 50m proximity · time limit running');
      }
    } else {
      // Mode B (IF-AND): 50m GPS -> switch to Accelerometer range check
      if (!isParked) {
        _cancelDwellTimer();
        leo.pickupStage = ParentPickupStage.approaching;
        leo.approachingDetail =
            'Inside 50m · Moving (accel ${_accelerometerDelta.toStringAsFixed(2)} m/s²)';
      } else {
        if (leo.pickupStage != ParentPickupStage.verifying) {
          _startDwellTimer(
            '50m + Accel parked (${_accelerometerDelta.toStringAsFixed(2)} m/s²)',
          );
        }
      }
    }
  }

  void _startDwellTimer(String detail) {
    _cancelDwellTimer();
    final leo = activeStudent;
    leo.pickupStage = ParentPickupStage.verifying;
    leo.approachingDetail = detail;

    final target = dwellTargetSeconds;
    _dwellSecondsRemaining = target;
    _dwellProgress = 0.0;
    notifyListeners();

    var elapsed = 0;
    _dwellTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsed++;
      _dwellSecondsRemaining = max(0, target - elapsed);
      _dwellProgress = elapsed / target;
      leo.verifyingProgress = _dwellProgress;

      if (elapsed >= target) {
        _cancelDwellTimer();
        leo.pickupStage = ParentPickupStage.ready;
        leo.approachingDetail = null;
        leo.verifyingProgress = null;
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
  }

  void _cancelDwellTimer() {
    _dwellTimer?.cancel();
    _dwellTimer = null;
    _dwellSecondsRemaining = 0;
    _dwellProgress = 0.0;
  }

  void resetPickupDemo() {
    _cancelDwellTimer();
    _distanceMeters = 150.0;
    _accelerometerDelta = 1.20;
    activeStudent.pickupStage = ParentPickupStage.notArrived;
    activeStudent.approachingDetail = null;
    activeStudent.verifyingProgress = null;
    activeStudent.releaseTime = null;
    activeStudent.releasedBy = null;
    if (_guardianPass != null) {
      _guardianPass = _guardianPass!.copyWith(isVerified: false);
    }
    notifyListeners();
  }

  // Teacher Attendance (Comment 1: Default Present + Tap Popup for Absent / Early)
  void updateStudentAttendance(
    String studentId,
    AttendanceStatus status, {
    String? earlyTime,
  }) {
    final s = _students.firstWhere((e) => e.id == studentId);
    s.attendance = status;
    if (status == AttendanceStatus.earlyLeave) {
      s.earlyPickupTime = earlyTime ?? '1:30 PM';
    } else {
      s.earlyPickupTime = null;
    }
    if (status == AttendanceStatus.absent) {
      s.pickupStage = ParentPickupStage.notArrived;
      if (s.id == activeStudentId) {
        _cancelDwellTimer();
      }
    } else if (s.id == activeStudentId) {
      _evaluateProximity();
    }
    notifyListeners();
  }

  // Guardian Pass (Feature 3A)
  void setGuardianPass(GuardianPass? pass) {
    _guardianPass = pass;
    notifyListeners();
  }

  void regenerateGuardianPin() {
    if (_guardianPass == null) return;
    final nextPin = (1000 + Random().nextInt(9000)).toString();
    _guardianPass = _guardianPass!.copyWith(pin: nextPin, isVerified: false);
    notifyListeners();
  }

  bool verifyGuardianPin(String enteredPin) {
    if (_guardianPass != null && _guardianPass!.pin == enteredPin.trim()) {
      _guardianPass = _guardianPass!.copyWith(isVerified: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Notes (Feature 3B)
  void addNote(SchoolNote note) {
    _notes.insert(0, note);
    if (note.isToday) {
      final leo = activeStudent;
      leo.note = note.teacherNote ?? note.title;
      if (note.kind == SchoolNoteKind.absence) {
        leo.attendance = AttendanceStatus.absent;
        leo.earlyPickupTime = null;
        leo.pickupStage = ParentPickupStage.notArrived;
        _cancelDwellTimer();
      } else {
        leo.attendance = AttendanceStatus.earlyLeave;
        leo.earlyPickupTime = note.time ?? '1:30 PM';
      }
    }
    notifyListeners();
  }

  // Teacher Dismissal Release
  void releaseStudent(String studentId, {String teacher = 'Mrs. Sara Alvarez'}) {
    final s = _students.firstWhere((e) => e.id == studentId);
    if (s.id == activeStudentId &&
        _guardianPass != null &&
        !_guardianPass!.isVerified) {
      return;
    }
    s.pickupStage = ParentPickupStage.released;
    final now = DateTime.now();
    final hour12 = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    s.releaseTime =
        '$hour12:${now.minute.toString().padLeft(2, '0')} $period';
    s.releasedBy = teacher;
    notifyListeners();
  }

  @override
  void dispose() {
    _dwellTimer?.cancel();
    super.dispose();
  }
}
