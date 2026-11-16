import 'package:flutter_test/flutter_test.dart';
import 'package:skola/main.dart';

void main() {
  testWidgets('SkolaApp boots on SplashScreen and routes to SignInScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SkolaApp());
    expect(find.text('Skola'), findsOneWidget);
    expect(find.text('Safe pickups. Simple days.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to Skola'), findsOneWidget);
  });
}
