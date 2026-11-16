import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../state/skola_controller.dart';
import '../../ui_ux/app_colors.dart';
import '../parent/create_guardian_pass_screen.dart';
import '../parent/early_pickup_screen.dart';
import '../parent/guardian_pass_screen.dart';
import '../parent/notes_overview_screen.dart';
import '../parent/parent_home_screen.dart';
import '../parent/parent_profile_screen.dart';
import '../parent/report_absence_screen.dart';
import '../teacher/teacher_attendance_screen.dart';
import '../teacher/teacher_dismissal_screen.dart';
import '../teacher/teacher_profile_screen.dart';

enum _ParentSubRoute { none, guardian, createGuardian, absence, early }

class AppShell extends StatefulWidget {
  final SkolaController controller;
  final bool isTeacher;

  const AppShell({
    super.key,
    required this.controller,
    required this.isTeacher,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tabIndex = 0;
  _ParentSubRoute _subRoute = _ParentSubRoute.none;

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTeacher != widget.isTeacher) {
      _tabIndex = 0;
      _subRoute = _ParentSubRoute.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    if (!widget.isTeacher && _subRoute != _ParentSubRoute.none) {
      switch (_subRoute) {
        case _ParentSubRoute.guardian:
          return GuardianPassScreen(
            controller: c,
            onBack: () => setState(() => _subRoute = _ParentSubRoute.none),
            onCreate: () =>
                setState(() => _subRoute = _ParentSubRoute.createGuardian),
          );
        case _ParentSubRoute.createGuardian:
          return CreateGuardianPassScreen(
            onBack: () => setState(() => _subRoute = _ParentSubRoute.guardian),
            onCreated: (pass) {
              c.setGuardianPass(pass);
              setState(() => _subRoute = _ParentSubRoute.guardian);
            },
          );
        case _ParentSubRoute.absence:
          return ReportAbsenceScreen(
            onBack: () => setState(() => _subRoute = _ParentSubRoute.none),
            onSend: (note) {
              c.addNote(note);
              setState(() {
                _subRoute = _ParentSubRoute.none;
                _tabIndex = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mrs. Alvarez can see this now')),
              );
            },
          );
        case _ParentSubRoute.early:
          return EarlyPickupScreen(
            guardianPass: c.guardianPass,
            onBack: () => setState(() => _subRoute = _ParentSubRoute.none),
            onSend: (note) {
              c.addNote(note);
              setState(() {
                _subRoute = _ParentSubRoute.none;
                _tabIndex = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mrs. Alvarez can see this now')),
              );
            },
          );
        case _ParentSubRoute.none:
          break;
      }
    }

    final readyCount = c.students
        .where(
          (s) =>
              s.attendance != AttendanceStatus.absent &&
              s.pickupStage == ParentPickupStage.ready,
        )
        .length;

    final Widget body;
    if (widget.isTeacher) {
      body = switch (_tabIndex) {
        0 => TeacherAttendanceScreen(controller: c),
        1 => TeacherDismissalScreen(controller: c),
        _ => TeacherProfileScreen(controller: c),
      };
    } else {
      body = switch (_tabIndex) {
        0 => ParentHomeScreen(
            controller: c,
            onOpenGuardianPass: () =>
                setState(() => _subRoute = _ParentSubRoute.guardian),
            onOpenNotes: () => setState(() => _tabIndex = 1),
          ),
        1 => NotesOverviewScreen(
            controller: c,
            onReportAbsence: () =>
                setState(() => _subRoute = _ParentSubRoute.absence),
            onEarlyPickup: () =>
                setState(() => _subRoute = _ParentSubRoute.early),
          ),
        _ => ParentProfileScreen(controller: c),
      };
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body,
            // Floating demo switcher matching Figma prototype
            Positioned(
              left: 14,
              bottom: 14,
              child: Material(
                color: AppColors.navyDark.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: c.switchRoleDemo,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.swap_horiz_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isTeacher ? 'Switch to Parent' : 'Switch to Teacher',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.blueSoft,
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: widget.isTeacher
            ? [
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  selectedIcon:
                      Icon(Icons.grid_view_rounded, color: AppColors.blue),
                  label: 'Attendance',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: readyCount > 0,
                    label: Text('$readyCount'),
                    child: const Icon(Icons.directions_car_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: readyCount > 0,
                    label: Text('$readyCount'),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.blue,
                    ),
                  ),
                  label: 'Dismissal',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon:
                      Icon(Icons.person_rounded, color: AppColors.blue),
                  label: 'Profile',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: AppColors.blue),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  selectedIcon:
                      Icon(Icons.description_rounded, color: AppColors.blue),
                  label: 'Notes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon:
                      Icon(Icons.person_rounded, color: AppColors.blue),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }
}
