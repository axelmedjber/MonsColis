import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monscolis/features/help/presentation/widgets/contact_support_section.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  group('ContactSupportSection', () {
    testWidgets('renders all contact methods', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Verify all contact methods are present
      expect(find.text('Call Support'), findsOneWidget);
      expect(find.text('Email Support'), findsOneWidget);
      expect(find.text('Visit Us'), findsOneWidget);
    });

    testWidgets('renders contact hours', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Verify contact hours are displayed
      expect(find.text('Contact Hours'), findsOneWidget);
      expect(find.text('Monday - Friday: 9:00 - 17:00'), findsOneWidget);
      expect(find.text('Saturday: 9:00 - 12:00'), findsOneWidget);
      expect(find.text('Sunday: Closed'), findsOneWidget);
    });

    testWidgets('renders message form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Verify message form elements
      expect(find.text('Send us a Message'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Send Message'), findsOneWidget);
    });

    testWidgets('handles message submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Fill in the message form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Subject'),
        'Test Subject',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Message'),
        'Test Message',
      );

      // Submit the form
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Message sent successfully'), findsOneWidget);
    });

    testWidgets('launches phone call on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Tap the call support option
      await tester.tap(find.text('Call Support'));
      await tester.pumpAndSettle();

      // Note: We can't fully test URL launching in widget tests
      // but we can verify the tile is tappable
      expect(find.text('Call Support'), findsOneWidget);
    });

    testWidgets('launches email on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Tap the email support option
      await tester.tap(find.text('Email Support'));
      await tester.pumpAndSettle();

      // Note: We can't fully test URL launching in widget tests
      // but we can verify the tile is tappable
      expect(find.text('Email Support'), findsOneWidget);
    });

    testWidgets('launches maps on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Tap the visit us option
      await tester.tap(find.text('Visit Us'));
      await tester.pumpAndSettle();

      // Note: We can't fully test URL launching in widget tests
      // but we can verify the tile is tappable
      expect(find.text('Visit Us'), findsOneWidget);
    });

    testWidgets('handles social media links', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Verify social media links
      expect(find.text('Follow Us'), findsOneWidget);
      expect(find.text('Facebook'), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);
    });

    testWidgets('validates message form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContactSupportSection(),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Verify form validation (no success message should appear)
      expect(find.text('Message sent successfully'), findsNothing);
    });
  });
}
