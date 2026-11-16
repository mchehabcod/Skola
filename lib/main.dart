import 'package:flutter/material.dart';
import 'screens/auth/detecting_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/shell/app_shell.dart';
import 'state/skola_controller.dart';
import 'ui_ux/app_theme.dart';

void main() {
  runApp(const SkolaApp());
}

class SkolaApp extends StatefulWidget {
  const SkolaApp({super.key});

  @override
  State<SkolaApp> createState() => _SkolaAppState();
}

class _SkolaAppState extends State<SkolaApp> {
  late final SkolaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SkolaController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'Skola',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: switch (_controller.route) {
            AppRoute.splash =>
              SplashScreen(onFinished: _controller.finishSplash),
            AppRoute.signIn => SignInScreen(controller: _controller),
            AppRoute.detecting => const DetectingScreen(),
            AppRoute.parent =>
              AppShell(controller: _controller, isTeacher: false),
            AppRoute.teacher =>
              AppShell(controller: _controller, isTeacher: true),
          },
        );
      },
    );
  }
}
