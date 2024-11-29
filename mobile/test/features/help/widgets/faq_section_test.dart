import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monscolis/features/help/presentation/widgets/faq_section.dart';

void main() {
  group('FAQSection', () {
    testWidgets('renders all FAQ categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Verify all categories are present
      expect(find.text('Getting Started'), findsOneWidget);
      expect(find.text('Appointments'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Technical Issues'), findsOneWidget);
    });

    testWidgets('search bar filters FAQ items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Enter search query
      await tester.enterText(
        find.byType(TextField),
        'document',
      );
      await tester.pump();

      // Verify filtered results
      expect(find.text('How long does document verification take?'),
          findsOneWidget);
      expect(find.text('What if my documents are rejected?'), findsOneWidget);
      expect(find.text('How do I book an appointment?'), findsNothing);
    });

    testWidgets('expands FAQ items on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Find and tap a FAQ item
      await tester.tap(find.text('How do I register for MonsColis?'));
      await tester.pumpAndSettle();

      // Verify answer is visible
      expect(
        find.text(
          'To register, you need to provide your phone number for verification. Once verified, you\'ll need to submit required documents to prove your eligibility for social grocery services.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('collapses expanded FAQ items on second tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Find and tap a FAQ item twice
      final faqItem = find.text('How do I register for MonsColis?');
      await tester.tap(faqItem);
      await tester.pumpAndSettle();
      await tester.tap(faqItem);
      await tester.pumpAndSettle();

      // Verify answer is hidden
      expect(
        find.text(
          'To register, you need to provide your phone number for verification. Once verified, you\'ll need to submit required documents to prove your eligibility for social grocery services.',
        ),
        findsNothing,
      );
    });

    testWidgets('handles empty search results gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Enter search query with no matches
      await tester.enterText(
        find.byType(TextField),
        'xyz123',
      );
      await tester.pump();

      // Verify no results are shown
      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets('maintains scroll position when expanding items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Find a FAQ item and record its position
      final faqItem = find.text('How do I register for MonsColis?');
      final initialPosition = tester.getCenter(faqItem);

      // Tap to expand
      await tester.tap(faqItem);
      await tester.pumpAndSettle();

      // Verify position hasn't changed significantly
      final newPosition = tester.getCenter(faqItem);
      expect(
        (initialPosition.dy - newPosition.dy).abs(),
        lessThan(1.0),
      );
    });

    testWidgets('search is case-insensitive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FAQSection(),
          ),
        ),
      );

      // Enter search query in different cases
      await tester.enterText(
        find.byType(TextField),
        'DOCUMENT',
      );
      await tester.pump();

      // Verify results are found regardless of case
      expect(find.text('How long does document verification take?'),
          findsOneWidget);
      expect(find.text('What if my documents are rejected?'), findsOneWidget);
    });
  });
}
