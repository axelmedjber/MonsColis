import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:monscolis/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete user journey', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test: Login Flow
      await _testLoginFlow(tester);

      // Test: Store Browsing and Appointment Booking
      await _testStoreAndAppointmentFlow(tester);

      // Test: Document Upload Flow
      await _testDocumentFlow(tester);

      // Test: Profile Management
      await _testProfileFlow(tester);
    });
  });
}

Future<void> _testLoginFlow(WidgetTester tester) async {
  // Find and tap the login button
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  // Enter phone number
  await tester.enterText(
    find.byKey(const Key('phone_input')),
    '+32123456789',
  );
  await tester.pumpAndSettle();

  // Submit phone number
  await tester.tap(find.text('Send Code'));
  await tester.pumpAndSettle();

  // Enter verification code
  await tester.enterText(
    find.byKey(const Key('verification_code_input')),
    '123456',
  );
  await tester.pumpAndSettle();

  // Verify successful login
  expect(find.text('Welcome to MonsColis'), findsOneWidget);
}

Future<void> _testStoreAndAppointmentFlow(WidgetTester tester) async {
  // Navigate to stores
  await tester.tap(find.text('Stores'));
  await tester.pumpAndSettle();

  // Select a store
  await tester.tap(find.text('Social Store Mons'));
  await tester.pumpAndSettle();

  // View store details
  expect(find.text('Available Time Slots'), findsOneWidget);

  // Select a time slot
  await tester.tap(find.text('09:00'));
  await tester.pumpAndSettle();

  // Book appointment
  await tester.tap(find.text('Book Appointment'));
  await tester.pumpAndSettle();

  // Verify booking confirmation
  expect(find.text('Appointment Confirmed'), findsOneWidget);
}

Future<void> _testDocumentFlow(WidgetTester tester) async {
  // Navigate to documents
  await tester.tap(find.text('Documents'));
  await tester.pumpAndSettle();

  // Tap upload button
  await tester.tap(find.text('Upload Document'));
  await tester.pumpAndSettle();

  // Select document type
  await tester.tap(find.text('ID Card'));
  await tester.pumpAndSettle();

  // Mock file selection and upload
  // Note: Actual file picking needs to be mocked in integration tests

  // Verify document appears in list
  expect(find.text('ID Card'), findsOneWidget);
  expect(find.text('Pending'), findsOneWidget);
}

Future<void> _testProfileFlow(WidgetTester tester) async {
  // Navigate to profile
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();

  // Test language change
  await tester.tap(find.text('Language'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Français'));
  await tester.pumpAndSettle();

  // Verify language change
  expect(find.text('Profil'), findsOneWidget);

  // Test dark mode toggle
  await tester.tap(find.byKey(const Key('dark_mode_switch')));
  await tester.pumpAndSettle();

  // Test notification settings
  await tester.tap(find.text('Notifications'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('appointment_notifications_switch')));
  await tester.pumpAndSettle();

  // Test help section
  await tester.tap(find.text('Help & Support'));
  await tester.pumpAndSettle();
  expect(find.text('FAQ'), findsOneWidget);

  // Test logout
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  expect(find.text('Login'), findsOneWidget);
}
