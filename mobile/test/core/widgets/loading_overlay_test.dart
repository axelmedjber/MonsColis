import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monscolis/core/widgets/loading_overlay.dart';

void main() {
  group('LoadingOverlay', () {
    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify content is still visible
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('hides loading indicator when isLoading is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Verify loading indicator is not shown
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // Verify content is visible
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('shows custom loading indicator when provided',
        (WidgetTester tester) async {
      const customIndicator = Text('Loading...');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              indicator: customIndicator,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Verify custom indicator is shown
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('handles opacity correctly', (WidgetTester tester) async {
      const opacity = 0.7;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              opacity: opacity,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Find the opacity widget
      final opacityWidget = tester.widget<Opacity>(
        find.byType(Opacity).first,
      );

      // Verify opacity value
      expect(opacityWidget.opacity, equals(opacity));
    });

    testWidgets('handles color correctly', (WidgetTester tester) async {
      const overlayColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              color: overlayColor,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Find the container with the overlay color
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      // Verify color value
      expect(container.color, equals(overlayColor));
    });

    testWidgets('handles progress indicator color correctly',
        (WidgetTester tester) async {
      const progressColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              progressIndicatorColor: progressColor,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Find the progress indicator
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      // Verify progress indicator color
      expect(progressIndicator.valueColor?.value, equals(progressColor));
    });

    testWidgets('handles tap events correctly when loading',
        (WidgetTester tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              child: ElevatedButton(
                onPressed: () => buttonPressed = true,
                child: const Text('Press Me'),
              ),
            ),
          ),
        ),
      );

      // Try to tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify button press was blocked
      expect(buttonPressed, isFalse);
    });

    testWidgets('allows tap events when not loading',
        (WidgetTester tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: ElevatedButton(
                onPressed: () => buttonPressed = true,
                child: const Text('Press Me'),
              ),
            ),
          ),
        ),
      );

      // Try to tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify button press was allowed
      expect(buttonPressed, isTrue);
    });
  });
}
